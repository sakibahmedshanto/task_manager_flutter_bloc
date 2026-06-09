import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;
  final Uuid uuid;

  TaskRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.uuid,
  });

  @override
  Future<List<Task>> getTasks() async {
    try {
      final localTasks = await localDataSource.getTasks();
      if (localTasks.isNotEmpty) {
        return localTasks.map((m) => m.toEntity()).toList();
      }
      try {
        final remoteTasks = await remoteDataSource.getSeedTasks();
        await localDataSource.cacheTasks(remoteTasks);
        return remoteTasks.map((m) => m.toEntity()).toList();
      } on SocketException {
        throw const NetworkFailure();
      } catch (_) {
        throw const ServerFailure();
      }
    } on AppFailure {
      rethrow;
    } catch (_) {
      throw const CacheFailure();
    }
  }

  @override
  Future<void> addTask(Task task) async {
    final model = TaskModel.fromEntity(task.copyWith(id: uuid.v4()));
    await localDataSource.addTask(model);
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
