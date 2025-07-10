import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textTertiary,
          indicatorColor: AppTheme.primaryColor,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          tabs: const [
            Tab(text: 'Received'),
            Tab(text: 'Sent'),
          ],
        ),
      ),
      body: Column(
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
              'Manage your task assignments',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReceivedTasks(),
                _buildSentTasks(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedTasks() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final myTasks = appProvider.getMyTasks();

        if (myTasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 64,
                  color: AppTheme.textTertiary,
                ),
                SizedBox(height: 16),
                Text(
                  'No received tasks yet',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tasks assigned to you will appear here',
                  style: TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: myTasks.length,
          itemBuilder: (context, index) {
            final task = myTasks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TaskCard(
                task: task,
                showToggleButton: true,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSentTasks() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final sentTasks = appProvider.getSentTasks();

        if (sentTasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.send,
                  size: 64,
                  color: AppTheme.textTertiary,
                ),
                SizedBox(height: 16),
                Text(
                  'No sent tasks yet',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tasks you assign will appear here',
                  style: TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: sentTasks.length,
          itemBuilder: (context, index) {
            final task = sentTasks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TaskCard(
                task: task,
                showToggleButton: false,
              ),
            );
          },
        );
      },
    );
  }
}