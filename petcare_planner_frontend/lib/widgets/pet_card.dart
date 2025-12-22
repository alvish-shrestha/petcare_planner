import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/pet.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final bool isSelected;
  final VoidCallback onTap;

  const PetCard({
    super.key,
    required this.pet,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            _petAvatar(),
            const SizedBox(height: 10),
            Text(
              pet.petName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "Poppins-Medium",
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _petAvatar() {
    return CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.background,
      backgroundImage: pet.petImage != null && pet.petImage!.isNotEmpty
          ? NetworkImage(pet.petImage!)
          : null,
      child: pet.petImage == null || pet.petImage!.isEmpty
          ? const Icon(Icons.pets, size: 26)
          : null,
    );
  }
}
