import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameOver = StateNotifierProvider<GameOver, bool>((ref) {
  return GameOver(ref);
});

class GameOver extends StateNotifier<bool> {
  GameOver(this.ref) : super(false);

  final Ref ref;

  set gameOver(bool gameOver) => state = gameOver;
  bool get gameOver => state;
}
