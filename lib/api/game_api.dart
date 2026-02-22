import 'dart:convert';
import 'package:http/http.dart' as http;

class GameApi {
  GameApi({this.baseUrl = 'http://localhost:3000'});
  final String baseUrl;

  Future<Map<String, dynamic>> createGame({
    String playerName = 'Player',
    int gridRows = 10,
    int gridCols = 10,
  }) async {
    final r = await http.post(
      Uri.parse('$baseUrl/api/games'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'playerName': playerName,
        'gridRows': gridRows,
        'gridCols': gridCols,
      }),
    );
    _throwIfNotOk(r);
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getGame(String gameId) async {
    final r = await http.get(Uri.parse('$baseUrl/api/games/$gameId'));
    _throwIfNotOk(r);
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> placeBlock(
    String gameId, {
    required int row,
    required int col,
    required String shape,
  }) async {
    final r = await http.post(
      Uri.parse('$baseUrl/api/games/$gameId/place'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'row': row, 'col': col, 'shape': shape}),
    );
    _throwIfNotOk(r);
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> clearLines(String gameId) async {
    final r = await http.post(Uri.parse('$baseUrl/api/games/$gameId/clear-lines'));
    _throwIfNotOk(r);
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> endGame(String gameId) async {
    final r = await http.post(Uri.parse('$baseUrl/api/games/$gameId/end'));
    _throwIfNotOk(r);
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    final r = await http.get(Uri.parse('$baseUrl/api/leaderboard?limit=$limit'));
    _throwIfNotOk(r);
    final data = jsonDecode(r.body) as Map<String, dynamic>;
    final list = data['leaderboard'] as List<dynamic>? ?? [];
    return list.cast<Map<String, dynamic>>();
  }

  void _throwIfNotOk(http.Response r) {
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw GameApiException(r.statusCode, r.body);
    }
  }
}

class GameApiException implements Exception {
  GameApiException(this.statusCode, this.body);
  final int statusCode;
  final String body;
  @override
  String toString() => 'GameApiException($statusCode): $body';
}
