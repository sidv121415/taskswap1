import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';
import 'custom_button.dart';
import 'user_avatar.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool showToggleButton;

  const TaskCard({
    super.key,
    required this.task,
    this.showToggleButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final otherUser = showToggleButton
            ? appProvider.users.firstWhere((u) => u.id == task.assignedBy)
            : appProvider.users.firstWhere((u) => u.id == task.assignedTo);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildPriorityChip(),
                    const SizedBox(width: 8),
                    _buildStatusChip(),
                  ],
                ),

                // Task Description
                if (task.description != null && task.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    task.description!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Task Details
                Row(
                  children: [
                    UserAvatar(
                      imageUrl: otherUser.photo,
                      name: otherUser.name,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${showToggleButton ? 'From' : 'To'} ${otherUser.name}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppTheme.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${DateFormat('MMM d, yyyy').format(task.dueDate)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),

                // Toggle Button
                if (showToggleButton) ...[
                  const SizedBox(height: 12),
                  CustomButton(
                    onPressed: () {
                      final newStatus = task.status == TaskStatus.pending
                          ? TaskStatus.completed
                          : TaskStatus.pending;
                      appProvider.updateTaskStatus(task.id, newStatus);
                    },
                    isOutlined: task.status == TaskStatus.completed,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          task.status == TaskStatus.completed
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          task.status == TaskStatus.completed
                              ? 'Completed'
                              : 'Mark Complete',
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriorityChip() {
    Color color;
    IconData icon;

    switch (task.priority) {
      case TaskPriority.high:
        color = AppTheme.errorColor;
        icon = Icons.priority_high;
        break;
      case TaskPriority.medium:
        color = AppTheme.warningColor;
        icon = Icons.remove;
        break;
      case TaskPriority.low:
        color = AppTheme.accentColor;
        icon = Icons.keyboard_arrow_down;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            task.priority.toString().split('.').last.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    final isCompleted = task.status == TaskStatus.completed;
    final color = isCompleted ? AppTheme.accentColor : AppTheme.textTertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        task.status.toString().split('.').last.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}