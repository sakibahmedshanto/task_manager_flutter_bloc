import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  const GetTasks(this.repository);

  Future<List<Task>> call() {
    return repository.getTasks();
  }
}
