import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getSeedTasks();
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final http.Client client;

  TaskRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TaskModel>> getSeedTasks() async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos?_limit=5'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final uuid = const Uuid();
      return jsonList.map((json) {
        final model = TaskModel.fromJson(json);
        // We override the ID with a UUID so it matches our local UUID generation format
        return TaskModel(
          id: uuid.v4(),
          title: model.title,
          description: 'Loaded from api (seed data)',
          isCompleted: model.isCompleted,
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch seed tasks: ${response.statusCode}');
    }
  }
}
