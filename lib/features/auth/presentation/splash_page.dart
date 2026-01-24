// lib/features/auth/presentation/splash_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✓ NAVIGATION

/// Pinterest-style splash screen with animated loading dots
/// Automatically navigates to auth entry after 3 seconds
/// ✓ GO_ROUTER: Uses context.go() for navigation
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToAuthEntry();
  }

  /// ✓ GO_ROUTER: Navigate to auth entry page after 3 seconds
  void _navigateToAuthEntry() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/auth-entry');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pinterest logo container with custom P icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFE60023), // Pinterest red
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arial',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Three-dot loading indicator with bounce animation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _BouncingDot(delay: Duration.zero),
                SizedBox(width: 6),
                _BouncingDot(delay: Duration(milliseconds: 150)),
                SizedBox(width: 6),
                _BouncingDot(delay: Duration(milliseconds: 300)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual bouncing dot with staggered animation
/// Creates a smooth wave-like loading effect
class _BouncingDot extends StatefulWidget {
  final Duration delay;

  const _BouncingDot({required this.delay});

  @override
  State<_BouncingDot> createState() => _BouncingDotState();
}

class _BouncingDotState extends State<_BouncingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start animation after delay for staggered effect
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFD1D1D1),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}