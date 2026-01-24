// lib/features/home/presentation/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✓ STATE MANAGEMENT
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // ✓ MASONRY GRID
import 'package:cached_network_image/cached_network_image.dart'; // ✓ IMAGE CACHING
import 'package:shimmer/shimmer.dart'; // ✓ LOADING EFFECTS
import 'package:go_router/go_router.dart'; // ✓ NAVIGATION
import '../providers/home_provider.dart';
import '../../../core/widgets/pinterest_bottom_nav.dart';

/// ✓ RIVERPOD: Main home feed page - Pinterest-style masonry grid
/// ConsumerWidget allows direct access to Riverpod providers
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✓ RIVERPOD: Watch the pins provider to reactively rebuild on state changes
    final pinsAsyncValue = ref.watch(pinsProvider);

    return Scaffold(
      backgroundColor: Colors.black, // Pinterest's signature black background
      body: RefreshIndicator(
        // ✓ PULL-TO-REFRESH: Invalidate provider to reload pins
        onRefresh: () async {
          ref.invalidate(pinsProvider);
          // Wait for new data to load
          await ref.read(pinsProvider.future);
        },
        color: Colors.white,
        backgroundColor: Colors.grey[900],
        child: SafeArea(
          child: Column(
            children: [
              // Pinterest-style minimal header
              _buildPinterestHeader(context),

              // Main scrollable content area
              Expanded(
                child: pinsAsyncValue.when(
                  // ✓ SHIMMER: Loading state with shimmer placeholders
                  loading: () => _buildLoadingGrid(),

                  // Error state with retry option
                  error: (error, stack) => _buildErrorState(error, ref),

                  // ✓ STAGGERED GRID: Success - show masonry grid of pins
                  data: (pins) => _buildPinsGrid(context, ref, pins),
                ),
              ),
            ],
          ),
        ),
      ),

      // ✓ BOTTOM NAVIGATION: Pinterest-style bottom nav bar
      bottomNavigationBar: const PinterestBottomNav(currentIndex: 0),
    );
  }

  /// Pinterest-accurate header with "For you" and action icon
  /// No AppBar - clean minimal design
  Widget _buildPinterestHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), // Minimal vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // "For you" label with underline indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'For you',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.5, // Tighter spacing like Pinterest
                ),
              ),
              const SizedBox(height: 6),
              // Active tab indicator - thin white line
              Container(
                width: 50,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),

          // Top-right action icon (tune/edit feed)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.tune,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// ✓ SHIMMER + STAGGERED GRID: Loading state with realistic placeholders
  /// Matches actual grid layout to prevent layout shift when data loads
  Widget _buildLoadingGrid() {
    // Varied aspect ratios matching real Pinterest content distribution
    final aspectRatios = [0.75, 1.35, 0.6, 1.0, 1.5, 0.8, 0.7, 1.25, 1.1, 0.65];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4), // Tight edge spacing
      child: MasonryGridView.count(
        crossAxisCount: 2, // Two-column grid
        mainAxisSpacing: 8, // Vertical spacing between cards
        crossAxisSpacing: 8, // Horizontal spacing between cards
        itemCount: 10,
        itemBuilder: (context, index) {
          final aspectRatio = aspectRatios[index % aspectRatios.length];
          return _buildShimmerCard(aspectRatio);
        },
      ),
    );
  }

  /// ✓ SHIMMER: Individual shimmer loading placeholder
  /// Subtle animation that doesn't distract
  Widget _buildShimmerCard(double aspectRatio) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!, // Dark base matching Pinterest
      highlightColor: Colors.grey[800]!, // Subtle highlight
      period: const Duration(milliseconds: 1500), // Slow, smooth animation
      child: AspectRatio(
        aspectRatio: 1 / aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16), // Match actual card radius
          ),
        ),
      ),
    );
  }

  /// Error state with retry functionality
  Widget _buildErrorState(Object error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check your connection and try again',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          // Retry button
          TextButton(
            onPressed: () {
              // ✓ RIVERPOD: Invalidate provider to retry fetch
              ref.invalidate(pinsProvider);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[900],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// ✓ STAGGERED GRID VIEW: Pinterest-style masonry grid layout
  /// Tightly packed, varied heights, smooth scrolling
  Widget _buildPinsGrid(BuildContext context, WidgetRef ref, List<Pin> pins) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4), // Minimal edge padding
      child: MasonryGridView.count(
        crossAxisCount: 2, // Two columns for mobile
        mainAxisSpacing: 8, // Tight vertical spacing like Pinterest
        crossAxisSpacing: 8, // Tight horizontal spacing
        itemCount: pins.length,
        itemBuilder: (context, index) {
          final pin = pins[index];
          return _buildPinCard(context, ref, pin);
        },
      ),
    );
  }

  /// ✓ CACHED_NETWORK_IMAGE: Individual pin card with image caching
  /// ✓ GO_ROUTER: Tappable with navigation to detail page
  Widget _buildPinCard(BuildContext context, WidgetRef ref, Pin pin) {
    return GestureDetector(
      // ✓ GO_ROUTER: Navigate to pin detail on tap
      onTap: () {
        // Update selected pin in state
        ref.read(selectedPinProvider.notifier).state = pin;
        // Navigate to detail page using go_router
        context.push('/pin/${pin.id}');
      },
      child: AnimatedScale(
        // Subtle scale feedback on tap (Pinterest-like interaction)
        scale: 1.0,
        duration: const Duration(milliseconds: 100),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16), // Pinterest corner radius
          child: CachedNetworkImage(
            imageUrl: pin.imageUrl,
            fit: BoxFit.cover,

            // ✓ CACHED_NETWORK_IMAGE: Efficient caching reduces network calls
            memCacheWidth: 800, // Optimize memory usage
            maxWidthDiskCache: 800,

            // ✓ SHIMMER: Placeholder while image loads
            placeholder: (context, url) => AspectRatio(
              aspectRatio: 1 / pin.aspectRatio,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[900]!,
                highlightColor: Colors.grey[800]!,
                child: Container(
                  color: Colors.grey[900],
                ),
              ),
            ),

            // Error widget if image fails to load
            errorWidget: (context, url, error) => AspectRatio(
              aspectRatio: 1 / pin.aspectRatio,
              child: Container(
                color: Colors.grey[900],
                child: const Icon(
                  Icons.broken_image_outlined,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),

            // ✓ CACHED_NETWORK_IMAGE: Custom image builder preserves aspect ratio
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
        ),
      ),
    );
  }
}