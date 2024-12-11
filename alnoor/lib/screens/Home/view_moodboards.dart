// ignore_for_file: deprecated_member_use

import 'package:alnoor/blocs/moodboard_bloc.dart';
import 'package:alnoor/models/moodboard.dart';
import 'package:alnoor/screens/Home/home.dart';
import 'package:alnoor/widgets/Four_Image_Display.dart';
import 'package:alnoor/widgets/Two_Image_Display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import '../../widgets/menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Moodboards(
        index: 0,
        isGuestUser: false,
      ),
    );
  }
}

class Moodboards extends StatefulWidget {
  final int index;
  final bool isGuestUser;

  Moodboards({required this.index, this.isGuestUser = false});

  @override
  _MoodboardsState createState() => _MoodboardsState();
}

class _MoodboardsState extends State<Moodboards> {
  FocusNode _focusNode = FocusNode();
  late ValueNotifier<bool> _isMenuVisibleNotifier;
  bool isDragging = false;
  int? draggingIndex;
  // TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isMenuVisibleNotifier = ValueNotifier<bool>(false);
    _focusNode.addListener(() {
      setState(() {
        print("five");
      });
    });
    context.read<MoodboardBloc>().add(LoadMoodboards(search: ""));
  }

  // void _onSearchSubmit() {
  //   setState(() {
  //     print("seven");
  //     filterIndex = 0;
  //   });
  //   context
  //       .read<FavouriteBloc>()
  //       .add(LoadFavourites(search: _textController.text));
  //   _focusNode.unfocus();
  // }

  @override
  void dispose() {
    _focusNode.dispose();
    _isMenuVisibleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
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
                  fit: BoxFit.contain, // Ensures the logo scales proportionally
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
                          top: screenHeight * 0.002, // Adjust the top position
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
      ),
    );
  }

  Widget _buildMainContent(
      double screenWidth, double screenHeight, BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;

    // State to manage dragging status

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stack(
          //   alignment: Alignment.center,
          //   children: [
          //     Container(
          //       height: screenHeight * 0.035,
          //       child: TextField(
          //         controller: _textController,
          //         focusNode: _focusNode,
          //         onChanged: (text) {
          //           if (_textController.text.isEmpty) {
          //             _onSearchSubmit();
          //           }
          //         },
          //         onSubmitted: (text) {
          //           _onSearchSubmit();
          //         },
          //         decoration: InputDecoration(
          //           suffixIcon: _textController.text.isNotEmpty
          //               ? IconButton(
          //                   icon: Container(
          //                     decoration: BoxDecoration(
          //                       shape: BoxShape.circle,
          //                       color: Colors.white,
          //                     ),
          //                     child: Icon(
          //                       Icons.close,
          //                       size: screenSize.width * 0.03,
          //                       color: Colors.black,
          //                     ),
          //                   ),
          //                   onPressed: () {
          //                     setState(() {
          //                       _textController.text = "";
          //                     });
          //                     _onSearchSubmit(); // Optionally call this if you want to trigger the search when clearing the text
          //                   },
          //                 )
          //               : null,
          //           filled: true,
          //           fillColor: Color(0xFFEFEFEF),
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(4),
          //             borderSide: BorderSide.none,
          //           ),
          //           contentPadding:
          //               EdgeInsets.symmetric(horizontal: screenWidth * 0.038),
          //         ),
          //         style: TextStyle(fontSize: screenHeight * 0.015),
          //         textAlign: TextAlign.left,
          //       ),
          //     ),
          //     if (!_focusNode.hasFocus && _textController.text.isEmpty)
          //       Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Icon(Icons.search,
          //               color: Colors.grey, size: screenHeight * 0.02),
          //           SizedBox(width: screenWidth * 0.02),
          //           Text(
          //             'Search Your Moodboards Here',
          //             style: GoogleFonts.poppins(
          //               fontSize: screenHeight * 0.012,
          //               color: Color(0xFF9A9A9A),
          //             ),
          //           ),
          //         ],
          //       ),
          //   ],
          // ),
          SizedBox(height: screenHeight * 0.011),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Moodboards',
              style: GoogleFonts.poppins(
                fontSize: screenHeight * 0.022,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          ]),
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: BlocBuilder<MoodboardBloc, MoodboardState>(
              builder: (context, state) {
                if (state is MoodboardLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is MoodboardError) {
                  return Center(child: Text(state.message));
                } else if (state is MoodboardLoaded) {
                  // Access the list of moodboards from the state
                  final moodboards = state.moodboards;

                  return Stack(
                    children: [
                      // The grid displaying moodboard items
                      GridView.builder(
                        padding: const EdgeInsets.only(
                            bottom: 80.0), // Leave space for trash icon
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: moodboards.length,
                        itemBuilder: (context, index) {
                          final moodboard = moodboards[index];
                          final images = [
                            moodboard.image1,
                            moodboard.image2,
                            moodboard.image3,
                            moodboard.image4
                          ];
                          final nonEmptyImages = images
                              .where((image) => image.isNotEmpty)
                              .toList();

                          Widget imageDisplay;
                          if (nonEmptyImages.length <= 2) {
                            imageDisplay = TwoImageDisplay(
                              id: moodboard.id,
                              name: moodboard.name,
                              imageUrl1: nonEmptyImages[0],
                              imageUrl2: nonEmptyImages.length > 1
                                  ? nonEmptyImages[1]
                                  : '',
                            );
                          } else {
                            imageDisplay = FourImageDisplay(
                              id: moodboard.id,
                              name: moodboard.name,
                              imageUrl1: moodboard.image1,
                              imageUrl2: moodboard.image2,
                              imageUrl3: moodboard.image3,
                              imageUrl4: moodboard.image4,
                            );
                          }

                          return LongPressDraggable<Moodboard>(
                            data: moodboard,
                            onDragStarted: () async {
                              setState(() {
                                isDragging = true;
                                draggingIndex = index;
                              });
                              if (await Vibration.hasVibrator() ?? false) {
                                Vibration.vibrate(
                                    duration:
                                        100); // Vibrate for 100 milliseconds
                              }
                            },
                            onDragEnd: (_) {
                              setState(() {
                                isDragging = false;
                                draggingIndex = null;
                              });
                            },
                            feedback: Opacity(
                              opacity: 0.7,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    16.0), // Adjust the radius as needed
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.425, // Adjust width to fit the design
                                  height:
                                      MediaQuery.of(context).size.height * 0.19,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child:
                                            imageDisplay, // Same image display as in original
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          moodboard
                                              .name, // Include the name in feedback
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              decoration: TextDecoration.none),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            childWhenDragging:
                                Container(), // Empty space when item is being dragged
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(child: imageDisplay),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    moodboard.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // The trash icon that appears when dragging
                      if (isDragging)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: DragTarget<Moodboard>(
                            onWillAccept: (data) => true,
                            onAccept: (moodboard) {
                              setState(() {
                                moodboards.removeAt(draggingIndex!);
                                isDragging = false;
                                draggingIndex = null;
                              });
                              _deleteMoodboard(moodboard);
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 40.0),
                                padding: const EdgeInsets.all(
                                    16.0), // Increased padding to make the target area larger
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 24.0, // Icon size remains small
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void _deleteMoodboard(Moodboard moodboard) {
    final moodboardBloc = BlocProvider.of<MoodboardBloc>(context);
    moodboardBloc.add(DeleteMoodboard(id: moodboard.id));
  }

  void _toggleMenu() {
    setState(() {
      print("thirteen");
      _isMenuVisibleNotifier.value = !_isMenuVisibleNotifier.value;
    });
  }
}
