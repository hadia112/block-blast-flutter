import 'package:flutter/material.dart';
import 'package:block_blast_flutter/api/game_api.dart';
import 'package:block_blast_flutter/screens/game_screen.dart';
import 'package:block_blast_flutter/screens/leaderboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController(text: 'Player');
  final _api = GameApi(baseUrl: 'http://localhost:3000');
  bool _loading = false;
  String? _error;

  Future<void> _startGame() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final game = await _api.createGame(
        playerName: _nameController.text.trim().isEmpty ? 'Player' : _nameController.text.trim(),
        gridRows: 10,
        gridCols: 10,
      );
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GameScreen(
            gameId: game['id'] as String,
            playerName: game['playerName'] as String,
            api: _api,
          ),
        ),
      );
    } on GameApiException catch (e) {
      setState(() => _error = 'Cannot reach server. Start backend: npm start in block-blast folder.\n${e.body}');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BLOCK BLAST',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Place blocks. Clear lines.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                      ),
                ),
                const SizedBox(height: 48),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Your name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 24),
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                FilledButton.icon(
                  onPressed: _loading ? null : _startGame,
                  icon: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow),
                  label: Text(_loading ? 'Starting…' : 'Play'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LeaderboardScreen(api: _api),
                      ),
                    );
                  },
                  icon: const Icon(Icons.leaderboard),
                  label: const Text('Leaderboard'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
