import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petcare_planner_frontend/views/notification/notification_screen.dart';
import 'package:petcare_planner_frontend/widgets/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/task_view_model.dart';
import 'package:petcare_planner_frontend/widgets/calendar.dart';
import 'package:petcare_planner_frontend/widgets/task_list_view.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDate = DateTime.now();

  String _getFormattedDate(DateTime date) {
    final formatter = DateFormat('EEEE, MMM d');
    return formatter.format(date);
  }

  void onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateString = _getFormattedDate(DateTime.now());

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 80),

          /// --- Date (formatted selected date) ---
          SizedBox(
            width: 330,
            child: Text(
              dateString,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          /// --- Title & Notification Icon ---
          SizedBox(
            width: 330,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Scheduled Tasks",
                  style: const TextStyle(
                    fontFamily: "Poppins-Bold",
                    fontSize: 24,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                /// --- Notification Icon ---
                Transform.translate(
                  offset: const Offset(0, -8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

            // Pass the selectedDate & callback to update it
            child: CalendarComponent(
              selectedDate: selectedDate,
              onDateSelected: onDateSelected,
            ),
          ),

          /// --- TASK CARD ---
          Expanded(
            child: SizedBox(
              width: 370,
              child: Consumer<TaskViewModel>(
                builder: (context, taskVM, _) {
                  // Filter tasks by selected date
                  final tasksForSelectedDate = taskVM.tasks.where((task) {
                    final localDate = task.date.toLocal();
                    final taskDateOnly = DateTime(
                      localDate.year,
                      localDate.month,
                      localDate.day,
                    );
                    return taskDateOnly ==
                        DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                        );
                  }).toList();

                  return TaskListView(tasks: tasksForSelectedDate);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
