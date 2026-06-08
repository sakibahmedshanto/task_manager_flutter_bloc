import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends Task {
  @HiveField(0)
  @override
  final String id;
  
  @HiveField(1)
  @override
  final String title;
  
  @HiveField(2)
  @override
  final String? description;
  
  @HiveField(3)
  @override
  final bool isCompleted;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
  }) : super(
          id: id,
          title: title,
          description: description,
          isCompleted: isCompleted,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String?,
      // JSONPlaceholder uses 'completed'
      isCompleted: json['completed'] as bool? ?? false,
    );
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
    );
  }
}
