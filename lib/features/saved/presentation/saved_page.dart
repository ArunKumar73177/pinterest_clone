import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import '../providers/saved_provider.dart';
import '../../home/providers/home_provider.dart';

/// ✓ SAVED: Pinterest-style saved pins page with real images
class SavedPage extends ConsumerWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardsAsync = ref.watch(boardsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(boardsProvider);
          await ref.read(boardsProvider.future);
        },
        color: Colors.white,
        backgroundColor: Colors.grey[900],
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Boards grid
              Expanded(
                child: boardsAsync.when(
                  loading: () => _buildLoadingGrid(),
                  error: (error, stack) => _buildErrorState(error, ref),
                  data: (boards) => _buildBoardsGrid(context, ref, boards),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Saved',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ✓ STAGGERED GRID: Boards grid with real data
  Widget _buildBoardsGrid(BuildContext context, WidgetRef ref, List<Board> boards) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: boards.length,
        itemBuilder: (context, index) {
          return _buildBoardCard(context, ref, boards[index]);
        },
      ),
    );
  }

  /// Board card with real preview images
  Widget _buildBoardCard(BuildContext context, WidgetRef ref, Board board) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to board detail page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opened ${board.title}'),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.grey[900],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Board preview with 3 real images
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: _buildBoardPreview(board.previewPins),
              ),
            ),

            // Board title and pin count
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    board.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${board.pinCount} Pins',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✓ CACHED_NETWORK_IMAGE: Board preview with real images
  Widget _buildBoardPreview(List<Pin> previewPins) {
    if (previewPins.isEmpty) {
      return Container(
        color: Colors.grey[900],
        child: Center(
          child: Icon(Icons.image_not_supported, color: Colors.grey[700], size: 40),
        ),
      );
    }

    return Row(
      children: [
        // Large image on left (2/3 width)
        Expanded(
          flex: 2,
          child: CachedNetworkImage(
            imageUrl: previewPins[0].imageUrl,
            fit: BoxFit.cover,
            height: double.infinity,
            memCacheWidth: 400,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[800]!,
              highlightColor: Colors.grey[700]!,
              child: Container(color: Colors.grey[800]),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[800],
              child: const Icon(Icons.broken_image, color: Colors.grey, size: 30),
            ),
          ),
        ),

        const SizedBox(width: 2),

        // Two smaller images on right (1/3 width, stacked)
        Expanded(
          flex: 1,
          child: Column(
            children: [
              // Top right image
              if (previewPins.length > 1)
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: previewPins[1].imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    memCacheWidth: 200,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(color: Colors.grey[800]),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[800],
                    ),
                  ),
                ),

              if (previewPins.length > 1) const SizedBox(height: 2),

              // Bottom right image
              if (previewPins.length > 2)
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: previewPins[2].imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    memCacheWidth: 200,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(color: Colors.grey[800]),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// ✓ SHIMMER: Loading grid
  Widget _buildLoadingGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[900]!,
            highlightColor: Colors.grey[800]!,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Error state with retry
  Widget _buildErrorState(Object error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Failed to load boards',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check your connection and try again',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => ref.invalidate(boardsProvider),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey[900],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}