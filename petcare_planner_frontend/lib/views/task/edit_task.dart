// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/widgets/app_snackbar.dart';
import 'package:petcare_planner_frontend/widgets/frequency_selector.dart';
import 'package:provider/provider.dart';
import 'package:petcare_planner_frontend/models/task.dart'; // Import your Task model
import 'package:petcare_planner_frontend/widgets/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/pet_view_model.dart';
import 'package:petcare_planner_frontend/view_models/task_view_model.dart';
import 'package:petcare_planner_frontend/widgets/action_button.dart';
import 'package:petcare_planner_frontend/widgets/custom_date_picker.dart';
import 'package:petcare_planner_frontend/widgets/custom_text_field.dart';
import 'package:petcare_planner_frontend/widgets/custom_time_picker.dart';
import 'package:petcare_planner_frontend/widgets/pet_card.dart';
import 'package:petcare_planner_frontend/widgets/reminder_toggle.dart';
import 'package:petcare_planner_frontend/widgets/task_type_card.dart';

class EditTaskScreen extends StatelessWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _EditTaskForm(task: task),
      ),
    );
  }
}

class _EditTaskForm extends StatefulWidget {
  final Task task;
  const _EditTaskForm({required this.task});

  @override
  State<_EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<_EditTaskForm> {
  late final TextEditingController taskTitleController;
  late final TextEditingController notesController;

  String? selectedPetId;
  String? selectedTaskType;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String repeat = 'None';
  bool reminder = false;

  @override
  void initState() {
    super.initState();

    taskTitleController = TextEditingController(text: widget.task.taskTitle);
    notesController = TextEditingController(text: widget.task.notes ?? "");

    selectedPetId = widget.task.pet.id;
    selectedTaskType = widget.task.taskType;
    selectedDate = widget.task.date;
    repeat = widget.task.repeat;
    reminder = widget.task.reminder;

    try {
      if (widget.task.time.contains(":")) {
        final parts = widget.task.time.split(':');
        selectedTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      } else {
        selectedTime = TimeOfDay.now();
      }
    } catch (e) {
      selectedTime = TimeOfDay.now();
    }

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

            /// --- HEADER ---
            SizedBox(
              width: 330,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  Container(
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
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  // Title
                  const Text(
                    "Edit Task",
                    style: TextStyle(
                      fontFamily: "Poppins-Bold",
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// --- Task Title ---
            _buildSectionLabel("Task Title"),
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
            _buildSectionLabel("Select Pet"),
            const SizedBox(height: 2),
            PetCard(
              pets: petViewModel.pets,
              selectedPetId: selectedPetId,
              isLoading: petViewModel.isLoading,
              onPetSelected: (id) {
                setState(() => selectedPetId = id);
              },
            ),

            const SizedBox(height: 14),

            /// --- Task Type ---
            _buildSectionLabel("Task Type"),
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
                        setState(() => selectedTaskType = taskType['label']);
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// --- Date & Time ---
            SizedBox(
              width: 330,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text("Date", style: _labelStyle),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 60,
                          child: CustomDateField(
                            initialDate: selectedDate,
                            imageAssetPath: "assets/images/calendar.png",
                            hint: "Select date",
                            onDateChanged: (val) =>
                                setState(() => selectedDate = val),
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
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text("Time", style: _labelStyle),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          height: 60,
                          child: CustomTimeField(
                            initialTime: selectedTime,
                            imageAssetPath: "assets/images/clock.png",
                            hint: "Select time",
                            onTimeChanged: (val) =>
                                setState(() => selectedTime = val),
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
            _buildSectionLabel("Notes (Optional)"),
            const SizedBox(height: 2),
            SizedBox(
              width: 330,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  height: 96,
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
                      hintText: "Add any additional details...",
                      hintStyle: TextStyle(
                        color: Color(0x59716F6F),
                        fontFamily: "Poppins",
                        fontSize: 14,
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

            /// --- Reminder Toggle ---
            SizedBox(
              width: 330,
              child: ReminderToggle(
                initialValue: reminder,
                onChanged: (val) => setState(() => reminder = val),
              ),
            ),

            const SizedBox(height: 24),

            /// --- SAVE BUTTON ---
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
                      text: "Save",
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
                        if (selectedPetId == null || selectedTaskType == null) {
                          AppSnackBar.show(
                            context,
                            message: "Please select pet and task type",
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

                        final success = await viewModel.updateTask(
                          taskId: widget.task.id,
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
                          Navigator.pop(context);
                          AppSnackBar.show(
                            context,
                            message: "Task updated successfully!",
                            type: SnackBarType.success,
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

  // Future<void> _handleSave() async {
  //   final viewModel = context.read<TaskViewModel>();

  //   if (taskTitleController.text.trim().isEmpty) {
  //     AppSnackBar.show(
  //       context,
  //       message: "Task title is required",
  //       type: SnackBarType.error,
  //     );
  //     return;
  //   }
  //   if (selectedPetId == null || selectedTaskType == null) {
  //     AppSnackBar.show(
  //       context,
  //       message: "Please ensure all fields are selected",
  //       type: SnackBarType.error,
  //     );
  //     return;
  //   }
  //   if (selectedDate == null || selectedTime == null) {
  //     AppSnackBar.show(
  //       context,
  //       message: "Date and Time are required",
  //       type: SnackBarType.error,
  //     );
  //     return;
  //   }

  //   final timeString =
  //       "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

  //   // You need to ensure your TaskViewModel has an updateTask method similar to this
  //   final success = await viewModel.updateTask(
  //     taskId: widget.task.id,
  //     taskTitle: taskTitleController.text.trim(),
  //     petId: selectedPetId!,
  //     taskType: selectedTaskType!,
  //     date: selectedDate!,
  //     time: timeString,
  //     repeat: repeat,
  //     notes: notesController.text.trim().isEmpty
  //         ? null
  //         : notesController.text.trim(),
  //     reminder: reminder,
  //   );

  //   if (viewModel.errorMessage != null) {
  //     AppSnackBar.show(
  //       context,
  //       message: viewModel.errorMessage!,
  //       type: SnackBarType.error,
  //     );
  //   } else if (success) {
  //     Navigator.pop(context); // Return to previous screen
  //     AppSnackBar.show(
  //       context,
  //       message: "Task updated successfully!",
  //       type: SnackBarType.success,
  //     );
  //   }
  // }

  // Helper Widget for Labels
  Widget _buildSectionLabel(String text) {
    return SizedBox(
      width: 330,
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(text, style: _labelStyle),
        ),
      ),
    );
  }

  static const TextStyle _labelStyle = TextStyle(
    fontFamily: "Poppins-Medium",
    fontSize: 14,
    color: AppColors.textPrimary,
  );
}
