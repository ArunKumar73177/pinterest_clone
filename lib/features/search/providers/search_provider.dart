import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../features/home/providers/home_provider.dart';
import 'dart:math';

/// ✓ SEARCH: Service for search-specific API calls
class SearchService {
  final Dio _dio;
  static const String _accessKey = '4WYOrF59mpX2qDyXOyg4IdGNshJHEGcEHHOpjy0yJL8';

  SearchService(this._dio);

  /// Fetch trending pins (random popular topics)
  Future<List<Pin>> fetchTrendingPins() async {
    try {
      final topics = ['trending', 'popular', 'explore'];
      final random = Random();
      final topic = topics[random.nextInt(topics.length)];

      final response = await _dio.get(
        '/search/photos',
        queryParameters: {
          'client_id': _accessKey,
          'query': topic,
          'per_page': 20,
          'page': random.nextInt(5) + 1,
          'orientation': 'portrait',
        },
      );

      final results = response.data['results'] as List;
      return results
          .map((json) => Pin.fromUnsplashJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to load trending: ${e.message}');
    }
  }

  /// Search pins by query
  Future<List<Pin>> searchPins(String query) async {
    try {
      final response = await _dio.get(
        '/search/photos',
        queryParameters: {
          'client_id': _accessKey,
          'query': query,
          'per_page': 30,
          'orientation': 'portrait',
        },
      );

      final results = response.data['results'] as List;
      return results
          .map((json) => Pin.fromUnsplashJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to search: ${e.message}');
    }
  }
}

/// Provider for search service
final searchServiceProvider = Provider<SearchService>((ref) {
  final dio = ref.watch(dioProvider);
  return SearchService(dio);
});

/// Provider for trending pins
final trendingPinsProvider = FutureProvider<List<Pin>>((ref) async {
  final searchService = ref.watch(searchServiceProvider);
  return await searchService.fetchTrendingPins();
});

/// Provider for search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for search results
final searchResultsProvider = FutureProvider<List<Pin>>((ref) async {
  final query = ref.watch(searchQueryProvider);

  if (query.isEmpty) {
    return [];
  }

  final searchService = ref.watch(searchServiceProvider);
  return await searchService.searchPins(query);
});