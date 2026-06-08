import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Task>> getTasks() async {
    try {
      final localTasks = await localDataSource.getTasks();
      
      // If local storage has tasks, just return them
      if (localTasks.isNotEmpty) {
        return localTasks;
      }

      // First time launch: local is empty, so fetch seed data
      final remoteTasks = await remoteDataSource.getSeedTasks();
      await localDataSource.cacheTasks(remoteTasks);
      return remoteTasks;
    } catch (e) {
      // If the API fails, still return whatever we have locally (empty or not)
      // and re-throw so the UI can show a meaningful error message
      throw Exception('Failed to load tasks: $e');
    }
  }

  @override
  Future<void> addTask(Task task) async {
    await localDataSource.addTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> updateTask(Task task) async {
    await localDataSource.updateTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }
}
