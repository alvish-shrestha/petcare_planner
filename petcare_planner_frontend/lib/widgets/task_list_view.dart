import 'package:flutter/material.dart';
import 'package:petcare_planner_frontend/modal/delete_modal.dart';
import 'package:petcare_planner_frontend/models/task.dart';
import 'package:petcare_planner_frontend/utils/app_colors.dart';
import 'package:petcare_planner_frontend/view_models/task_view_model.dart';
import 'package:petcare_planner_frontend/views/task/edit_task.dart';
import 'package:petcare_planner_frontend/widgets/task_card.dart';
import 'package:provider/provider.dart';

class TaskListView extends StatelessWidget {
  final List<Task> tasks;

  const TaskListView({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          "No tasks scheduled for today",
          style: TextStyle(
            fontFamily: "Poppins-Bold",
            color: AppColors.textPrimary.withAlpha(100),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        final hour = int.parse(task.time.split(':')[0]);
        final period = hour >= 12 ? 'PM' : 'AM';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditTaskScreen(task: task),
              ),
            );
          },
          child: TaskCard(
            time: task.time,
            period: period,
            title: task.taskTitle,
            description: (task.notes != null && task.notes!.isNotEmpty)
                ? task.notes!
                : task.taskType,
            onDelete: () async {
              final bool? shouldDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return const DeleteModal();
                },
              );

              if (shouldDelete == true && context.mounted) {
                context.read<TaskViewModel>().deleteTask(task.id);
              }
            },
          ),
        );
      },
    );
  }
}
