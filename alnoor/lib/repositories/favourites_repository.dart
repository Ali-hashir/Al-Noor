import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'package:alnoor/utils/globals.dart' as globals;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../services/product_dao.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class FavouritesRepository {
  final ProductDao productDao = ProductDao();

  // Check internet connectivity
  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<List<Product>>> fetchFavourites(search) async {
    bool isConnected = await _isConnected();
    print('Connectivity status: $isConnected');

    if (isConnected) {
      var response = null;
      var responseImage = null;
      if (search != "") {
        response = await http.get(
          Uri.parse("https://alnoormdf.com/alnoor/favourites/search/${search}"),
          headers: {
            'Authorization': 'Bearer ${globals.token}',
          },
        ).timeout(Duration(seconds: 60));
      } else {
        response = await http.get(
          Uri.parse('https://alnoormdf.com/alnoor/favourites'),
          headers: {
            'Authorization': 'Bearer ${globals.token}',
          },
        ).timeout(Duration(seconds: 60));
      }
      responseImage = await http.get(
        Uri.parse('https://alnoormdf.com/alnoor/get-images'),
        headers: {
          'Authorization': 'Bearer ${globals.token}',
        },
      ).timeout(Duration(seconds: 60));
      if (response.statusCode == 200 && responseImage.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        Map<String, dynamic> dataImage = jsonDecode(responseImage.body);
        var prod = search != "" ? data['results'] : data['favourites'];
        if (prod.isEmpty) {
          if (dataImage['images'].isEmpty) {
            return [[], [], [], []];
          } else {
            Map<String, dynamic> images = dataImage['images'];
            List<dynamic> myIdeasItems = images["MY IDEAS"];
            List<Product> myIdeasList = myIdeasItems
                .map((product) => Product.fromJson(product))
                .toList();
            return [[], [], [], myIdeasList];
          }
        } else {
          Map<String, dynamic> productsJson = prod;
          List<dynamic> myKitchenItems = productsJson['MY KITCHEN'] ?? [];
          List<dynamic> myBedroomItems = productsJson['MY BEDROOM'] ?? [];
          List<dynamic> myLoungeItems = productsJson['MY LOUNGE'] ?? [];
          List<Product> myKitchenList =
              myKitchenItems.map((product) => Product.fromJson(product)).toList();
          List<Product> myBedroomList =
              myBedroomItems.map((product) => Product.fromJson(product)).toList();
          List<Product> myLoungeList =
              myLoungeItems.map((product) => Product.fromJson(product)).toList();
          if (dataImage['images'].isEmpty) {
            return [myKitchenList, myBedroomList, myLoungeList, []];
          } else {
            Map<String, dynamic> images = dataImage['images'];
            List<dynamic> myIdeasItems = images["MY IDEAS"];
            List<Product> myIdeasList = myIdeasItems
                .map((product) => Product.fromJson(product))
                .toList();
            return [myKitchenList, myBedroomList, myLoungeList, myIdeasList];
          }
        }
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      // Offline - fetch from local database
      return await _fetchFavouritesFromLocal();
    }
  }

  Future<List<List<Product>>> _fetchFavouritesFromLocal() async {
    print('Fetching favourites from local database');
    List<Product> products = await productDao.getProducts();
    // Assuming you have a way to categorize the products locally
    List<Product> myKitchenList = products.where((product) => product.category == 'MY KITCHEN').toList();
    List<Product> myBedroomList = products.where((product) => product.category == 'MY BEDROOM').toList();
    List<Product> myLoungeList = products.where((product) => product.category == 'MY LOUNGE').toList();
    List<Product> myIdeasList = products.where((product) => product.category == 'MY IDEAS').toList();
    return [myKitchenList, myBedroomList, myLoungeList, myIdeasList];
  }

  Future<void> addFavourites(String productId, String collectionName) async {
    var response = await http.post(
      Uri.parse('https://alnoormdf.com/alnoor/favourites/add'),
      headers: {
        'Authorization': 'Bearer ${globals.token}',
      },
      body: {
        'product_id': productId,
        'collection_name': collectionName,
      },
    ).timeout(Duration(seconds: 60));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to add to favourites');
    }
  }

  Future<void> uploadImage(File imageFile, String collectionName) async {
    final url = Uri.parse('https://alnoormdf.com/alnoor/upload-image');

    final mimeTypeData =
        lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])?.split('/');

    final request = http.MultipartRequest('POST', url)
      ..fields['collection_name'] = collectionName
      ..files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
        ),
      )
      ..headers['Authorization'] = 'Bearer ${globals.token}';

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
      } else {
        print('Image upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
