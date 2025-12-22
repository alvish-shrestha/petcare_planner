// ignore_for_file: unused_element_parameter, unnecessary_underscores, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/pet_view_model.dart';
import 'package:petcare_planner_frontend/view_models/task_view_model.dart';
import 'package:petcare_planner_frontend/widgets/action_button.dart';
import 'package:petcare_planner_frontend/widgets/app_snackbar.dart';
import 'package:petcare_planner_frontend/widgets/custom_date_picker.dart';
import 'package:petcare_planner_frontend/widgets/custom_text_field.dart';
import 'package:petcare_planner_frontend/widgets/custom_time_picker.dart';
import 'package:petcare_planner_frontend/widgets/frequency_selector.dart';
import 'package:petcare_planner_frontend/widgets/pet_card.dart';
import 'package:petcare_planner_frontend/widgets/reminder_toggle.dart';
import 'package:petcare_planner_frontend/widgets/task_type_card.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const Padding(padding: EdgeInsets.all(16.0), child: _AddTaskForm()),
    );
  }
}

class _AddTaskForm extends StatefulWidget {
  const _AddTaskForm({super.key});

  @override
  State<_AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<_AddTaskForm> {
  late final TextEditingController taskTitleController;
  String? selectedPetId;
  String? selectedTaskType;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String repeat = 'None';
  late final TextEditingController notesController;
  bool reminder = true;

  @override
  void initState() {
    super.initState();
    taskTitleController = TextEditingController();
    notesController = TextEditingController();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetViewModel>().fetchPets();
    });
  }

  @override
  void dispose() {
    taskTitleController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> taskTypes = [
      {'label': 'Feeding', 'image': "assets/images/feeding.png"},
      {'label': 'Walking', 'image': "assets/images/walking.png"},
      {'label': 'Grooming', 'image': "assets/images/grooming.png"},
      {'label': 'Medical', 'image': "assets/images/medical.png"},
    ];
    final viewModel = context.watch<TaskViewModel>();
    final petViewModel = context.watch<PetViewModel>();

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 60),

            /// --- TITLE ---
            SizedBox(
              width: 330,
              child: Row(
                children: [
                  // --- Back Button on left ---
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),

                  const Spacer(),

                  // --- Center Title ---
                  const Text(
                    "New Task",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// --- Task Title ---
            SizedBox(
              width: 330,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Task Title",
                    style: TextStyle(
                      fontFamily: "Poppins-Medium",
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
              height: 60,
              child: CustomTextField(
                hint: "Enter task name",
                controller: taskTitleController,
              ),
            ),

            const SizedBox(height: 14),

            /// --- Select Pet ---
            SizedBox(
              width: 330,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Pet",
                    style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 2),

            PetCard(
              pets: petViewModel.pets,
              selectedPetId: selectedPetId,
              isLoading: petViewModel.isLoading,
              onPetSelected: (id) {
                setState(() {
                  selectedPetId = id;
                });
              },
            ),

            const SizedBox(height: 14),

            /// --- Task Type ---
            SizedBox(
              width: 330,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Task Type",
                    style: TextStyle(
                      fontFamily: "Poppins-Medium",
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
              height: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final taskType in taskTypes)
                    TaskTypeCard(
                      label: taskType['label']!,
                      imagePath: taskType['image']!,
                      selected: selectedTaskType == taskType['label'],
                      onTap: () {
                        setState(() {
                          selectedTaskType = taskType['label'];
                        });
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// --- Date & Time Picker ---
            SizedBox(
              width: 330,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            "Date",
                            style: const TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 60,
                          child: CustomDateField(
                            initialDate: selectedDate,
                            imageAssetPath: "assets/images/calendar.png",
                            hint: "Select date",
                            onDateChanged: (newDate) {
                              setState(() {
                                selectedDate = newDate;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            "Time",
                            style: const TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 60,
                          child: CustomTimeField(
                            initialTime: selectedTime,
                            imageAssetPath: "assets/images/clock.png",
                            hint: "Select time",
                            onTimeChanged: (newTime) {
                              setState(() {
                                selectedTime = newTime;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// --- Repeat ---
            SizedBox(
              width: 330,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Repeat",
                    style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            SizedBox(width: 330, child: FrequencySelector()),

            const SizedBox(height: 14),

            /// --- Notes ---
            SizedBox(
              width: 330,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Notes (Optional)",
                    style: TextStyle(
                      fontFamily: "Poppins-Medium",
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
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  height: 96, // approx 3 rows height
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        offset: Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: notesController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 3,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: "Poppins",
                      fontSize: 14,
                    ),
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: "Write notes here...",
                      hintStyle: TextStyle(
                        color: Color(0x59716F6F),
                        fontFamily: "Poppins",
                        fontSize: 16,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: 330,
              child: ReminderToggle(
                initialValue: true,
                onChanged: (value) {
                  print("Reminder: $value");
                },
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
                      text: "Create Task",
                      onPressed: () async {
                        final viewModel = context.read<TaskViewModel>();

                        if (taskTitleController.text.trim().isEmpty) {
                          AppSnackBar.show(
                            context,
                            message: "Task title is required",
                            type: SnackBarType.error,
                          );
                          return;
                        }
                        if (selectedPetId == null) {
                          AppSnackBar.show(
                            context,
                            message: "Please select a pet",
                            type: SnackBarType.error,
                          );
                          return;
                        }
                        if (selectedTaskType == null) {
                          AppSnackBar.show(
                            context,
                            message: "Please select a task type",
                            type: SnackBarType.error,
                          );
                          return;
                        }
                        if (selectedDate == null || selectedTime == null) {
                          AppSnackBar.show(
                            context,
                            message: "Please select date and time",
                            type: SnackBarType.error,
                          );
                          return;
                        }

                        final timeString =
                            "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

                        final success = await viewModel.createTask(
                          taskTitle: taskTitleController.text.trim(),
                          petId: selectedPetId!,
                          taskType: selectedTaskType!,
                          date: selectedDate!,
                          time: timeString,
                          repeat: repeat,
                          notes: notesController.text.trim().isEmpty
                              ? null
                              : notesController.text.trim(),
                          reminder: reminder,
                        );

                        if (viewModel.errorMessage != null) {
                          AppSnackBar.show(
                            context,
                            message: viewModel.errorMessage!,
                            type: SnackBarType.error,
                          );
                        } else if (success) {
                          AppSnackBar.show(
                            context,
                            message: "Task added successfully!",
                            type: SnackBarType.success,
                          );
                          Navigator.pop(context);
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
