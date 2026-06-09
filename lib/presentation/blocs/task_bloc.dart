import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<ToggleTaskEvent>(_onToggleTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasks();
      emit(TaskLoaded(tasks: tasks));
    } on AppFailure catch (e) {
      emit(TaskError(e.message));
    } catch (_) {
      emit(const TaskError('Something went wrong. Please try again.'));
    }
  }

  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await addTask(Task(id: '', title: event.title, description: event.description));
      final tasks = await getTasks();
      emit(TaskLoaded(tasks: tasks));
    } on AppFailure catch (e) {
      emit(TaskError(e.message));
    } catch (_) {
      emit(const TaskError('Failed to add task. Please try again.'));
    }
  }

  Future<void> _onToggleTask(
    ToggleTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final updated = event.task.copyWith(isCompleted: !event.task.isCompleted);
      await updateTask(updated);

      if (state is TaskLoaded) {
        final updatedList = (state as TaskLoaded)
            .tasks
            .map((t) => t.id == updated.id ? updated : t)
            .toList();
        emit(TaskLoaded(tasks: updatedList));
      }
    } on AppFailure catch (e) {
      emit(TaskError(e.message));
    } catch (_) {
      emit(const TaskError('Failed to update task. Please try again.'));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await deleteTask(event.id);

      if (state is TaskLoaded) {
        final updatedList =
            (state as TaskLoaded).tasks.where((t) => t.id != event.id).toList();
        emit(TaskLoaded(tasks: updatedList));
      }
    } on AppFailure catch (e) {
      emit(TaskError(e.message));
    } catch (_) {
      emit(const TaskError('Failed to delete task. Please try again.'));
    }
  }
}
