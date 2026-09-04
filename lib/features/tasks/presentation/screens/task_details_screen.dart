import 'package:flutter/material.dart';
import 'package:tasky_app/core/utils/app_colors/color_model.dart';
import 'package:tasky_app/features/tasks/domain/entities/task_entity.dart';
import 'add_edit_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final TaskEntity task;
  final Future<void> Function(TaskEntity) onUpdate;
  final Future<void> Function(String) onDelete;

  const TaskDetailsScreen({
    super.key,
    required this.task,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TaskEntity _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Delete Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.titleOfAlartDailog,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColor.subTextColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.onDelete(_currentTask.id);
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToEdit() async {
    final updatedTask = await Navigator.push<TaskEntity>(
      context,
      MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: _currentTask)),
    );

    if (updatedTask != null) {
      await widget.onUpdate(updatedTask);
      if (mounted) {
        setState(() {
          _currentTask = updatedTask;
        });
      }
    }
  }

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
    return Scaffold(
      backgroundColor: const Color(0xffF9F9FB),
      appBar: AppBar(
        title: const Text(
          'Task Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColor.parimerayColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Task',
            onPressed: _navigateToEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Task',
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentTask.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.superTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentTask.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColor.subTextColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      icon: Icons.category_outlined,
                      label: 'Category',
                      value: _currentTask.category,
                      valueColor: AppColor.parimerayColor,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.flag_outlined,
                      label: 'Priority',
                      value: _currentTask.priority,
                      valueColor: _getPriorityColor(_currentTask.priority),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.check_circle_outline,
                      label: 'Status',
                      value: _currentTask.status,
                      valueColor: _getStatusColor(_currentTask.status),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.calendar_month_outlined,
                      label: 'Due Date',
                      value: _currentTask.dueDate,
                      valueColor: AppColor.superTextColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AppColor.subTextColor),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColor.subTextColor,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: valueColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
