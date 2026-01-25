import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

/// ✓ SEARCH: Pinterest-style search page
/// Search bar + trending topics + masonry grid of search results
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            _buildSearchBar(),

            // Content area
            Expanded(
              child: _isSearching
                  ? _buildSearchResults()
                  : _buildTrendingTopics(),
            ),
          ],
        ),
      ),
    );
  }

  /// Pinterest-style search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(28),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search for ideas',
            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
            prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 22),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear, color: Colors.grey[600], size: 20),
              onPressed: () {
                _searchController.clear();
                setState(() => _isSearching = false);
              },
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          onChanged: (value) {
            setState(() => _isSearching = value.isNotEmpty);
          },
        ),
      ),
    );
  }

  /// Trending topics section (when not searching)
  Widget _buildTrendingTopics() {
    final topics = [
      'Home decor', 'Fashion', 'Food', 'Travel',
      'Art', 'Architecture', 'Nature', 'Technology',
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Popular ideas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[300],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topics.map((topic) {
                return _buildTopicChip(topic);
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          _buildTrendingGrid(),
        ],
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    return GestureDetector(
      onTap: () {
        _searchController.text = topic;
        setState(() => _isSearching = true);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          topic,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// ✓ STAGGERED GRID: Trending pins grid
  Widget _buildTrendingGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: 6,
        itemBuilder: (context, index) {
          return _buildPlaceholderCard([0.8, 1.2, 0.7, 1.4, 0.9, 1.1][index]);
        },
      ),
    );
  }

  /// Search results grid (placeholder)
  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildPlaceholderCard([0.75, 1.35, 0.6, 1.0, 1.5][index % 5]);
        },
      ),
    );
  }

  /// ✓ SHIMMER: Placeholder card
  Widget _buildPlaceholderCard(double aspectRatio) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: AspectRatio(
        aspectRatio: 1 / aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}