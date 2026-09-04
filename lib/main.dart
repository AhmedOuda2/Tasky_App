import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky_app/core/utils/app_colors/color_model.dart';
import 'package:tasky_app/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:tasky_app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:tasky_app/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:tasky_app/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:tasky_app/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:tasky_app/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:tasky_app/features/tasks/presentation/controller/task_controller.dart';
import 'package:tasky_app/features/tasks/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Data Layer: SharedPreferences & Local Data Source
  final sharedPreferences = await SharedPreferences.getInstance();
  final localDataSource = TaskLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );

  // 2. Data Layer: Repository Implementation
  final taskRepository = TaskRepositoryImpl(localDataSource: localDataSource);

  // 3. Domain Layer: Use Cases
  final getTasksUseCase = GetTasksUseCase(taskRepository);
  final addTaskUseCase = AddTaskUseCase(taskRepository);
  final updateTaskUseCase = UpdateTaskUseCase(taskRepository);
  final deleteTaskUseCase = DeleteTaskUseCase(taskRepository);

  // 4. Presentation Layer: State Controller
  final taskController = TaskController(
    getTasksUseCase: getTasksUseCase,
    addTaskUseCase: addTaskUseCase,
    updateTaskUseCase: updateTaskUseCase,
    deleteTaskUseCase: deleteTaskUseCase,
  );

  // Initial Fetching
  await taskController.fetchTasks();

  runApp(TaskyApp(controller: taskController));
}

class TaskyApp extends StatelessWidget {
  final TaskController controller;

  const TaskyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasky',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xffF9F9FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.parimerayColor,
          primary: AppColor.parimerayColor,
        ),
      ),
      home: HomeScreen(controller: controller),
    );
  }
}
