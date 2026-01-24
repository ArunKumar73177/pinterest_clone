// lib/features/home/presentation/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✓ STATE MANAGEMENT
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // ✓ MASONRY GRID
import 'package:cached_network_image/cached_network_image.dart'; // ✓ IMAGE CACHING
import 'package:shimmer/shimmer.dart'; // ✓ LOADING EFFECTS
import '../providers/home_provider.dart';

/// Main home feed page - Pinterest-style masonry grid
/// Uses ConsumerWidget to access Riverpod providers
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✓ RIVERPOD: Watch the pins provider to get pins data and loading state
    final pinsAsyncValue = ref.watch(pinsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Scrollable content with masonry grid
            Expanded(
              child: pinsAsyncValue.when(
                // Loading state - show shimmer placeholders
                loading: () => _buildLoadingGrid(),

                // Error state
                error: (error, stack) => _buildErrorState(error),

                // Success state - show actual pins
                data: (pins) => _buildPinsGrid(pins),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header section
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: const Row(
        children: [
          Text(
            'For you',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// ✓ SHIMMER: Loading state with shimmer effect placeholders
  Widget _buildLoadingGrid() {
    // Varied aspect ratios for natural Pinterest look
    final aspectRatios = [0.75, 1.3, 0.65, 1.0, 1.5, 0.8, 0.7, 1.2];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: 8,
        itemBuilder: (context, index) {
          final aspectRatio = aspectRatios[index % aspectRatios.length];
          return _buildShimmerCard(aspectRatio);
        },
      ),
    );
  }

  /// ✓ SHIMMER: Individual shimmer loading card
  Widget _buildShimmerCard(double aspectRatio) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: AspectRatio(
        aspectRatio: 1 / aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  /// Error state display
  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Failed to load pins',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// ✓ STAGGERED GRID VIEW: Main Pinterest-style masonry grid
  Widget _buildPinsGrid(List<Pin> pins) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: MasonryGridView.count(
        crossAxisCount: 2, // Two columns
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: pins.length,
        itemBuilder: (context, index) {
          return _buildPinCard(pins[index]);
        },
      ),
    );
  }

  /// ✓ CACHED_NETWORK_IMAGE: Individual pin card with cached image
  Widget _buildPinCard(Pin pin) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: pin.imageUrl,
        fit: BoxFit.cover,

        // Placeholder while loading - shimmer effect
        placeholder: (context, url) => AspectRatio(
          aspectRatio: 1 / pin.aspectRatio,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.grey[300],
            ),
          ),
        ),

        // Error widget if image fails to load
        errorWidget: (context, url, error) => AspectRatio(
          aspectRatio: 1 / pin.aspectRatio,
          child: Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.broken_image_outlined,
              size: 48,
              color: Colors.grey,
            ),
          ),
        ),

        // Image builder for custom aspect ratio
        imageBuilder: (context, imageProvider) => AspectRatio(
          aspectRatio: 1 / pin.aspectRatio,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}