import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/models/pet.dart';
import 'package:petcare_planner_frontend/utils/pet_api_utils.dart';
import 'package:petcare_planner_frontend/widgets/app_colors.dart';

class PetDetailsCard extends StatelessWidget {
  final Pet pet;
  const PetDetailsCard({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // --- Pet image circle ---
          ClipOval(
            child: pet.petImage != null && pet.petImage!.isNotEmpty
                ? Image.network(
                    PetApiUtils.getFullImageUrl(pet.petImage!),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _placeholderImageCircle(),
                  )
                : _placeholderImageCircle(),
          ),

          SizedBox(width: 16),

          // --- Pet info ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.petName,
                  style: const TextStyle(
                    fontFamily: 'Poppins-Bold',
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${pet.breed} • Age: ${pet.age}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // --- Dropdown arrow ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 30,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImageCircle() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey[300],
      child: const Icon(Icons.pets, size: 30, color: Colors.grey),
    );
  }
}
