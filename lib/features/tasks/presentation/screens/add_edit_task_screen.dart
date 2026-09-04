import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasky_app/core/utils/app_colors/color_model.dart';
import '../../domain/entities/task_entity.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TaskEntity? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _dateController;

  late String _selectedCategory;
  late String _selectedPriority;
  late String _selectedStatus;

  final List<String> _categories = const [
    'Work',
    'Personal',
    'Learning',
    'Health',
  ];
  final List<String> _priorities = const ['High', 'Medium', 'Low'];
  final List<String> _statuses = const ['Pending', 'In Progress', 'Completed'];

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _titleController = TextEditingController(text: t?.title ?? '');
    _descController = TextEditingController(text: t?.description ?? '');
    _dateController = TextEditingController(
      text: t?.dueDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    _selectedCategory = t != null && _categories.contains(t.category)
        ? t.category
        : 'Work';
    _selectedPriority = t != null && _priorities.contains(t.priority)
        ? t.priority
        : 'Medium';
    _selectedStatus = t != null && _statuses.contains(t.status)
        ? t.status
        : 'Pending';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime initial =
        DateTime.tryParse(_dateController.text) ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.parimerayColor,
              onPrimary: Colors.white,
              onSurface: AppColor.superTextColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final taskResult = TaskEntity(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      category: _selectedCategory,
      priority: _selectedPriority,
      status: _selectedStatus,
      dueDate: _dateController.text.trim(),
    );

    Navigator.pop(context, taskResult);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Task' : 'Add New Task',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColor.parimerayColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Task Title',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColor.superTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter task title...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(
                      Icons.title,
                      color: AppColor.parimerayColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                const Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColor.superTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter task description...',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: Icon(
                        Icons.description_outlined,
                        color: AppColor.parimerayColor,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the task description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Category',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColor.superTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                            items: _categories
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null)
                                setState(() => _selectedCategory = val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Priority',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColor.superTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedPriority,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                            items: _priorities
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null)
                                setState(() => _selectedPriority = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColor.superTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                            items: _statuses
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null)
                                setState(() => _selectedStatus = val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Due Date',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColor.superTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            onTap: _pickDate,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              suffixIcon: const Icon(
                                Icons.calendar_month,
                                color: AppColor.parimerayColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.parimerayColor,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: Text(
                      isEditing ? 'Save Changes' : 'Create Task',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
