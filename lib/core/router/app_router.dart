import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/features/auth/presentation/splash_page.dart';
import 'package:pinterest_clone/features/auth/presentation/auth_entry_page.dart';
import 'package:pinterest_clone/features/auth/presentation/sign_in_page.dart';
import 'package:pinterest_clone/features/home/presentation/home_page.dart';
import 'package:pinterest_clone/features/search/presentation/search_page.dart';
import 'package:pinterest_clone/features/create/presentation/create_page.dart';
import 'package:pinterest_clone/features/inbox/presentation/inbox_page.dart';
import 'package:pinterest_clone/features/saved/presentation/saved_page.dart';
import 'package:pinterest_clone/features/pin/presentation/pin_detail_page.dart';
import 'package:pinterest_clone/core/widgets/bottom_nav_shell.dart';

/// ✓ GO_ROUTER: Centralized router configuration with ShellRoute
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // ═══════════════════════════════════════════════════════════
      // AUTH ROUTES (No bottom navigation)
      // ═══════════════════════════════════════════════════════════
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/auth-entry',
        name: 'auth-entry',
        builder: (context, state) => const AuthEntryPage(),
      ),
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        builder: (context, state) {
          final email = state.extra as String? ??
              state.uri.queryParameters['email'] ??
              'user@example.com';
          return SignInPage(email: email);
        },
      ),

      // ═══════════════════════════════════════════════════════════
      // BOTTOM NAV SHELL ROUTES (Persistent bottom navigation)
      // ═══════════════════════════════════════════════════════════
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const SearchPage(),
            ),
          ),
          GoRoute(
            path: '/create',
            name: 'create',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const CreatePage(),
            ),
          ),
          GoRoute(
            path: '/inbox',
            name: 'inbox',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const InboxPage(),
            ),
          ),
          GoRoute(
            path: '/saved',
            name: 'saved',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const SavedPage(),
            ),
          ),
        ],
      ),

      // ═══════════════════════════════════════════════════════════
      // DETAIL ROUTES (No bottom navigation - full screen)
      // ═══════════════════════════════════════════════════════════
      GoRoute(
        path: '/pin/:id',
        name: 'pin-detail',
        builder: (context, state) {
          final pinId = state.pathParameters['id']!;
          return PinDetailPage(pinId: pinId);
        },
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE60023),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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