// ignore_for_file: unused_element_parameter, unnecessary_underscores, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/repository/task_repository.dart';
import 'package:petcare_planner_frontend/services/task_service.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/pet_view_model.dart';
import 'package:petcare_planner_frontend/view_models/task_view_model.dart';
import 'package:petcare_planner_frontend/views/task/add_task.dart';
import 'package:petcare_planner_frontend/widgets/action_button.dart';
import 'package:petcare_planner_frontend/widgets/app_snackbar.dart';
import 'package:petcare_planner_frontend/widgets/custom_dropdown.dart';
import 'package:petcare_planner_frontend/widgets/custom_text_field.dart';
import 'package:petcare_planner_frontend/widgets/pet_type_card.dart';
import 'package:provider/provider.dart';

class AddPetScreen extends StatelessWidget {
  const AddPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const Padding(padding: EdgeInsets.all(16.0), child: _AddPetForm()),
    );
  }
}

class _AddPetForm extends StatefulWidget {
  const _AddPetForm({super.key});

  @override
  State<_AddPetForm> createState() => _AddPetFormState();
}

class _AddPetFormState extends State<_AddPetForm> {
  late final TextEditingController petNameController;
  late final TextEditingController breedController;
  late final TextEditingController ageController;

  @override
  void initState() {
    super.initState();
    petNameController = TextEditingController();
    breedController = TextEditingController();
    ageController = TextEditingController();
  }

  @override
  void dispose() {
    petNameController.dispose();
    breedController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PetViewModel>();

    final List<Map<String, dynamic>> petTypes = [
      {"label": "Dog", "imagePath": "assets/images/Dog.png"},
      {"label": "Cat", "imagePath": "assets/images/Cat.png"},
      {"label": "Other", "imagePath": "assets/images/Other.png"},
    ];

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 60),

            /// --- TITLE ---
            const Text(
              "Add Your Pet",
              style: TextStyle(
                fontFamily: "Poppins-Bold",
                fontSize: 36,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Let's meet your pet!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins-Bold",
                fontSize: 20,
                color: AppColors.textPrimary,
              ),
            ),

            const Text(
              "Add a photo and basic information",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

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
                child: viewModel.petImage != null
                    ? ClipOval(
                        child: Image.file(
                          viewModel.petImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.add_a_photo, size: 32),
              ),
            ),

            SizedBox(height: 6),

            /// --- Add Photo label ---
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Add Photo",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: Color(0xA6725E5E),
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// --- PET TYPE ---
            SizedBox(
              width: 330,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Pet Type",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 2),

            SizedBox(
              width: 330,
              child: Center(
                child: SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: petTypes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, index) {
                      final pet = petTypes[index];
                      return PetTypeCard(
                        label: pet['label'] as String,
                        imagePath: pet['imagePath'] as String,
                        selected: viewModel.petType == pet['label'],
                        onTap: () =>
                            viewModel.setPetType(pet['label'] as String),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// --- PET NAME ---
            SizedBox(
              width: 330,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Pet Name",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 330,
              height: 60,
              child: CustomTextField(
                hint: "e.g. Max, Luna, Buddy",
                controller: petNameController,
              ),
            ),

            const SizedBox(height: 8),

            /// --- BREED ---
            SizedBox(
              width: 330,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Breed",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 330,
              height: 60,
              child: CustomTextField(
                hint: "e.g. Golden Retriever",
                controller: breedController,
              ),
            ),

            const SizedBox(height: 14),

            /// --- AGE ---
            SizedBox(
              width: 330,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Age",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
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
                        items: ['Male', 'Female'],
                        onChanged: (value) => viewModel.setGender(value!),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// --- SUBMIT BUTTON ---
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 20),
                ],
                borderRadius: BorderRadius.circular(30),
              ),
              child: viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : ActionButton(
                      text: "Submit",
                      onPressed: () async {
                        final viewModel = context.read<PetViewModel>();

                        if (viewModel.petType == null ||
                            viewModel.gender == null) {
                          AppSnackBar.show(
                            context,
                            message: "Please select pet type and gender",
                            type: SnackBarType.error,
                          );
                          return;
                        }

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

                        final success = await viewModel.addPet(
                          petName: petNameController.text.trim(),
                          breed: breedController.text.trim(),
                          age: int.parse(ageController.text),
                        );

                        if (!mounted) return;

                        if (success) {
                          AppSnackBar.show(
                            context,
                            message: "Pet Added Successfully!",
                            type: SnackBarType.success,
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) => TaskViewModel(
                                  TaskRepository(TaskService()),
                                ),
                                child: const AddTaskScreen(),
                              ),
                            ),
                          );
                        } else {
                          AppSnackBar.show(
                            context,
                            message:
                                viewModel.errorMessage ?? "Failed to add pet",
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
    );
  }
}
