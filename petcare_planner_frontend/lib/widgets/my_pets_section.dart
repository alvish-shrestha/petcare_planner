// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/models/pet.dart';
import 'package:petcare_planner_frontend/widgets/app_colors.dart';
import 'package:petcare_planner_frontend/utils/pet_api_utils.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (pets.isEmpty) ...[
            const Text(
              "No pets found",
              style: TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
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
                        backgroundImage:
                            pet.petImage != null && pet.petImage!.isNotEmpty
                            ? NetworkImage(
                                PetApiUtils.getFullImageUrl(pet.petImage!),
                              )
                            : null,
                        child: pet.petImage == null || pet.petImage!.isEmpty
                            ? const Icon(Icons.pets)
                            : null,
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet.petName,
                            style: const TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            "${pet.breed}\n• ${pet.age} years",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],

          /// --- Add New Pet Button ---
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
