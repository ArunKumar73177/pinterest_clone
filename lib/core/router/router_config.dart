// lib/core/router/router_config.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✓ NAVIGATION
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✓ STATE MANAGEMENT
import '../../features/home/presentation/home_page.dart';
import '../../features/pin/presentation/pin_detail_page.dart';

/// ✓ GO_ROUTER: Central router configuration for app navigation
/// Defines all routes and navigation behavior
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true, // Helpful for debugging navigation
    routes: [
      // Home route - Pinterest feed
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Pin detail route - individual pin view
      // ✓ GO_ROUTER: Path parameter for pin ID
      GoRoute(
        path: '/pin/:id',
        name: 'pin_detail',
        builder: (context, state) {
          final pinId = state.pathParameters['id']!;
          return PinDetailPage(pinId: pinId);
        },
      ),
    ],

    // Error page for invalid routes
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
              style: TextStyle(fontSize: 18, color: Colors.grey[400]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});