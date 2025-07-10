import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/notification.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';
import 'user_avatar.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final relatedUser = _getRelatedUser(appProvider);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar or Icon
                if (relatedUser != null)
                  UserAvatar(
                    imageUrl: relatedUser.photo,
                    name: relatedUser.name,
                    size: 40,
                  )
                else
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getNotificationColor().withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getNotificationIcon(),
                      color: _getNotificationColor(),
                      size: 20,
                    ),
                  ),

                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.message,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(notification.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Type Icon
                Icon(
                  _getNotificationIcon(),
                  color: _getNotificationColor(),
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  User? _getRelatedUser(AppProvider appProvider) {
    // Extract user from notification message
    final message = notification.message;
    if (message.contains(' assigned you a task') ||
        message.contains(' sent you a connection request') ||
        message.contains(' accepted your connection request')) {
      final userName = message.split(' ')[0];
      return appProvider.users.firstWhere(
        (u) => u.name.startsWith(userName),
        orElse: () => appProvider.users.first,
      );
    }
    return null;
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.taskAssigned:
        return Icons.task_alt;
      case NotificationType.taskCompleted:
        return Icons.check_circle;
      case NotificationType.connectionRequest:
        return Icons.person_add;
      case NotificationType.connectionAccepted:
        return Icons.people;
    }
  }

  Color _getNotificationColor() {
    switch (notification.type) {
      case NotificationType.taskAssigned:
        return AppTheme.primaryColor;
      case NotificationType.taskCompleted:
        return AppTheme.accentColor;
      case NotificationType.connectionRequest:
        return AppTheme.secondaryColor;
      case NotificationType.connectionAccepted:
        return AppTheme.accentColor;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }
}