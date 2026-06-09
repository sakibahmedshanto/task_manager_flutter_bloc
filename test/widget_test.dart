import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_flutter_bloc/domain/entities/task.dart';
import 'package:task_manager_flutter_bloc/presentation/blocs/task_state.dart';

void main() {
  group('Task entity', () {
    const task = Task(id: '1', title: 'Buy groceries');

    test('copyWith updates only the specified fields', () {
      final updated = task.copyWith(isCompleted: true);
      expect(updated.id, '1');
      expect(updated.title, 'Buy groceries');
      expect(updated.isCompleted, isTrue);
    });

    test('two tasks with identical fields are equal', () {
      expect(const Task(id: '1', title: 'Buy groceries'), equals(task));
    });

    test('tasks with different ids are not equal', () {
      expect(const Task(id: '2', title: 'Buy groceries'), isNot(equals(task)));
    });
  });

  group('TaskState', () {
    test('TaskLoaded instances with the same list are equal', () {
      const tasks = [Task(id: '1', title: 'Task A')];
      expect(
        const TaskLoaded(tasks: tasks),
        equals(const TaskLoaded(tasks: tasks)),
      );
    });

    test('TaskError instances with the same message are equal', () {
      expect(
        const TaskError('Network error'),
        equals(const TaskError('Network error')),
      );
    });
  });
}
