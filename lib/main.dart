import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/features/auth/presentation/splash_page.dart';
import 'package:pinterest_clone/features/auth/presentation/auth_entry_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pinterest Clone',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFE60023), // Pinterest red
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AppNavigator(),
    );
  }
}

/// Handles splash screen and navigation to auth entry
class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  @override
  void initState() {
    super.initState();
    _navigateToAuthEntry();
  }

  /// Navigate to auth entry page after 3 seconds
  void _navigateToAuthEntry() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthEntryPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Fade transition for smooth navigation
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}