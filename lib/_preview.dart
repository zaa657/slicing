
import 'package:flutter/material.dart';
import 'package:slicing/auth/login.dart';
import 'package:slicing/auth/register.dart';
import 'package:slicing/auth/splash_screen.dart';
import 'package:slicing/main.dart';
import 'package:slicing/menu/home.dart';
import 'package:slicing/menu/inbox.dart';
import 'package:slicing/menu/profile.dart';
import 'package:slicing/menu/today.dart';

void main() => runApp(const PreviewApp());

class PreviewApp extends StatelessWidget {
  const PreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = Uri.base.queryParameters['screen'] ?? 'splash';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.canvas,
      ),
      home: _screenFor(screen),
    );
  }
}

Widget _screenFor(String name) {
  switch (name) {
    case 'login':
      return const LoginPage();
    case 'register':
      return const RegisterPage();
    case 'home':
      return const _Tabbed(index: 0);
    case 'today':
      return const _Tabbed(index: 1);
    case 'inbox':
      return const _Tabbed(index: 2);
    case 'profile':
      return const _Tabbed(index: 3);
    case 'detail':
      return const TaskDetailPage(title: 'Design Wireframe');
    case 'calendar':
      return const CalendarPage();
    default:
      return const SplashScreen();
  }
}

class _Tabbed extends StatelessWidget {
  const _Tabbed({required this.index});

  final int index;

  static const _pages = <Widget>[
    HomePage(),
    TodayPage(),
    InboxPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: index == 3 ? Colors.white : AppColors.canvas,
      body: SafeArea(child: _pages[index]),
      floatingActionButton: index == 0 ? const AddTaskButton() : null,
      bottomNavigationBar: AppBottomNav(currentIndex: index, onTap: (_) {}),
    );
  }
}
