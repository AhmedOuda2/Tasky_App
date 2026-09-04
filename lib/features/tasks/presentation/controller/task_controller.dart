import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';

class TaskController extends ChangeNotifier {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  TaskController({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  });

  List<TaskEntity> _allTasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedPriority = 'All';
  String _selectedStatus = 'All';

  List<TaskEntity> get allTasks => List.unmodifiable(_allTasks);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedPriority => _selectedPriority;
  String get selectedStatus => _selectedStatus;

  int get totalCount => _allTasks.length;
  int get completedCount =>
      _allTasks.where((t) => t.status == 'Completed').length;
  int get inProgressCount =>
      _allTasks.where((t) => t.status == 'In Progress').length;
  int get pendingCount => _allTasks.where((t) => t.status == 'Pending').length;

  List<TaskEntity> get filteredTasks {
    return _allTasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(
        _searchQuery.trim().toLowerCase(),
      );
      final matchesCategory =
          _selectedCategory == 'All' || task.category == _selectedCategory;
      final matchesPriority =
          _selectedPriority == 'All' || task.priority == _selectedPriority;
      final matchesStatus =
          _selectedStatus == 'All' || task.status == _selectedStatus;
      return matchesSearch &&
          matchesCategory &&
          matchesPriority &&
          matchesStatus;
    }).toList();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Fetch all tasks with Error Handling
  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allTasks = await getTasksUseCase();
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تحميل المهام: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTask(TaskEntity task) async {
    _errorMessage = null;
    try {
      if (task.title.trim().isEmpty) {
        throw Exception('عنوان المهمة لا يمكن أن يكون فارغاً.');
      }
      await addTaskUseCase(task);
      await fetchTasks();
      return true;
    } catch (e) {
      _errorMessage = 'فشل في إضافة المهمة: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(TaskEntity task) async {
    _errorMessage = null;
    try {
      if (task.id.isEmpty) {
        throw Exception('معرّف المهمة غير صالح.');
      }
      await updateTaskUseCase(task);
      await fetchTasks();
      return true;
    } catch (e) {
      _errorMessage = 'فشل في تحديث المهمة: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    _errorMessage = null;
    try {
      if (id.isEmpty) {
        throw Exception('معرّف المهمة غير صحيح.');
      }
      await deleteTaskUseCase(id);
      await fetchTasks();
      return true;
    } catch (e) {
      _errorMessage = 'فشل في حذف المهمة: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleTaskStatus(TaskEntity task) async {
    final nextStatus = task.status == 'Completed' ? 'Pending' : 'Completed';
    final updated = task.copyWith(status: nextStatus);
    await updateTask(updated);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setFilterPriority(String priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }
}
