// lib/features/pin_detail/presentation/pin_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✓ STATE MANAGEMENT
import 'package:cached_network_image/cached_network_image.dart'; // ✓ IMAGE CACHING
import 'package:go_router/go_router.dart'; // ✓ NAVIGATION
import '../../home/providers/home_provider.dart';

/// ✓ RIVERPOD + GO_ROUTER: Pin detail page shown when user taps a pin
/// Demonstrates navigation integration with state management
class PinDetailPage extends ConsumerWidget {
  final String pinId;

  const PinDetailPage({
    super.key,
    required this.pinId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✓ RIVERPOD: Get the selected pin from state
    final selectedPin = ref.watch(selectedPinProvider);
    final pinsAsync = ref.watch(pinsProvider);

    // Find pin by ID from the pins list (fallback if selectedPin is null)
    Pin? pin = selectedPin;
    if (pin == null) {
      pinsAsync.whenData((pins) {
        pin = pins.firstWhere(
              (p) => p.id.toString() == pinId,
          orElse: () => pins.first,
        );
      });
    }

    if (pin == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // Pinterest-style app bar with back button
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              // ✓ GO_ROUTER: Navigate back to home feed
              onPressed: () => context.pop(),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            actions: [
              // Share/menu actions
              IconButton(
                onPressed: () {},
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.more_horiz, color: Colors.white),
                ),
              ),
            ],
          ),

          // Main pin image
          SliverToBoxAdapter(
            child: _buildPinImage(pin!),
          ),

          // Pin details section
          SliverToBoxAdapter(
            child: _buildPinDetails(pin!),
          ),
        ],
      ),

      // Pinterest-style bottom action bar
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  /// ✓ CACHED_NETWORK_IMAGE: Main pin image with hero animation potential
  Widget _buildPinImage(Pin pin) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: pin.imageUrl,
          fit: BoxFit.cover,
          // ✓ CACHED_NETWORK_IMAGE: Reuses cached image from home feed
          memCacheWidth: 1200, // Higher resolution for detail view
          placeholder: (context, url) => AspectRatio(
            aspectRatio: 1 / pin.aspectRatio,
            child: Container(
              color: Colors.grey[900],
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  /// Pin details content area
  Widget _buildPinDetails(Pin pin) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pin title
          if (pin.title.isNotEmpty)
            Text(
              pin.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          const SizedBox(height: 12),

          // Pin description
          if (pin.description != null)
            Text(
              pin.description!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                height: 1.5,
              ),
            ),

          const SizedBox(height: 20),

          // User info placeholder
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[800],
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pinterest User',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[300],
                    ),
                  ),
                  Text(
                    '1.2K followers',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Follow',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Pinterest-style bottom action bar
  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.grey[900]!, width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Comment button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline, size: 20),
                label: const Text('Comment'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey[800]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Save button
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}