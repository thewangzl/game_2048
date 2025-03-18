import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tile.dart';
import '../providers/game_provider.dart';
import '../models/game_logic.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  void _handleGesture(BuildContext context, Direction direction) {
    final gameProvider = context.read<GameProvider>();
    gameProvider.move(direction);
    if (gameProvider.isGameOver()) {
      _showGameOverDialog(context);
    }
  }

  void _showGameOverDialog(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('游戏结束'),
          content: Text('最终得分: ${gameProvider.score}'),
          actions: <Widget>[
            TextButton(
              child: const Text('重新开始'),
              onPressed: () {
                gameProvider.initGame();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 2: return const Color(0xFFEEE4DA);
      case 4: return const Color(0xFFEDE0C8);
      case 8: return const Color(0xFFF2B179);
      case 16: return const Color(0xFFF59563);
      case 32: return const Color(0xFFF67C5F);
      case 64: return const Color(0xFFF65E3B);
      case 128: return const Color(0xFFEDCF72);
      case 256: return const Color(0xFFEDCC61);
      case 512: return const Color(0xFFEDC850);
      case 1024: return const Color(0xFFEDC53F);
      case 2048: return const Color(0xFFEDC22E);
      default: return const Color(0xFFCDC1B4);
    }
  }

  Color _getTextColor(int value) {
    return value <= 4 ? Colors.grey[800]! : Colors.white;
  }

  Widget _buildTile(Tile tile) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.all(4.0),
      width: 65.0,
      height: 65.0,
      decoration: BoxDecoration(
        color: _getTileColor(tile.value),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          tile.value == 0 ? '' : tile.value.toString(),
          style: TextStyle(
            fontSize: tile.value > 512 ? 20.0 : 24.0,
            fontWeight: FontWeight.bold,
            color: _getTextColor(tile.value),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dy < -250) {
          _handleGesture(context, Direction.up);
        } else if (details.velocity.pixelsPerSecond.dy > 250) {
          _handleGesture(context, Direction.down);
        }
      },
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx < -250) {
          _handleGesture(context, Direction.left);
        } else if (details.velocity.pixelsPerSecond.dx > 250) {
          _handleGesture(context, Direction.right);
        }
      },
      child: Consumer<GameProvider>(
        builder: (context, gameProvider, child) => Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFBBADA0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,  // 添加这一行
            children: List.generate(4, (i) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (j) {
                  return _buildTile(gameProvider.gameLogic.board[i][j]);
                }),
              );
            }),
          ),
        ),
      ),
    );
  }
}
