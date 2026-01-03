import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/api_utils.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/pet_view_model.dart';
import 'package:petcare_planner_frontend/widgets/pet_details_card.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<PetViewModel>();
      if (vm.pets.isEmpty && !vm.isLoading) {
        vm.fetchPets();
      }
    });

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 80),

          /// --- Time of the day ---
          SizedBox(
            width: 330,
            child: const Text(
              "Good morning",
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
              children: [
                const Text(
                  "Hi, User! 👋",
                  style: TextStyle(
                    fontFamily: "Poppins-Bold",
                    fontSize: 24,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(width: 150),

                // --- Notification ---
                GestureDetector(
                  onTap: () {
                    // TODO: Notification
                    print("Notificaton clicked");
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x19000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.notifications, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          /// --- PET DETAILS CARD ---
          Consumer<PetViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                );
              }

              if (vm.selectedPet == null) {
                return const SizedBox();
              }

              return GestureDetector(
                onTap: () => _showPetSelector(context),
                child: PetDetailsCard(pet: vm.selectedPet!),
              );
            },
          ),

          const SizedBox(height: 40),

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
        ],
      ),
    );
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
}
