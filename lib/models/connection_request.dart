enum ConnectionStatus { pending, accepted, declined }

class ConnectionRequest {
  final String id;
  final String fromUserId;
  final String toUserId;
  final ConnectionStatus status;
  final DateTime createdAt;

  ConnectionRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    required this.createdAt,
  });

  factory ConnectionRequest.fromJson(Map<String, dynamic> json) {
    return ConnectionRequest(
      id: json['id'],
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      status: ConnectionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ConnectionRequest copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    ConnectionStatus? status,
    DateTime? createdAt,
  }) {
    return ConnectionRequest(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}