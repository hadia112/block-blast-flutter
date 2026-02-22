class GameState {
  GameState({
    required this.id,
    required this.playerName,
    required this.grid,
    required this.gridRows,
    required this.gridCols,
    required this.score,
    required this.level,
    required this.linesCleared,
    required this.status,
  });

  factory GameState.fromJson(Map<String, dynamic> json) {
    final gridRaw = json['grid'] as List<dynamic>?;
    final grid = gridRaw
            ?.map((row) => (row as List<dynamic>).map((e) => (e as num).toInt()).toList())
            .toList() ??
        [];
    return GameState(
      id: json['id'] as String? ?? '',
      playerName: json['playerName'] as String? ?? 'Player',
      grid: grid,
      gridRows: (json['gridRows'] as num?)?.toInt() ?? 10,
      gridCols: (json['gridCols'] as num?)?.toInt() ?? 10,
      score: (json['score'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      linesCleared: (json['linesCleared'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'playing',
    );
  }

  final String id;
  final String playerName;
  final List<List<int>> grid;
  final int gridRows;
  final int gridCols;
  final int score;
  final int level;
  final int linesCleared;
  final String status;

  bool get isPlaying => status == 'playing';
}
