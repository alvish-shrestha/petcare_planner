import '../services/task_service.dart';

class TaskRepository {
  final TaskService _service;

  TaskRepository(this._service);

  Future<Map<String, dynamic>> createTask({
    required String taskTitle,
    required String petId,
    required String taskType,
    required String date,
    required String time,
    String repeat = 'None',
    String? notes,
    bool reminder = true,
  }) {
    return _service.createTask(
      taskTitle: taskTitle,
      petId: petId,
      taskType: taskType,
      date: date,
      time: time,
      repeat: repeat,
      notes: notes,
      reminder: reminder,
    );
  }

  Future<Map<String, dynamic>> getAllTasks({String? petId}) {
    return _service.getAllTasks(petId: petId);
  }

  Future<Map<String, dynamic>> getTaskById(String id) {
    return _service.getTaskById(id);
  }

  Future<Map<String, dynamic>> updateTask({
    required String id,
    Map<String, dynamic>? updateData,
  }) {
    return _service.updateTask(id: id, updateData: updateData);
  }

  Future<Map<String, dynamic>> deleteTask(String id) {
    return _service.deleteTask(id);
  }
}
