import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../models/task.dart';
import '../models/connection_request.dart';
import '../models/notification.dart';

class AppProvider extends ChangeNotifier {
  User? _currentUser;
  List<User> _users = [];
  List<ConnectionRequest> _connections = [];
  List<Task> _tasks = [];
  List<AppNotification> _notifications = [];
  bool _isAuthenticated = false;

  // Getters
  User? get currentUser => _currentUser;
  List<User> get users => _users;
  List<ConnectionRequest> get connections => _connections;
  List<Task> get tasks => _tasks;
  List<AppNotification> get notifications => _notifications;
  bool get isAuthenticated => _isAuthenticated;

  final Uuid _uuid = const Uuid();

  AppProvider() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _users = [
      User(
        id: 'u1',
        username: 'sara_k',
        name: 'Sara Kumar',
        email: 'sara@example.com',
        phone: '+91 9876543210',
        photo: 'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=400',
        bio: 'Product designer passionate about creating meaningful experiences',
        isOnline: true,
      ),
      User(
        id: 'u2',
        username: 'alex_dev',
        name: 'Alex Thompson',
        email: 'alex@example.com',
        photo: 'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400',
        bio: 'Full-stack developer building the future',
        isOnline: false,
      ),
      User(
        id: 'u3',
        username: 'maya_creative',
        name: 'Maya Chen',
        email: 'maya@example.com',
        photo: 'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400',
        bio: 'Creative director & brand strategist',
        isOnline: true,
      ),
    ];
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final user = _users.firstWhere(
      (u) => u.email == email,
      orElse: () => throw Exception('User not found'),
    );
    
    if (password == 'password') {
      _currentUser = user;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  List<User> searchUsers(String query) {
    if (query.isEmpty) return [];
    
    return _users.where((user) {
      return user.id != _currentUser?.id &&
          (user.username.toLowerCase().contains(query.toLowerCase()) ||
           user.name.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  void sendConnectionRequest(String toUserId) {
    if (_currentUser == null) return;

    final request = ConnectionRequest(
      id: _uuid.v4(),
      fromUserId: _currentUser!.id,
      toUserId: toUserId,
      status: ConnectionStatus.pending,
      createdAt: DateTime.now(),
    );

    _connections.add(request);

    final notification = AppNotification(
      id: _uuid.v4(),
      userId: toUserId,
      type: NotificationType.connectionRequest,
      message: '${_currentUser!.name} sent you a connection request',
      createdAt: DateTime.now(),
    );

    _notifications.add(notification);
    notifyListeners();
  }

  void respondToRequest(String requestId, ConnectionStatus status) {
    final requestIndex = _connections.indexWhere((r) => r.id == requestId);
    if (requestIndex == -1) return;

    _connections[requestIndex] = _connections[requestIndex].copyWith(status: status);

    if (status == ConnectionStatus.accepted) {
      final request = _connections[requestIndex];
      final notification = AppNotification(
        id: _uuid.v4(),
        userId: request.fromUserId,
        type: NotificationType.connectionAccepted,
        message: '${_currentUser!.name} accepted your connection request',
        createdAt: DateTime.now(),
      );
      _notifications.add(notification);
    }

    notifyListeners();
  }

  void createTask({
    required String title,
    String? description,
    required TaskPriority priority,
    required DateTime dueDate,
    required String assignedTo,
  }) {
    if (_currentUser == null) return;

    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      assignedBy: _currentUser!.id,
      assignedTo: assignedTo,
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
    );

    _tasks.add(task);

    final notification = AppNotification(
      id: _uuid.v4(),
      userId: assignedTo,
      type: NotificationType.taskAssigned,
      message: '${_currentUser!.name} assigned you a task: "$title"',
      createdAt: DateTime.now(),
    );

    _notifications.add(notification);
    notifyListeners();
  }

  void updateTaskStatus(String taskId, TaskStatus status) {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    _tasks[taskIndex] = _tasks[taskIndex].copyWith(status: status);
    notifyListeners();
  }

  List<Task> getMyTasks() {
    if (_currentUser == null) return [];
    return _tasks.where((task) => task.assignedTo == _currentUser!.id).toList();
  }

  List<Task> getSentTasks() {
    if (_currentUser == null) return [];
    return _tasks.where((task) => task.assignedBy == _currentUser!.id).toList();
  }

  List<User> getConnections() {
    if (_currentUser == null) return [];
    
    final acceptedConnections = _connections.where((conn) =>
        conn.status == ConnectionStatus.accepted &&
        (conn.fromUserId == _currentUser!.id || conn.toUserId == _currentUser!.id));

    return acceptedConnections.map((conn) {
      final connectedUserId = conn.fromUserId == _currentUser!.id 
          ? conn.toUserId 
          : conn.fromUserId;
      return _users.firstWhere((user) => user.id == connectedUserId);
    }).toList();
  }

  List<ConnectionRequest> getPendingRequests() {
    if (_currentUser == null) return [];
    
    return _connections.where((conn) =>
        conn.status == ConnectionStatus.pending && 
        conn.toUserId == _currentUser!.id).toList();
  }

  List<AppNotification> getUserNotifications() {
    if (_currentUser == null) return [];
    
    return _notifications
        .where((notif) => notif.userId == _currentUser!.id)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void markNotificationAsRead(String notificationId) {
    final notifIndex = _notifications.indexWhere((n) => n.id == notificationId);
    if (notifIndex == -1) return;

    _notifications[notifIndex] = _notifications[notifIndex].copyWith(read: true);
    notifyListeners();
  }

  int get unreadNotificationCount {
    if (_currentUser == null) return 0;
    return _notifications
        .where((notif) => notif.userId == _currentUser!.id && !notif.read)
        .length;
  }

  bool isAlreadyConnected(String userId) {
    if (_currentUser == null) return false;
    
    return _connections.any((conn) =>
        conn.status == ConnectionStatus.accepted &&
        ((conn.fromUserId == _currentUser!.id && conn.toUserId == userId) ||
         (conn.toUserId == _currentUser!.id && conn.fromUserId == userId)));
  }

  bool hasRequestPending(String userId) {
    if (_currentUser == null) return false;
    
    return _connections.any((conn) =>
        conn.status == ConnectionStatus.pending &&
        conn.fromUserId == _currentUser!.id &&
        conn.toUserId == userId);
  }
}