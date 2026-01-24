// lib/features/home/providers/home_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✓ STATE MANAGEMENT
import 'package:dio/dio.dart'; // ✓ NETWORKING
import 'dart:math';

/// Pin model representing a single Pinterest-style pin
class Pin {
  final int id;
  final String imageUrl;
  final double aspectRatio;
  final String title;
  final String? description;
  final String? authorName;
  final String? authorImage;

  Pin({
    required this.id,
    required this.imageUrl,
    required this.aspectRatio,
    this.title = '',
    this.description,
    this.authorName,
    this.authorImage,
  });

  /// Factory constructor to create Pin from Unsplash API JSON
  factory Pin.fromUnsplashJson(Map<String, dynamic> json) {
    final width = json['width'] as int;
    final height = json['height'] as int;
    final aspectRatio = height / width; // For vertical scrolling

    return Pin(
      id: json['id'].hashCode, // Convert string ID to int
      imageUrl: json['urls']['regular'] as String, // High quality image
      aspectRatio: aspectRatio.clamp(0.6, 1.5), // Limit extreme ratios
      title: json['alt_description'] as String? ??
          json['description'] as String? ??
          'Pinterest Pin',
      description: json['description'] as String?,
      authorName: json['user']['name'] as String?,
      authorImage: json['user']['profile_image']['medium'] as String?,
    );
  }
}

/// ✓ DIO: Dio client provider for Unsplash API
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.unsplash.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept-Version': 'v1',
      },
    ),
  );

  // ✓ DIO: Add interceptors for debugging
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: false, // Don't log large image data
      logPrint: (obj) => print('[DIO] $obj'),
    ),
  );

  return dio;
});

/// ✓ DIO + RIVERPOD: Service provider for fetching pins using Dio
final pinsServiceProvider = Provider<PinsService>((ref) {
  final dio = ref.watch(dioProvider);
  return PinsService(dio);
});

/// Service class that handles Unsplash API calls using Dio
class PinsService {
  final Dio _dio;

  // IMPORTANT: Replace with your Unsplash Access Key
  // Get free API key at: https://unsplash.com/developers
  static const String _accessKey = '4WYOrF59mpX2qDyXOyg4IdGNshJHEGcEHHOpjy0yJL8';

  // Search topics for varied content (randomly selected)
  static final List<String> _searchTopics = [
    'nature', 'architecture', 'food', 'travel', 'fashion',
    'art', 'animals', 'technology', 'interior', 'minimal',
    'landscape', 'portrait', 'vintage', 'modern', 'ocean'
  ];

  PinsService(this._dio);

  /// ✓ DIO: Fetch pins from Unsplash API
  /// Returns different images each time by using random search topics
  Future<List<Pin>> fetchPins() async {
    try {
      // Select random topic for variety
      final random = Random();
      final topic = _searchTopics[random.nextInt(_searchTopics.length)];
      final randomPage = random.nextInt(10) + 1; // Random page 1-10

      print('[UNSPLASH] Fetching: $topic (page $randomPage)');

      // ✓ DIO: Make GET request to Unsplash API
      final response = await _dio.get(
        '/search/photos',
        queryParameters: {
          'client_id': _accessKey,
          'query': topic,
          'per_page': 30, // Pinterest typically shows 20-30 pins
          'page': randomPage,
          'orientation': 'portrait', // Prefer vertical images
        },
      );

      // Parse response
      final results = response.data['results'] as List;

      if (results.isEmpty) {
        throw Exception('No images found');
      }

      // Convert to Pin objects
      final pins = results
          .map((json) => Pin.fromUnsplashJson(json as Map<String, dynamic>))
          .toList();

      print('[UNSPLASH] Loaded ${pins.length} pins');
      return pins;

    } on DioException catch (e) {
      // ✓ DIO: Handle specific Dio errors
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid Unsplash API key. Please add your key in home_provider.dart');
      } else if (e.response?.statusCode == 403) {
        throw Exception('Rate limit exceeded. Try again in a few minutes.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to load pins: $e');
    }
  }

  /// Fetch pins by specific topic (for future search feature)
  Future<List<Pin>> fetchPinsByTopic(String topic) async {
    try {
      final response = await _dio.get(
        '/search/photos',
        queryParameters: {
          'client_id': _accessKey,
          'query': topic,
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

/// ✓ RIVERPOD: Main provider that fetches and provides pins data
/// FutureProvider automatically handles loading/error/data states
final pinsProvider = FutureProvider<List<Pin>>((ref) async {
  final pinsService = ref.watch(pinsServiceProvider);
  return await pinsService.fetchPins();
});

/// ✓ RIVERPOD: Provider to track selected pin for navigation
final selectedPinProvider = StateProvider<Pin?>((ref) => null);