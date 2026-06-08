import '../entities/task.dart';
import '../repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  const AddTask(this.repository);

  Future<void> call(Task task) {
    return repository.addTask(task);
  }
}
