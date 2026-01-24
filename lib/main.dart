// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✓ STATE MANAGEMENT
import 'package:go_router/go_router.dart'; // ✓ NAVIGATION
import 'package:pinterest_clone/features/auth/presentation/splash_page.dart';
import 'package:pinterest_clone/features/auth/presentation/auth_entry_page.dart';
import 'package:pinterest_clone/features/auth/presentation/sign_in_page.dart';
import 'package:pinterest_clone/features/home/presentation/home_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// ✓ GO_ROUTER: Router configuration provider
/// Centralized routing for the entire app
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Splash screen route
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Auth entry page (email input)
      GoRoute(
        path: '/auth-entry',
        name: 'auth-entry',
        builder: (context, state) => const AuthEntryPage(),
      ),

      // Sign in page with optional email parameter
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) {
          // Get email from extra data or query parameters
          final email = state.extra as String? ??
              state.uri.queryParameters['email'] ??
              'user@example.com';
          return SignInPage(email: email);
        },
      ),

      // Main home feed (Pinterest-style grid)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Future routes can be added here
      // Example: Pin detail page
      // GoRoute(
      //   path: '/pin/:id',
      //   name: 'pin-detail',
      //   builder: (context, state) {
      //     final pinId = state.pathParameters['id']!;
      //     return PinDetailPage(pinId: pinId);
      //   },
      // ),
    ],

    // Error page for undefined routes
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60023),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✓ GO_ROUTER + RIVERPOD: Get router from provider
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Pinterest Clone',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFE60023), // Pinterest red
        scaffoldBackgroundColor: Colors.white,
      ),
      // ✓ GO_ROUTER: Use router configuration
      routerConfig: router,
    );
  }
}