import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/connection_request.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';
import 'custom_button.dart';
import 'user_avatar.dart';

class ConnectionRequestCard extends StatelessWidget {
  final User user;
  final ConnectionRequest request;

  const ConnectionRequestCard({
    super.key,
    required this.user,
    required this.request,
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
                  const SizedBox(height: 4),
                  const Text(
                    'Wants to connect with you',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                CustomButton(
                  onPressed: () {
                    context.read<AppProvider>().respondToRequest(
                          request.id,
                          ConnectionStatus.accepted,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Accepted connection from ${user.name}'),
                        backgroundColor: AppTheme.accentColor,
                      ),
                    );
                  },
                  width: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 16),
                      SizedBox(width: 4),
                      Text('Accept', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                CustomButton(
                  onPressed: () {
                    context.read<AppProvider>().respondToRequest(
                          request.id,
                          ConnectionStatus.declined,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Declined connection from ${user.name}'),
                        backgroundColor: AppTheme.textSecondary,
                      ),
                    );
                  },
                  isOutlined: true,
                  width: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.close, size: 16),
                      SizedBox(width: 4),
                      Text('Decline', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}