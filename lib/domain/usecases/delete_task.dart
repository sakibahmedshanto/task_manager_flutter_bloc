import '../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  const DeleteTask(this.repository);

  Future<void> call(String id) {
    return repository.deleteTask(id);
  }
}
