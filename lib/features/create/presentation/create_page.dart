import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ✓ CREATE: Pinterest-style create/upload page
/// Floating action button style with upload options
class CreatePage extends ConsumerWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Main content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Large create icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Create Pin',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[300],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Upload your ideas and inspiration',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Upload button
                    _buildCreateButton(
                      icon: Icons.cloud_upload_outlined,
                      label: 'Upload from device',
                      onTap: () {
                        // TODO: Implement image picker
                        _showComingSoonDialog(context);
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildCreateButton(
                      icon: Icons.link,
                      label: 'Create from link',
                      onTap: () {
                        _showComingSoonDialog(context);
                      },
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Create',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFE60023),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Coming Soon',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This feature will be available soon!',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFFE60023)),
            ),
          ),
        ],
      ),
    );
  }
}