import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import '../providers/search_provider.dart';
import '../../home/providers/home_provider.dart';

/// ✓ SEARCH: Pinterest-style search page with real images
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
    // Watch search query and results
    final searchQuery = ref.watch(searchQueryProvider);
    final isSearchActive = searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            _buildSearchBar(),

            // Content area
            Expanded(
              child: isSearchActive
                  ? _buildSearchResults()
                  : _buildTrendingContent(),
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
                ref.read(searchQueryProvider.notifier).state = '';
                setState(() => _isSearching = false);
              },
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          onChanged: (value) {
            setState(() => _isSearching = value.isNotEmpty);
            ref.read(searchQueryProvider.notifier).state = value;
          },
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              ref.read(searchQueryProvider.notifier).state = value;
            }
          },
        ),
      ),
    );
  }

  /// Trending content when not searching
  Widget _buildTrendingContent() {
    final trendingPins = ref.watch(trendingPinsProvider);

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

          // Topic chips
          _buildTopicChips(),

          const SizedBox(height: 16),

          // Trending pins grid
          trendingPins.when(
            loading: () => _buildLoadingGrid(),
            error: (error, stack) => _buildErrorState(error),
            data: (pins) => _buildPinsGrid(pins),
          ),
        ],
      ),
    );
  }

  /// Topic chips
  Widget _buildTopicChips() {
    final topics = [
      'Home decor', 'Fashion', 'Food', 'Travel',
      'Art', 'Architecture', 'Nature', 'Technology',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: topics.map((topic) {
          return GestureDetector(
            onTap: () {
              _searchController.text = topic;
              ref.read(searchQueryProvider.notifier).state = topic;
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
        }).toList(),
      ),
    );
  }

  /// Search results grid
  Widget _buildSearchResults() {
    final searchResults = ref.watch(searchResultsProvider);

    return searchResults.when(
      loading: () => _buildLoadingGrid(),
      error: (error, stack) => _buildErrorState(error),
      data: (pins) {
        if (pins.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[700]),
                const SizedBox(height: 16),
                Text(
                  'No results found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try searching for something else',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        return _buildPinsGrid(pins);
      },
    );
  }

  /// ✓ STAGGERED GRID: Masonry grid of pins
  Widget _buildPinsGrid(List<Pin> pins) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: pins.length,
        itemBuilder: (context, index) {
          final pin = pins[index];
          return _buildPinCard(pin);
        },
      ),
    );
  }

  /// ✓ CACHED_NETWORK_IMAGE: Pin card with real image
  Widget _buildPinCard(Pin pin) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedPinProvider.notifier).state = pin;
        context.push('/pin/${pin.id}');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: pin.imageUrl,
          fit: BoxFit.cover,
          memCacheWidth: 800,
          maxWidthDiskCache: 800,
          placeholder: (context, url) => AspectRatio(
            aspectRatio: 1 / pin.aspectRatio,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[900]!,
              highlightColor: Colors.grey[800]!,
              child: Container(color: Colors.grey[900]),
            ),
          ),
          errorWidget: (context, url, error) => AspectRatio(
            aspectRatio: 1 / pin.aspectRatio,
            child: Container(
              color: Colors.grey[900],
              child: const Icon(Icons.broken_image_outlined, size: 40, color: Colors.grey),
            ),
          ),
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
    );
  }

  /// ✓ SHIMMER: Loading grid
  Widget _buildLoadingGrid() {
    final aspectRatios = [0.75, 1.35, 0.6, 1.0, 1.5, 0.8];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[900]!,
            highlightColor: Colors.grey[800]!,
            child: AspectRatio(
              aspectRatio: 1 / aspectRatios[index % aspectRatios.length],
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Error state
  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(fontSize: 16, color: Colors.grey[300]),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}