// lib/features/home/providers/home_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✓ STATE MANAGEMENT
import 'package:dio/dio.dart'; // ✓ NETWORKING

/// Pin model representing a single Pinterest-style pin
class Pin {
  final int id;
  final String imageUrl;
  final double aspectRatio;
  final String title; // Added for detail page
  final String? description;

  Pin({
    required this.id,
    required this.imageUrl,
    required this.aspectRatio,
    this.title = '',
    this.description,
  });

  /// Factory constructor to create Pin from JSON
  factory Pin.fromJson(Map<String, dynamic> json) {
    return Pin(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String,
      aspectRatio: (json['aspectRatio'] as num).toDouble(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
    );
  }
}

/// ✓ DIO: Dio client provider for making HTTP requests
/// Configured with Pinterest-like API settings
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.pinterest.com/v5', // Pinterest API structure
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // ✓ DIO: Add interceptors for request/response logging
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('[DIO] $obj'), // Visible Dio usage
    ),
  );

  return dio;
});

/// ✓ DIO + RIVERPOD: Service provider for fetching pins using Dio
final pinsServiceProvider = Provider<PinsService>((ref) {
  final dio = ref.watch(dioProvider);
  return PinsService(dio);
});

/// Service class that handles API calls using Dio
class PinsService {
  final Dio _dio;

  PinsService(this._dio);

  /// ✓ DIO: Fetch pins from API (currently mocked)
  /// In production: final response = await _dio.get('/pins/feed');
  Future<List<Pin>> fetchPins() async {
    try {
      // Simulate network delay to showcase Dio and loading states
      await Future.delayed(const Duration(milliseconds: 1200));

      // Mock Pinterest-style feed data with varied aspect ratios
      // Real implementation would parse: response.data['items']
      final mockResponse = [
        {'id': 1, 'imageUrl': 'https://images.unsplash.com/photo-1597434429739-2574d7e06807?w=800', 'aspectRatio': 0.75, 'title': 'Mountain Landscape'},
        {'id': 2, 'imageUrl': 'https://images.unsplash.com/photo-1717674798266-e2f700bdafec?w=800', 'aspectRatio': 1.35, 'title': 'Fashion Portrait'},
        {'id': 3, 'imageUrl': 'https://images.unsplash.com/photo-1648475237029-7f853809ca14?w=800', 'aspectRatio': 0.6, 'title': 'Interior Design'},
        {'id': 4, 'imageUrl': 'https://images.unsplash.com/photo-1765128331807-4a6cf08d5e5b?w=800', 'aspectRatio': 1.0, 'title': 'Culinary Art'},
        {'id': 5, 'imageUrl': 'https://images.unsplash.com/photo-1688842338438-f2371e85e1c6?w=800', 'aspectRatio': 1.5, 'title': 'Architecture'},
        {'id': 6, 'imageUrl': 'https://images.unsplash.com/photo-1567003762442-2078a0da1cee?w=800', 'aspectRatio': 0.8, 'title': 'Creative Art'},
        {'id': 7, 'imageUrl': 'https://images.unsplash.com/photo-1769103489351-cf0e7e3a33c7?w=800', 'aspectRatio': 0.7, 'title': 'Minimalist'},
        {'id': 8, 'imageUrl': 'https://images.unsplash.com/photo-1768916905618-304bf04332b5?w=800', 'aspectRatio': 1.25, 'title': 'Botanical'},
        {'id': 9, 'imageUrl': 'https://images.unsplash.com/photo-1712316146767-610c37aa62a2?w=800', 'aspectRatio': 1.1, 'title': 'Cute Pets'},
        {'id': 10, 'imageUrl': 'https://images.unsplash.com/photo-1569832724830-0b4ab7b52ab2?w=800', 'aspectRatio': 0.65, 'title': 'Ocean Waves'},
        {'id': 11, 'imageUrl': 'https://images.unsplash.com/photo-1622032209098-b34bd5fb1776?w=800', 'aspectRatio': 1.4, 'title': 'Vintage'},
        {'id': 12, 'imageUrl': 'https://images.unsplash.com/photo-1738520420654-87cd2ad005d0?w=800', 'aspectRatio': 0.9, 'title': 'Technology'},
        {'id': 13, 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 'aspectRatio': 0.7, 'title': 'Mountain Lake'},
        {'id': 14, 'imageUrl': 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=800', 'aspectRatio': 1.2, 'title': 'Cozy Cat'},
        {'id': 15, 'imageUrl': 'https://images.unsplash.com/photo-1551963831-b3b1ca40c98e?w=800', 'aspectRatio': 1.0, 'title': 'Breakfast'},
      ];

      return mockResponse.map((json) => Pin.fromJson(json)).toList();
    } on DioException catch (e) {
      // ✓ DIO: Handle Dio-specific errors (network, timeout, etc.)
      throw Exception('Network error: ${e.message}');
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
/// StateProvider allows simple value updates across the app
final selectedPinProvider = StateProvider<Pin?>((ref) => null);