import 'package:alnoor/screens/Home/favourites.dart';
import 'package:alnoor/screens/Home/home.dart';
import 'package:alnoor/widgets/Image_Collection.dart';
import 'package:alnoor/widgets/menu.dart'; // Import the menu widget
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AddToFavourites extends StatefulWidget {
  final String productId;

  AddToFavourites({required this.productId});

  @override
  _AddToFavouritesState createState() => _AddToFavouritesState();
}

class _AddToFavouritesState extends State<AddToFavourites> {
  int filterIndex = 0;
  late ValueNotifier<bool> _isMenuVisibleNotifier;

  @override
  void initState() {
    _isMenuVisibleNotifier = ValueNotifier<bool>(false);
    super.initState();
  }

  void setFilterIndex(int value) {
    setState(() {
      print("three");
      filterIndex = value;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Favourites(
                index: value,
              )),
    );
  }

  void _toggleMenu() {
    _isMenuVisibleNotifier.value = !_isMenuVisibleNotifier.value;
  }

  @override
  void dispose() {
    _isMenuVisibleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
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
                fit: BoxFit.contain, // Ensures the logo scales proportionally
              ),
            ),
          ),
        ),
        actions: [
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
                    onPressed: _toggleMenu,
                  );
                }),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Favourites',
                    style: GoogleFonts.poppins(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                ]),
                SizedBox(height: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Choose A Collection:",
                              style: GoogleFonts.poppins(
                                  fontSize: 14.0, fontWeight: FontWeight.w600),
                            )
                          ]),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 142,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: OverlappingImagesWidget(
                                    imageUrls: [
                                      'assets/images/Kitchen2.jpg',
                                      'assets/images/Kitchen3.jpg',
                                      'assets/images/Kitchen1.jpg'
                                    ],
                                    text: 'MY KITCHEN',
                                    index: 0,
                                    setFilter: setFilterIndex,
                                    selected: false,
                                    productId: widget.productId,
                                    isFavourites: false),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Favourites(
                                              index: 1,
                                            )),
                                  );
                                },
                                child: OverlappingImagesWidget(
                                    imageUrls: [
                                      'assets/images/Bedroom2.jpg',
                                      'assets/images/Bedroom3.jpg',
                                      'assets/images/Bedroom1.jpg'
                                    ],
                                    text: 'MY BEDROOM',
                                    selected: false,
                                    setFilter: setFilterIndex,
                                    index: 1,
                                    productId: widget.productId,
                                    isFavourites: false),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 142,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Favourites(
                                              index: 2,
                                            )),
                                  );
                                },
                                child: OverlappingImagesWidget(
                                    imageUrls: [
                                      'assets/images/Bedroom2.jpg',
                                      'assets/images/Bedroom3.jpg',
                                      'assets/images/Bedroom1.jpg'
                                    ],
                                    text: 'MY LOUNGE',
                                    index: 2,
                                    productId: widget.productId,
                                    setFilter: setFilterIndex,
                                    selected: false,
                                    isFavourites: false),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
              valueListenable: _isMenuVisibleNotifier,
              builder: (context, isVisible, child) {
                return isVisible
                    ? // Show menu when it's visible
                    Positioned(
                        top: screenHeight * 0.002,
                        right: 10,
                        child: HamburgerMenu(
                          isGuestUser: false,
                          isMenuVisible: isVisible,
                          onMenuToggle: _toggleMenu,
                          variant: 1,
                        ),
                      )
                    : SizedBox.shrink();
              }),
        ],
      ),
    );
  }
}
