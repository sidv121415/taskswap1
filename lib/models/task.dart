enum TaskPriority { low, medium, high }
enum TaskStatus { pending, completed }

class Task {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime dueDate;
  final String assignedBy;
  final String assignedTo;
  final TaskStatus status;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.dueDate,
    required this.assignedBy,
    required this.assignedTo,
    required this.status,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: TaskPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
      ),
      dueDate: DateTime.parse(json['dueDate']),
      assignedBy: json['assignedBy'],
      assignedTo: json['assignedTo'],
      status: TaskStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.toString().split('.').last,
      'dueDate': dueDate.toIso8601String(),
      'assignedBy': assignedBy,
      'assignedTo': assignedTo,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    DateTime? dueDate,
    String? assignedBy,
    String? assignedTo,
    TaskStatus? status,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      assignedBy: assignedBy ?? this.assignedBy,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}