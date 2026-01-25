import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../features/home/providers/home_provider.dart';
import 'dart:math';

/// Board model for saved collections
class Board {
  final String id;
  final String title;
  final int pinCount;
  final List<Pin> previewPins;

  Board({
    required this.id,
    required this.title,
    required this.pinCount,
    required this.previewPins,
  });
}

/// Service for saved/boards functionality
class SavedService {
  final Dio _dio;
  static const String _accessKey = '4WYOrF59mpX2qDyXOyg4IdGNshJHEGcEHHOpjy0yJL8';

  SavedService(this._dio);

  /// Fetch boards with preview pins
  Future<List<Board>> fetchBoards() async {
    try {
      final boardTopics = [
        'travel',
        'home decor',
        'food',
        'fashion',
        'art',
        'fitness',
      ];

      final boards = <Board>[];

      for (int i = 0; i < boardTopics.length; i++) {
        final topic = boardTopics[i];

        final response = await _dio.get(
          '/search/photos',
          queryParameters: {
            'client_id': _accessKey,
            'query': topic,
            'per_page': 3, // Get 3 preview images per board
            'page': 1,
            'orientation': 'portrait',
          },
        );

        final results = response.data['results'] as List;
        final pins = results
            .map((json) => Pin.fromUnsplashJson(json as Map<String, dynamic>))
            .toList();

        boards.add(Board(
          id: 'board_$i',
          title: _formatBoardTitle(topic),
          pinCount: Random().nextInt(20) + 5, // Random pin count 5-25
          previewPins: pins,
        ));
      }

      return boards;
    } on DioException catch (e) {
      throw Exception('Failed to load boards: ${e.message}');
    }
  }

  String _formatBoardTitle(String topic) {
    return topic
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

/// Provider for saved service
final savedServiceProvider = Provider<SavedService>((ref) {
  final dio = ref.watch(dioProvider);
  return SavedService(dio);
});

/// Provider for boards
final boardsProvider = FutureProvider<List<Board>>((ref) async {
  final savedService = ref.watch(savedServiceProvider);
  return await savedService.fetchBoards();
});