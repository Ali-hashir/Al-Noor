// ignore_for_file: deprecated_member_use

import 'package:alnoor/blocs/favorites_bloc.dart';
import 'package:alnoor/classes/image_manager.dart';
import 'package:alnoor/models/product.dart';
import 'package:alnoor/screens/Home/home.dart';
import 'package:alnoor/widgets/Add_To_Compare_Row.dart';
import 'package:alnoor/widgets/Product_Grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Uploads(
        index: 0,
        isGuestUser: false, // Change this to true if testing as a guest user
      ),
    );
  }
}

class Uploads extends StatefulWidget {
  final int index;
  final bool isGuestUser; // Pass this flag to determine if the user is a guest

  Uploads({required this.index, this.isGuestUser = false});

  @override
  _UploadsState createState() => _UploadsState();
}

class _UploadsState extends State<Uploads> {
  FocusNode _focusNode = FocusNode();
  int currentPage = 0;
  late PageController _pageController;
  int filterIndex = 3;
  late ValueNotifier<bool> _isMenuVisibleNotifier;
  TextEditingController _textController = TextEditingController();
  late ValueNotifier<bool> _isDraggingNotifier;
  late ValueNotifier<int?> _draggingIndexNotifier;

  void setIsDragging(bool value) {
    _isDraggingNotifier.value = value;
  }

  void setDraggingIndex(int? value) {
    _draggingIndexNotifier.value = value;
  }

  @override
  void initState() {
    super.initState();
    _isDraggingNotifier = ValueNotifier<bool>(false);
    _draggingIndexNotifier = ValueNotifier<int?>(null);
    _isMenuVisibleNotifier = ValueNotifier<bool>(false);
    _focusNode.addListener(() {
      setState(() {
        print("five");
      });
    });
    setState(() {
      print("six");
      filterIndex = widget.index;
    });
    _pageController = PageController(initialPage: currentPage);
    context.read<FavouriteBloc>().add(LoadFavourites(search: ""));
  }

  void _onSearchSubmit() {
    setState(() {
      print("seven");
      filterIndex = 3;
    });
    context
        .read<FavouriteBloc>()
        .add(LoadFavourites(search: _textController.text));
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _isDraggingNotifier.dispose();
    _draggingIndexNotifier.dispose();
    _pageController.dispose();
    _focusNode.dispose();
    _isMenuVisibleNotifier.dispose();
    super.dispose();
  }

  void setFilterIndex(int value) {
    setState(() {
      print("nine");
      filterIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop([
          ImageManager().getImage(1),
          ImageManager().getImage(2),
          ImageManager().getImage(3),
          ImageManager().getImage(4),
          ImageManager().getImage(5),
          ImageManager().getImage(6),
        ]);
        return false;
      },
      child: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
          _isMenuVisibleNotifier.value = false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            toolbarHeight: screenWidth * 0.125,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Transform.scale(
              scale: 1.8,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.04),
                  child: SvgPicture.asset(
                    'assets/images/Logo_Black.svg',
                    width: screenWidth * 0.14, // Responsive logo size
                    height: screenWidth * 0.14, // Responsive logo size
                    fit: BoxFit
                        .contain, // Ensures the logo scales proportionally
                  ),
                ),
              ),
            ),
            actions: [
              if (!widget
                  .isGuestUser) // Show menu button only if the user is not a guest
                Padding(
                  padding: EdgeInsets.only(
                      right: screenWidth * 0.015), // Adjust the value as needed
                  child: ValueListenableBuilder<bool>(
                      valueListenable: _isMenuVisibleNotifier,
                      builder: (context, isVisible, child) {
                        return IconButton(
                          icon: SvgPicture.asset(
                            isVisible
                                ? 'assets/images/menu_white.svg'
                                : 'assets/images/menu.svg',
                            width: screenWidth * 0.085,
                            height: screenWidth * 0.085,
                          ),
                          onPressed: () {
                            _isMenuVisibleNotifier.value =
                                !_isMenuVisibleNotifier.value;
                          },
                        );
                      }),
                ),
            ],
          ),
          body: Stack(
            children: [
              _buildMainContent(screenWidth, screenHeight, context),
              ValueListenableBuilder<bool>(
                  valueListenable: _isMenuVisibleNotifier,
                  builder: (context, isVisible, child) {
                    return isVisible
                        ? Positioned(
                            top:
                                screenHeight * 0.002, // Adjust the top position
                            right: 10, // Adjust the right position
                            child: HamburgerMenu(
                              variant: 1,
                              isGuestUser: widget.isGuestUser,
                              isMenuVisible: isVisible,
                              onMenuToggle: _toggleMenu,
                            ),
                          )
                        : SizedBox.shrink();
                  }),
            ],
          ),
          bottomNavigationBar: AddToCompareRow(
            showCamera: true,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(
      double screenWidth, double screenHeight, BuildContext context) {
    List<Product> prods = [];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Stack(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Uploads',
                style: GoogleFonts.poppins(
                  fontSize: screenHeight * 0.022,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            ]),
            SizedBox(height: screenHeight * 0.012),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.01),
                  Expanded(
                    child: BlocBuilder<FavouriteBloc, FavouriteState>(
                      builder: (context, state) {
                        if (state is FavouriteLoading ||
                            state is UploadImageLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is FavouriteError) {
                          return Center(child: Text(state.message));
                        } else if (state is FavouriteLoaded) {
                          prods = state.favourites[3];
                          if (state.favourites[filterIndex].length == 0) {
                            return Center(
                                child: Text("No Items In This Collection "));
                          }
                          return ProductGrid(
                            setIsDragging: (value) =>
                                _isDraggingNotifier.value = value,
                            setDraggingIndex: (value) =>
                                _draggingIndexNotifier.value = value,
                            isGuestUser: widget.isGuestUser,
                            isFavourites: true,
                            products: prods,
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]),
          ValueListenableBuilder<bool>(
            valueListenable: _isDraggingNotifier,
            builder: (context, isDragging, child) {
              return isDragging
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: DragTarget<Product>(
                        onWillAccept: (data) => true,
                        onAccept: (product) {
                          setState(() {
                            prods.removeAt(_draggingIndexNotifier.value ?? 0);
                          });
                          _isDraggingNotifier.value = false;
                          _draggingIndexNotifier.value = null;
                          _deleteUpload(product);
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 40.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          );
                        },
                      ),
                    )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  void _deleteUpload(Product product) {
    final favouritesBloc = BlocProvider.of<FavouriteBloc>(context);
    favouritesBloc.add(DeleteUpload(id: product.productId));
  }

  void _toggleMenu() {
    setState(() {
      print("thirteen");
      _isMenuVisibleNotifier.value = !_isMenuVisibleNotifier.value;
    });
  }
}
