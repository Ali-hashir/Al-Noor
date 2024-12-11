import 'package:alnoor/screens/Home/home.dart';
import 'package:alnoor/widgets/contact_card.dart';
import 'package:alnoor/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';

class DealersPage extends StatefulWidget {
  final bool isGuestUser;

  const DealersPage({Key? key, required this.isGuestUser}) : super(key: key);

  @override
  _DealersPageState createState() => _DealersPageState();
}

class _DealersPageState extends State<DealersPage> {
  late ValueNotifier<bool> _isMenuVisibleNotifier;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _isMenuVisibleNotifier = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _isMenuVisibleNotifier.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    _isMenuVisibleNotifier.value = !_isMenuVisibleNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size and apply scaling factors
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          _isMenuVisibleNotifier.value = false;
        },
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 0, right: 16.0, top: 0, bottom: 16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/images/Logo_Black.svg',
                                  width: 67,
                                  height: 67,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                  );
                                },
                              ),
                              if (!widget.isGuestUser)
                                ValueListenableBuilder<bool>(
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
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ContactCard(
                                  heading: "Karachi Design Studio",
                                  address:
                                      "24-C, 7th Commercial Lane, Main Khayaban-e-Bahria, Phase IV, Dha, Karachi.",
                                  phone1: "+92 21 372 372 05",
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                ContactCard(
                                  heading: "Lahore Design Studio",
                                  address:
                                      "7-AI Sector XX, Phase 3, DHA, Lahore.",
                                  phone1: "+92 21 372 372 05",
                                ),
                                SizedBox(height: screenHeight * 0.06),
                                ElevatedButton(
                                  onPressed: () async {
                                    await EasyLauncher.url(
                                        url: "https://alnoormdf.com/dealers");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff464444),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 32.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    "Find A Dealer",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isMenuVisibleNotifier,
                    builder: (context, isVisible, child) {
                      return (isVisible && !widget.isGuestUser)
                          ? Positioned(
                              top: constraints.maxHeight * 0.083,
                              right: 29,
                              child: HamburgerMenu(
                                variant: 2,
                                isGuestUser: widget.isGuestUser,
                                isMenuVisible: isVisible,
                                onMenuToggle: _toggleMenu,
                              ),
                            )
                          : Container();
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isMenuVisibleNotifier,
                    builder: (context, isVisible, child) {
                      return (isVisible && !widget.isGuestUser)
                          ? Positioned(
                              top: constraints.maxHeight * 0.028,
                              right: 16,
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  'assets/images/menu_white.svg',
                                  width: screenWidth * 0.065,
                                  height: screenWidth * 0.065,
                                ),
                                onPressed: _toggleMenu,
                              ))
                          : Container();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
