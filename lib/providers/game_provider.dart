import 'package:flutter/foundation.dart';
import '../models/game_logic.dart';

class GameProvider extends ChangeNotifier {
  final GameLogic _gameLogic = GameLogic();

  GameLogic get gameLogic => _gameLogic;
  int get score => _gameLogic.score;
  int get bestScore => _gameLogic.bestScore;

  void initGame() {
    _gameLogic.initGame();
    notifyListeners();
  }

  void move(Direction direction) {
    if (_gameLogic.move(direction)) {
      notifyListeners();
    }
  }

  bool isGameOver() {
    return _gameLogic.isGameOver();
  }
}