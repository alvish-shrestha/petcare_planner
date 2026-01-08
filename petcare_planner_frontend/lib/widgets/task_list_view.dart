import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/task_view_model.dart';
import 'package:petcare_planner_frontend/widgets/task_card.dart';
import 'package:provider/provider.dart';

class TaskListView extends StatelessWidget {
  final List tasks;

  const TaskListView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          "No tasks scheduled for today",
          style: TextStyle(
            fontFamily: "Poppins",
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(5),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final hour = int.parse(task.time.split(':')[0]);
        final period = hour >= 12 ? 'PM' : 'AM';

        return TaskCard(
          time: task.time,
          period: period,
          title: task.taskTitle,
          description: task.notes ?? task.taskType,
          onDelete: () {
            context.read<TaskViewModel>().deleteTask(task.id);
          },
        );
      },
    );
  }
}
