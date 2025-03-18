import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/game_board.dart';
import '../widgets/score_board.dart';
import '../providers/game_provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2048'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<GameProvider>().initGame();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFAF8EF),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<GameProvider>(
              builder: (context, gameProvider, child) => ScoreBoard(
                score: gameProvider.score,
                bestScore: gameProvider.bestScore,
              ),
            ),
            const SizedBox(height: 20),
            const GameBoard(),
          ],
        ),
      ),
    );
  }
}