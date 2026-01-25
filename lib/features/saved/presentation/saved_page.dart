import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

/// ✓ SAVED: Pinterest-style saved pins page
/// Grid of saved/bookmarked pins organized by boards
class SavedPage extends ConsumerWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Boards grid
            Expanded(
              child: _buildBoardsGrid(),
            ),
          ],
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

  /// ✓ STAGGERED GRID: Boards displayed as cards
  Widget _buildBoardsGrid() {
    final boards = [
      'Travel Inspiration',
      'Home Decor',
      'Recipe Ideas',
      'Fashion',
      'Art & Design',
      'Fitness Goals',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: boards.length,
        itemBuilder: (context, index) {
          return _buildBoardCard(boards[index], index);
        },
      ),
    );
  }

  Widget _buildBoardCard(String title, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Board preview (3 images in grid)
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: _buildBoardPreview(),
            ),
          ),

          // Board title and pin count
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(index + 1) * 5} Pins',
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
    );
  }

  /// ✓ SHIMMER: Board preview with 3 shimmer placeholders
  Widget _buildBoardPreview() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: [
        _buildPreviewTile(true),
        _buildPreviewTile(false),
        _buildPreviewTile(false),
      ],
    );
  }

  Widget _buildPreviewTile(bool isLarge) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        color: Colors.grey[800],
      ),
    );
  }
}