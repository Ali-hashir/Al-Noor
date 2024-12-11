import 'package:alnoor/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutUsPage extends StatefulWidget {
  final bool isGuestUser;

  const AboutUsPage({Key? key, required this.isGuestUser}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  late ValueNotifier<bool> _isMenuVisibleNotifier;

  @override
  void initState() {
    super.initState();
    _isMenuVisibleNotifier = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(onTap: () {
      _isMenuVisibleNotifier.value = false;
    }, child: Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Main content background
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: constraints.maxHeight * 0.1),
                        Container(
                          height: constraints.maxHeight * 0.4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/AboutUs.png'), // Replace with your image path
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.03),
                        Center(
                            child: Text(
                          'About Us',
                          style: TextStyle(
                            fontSize: constraints.maxHeight * 0.02,
                            fontWeight: FontWeight.w900,
                          ),
                        )),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        Center(
                          child: Text(
                            'Al-Noor Group of companies first began its operations with trading activities in the late nineteenth century in Mauritius and subsequently offices were set up in India, Sri Lanka and Burma to handle trading of sugar, rice and jute. After the partition of the sub-continent, the Group established Noori Trading Corporation (Pvt) Limited in Karachi, Pakistan to handle the trading of general merchandise and in 1960 Noori Sugar Factory was established with a cane research farm in Moro/Nawabshah District along with a small sugar-manufacturing unit.',
                            style: TextStyle(
                              fontSize: constraints.maxHeight * 0.016,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isMenuVisibleNotifier,
                builder: (context, isVisible, child) {
                  return (isVisible && !widget.isGuestUser)
                      ? Positioned(
                          top: constraints.maxHeight * 0.09,
                          right: 20,
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
              // Top bar with logo and menu icon
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 0,
                    right: screenWidth * 0.02,
                    top: constraints.maxHeight * 0.03,
                    bottom: constraints.maxHeight * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/Logo_Black.svg',
                          width: 67,
                          height: 67,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
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
                                onPressed: () {
                                  _isMenuVisibleNotifier.value =
                                      !_isMenuVisibleNotifier.value;
                                },
                              );
                            }),
                    ],
                  ),
                ),
              ),
              // Hamburger menu overlay
            ],
          );
        },
      ),
    ));
  }

  void _toggleMenu() {
    _isMenuVisibleNotifier.value = !_isMenuVisibleNotifier.value;
  }
}
