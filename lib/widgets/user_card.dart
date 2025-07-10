import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';
import 'custom_button.dart';
import 'user_avatar.dart';
import 'create_task_modal.dart';

class UserCard extends StatelessWidget {
  final User user;
  final bool showConnectButton;
  final bool showAssignTaskButton;

  const UserCard({
    super.key,
    required this.user,
    this.showConnectButton = false,
    this.showAssignTaskButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            UserAvatar(
              imageUrl: user.photo,
              name: user.name,
              isOnline: user.isOnline,
              size: 56,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${user.username}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  if (user.bio != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      user.bio!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            if (showConnectButton) _buildConnectButton(context),
            if (showAssignTaskButton) _buildAssignTaskButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectButton(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final isConnected = appProvider.isAlreadyConnected(user.id);
        final hasPending = appProvider.hasRequestPending(user.id);

        if (isConnected) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Connected',
              style: TextStyle(
                color: AppTheme.accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        if (hasPending) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Pending',
              style: TextStyle(
                color: AppTheme.warningColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return CustomButton(
          onPressed: () {
            appProvider.sendConnectionRequest(user.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Connection request sent to ${user.name}'),
                backgroundColor: AppTheme.accentColor,
              ),
            );
          },
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_add, size: 16),
              SizedBox(width: 4),
              Text('Connect', style: TextStyle(fontSize: 12)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAssignTaskButton(BuildContext context) {
    return CustomButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => CreateTaskModal(user: user),
        );
      },
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_task, size: 16),
          SizedBox(width: 4),
          Text('Assign Task', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}