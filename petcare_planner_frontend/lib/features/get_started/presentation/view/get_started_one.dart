import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/features/get_started/presentation/view/get_started_two.dart';

class GetStartedOne extends StatelessWidget {
  const GetStartedOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2DC),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 65),

            /// --- Title Section ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    "Welcome to",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 36,
                      color: Color(0xFF725E5E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "PetCare Planner",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 36,
                      color: Color(0xFF725E5E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 0),

            /// --- Image Section ---
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 392,
              child: Image.asset(
                "assets/images/get_started_one.png",
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            /// --- Subtitle ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Organize your pet’s daily\ncare easily.",
                style: TextStyle(
                  fontFamily: "Poppins-SemiBold",
                  fontSize: 18,
                  color: Color(0xFF725E5E),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

            /// --- Bottom Buttons ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontFamily: "Poppins-Italic",
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x4D000000),
                          offset: const Offset(0, 4),
                          blurRadius: 15,
                          spreadRadius: 0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: SizedBox(
                      height: 44,
                      width: 175,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7BAF9E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 200,
                              ),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const GetStartedTwo(),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    final offsetAnimation = Tween<Offset>(
                                      begin: const Offset(0.0, 0.1),
                                      end: Offset.zero,
                                    ).animate(animation);

                                    final fadeAnimation = Tween<double>(
                                      begin: 0.0,
                                      end: 1.0,
                                    ).animate(animation);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: FadeTransition(
                                        opacity: fadeAnimation,
                                        child: child,
                                      ),
                                    );
                                  },
                            ),
                          );
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            fontFamily: "Poppins-BoldItalic",
                            fontSize: 16,
                            color: Color(0xFFFDFDFD),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
