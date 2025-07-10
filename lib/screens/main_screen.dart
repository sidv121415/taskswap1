import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';
import 'search/search_screen.dart';
import 'connections/connections_screen.dart';
import 'tasks/tasks_screen.dart';
import 'notifications/notifications_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const SearchScreen(),
    const ConnectionsScreen(),
    const TasksScreen(),
    const NotificationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppTheme.surfaceColor,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: AppTheme.textTertiary,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Connections',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.task_alt),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications),
                      if (appProvider.unreadNotificationCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${appProvider.unreadNotificationCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: 'Notifications',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}