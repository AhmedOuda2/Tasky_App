import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.priority,
    required super.status,
    required super.dueDate,
  });

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      priority: entity.priority,
      status: entity.status,
      dueDate: entity.dueDate,
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'Personal',
      priority: map['priority'] ?? 'Medium',
      status: map['status'] ?? 'Pending',
      dueDate: map['dueDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'dueDate': dueDate,
    };
  }

  static List<TaskModel> get initialDataset => const [
    TaskModel(
      id: '1',
      title: 'Complete Project Report',
      description: 'Finish the monthly project report',
      category: 'Work',
      priority: 'High',
      status: 'In Progress',
      dueDate: '2026-08-25',
    ),
    TaskModel(
      id: '2',
      title: 'Buy Groceries',
      description: 'Buy milk, bread, eggs and vegetables',
      category: 'Personal',
      priority: 'Medium',
      status: 'Pending',
      dueDate: '2026-08-24',
    ),
    TaskModel(
      id: '3',
      title: 'Study Flutter',
      description: 'Review Flutter widgets and state management',
      category: 'Learning',
      priority: 'High',
      status: 'In Progress',
      dueDate: '2026-08-27',
    ),
    TaskModel(
      id: '4',
      title: 'Team Meeting',
      description: 'Attend weekly development team meeting',
      category: 'Work',
      priority: 'High',
      status: 'Pending',
      dueDate: '2026-08-26',
    ),
    TaskModel(
      id: '5',
      title: 'Go to Gym',
      description: 'Complete one hour workout',
      category: 'Health',
      priority: 'Low',
      status: 'Completed',
      dueDate: '2026-08-22',
    ),
    TaskModel(
      id: '6',
      title: 'Read a Book',
      description: 'Read 30 pages from current book',
      category: 'Personal',
      priority: 'Low',
      status: 'Pending',
      dueDate: '2026-08-28',
    ),
    TaskModel(
      id: '7',
      title: 'Design App UI',
      description: 'Create the first version of Tasky UI',
      category: 'Work',
      priority: 'High',
      status: 'Completed',
      dueDate: '2026-08-20',
    ),
    TaskModel(
      id: '8',
      title: 'Learn Dart',
      description: 'Practice Dart fundamentals',
      category: 'Learning',
      priority: 'Medium',
      status: 'In Progress',
      dueDate: '2026-08-29',
    ),
    TaskModel(
      id: '9',
      title: 'Pay Bills',
      description: 'Pay electricity and internet bills',
      category: 'Personal',
      priority: 'High',
      status: 'Pending',
      dueDate: '2026-08-24',
    ),
    TaskModel(
      id: '10',
      title: 'Doctor Appointment',
      description: 'Attend scheduled appointment',
      category: 'Health',
      priority: 'High',
      status: 'Pending',
      dueDate: '2026-08-30',
    ),
    TaskModel(
      id: '11',
      title: 'Prepare Presentation',
      description: 'Prepare slides for client presentation',
      category: 'Work',
      priority: 'Medium',
      status: 'In Progress',
      dueDate: '2026-08-31',
    ),
    TaskModel(
      id: '12',
      title: 'Watch Flutter Tutorial',
      description: 'Complete Flutter course lesson',
      category: 'Learning',
      priority: 'Low',
      status: 'Completed',
      dueDate: '2026-08-21',
    ),
    TaskModel(
      id: '15',
      title: 'Plan Weekend',
      description: 'Plan activities for the weekend',
      category: 'Personal',
      priority: 'Low',
      status: 'Pending',
      dueDate: '2026-09-01',
    ),
    TaskModel(
      id: '16',
      title: 'Update CV',
      description: 'Update skills and recent projects',
      category: 'Learning',
      priority: 'Medium',
      status: 'Pending',
      dueDate: '2026-09-02',
    ),
    TaskModel(
      id: '17',
      title: 'Backup Files',
      description: 'Backup important files and documents',
      category: 'Work',
      priority: 'High',
      status: 'Completed',
      dueDate: '2026-08-23',
    ),
  ];
}
