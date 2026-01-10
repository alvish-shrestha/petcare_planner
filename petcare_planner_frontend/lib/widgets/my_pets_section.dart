// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';

class Pet {
  final String name;
  final String breed;
  final int age;
  final String imageUrl;

  Pet({
    required this.name,
    required this.breed,
    required this.age,
    required this.imageUrl,
  });
}

class MyPetsSection extends StatelessWidget {
  final List<Pet> pets;
  final VoidCallback onAddNewPet;
  final ValueChanged<Pet>? onPetTap;

  const MyPetsSection({
    super.key,
    required this.pets,
    required this.onAddNewPet,
    this.onPetTap,
  });

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.098),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          // List of pet items
          for (final pet in pets) ...[
            GestureDetector(
              onTap: () => onPetTap?.call(pet),
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(pet.imageUrl),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontFamily: "Poppins-Medium",
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "${pet.breed}\n• ${pet.age} years",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            color: AppColors.textPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Add New Pet Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: onAddNewPet,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add New Pet",
                style: TextStyle(
                  fontFamily: "Poppins-Medium",
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
