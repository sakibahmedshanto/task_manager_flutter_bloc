import 'package:hive/hive.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> cacheTasks(List<TaskModel> tasks);
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box<TaskModel> taskBox;

  TaskLocalDataSourceImpl({required this.taskBox});

  @override
  Future<List<TaskModel>> getTasks() {
    return Future.value(taskBox.values.toList());
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    // Convert list to a map with task ID as the key for Hive putAll
    final Map<String, TaskModel> taskMap = {
      for (var t in tasks) t.id: t
    };
    await taskBox.putAll(taskMap);
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await taskBox.delete(id);
  }
}
