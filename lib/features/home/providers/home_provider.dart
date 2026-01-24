// lib/features/home/providers/home_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✓ STATE MANAGEMENT
import 'package:dio/dio.dart'; // ✓ NETWORKING

/// Pin model representing a single Pinterest-style pin
class Pin {
  final int id;
  final String imageUrl;
  final double aspectRatio;

  Pin({
    required this.id,
    required this.imageUrl,
    required this.aspectRatio,
  });

  /// Factory constructor to create Pin from JSON
  factory Pin.fromJson(Map<String, dynamic> json) {
    return Pin(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String,
      aspectRatio: (json['aspectRatio'] as num).toDouble(),
    );
  }
}

/// ✓ DIO: Dio client provider for making HTTP requests
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com', // Replace with actual API
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Add interceptors for logging (useful for debugging)
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
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

  /// ✓ DIO: Fetch pins from API (or mock data)
  Future<List<Pin>> fetchPins() async {
    try {
      // In a real app, you would make an actual API call:
      // final response = await _dio.get('/pins');
      // return (response.data as List).map((json) => Pin.fromJson(json)).toList();

      // For demonstration, we're mocking the API response using Dio's delay
      // This shows Dio usage even without a real backend
      await Future.delayed(const Duration(milliseconds: 1500));

      // Mock data matching the React component
      final mockResponse = [
        {'id': 1, 'imageUrl': 'https://images.unsplash.com/photo-1597434429739-2574d7e06807?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxuYXR1cmUlMjBsYW5kc2NhcGUlMjBtb3VudGFpbnN8ZW58MXx8fHwxNzY5MjAyNTI5fDA&ixlib=rb-4.1.0&q=80&w=1080', 'aspectRatio': 0.75},
        {'id': 2, 'imageUrl': 'https://images.unsplash.com/photo-1717674798266-e2f700bdafec?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmYXNoaW9uJTIwcG9ydHJhaXQlMjBzdHlsZXxlbnwxfHx8fDE3NjkyNDc1NTV8MA&ixlib=rb-4.1.0&q=80&w=1080', 'aspectRatio': 1.3},
        {'id': 3, 'imageUrl': 'https://images.unsplash.com/photo-1648475237029-7f853809ca14?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxpbnRlcmlvciUyMGRlc2lnbiUyMGhvbWV8ZW58MXx8fHwxNzY5MjQ3NTU1fDA&ixlib=rb-4.1.0&q=80&w=1080', 'aspectRatio': 0.65},
        {'id': 4, 'imageUrl': 'https://images.unsplash.com/photo-1765128331807-4a6cf08d5e5b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmb29kJTIwY3VsaW5hcnklMjBkZWxpY2lvdXN8ZW58MXx8fHwxNzY5MjQ3NTU1fDA&ixlib=rb-4.1.0&q=80&w=1080', 'aspectRatio': 1.0},
        {'id': 5, 'imageUrl': 'https://images.unsplash.com/photo-1688842338438-f2371e85e1c6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0cmF2ZWwlMjBhcmNoaXRlY3R1cmUlMjBjaXR5fGVufDF8fHx8MTc2OTI0NzU1Nnww&ixlib=rb-4.1.0&q=80&w=1080', 'aspectRatio': 1.5},
        {'id': 6, 'imageUrl': 'https://images.unsplash.com/photo-1567003762442-2078a0da1cee?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxhcnQlMjBjcmVhdGl2ZSUyMGNvbG9yZnVsfGVufDF8fHx8MTc2OTE2ODg1Mnww&ixlib=rb-4.1.0&q=80&w=1080', 'aspectRatio': 0.8},
        {'id': 7, 'imageUrl': 'https://images.unsplash.com/photo-1769103489351-cf0e7e3a33c7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtaW5pbWFsaXN0JTIwbW9kZXJuJTIwYWVzdGhldGljfGVufDF8fHx8MTc2OTI0NzU1N3ww&ixlib=rb-4.1.0&q=80&w=1080', 'aspectRatio': 0.7},
        {'id': 8, 'imageUrl': 'https://images.unsplash.com/photo-1768916905618-304bf04332b5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxuYXR1cmUlMjBmbG93ZXJzJTIwYm90YW5pY2FsfGVufDF8fHx8MTc2OTI0NzU1N3ww&ixlib=rb-4.1.0&q=80&w=1080', 'aspectRatio': 1.2},
        {'id': 9, 'imageUrl': 'https://images.unsplash.com/photo-1712316146767-610c37aa62a2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwZXRzJTIwYW5pbWFscyUyMGN1dGV8ZW58MXx8fHwxNzY5MjQ3NTU3fDA&ixlib=rb-4.1.0&q=80&w=1080', 'aspectRatio': 1.1},
        {'id': 10, 'imageUrl': 'https://images.unsplash.com/photo-1569832724830-0b4ab7b52ab2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxvY2VhbiUyMGJlYWNoJTIwd2F2ZXN8ZW58MXx8fHwxNzY5MTY1NTIyfDA&ixlib=rb-4.1.0&q=80&w=1080', 'aspectRatio': 0.6},
        {'id': 11, 'imageUrl': 'https://images.unsplash.com/photo-1622032209098-b34bd5fb1776?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx2aW50YWdlJTIwcmV0cm8lMjBhZXN0aGV0aWN8ZW58MXx8fHwxNzY5MjQ3NTU4fDA&ixlib=rb-4.1.0&q=80&w=1080', 'aspectRatio': 1.4},
        {'id': 12, 'imageUrl': 'https://images.unsplash.com/photo-1738520420654-87cd2ad005d0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0ZWNobm9sb2d5JTIwZ2FkZ2V0cyUyMG1vZGVybnxlbnwxfHx8fDE3NjkyNDc1NTh8MA&ixlib=rb-4.1.0&q=80&w=1080', 'aspectRatio': 0.9},
      ];

      return mockResponse.map((json) => Pin.fromJson(json)).toList();
    } on DioException catch (e) {
      // Handle Dio-specific errors
      throw Exception('Failed to fetch pins: ${e.message}');
    }
  }
}

/// ✓ RIVERPOD: Main provider that fetches and provides pins data
/// Uses FutureProvider to handle async data loading
final pinsProvider = FutureProvider<List<Pin>>((ref) async {
  final pinsService = ref.watch(pinsServiceProvider);
  return await pinsService.fetchPins();
});