import 'package:petcare_planner_frontend/models/pet.dart';

class Task {
  final String id;
  final String taskTitle;
  final Pet pet;
  final String taskType;
  final DateTime date;
  final String time;
  final String repeat;
  final String? notes;
  final bool reminder;

  Task({
    required this.id,
    required this.taskTitle,
    required this.pet,
    required this.taskType,
    required this.date,
    required this.time,
    this.repeat = "None",
    this.notes,
    this.reminder = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      taskTitle: json['taskTitle'],
      pet: Pet.fromJson(json['petId']),
      taskType: json['taskType'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      repeat: json['repeat'] ?? "None",
      notes: json['notes'],
      reminder: json['reminder'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskTitle': taskTitle,
      'petId': pet,
      'taskType': taskType,
      'date': date.toIso8601String(),
      'time': time,
      'repeat': repeat,
      'notes': notes,
      'reminder': reminder,
    };
  }
}
