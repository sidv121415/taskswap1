enum NotificationType {
  taskAssigned,
  taskCompleted,
  connectionRequest,
  connectionAccepted,
}

class AppNotification {
  final String id;
  final String userId;
  final NotificationType type;
  final String message;
  final DateTime createdAt;
  final bool read;

  AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.createdAt,
    this.read = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      userId: json['userId'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      read: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString().split('.').last,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'read': read,
    };
  }

  AppNotification copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? message,
    DateTime? createdAt,
    bool? read,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      read: read ?? this.read,
    );
  }
}