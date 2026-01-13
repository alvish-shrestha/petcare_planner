// ignore_for_file: use_build_context_synchronously, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/modal/delete_modal.dart';
import 'package:petcare_planner_frontend/models/pet.dart';
import 'package:petcare_planner_frontend/utils/api_config.dart';
import 'package:petcare_planner_frontend/widgets/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/pet_view_model.dart';
import 'package:petcare_planner_frontend/widgets/action_button.dart';
import 'package:petcare_planner_frontend/widgets/app_snackbar.dart';
import 'package:petcare_planner_frontend/widgets/custom_dropdown.dart';
import 'package:petcare_planner_frontend/widgets/custom_text_field.dart';
import 'package:petcare_planner_frontend/widgets/pet_type_card.dart';
import 'package:provider/provider.dart';

class EditPetScreen extends StatefulWidget {
  final Pet pet;

  const EditPetScreen({super.key, required this.pet});

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  late final TextEditingController petNameController;
  late final TextEditingController breedController;
  late final TextEditingController ageController;

  @override
  void initState() {
    super.initState();
    petNameController = TextEditingController(text: widget.pet.petName);
    breedController = TextEditingController(text: widget.pet.breed);
    ageController = TextEditingController(text: widget.pet.age.toString());

    Future.microtask(() {
      final viewModel = context.read<PetViewModel>();
      viewModel.clearImage();
      viewModel.setPetType(widget.pet.petType);
      viewModel.setGender(widget.pet.gender);
    });
  }

  @override
  void dispose() {
    petNameController.dispose();
    breedController.dispose();
    ageController.dispose();
    super.dispose();
  }

  // --- UPDATED DELETE HANDLER ---
  void _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => const DeleteModal(),
    );

    if (confirm == true && mounted) {
      final viewModel = context.read<PetViewModel>();
      final success = await viewModel.deletePet(widget.pet.id);

      if (mounted && success) {
        Navigator.pop(context);
        AppSnackBar.show(
          context,
          message: "Pet deleted",
          type: SnackBarType.success,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PetViewModel>();

    final List<Map<String, dynamic>> petTypes = [
      {"label": "Dog", "imagePath": "assets/images/Dog.png"},
      {"label": "Cat", "imagePath": "assets/images/Cat.png"},
      {"label": "Other", "imagePath": "assets/images/Other.png"},
    ];

    final String? networkImageUrl = widget.pet.petImage != null
        ? "${ApiConfig.baseUrl}/${widget.pet.petImage!.replaceAll('\\', '/')}"
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              /// --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () {
                        viewModel.clearImage();
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  // Title
                  const Text(
                    "Edit Pet",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 24,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  // Delete Icon (Right side)
                  IconButton(
                    onPressed: _handleDelete,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// --- PHOTO PICKER ---
              GestureDetector(
                onTap: viewModel.pickImage,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x72000000),
                        offset: const Offset(0, 2),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _buildProfileImage(viewModel, networkImageUrl),
                  ),
                ),
              ),

              const SizedBox(height: 6),
              const Text(
                "Change Photo",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  color: Color(0xA6725E5E),
                ),
              ),

              const SizedBox(height: 20),

              /// --- PET TYPE ---
              SizedBox(
                width: 330,
                child: const Text(
                  "Pet Type",
                  style: TextStyle(
                    fontFamily: "Poppins-Bold",
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: petTypes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final pet = petTypes[index];
                    return PetTypeCard(
                      label: pet['label'] as String,
                      imagePath: pet['imagePath'] as String,
                      selected: viewModel.petType == pet['label'],
                      onTap: () => viewModel.setPetType(pet['label'] as String),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              /// --- PET NAME ---
              SizedBox(
                width: 330,
                child: const Text(
                  "Pet Name",
                  style: TextStyle(
                    fontFamily: "Poppins-Bold",
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 330,
                height: 60,
                child: CustomTextField(
                  hint: "Pet Name",
                  controller: petNameController,
                ),
              ),

              const SizedBox(height: 8),

              /// --- BREED ---
              SizedBox(
                width: 330,
                child: const Text(
                  "Breed",
                  style: TextStyle(
                    fontFamily: "Poppins-Bold",
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 330,
                height: 60,
                child: CustomTextField(
                  hint: "Breed",
                  controller: breedController,
                ),
              ),

              const SizedBox(height: 14),

              /// --- AGE ---
              SizedBox(
                width: 330,
                child: const Text(
                  "Age",
                  style: TextStyle(
                    fontFamily: "Poppins-Bold",
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              /// --- AGE + GENDER ---
              SizedBox(
                width: 330,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: CustomTextField(
                          hint: "Years",
                          controller: ageController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: CustomDropdown(
                          value: viewModel.gender,
                          hint: 'Select',
                          items: const ['Male', 'Female'],
                          onChanged: (value) => viewModel.setGender(value!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// --- UPDATE BUTTON ---
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 20,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator()
                    : ActionButton(
                        text: "Update",
                        onPressed: () async {
                          if (petNameController.text.isEmpty ||
                              breedController.text.isEmpty ||
                              ageController.text.isEmpty) {
                            AppSnackBar.show(
                              context,
                              message: "All fields are required",
                              type: SnackBarType.error,
                            );
                            return;
                          }

                          final age = int.tryParse(ageController.text);
                          if (age == null) {
                            AppSnackBar.show(
                              context,
                              message: "Invalid age",
                              type: SnackBarType.error,
                            );
                            return;
                          }

                          final success = await viewModel.updatePet(
                            petId: widget.pet.id,
                            petName: petNameController.text.trim(),
                            breed: breedController.text.trim(),
                            age: age,
                          );

                          if (mounted && success) {
                            AppSnackBar.show(
                              context,
                              message: "Pet updated!",
                              type: SnackBarType.success,
                            );
                            Navigator.pop(context);
                          } else if (mounted) {
                            AppSnackBar.show(
                              context,
                              message:
                                  viewModel.errorMessage ?? "Update failed",
                              type: SnackBarType.error,
                            );
                          }
                        },
                      ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// Logic to decide which image to show
  Widget _buildProfileImage(PetViewModel viewModel, String? networkUrl) {
    // 1. User picked a new file
    if (viewModel.petImage != null) {
      return Image.file(viewModel.petImage!, fit: BoxFit.cover);
    }
    // 2. Existing image from Backend
    if (networkUrl != null) {
      return Image.network(
        networkUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.pets, size: 40, color: Colors.grey);
        },
      );
    }
    // 3. No image at all
    return const Icon(Icons.add_a_photo, size: 32, color: Colors.grey);
  }
}
