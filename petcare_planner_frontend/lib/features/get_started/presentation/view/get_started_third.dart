import 'package:flutter/material.dart';

class GetStartedThree extends StatelessWidget {
  const GetStartedThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0DC),
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
              height: 392, // Fixed height
              child: Image.asset(
                "assets/images/get_started_three.png",
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 0),

            /// --- Subtitle ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Track everything in one\nsimple app.",
                style: TextStyle(
                  fontFamily: "Poppins-SemiBold",
                  fontSize: 18,
                  color: Color(0xFF725E5E),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

            /// --- Bottom Button ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    height: 44,
                    width: 317,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7BAF9E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Get Started",
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
