import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final int score;
  final int bestScore;

  const ScoreBoard({
    super.key,
    this.score = 0,
    this.bestScore = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildScoreBox('分数', score.toString()),
        _buildScoreBox('最高分', bestScore.toString()),
      ],
    );
  }

  Widget _buildScoreBox(String label, String score) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFBBADA0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          Text(
            score,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}