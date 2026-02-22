import 'package:flutter/material.dart';
import 'package:block_blast_flutter/api/game_api.dart';
import 'package:block_blast_flutter/models/game_state.dart';
import 'package:block_blast_flutter/widgets/game_grid.dart';
import 'package:block_blast_flutter/widgets/shape_picker.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.gameId,
    required this.playerName,
    required this.api,
  });

  final String gameId;
  final String playerName;
  final GameApi api;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameState? _game;
  String? _selectedShape;
  bool _loading = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      final data = await widget.api.getGame(widget.gameId);
      if (mounted) setState(() {
        _game = GameState.fromJson(data);
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() {
        _message = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _placeBlock(int row, int col) async {
    if (_game == null || !_game!.isPlaying || _selectedShape == null) return;
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      final data = await widget.api.placeBlock(
        widget.gameId,
        row: row,
        col: col,
        shape: _selectedShape!,
      );
      if (mounted) {
        setState(() {
          _game = GameState.fromJson(data);
          _loading = false;
        });
        await _clearLines();
      }
    } catch (e) {
      if (mounted) setState(() {
        _message = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _clearLines() async {
    if (_game == null || !_game!.isPlaying) return;
    try {
      final data = await widget.api.clearLines(widget.gameId);
      if (mounted) setState(() => _game = GameState.fromJson(data));
    } catch (_) {}
  }

  Future<void> _endGame() async {
    if (_game == null || !_game!.isPlaying) return;
    setState(() => _loading = true);
    try {
      final data = await widget.api.endGame(widget.gameId);
      if (mounted) {
        setState(() {
          _game = GameState.fromJson(data);
          _loading = false;
        });
        _showGameOver();
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showGameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text(
          'Score: ${_game?.score ?? 0}\nLines: ${_game?.linesCleared ?? 0}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            child: const Text('Home'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _game == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final game = _game;
    if (game == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Block Blast')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_message != null) Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_message!, textAlign: TextAlign.center),
              ),
              TextButton(
                onPressed: _loadGame,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final cellSize = 28.0;
    final gridWidth = game.gridCols * cellSize;
    final gridHeight = game.gridRows * cellSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Block Blast'),
        actions: [
          if (game.isPlaying)
            TextButton(
              onPressed: _loading ? null : _endGame,
              child: const Text('End game'),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatChip(label: 'Score', value: '${game.score}'),
                    _StatChip(label: 'Level', value: '${game.level}'),
                    _StatChip(label: 'Lines', value: '${game.linesCleared}'),
                  ],
                ),
                const SizedBox(height: 16),
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _message!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: GameGrid(
                    grid: game.grid,
                    cellSize: cellSize,
                    onCellTap: game.isPlaying && _selectedShape != null ? _placeBlock : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Pick a block, then tap a cell to place',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                ShapePicker(
                  selectedShape: _selectedShape,
                  onShapeSelected: (s) => setState(() => _selectedShape = s),
                  cellSize: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
