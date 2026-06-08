import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await addTask(event.task);
      if (state is TaskLoaded) {
        final currentTasks = (state as TaskLoaded).tasks;
        emit(TaskLoaded(tasks: [...currentTasks, event.task]));
      } else {
        add(LoadTasksEvent());
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleTask(ToggleTaskEvent event, Emitter<TaskState> emit) async {
    try {
      final updatedTask = event.task.copyWith(isCompleted: !event.task.isCompleted);
      await updateTask(updatedTask);
      
      if (state is TaskLoaded) {
        final currentTasks = (state as TaskLoaded).tasks;
        final updatedTasks = currentTasks.map(
          (t) => t.id == updatedTask.id ? updatedTask : t
        ).toList();
        emit(TaskLoaded(tasks: updatedTasks));
      } else {
        add(LoadTasksEvent());
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await deleteTask(event.id);
      if (state is TaskLoaded) {
        final currentTasks = (state as TaskLoaded).tasks;
        final updatedTasks = currentTasks.where((t) => t.id != event.id).toList();
        emit(TaskLoaded(tasks: updatedTasks));
      } else {
        add(LoadTasksEvent());
      }
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
