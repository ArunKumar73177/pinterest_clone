import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ✓ INBOX: Pinterest-style inbox/messages page
/// Shows notifications and messages placeholder
class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with tabs
            _buildHeader(),

            // Empty state
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        size: 48,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'When you get notifications, they\'ll show up here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Inbox',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(
                  'All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[400]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}