import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const TaskSwapApp());
}

class TaskSwapApp extends StatelessWidget {
  const TaskSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'TaskSwap',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            home: appProvider.isAuthenticated 
                ? const MainScreen() 
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}