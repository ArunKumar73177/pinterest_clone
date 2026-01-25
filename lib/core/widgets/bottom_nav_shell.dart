import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ✓ GO_ROUTER: Shell widget that wraps bottom nav routes
/// Provides persistent bottom navigation across tabs
class BottomNavShell extends StatelessWidget {
  final Widget child;

  const BottomNavShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: child,
      bottomNavigationBar: _PinterestBottomNav(),
    );
  }
}

/// Pinterest-style bottom navigation bar
/// Determines active tab from current route location
class _PinterestBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    // Determine current index from route
    int currentIndex = 0;
    if (location.startsWith('/home')) {
      currentIndex = 0;
    } else if (location.startsWith('/search')) {
      currentIndex = 1;
    } else if (location.startsWith('/create')) {
      currentIndex = 2;
    } else if (location.startsWith('/inbox')) {
      currentIndex = 3;
    } else if (location.startsWith('/saved')) {
      currentIndex = 4;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.grey[900]!,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => context.go('/home'),
              ),
              _NavItem(
                icon: Icons.search,
                label: 'Search',
                isActive: currentIndex == 1,
                onTap: () => context.go('/search'),
              ),
              _NavItem(
                icon: Icons.add_circle_outline,
                label: 'Create',
                isActive: currentIndex == 2,
                onTap: () => context.go('/create'),
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline,
                label: 'Inbox',
                isActive: currentIndex == 3,
                onTap: () => context.go('/inbox'),
              ),
              _NavItem(
                icon: Icons.bookmark_border,
                label: 'Saved',
                isActive: currentIndex == 4,
                onTap: () => context.go('/saved'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual navigation item
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: isActive ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}