import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repository/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository;

  TaskViewModel(this._repository);

  bool isLoading = false;
  String? errorMessage;

  List<Task> tasks = [];
  Task? selectedTask;

  /// --- Create Task ---
  Future<bool> createTask({
    required String taskTitle,
    required String petId,
    required String taskType,
    required DateTime date,
    required String time,
    String repeat = 'None',
    String? notes,
    bool reminder = true,
  }) async {
    _setLoading(true);
    errorMessage = null;

    try {
      await _repository.createTask(
        taskTitle: taskTitle,
        petId: petId,
        taskType: taskType,
        date: date.toIso8601String(),
        time: time,
        repeat: repeat,
        notes: notes,
        reminder: reminder,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// --- Fetch Tasks ---
  Future<void> fetchTasks({String? petId}) async {
    _setLoading(true);

    try {
      final response = await _repository.getAllTasks(petId: petId);
      tasks = (response['tasks'] as List).map((e) => Task.fromJson(e)).toList();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// --- Delete Task ---
  Future<bool> deleteTask(String id) async {
    _setLoading(true);

    try {
      await _repository.deleteTask(id);
      tasks.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
