class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;
  final String dueDate;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.dueDate,
  });

  bool get isCompleted => status == 'Completed';

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? status,
    String? dueDate,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
