import 'package:flutter/material.dart';

/// Pinterest-style splash screen with centered logo and loading indicator
/// Matches the authentic Pinterest mobile app design
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pinterest logo container with rounded corners and shadow
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
              child: Center(
                child: Icon(
                  Icons.pinterest,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),

            const SizedBox(height: 32), // Gap between logo and loading indicator

            // Three-dot loading indicator with staggered bounce animation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BouncingDot(delay: Duration.zero),
                const SizedBox(width: 6),
                _BouncingDot(delay: const Duration(milliseconds: 150)),
                const SizedBox(width: 6),
                _BouncingDot(delay: const Duration(milliseconds: 300)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual bouncing dot for the loading indicator
/// Uses AnimationController for smooth, continuous bounce effect
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

    // Setup repeating bounce animation
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

    // Start animation after specified delay
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
              color: Color(0xFFD1D1D1), // Light gray
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}