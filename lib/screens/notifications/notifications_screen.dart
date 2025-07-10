import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Mark all notifications as read when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = context.read<AppProvider>();
      final notifications = appProvider.getUserNotifications();
      for (final notification in notifications) {
        if (!notification.read) {
          appProvider.markNotificationAsRead(notification.id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final notifications = appProvider.getUserNotifications();

          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceColor,
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                ),
                child: const Text(
                  'Stay updated with your latest activity',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),

              // Notifications List
              Expanded(
                child: notifications.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 64,
                              color: AppTheme.textTertiary,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No notifications yet',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'You\'ll see updates about tasks and connections here',
                              style: TextStyle(
                                color: AppTheme.textTertiary,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: NotificationCard(
                              notification: notification,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}