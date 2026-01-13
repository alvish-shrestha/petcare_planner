// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/pet_api_utils.dart';
import 'package:petcare_planner_frontend/widgets/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/auth_view_model.dart';
import 'package:petcare_planner_frontend/view_models/pet_view_model.dart';
import 'package:petcare_planner_frontend/view_models/task_view_model.dart';
import 'package:petcare_planner_frontend/views/pet/add_pet.dart';
import 'package:petcare_planner_frontend/views/task/add_task.dart';
import 'package:petcare_planner_frontend/widgets/add_task_button.dart';
import 'package:petcare_planner_frontend/widgets/pet_details_card.dart';
import 'package:petcare_planner_frontend/widgets/task_list_view.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  /// --- TIME OF THE DAY ---
  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  /// --- PET SELECTOR ---
  void _showPetSelector(BuildContext context) {
    final vm = context.read<PetViewModel>();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: vm.pets.length + 1,
          separatorBuilder: (_, _) =>
              Divider(color: AppColors.textPrimary.withOpacity(0.1)),
          itemBuilder: (context, index) {
            if (index == vm.pets.length) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  // Icon color matching text
                  child: const Icon(Icons.add, color: AppColors.textPrimary),
                ),
                title: const Text(
                  "Add New Pet",
                  style: TextStyle(
                    fontFamily: "Poppins-Bold",
                    color: AppColors.textPrimary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddPetScreen()),
                  );
                },
              );
            }

            final pet = vm.pets[index];
            final isSelected = pet.id == vm.selectedPet?.id;

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: pet.petImage != null
                    ? NetworkImage(PetApiUtils.getFullImageUrl(pet.petImage!))
                    : null,
                child: pet.petImage == null
                    ? const Icon(
                        Icons.pets,
                        color: AppColors.textPrimary,
                        size: 20,
                      )
                    : null,
              ),
              title: Text(
                pet.petName,
                style: const TextStyle(
                  fontFamily: "Poppins-Bold",
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                '${pet.breed} • Age ${pet.age}',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12,
                  color: AppColors.textPrimary.withOpacity(0.7),
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.textPrimary)
                  : null,
              onTap: () {
                vm.selectPet(pet);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final petVM = context.read<PetViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (petVM.pets.isEmpty && !petVM.isLoading) {
        petVM.fetchPets();
      }
    });

    return Center(
      child: SizedBox(
        width: 340,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 80),

                /// --- Time of the day ---
                SizedBox(
                  width: 330,
                  child: Text(
                    _getGreeting(),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                /// --- Username ---
                SizedBox(
                  width: 330,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<AuthViewModel>(
                        builder: (context, authVM, _) {
                          final username = authVM.user?.username ?? 'User';
                          return Text(
                            'Hi, $username! 👋',
                            style: const TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: 24,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),

                      /// --- Notification Icon ---
                      Transform.translate(
                        offset: const Offset(0, -8),
                        child: GestureDetector(
                          onTap: () {
                            // TODO
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x20000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.notifications,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// --- PET DETAILS / EMPTY STATE ---
                Consumer<PetViewModel>(
                  builder: (context, petVM, _) {
                    if (petVM.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(),
                      );
                    }

                    /// --- NO PETS STATE ---
                    if (petVM.pets.isEmpty) {
                      return Container(
                        width: 330,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x20000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.pets,
                              size: 48,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "No pets added yet",
                              style: TextStyle(
                                fontFamily: "Poppins-Bold",
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Add your pet to start managing care tasks",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AddPetScreen(),
                                  ),
                                );
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    "Add Pet",
                                    style: TextStyle(
                                      fontFamily: "Poppins-Bold",
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Positioned(
                                    bottom:
                                        0, // adjust this to add more space below the text
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 2, // thickness of underline
                                      color: AppColors.textPrimary.withOpacity(
                                        0.5,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    /// --- PET DETAILS CARD ---
                    if (petVM.selectedPet == null) {
                      petVM.selectPet(petVM.pets.first);
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final taskVM = context.read<TaskViewModel>();
                      taskVM.fetchTasks(petId: petVM.selectedPet!.id);
                    });

                    return GestureDetector(
                      onTap: () => _showPetSelector(context),
                      child: PetDetailsCard(pet: petVM.selectedPet!),
                    );
                  },
                ),

                const SizedBox(height: 20),

                /// --- TODAY'S CARE PLAN ---
                SizedBox(
                  width: 330,
                  child: const Text(
                    "Today's Care Plan",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                /// --- TASK CARD ---
                Expanded(
                  child: SizedBox(
                    width: 340,
                    child: Consumer<TaskViewModel>(
                      builder: (context, taskVM, _) {
                        final today = DateTime.now();
                        final todayDateOnly = DateTime(
                          today.year,
                          today.month,
                          today.day,
                        );

                        final todayTasks = taskVM.tasks.where((task) {
                          final localDate = task.date.toLocal();
                          final taskDateOnly = DateTime(
                            localDate.year,
                            localDate.month,
                            localDate.day,
                          );
                          return taskDateOnly == todayDateOnly;
                        }).toList();

                        return TaskListView(tasks: todayTasks);
                      },
                    ),
                  ),
                ),
              ],
            ),

            /// --- Add Task Button ---
            Positioned(
              bottom: 24,
              right: 0,
              child: AddTaskButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddTaskScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
