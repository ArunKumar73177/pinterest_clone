// lib/core/widgets/pinterest_bottom_nav.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✓ NAVIGATION

/// Pinterest-style bottom navigation bar
/// Matches the exact design from the real Pinterest app
class PinterestBottomNav extends StatelessWidget {
  final int currentIndex;

  const PinterestBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C), // Dark gray background
        border: Border(
          top: BorderSide(
            color: Colors.grey[900]!,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home,
                label: 'Home',
                index: 0,
                route: '/home',
              ),
              _buildNavItem(
                context: context,
                icon: Icons.search,
                label: 'Search',
                index: 1,
                route: '/search',
              ),
              _buildNavItem(
                context: context,
                icon: Icons.add,
                label: 'Create',
                index: 2,
                route: '/create',
                isCreate: true,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.chat_bubble_outline,
                label: 'Inbox',
                index: 3,
                route: '/inbox',
              ),
              _buildNavItem(
                context: context,
                icon: Icons.person_outline,
                label: 'Saved',
                index: 4,
                route: '/saved',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required String route,
    bool isCreate = false,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (route == '/home') {
            context.go('/home');
          } else {
            // Show coming soon message for other tabs
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$label - Coming Soon'),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.grey[800],
              ),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected && !isCreate ? Icons.home : icon,
              color: isSelected ? Colors.white : Colors.grey[400],
              size: isCreate ? 28 : 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.white : Colors.grey[400],
              ),
            ),
            const SizedBox(height: 2),
            // Active indicator
            if (isSelected)
              Container(
                width: 40,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1),
                ),
              )
            else
              const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}