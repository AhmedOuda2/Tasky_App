import 'package:flutter/material.dart';
import 'package:tasky_app/core/utils/app_colors/color_model.dart';
import 'package:tasky_app/features/tasks/domain/entities/task_entity.dart';
import 'package:tasky_app/features/tasks/presentation/controller/task_controller.dart';
import 'add_edit_task_screen.dart';
import 'task_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final TaskController controller;

  const HomeScreen({super.key, required this.controller});

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.blue;
      case 'Pending':
        return Colors.orange.shade800;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final tasks = controller.filteredTasks;

        return Scaffold(
          backgroundColor: const Color(0xffF9F9FB),
          appBar: AppBar(
            title: const Text(
              'Tasky Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            backgroundColor: AppColor.parimerayColor,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () => controller.fetchTasks(),
              ),
            ],
          ),
          body: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.parimerayColor,
                  ),
                )
              : RefreshIndicator(
                  color: AppColor.parimerayColor,
                  onRefresh: controller.fetchTasks,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.hasError) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    controller.errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  onPressed: controller.clearError,
                                ),
                              ],
                            ),
                          ),
                        ],
                        _buildSummaryDashboard(controller),
                        const SizedBox(height: 18),
                        _buildSearchField(controller),
                        const SizedBox(height: 12),
                        _buildFiltersSection(controller),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tasks',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.superTextColor,
                              ),
                            ),
                            Text(
                              '${tasks.length} found',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColor.subTextColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildTaskList(context, tasks),
                      ],
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColor.parimerayColor,
            foregroundColor: Colors.white,
            elevation: 3,
            child: const Icon(Icons.add),
            onPressed: () async {
              final newTask = await Navigator.push<TaskEntity>(
                context,
                MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
              );

              if (newTask != null) {
                final success = await controller.addTask(newTask);
                if (context.mounted && success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task added successfully!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildSummaryDashboard(TaskController c) {
    return Row(
      children: [
        _buildSummaryCard('Total', c.totalCount.toString(), Colors.blue),
        const SizedBox(width: 8),
        _buildSummaryCard('Done', c.completedCount.toString(), Colors.green),
        const SizedBox(width: 8),
        _buildSummaryCard(
          'Active',
          c.inProgressCount.toString(),
          Colors.purple,
        ),
        const SizedBox(width: 8),
        _buildSummaryCard('Pending', c.pendingCount.toString(), Colors.orange),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColor.subTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(TaskController c) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search tasks by title...',
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColor.hintTextColorAndBorderTextFormFeild,
        ),
        prefixIcon: const Icon(Icons.search, color: AppColor.parimerayColor),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      onChanged: c.setSearchQuery,
    );
  }

  Widget _buildFiltersSection(TaskController c) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterDropdown('Category', c.selectedCategory, [
            'All',
            'Work',
            'Personal',
            'Learning',
            'Health',
          ], c.setFilterCategory),
          const SizedBox(width: 8),
          _buildFilterDropdown('Priority', c.selectedPriority, [
            'All',
            'High',
            'Medium',
            'Low',
          ], c.setFilterPriority),
          const SizedBox(width: 8),
          _buildFilterDropdown('Status', c.selectedStatus, [
            'All',
            'Pending',
            'In Progress',
            'Completed',
          ], c.setFilterStatus),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String currentValue,
    List<String> items,
    Function(String) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          icon: const Icon(Icons.arrow_drop_down, color: AppColor.subTextColor),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item == 'All' ? '$label: All' : item,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColor.superTextColor,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<TaskEntity> tasks) {
    if (tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Icon(Icons.inbox_outlined, size: 55, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'No tasks found',
              style: TextStyle(fontSize: 15, color: AppColor.subTextColor),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          color: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            leading: Checkbox(
              value: task.isCompleted,
              activeColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (_) => controller.toggleTaskStatus(task),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: task.isCompleted ? Colors.grey : AppColor.superTextColor,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  task.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColor.subTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: [
                    _buildBadge(
                      task.category,
                      Colors.deepPurple.shade50,
                      AppColor.parimerayColor,
                    ),
                    _buildBadge(
                      task.priority,
                      _getPriorityColor(task.priority).withOpacity(0.1),
                      _getPriorityColor(task.priority),
                    ),
                    _buildBadge(
                      task.status,
                      _getStatusColor(task.status).withOpacity(0.1),
                      _getStatusColor(task.status),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Text(
              task.dueDate,
              style: const TextStyle(
                fontSize: 11,
                color: AppColor.subTextColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskDetailsScreen(
                    task: task,
                    onUpdate: (updated) async {
                      final success = await controller.updateTask(updated);
                      if (context.mounted && success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task updated successfully!'),
                            backgroundColor: Colors.blue,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    onDelete: (id) async {
                      final success = await controller.deleteTask(id);
                      if (context.mounted && success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task deleted successfully!'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBadge(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
