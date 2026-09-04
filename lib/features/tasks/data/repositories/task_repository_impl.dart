import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TaskEntity>> getTasks() async {
    return await localDataSource.getSavedTasks();
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    final tasks = await localDataSource.getSavedTasks();
    tasks.insert(0, TaskModel.fromEntity(task));
    await localDataSource.cacheTasks(tasks);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final tasks = await localDataSource.getSavedTasks();
    final index = tasks.indexWhere((item) => item.id == task.id);
    if (index != -1) {
      tasks[index] = TaskModel.fromEntity(task);
      await localDataSource.cacheTasks(tasks);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await localDataSource.getSavedTasks();
    tasks.removeWhere((item) => item.id == id);
    await localDataSource.cacheTasks(tasks);
  }
}
