import 'package:flutter/material.dart';

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
              width: MediaQuery.of(context).size.width, // Full width
              height: 392, // Fixed height
              child: Image.asset(
                "assets/images/get_started_one_dog.png",
                fit: BoxFit.cover, // Fills left & right
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
                  SizedBox(
                    height: 44,
                    width: 175,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF89B2A0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
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
