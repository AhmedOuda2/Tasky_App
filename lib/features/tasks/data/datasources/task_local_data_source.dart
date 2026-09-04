import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getSavedTasks();
  Future<void> cacheTasks(List<TaskModel> tasks);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const String _storageKey = 'tasky_app_cached_tasks';
  final SharedPreferences sharedPreferences;

  TaskLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TaskModel>> getSavedTasks() async {
    final jsonString = sharedPreferences.getString(_storageKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .map((item) => TaskModel.fromMap(item as Map<String, dynamic>))
          .toList();
    }

    // في حال كانت أول مرة يُفتح فيها التطبيق، نُحمّل البيانات الافتراضية
    final initialTasks = TaskModel.initialDataset;
    await cacheTasks(initialTasks);
    return initialTasks;
  }

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final List<Map<String, dynamic>> mapList = tasks
        .map((task) => task.toMap())
        .toList();
    await sharedPreferences.setString(_storageKey, jsonEncode(mapList));
  }
}
