import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/models/pet.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';

class PetCard extends StatelessWidget {
  final List<Pet> pets;
  final String? selectedPetId;
  final bool isLoading;
  final Function(String) onPetSelected;

  const PetCard({
    super.key,
    required this.pets,
    required this.selectedPetId,
    required this.isLoading,
    required this.onPetSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      height: 110,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pets.isEmpty
          ? const Center(child: Text("No pets found"))
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: pets.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final pet = pets[index];
                final selected = selectedPetId == pet.id;

                return GestureDetector(
                  onTap: () => onPetSelected(pet.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: 100,
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: pet.petImage != null
                              ? Image.network(
                                  "http://localhost:3000/${pet.petImage}",
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/default_pet.png",
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pet.petName,
                          style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            fontSize: 13,
                            color: selected
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
