import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/connection_request.dart';
import '../../utils/theme.dart';
import '../../widgets/user_card.dart';
import '../../widgets/connection_request_card.dart';

class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final connections = appProvider.getConnections();
          final pendingRequests = appProvider.getPendingRequests();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Manage your connections and task exchanges',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),

                // Pending Requests Section
                if (pendingRequests.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person_add,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pending Requests (${pendingRequests.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...pendingRequests.map((request) {
                    final fromUser = appProvider.users.firstWhere(
                      (u) => u.id == request.fromUserId,
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: ConnectionRequestCard(
                        user: fromUser,
                        request: request,
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                ],

                // Connected Users Section
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.people,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Connected (${connections.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                if (connections.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: AppTheme.textTertiary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No connections yet',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Search for users to start connecting',
                            style: TextStyle(
                              color: AppTheme.textTertiary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...connections.map((user) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: UserCard(
                        user: user,
                        showAssignTaskButton: true,
                      ),
                    );
                  }),
                
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}