import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/api_utils.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/auth_view_model.dart';
import 'package:petcare_planner_frontend/view_models/pet_view_model.dart';
import 'package:petcare_planner_frontend/view_models/task_view_model.dart';
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: vm.pets.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (context, index) {
            final pet = vm.pets[index];
            final isSelected = pet.id == vm.selectedPet?.id;

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: pet.petImage != null
                    ? NetworkImage(ApiUtils.getFullImageUrl(pet.petImage!))
                    : null,
                child: pet.petImage == null ? const Icon(Icons.pets) : null,
              ),
              title: Text(pet.petName),
              subtitle: Text('${pet.breed} • Age ${pet.age}'),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Colors.green)
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final petVM = context.read<PetViewModel>();
      if (petVM.pets.isEmpty && !petVM.isLoading) {
        petVM.fetchPets();
      }
    });

    return Center(
      child: Column(
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
                      // TODO: handle notification tap
                      print("Notification Tapped");
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

          SizedBox(height: 20),

          /// --- PET DETAILS CARD ---
          Consumer<PetViewModel>(
            builder: (context, petVM, _) {
              if (petVM.isLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                );
              }

              if (petVM.selectedPet == null) {
                return const SizedBox();
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
    );
  }
}
