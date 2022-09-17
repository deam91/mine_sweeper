import 'package:flutter_riverpod/flutter_riverpod.dart';

final alive = StateNotifierProvider<Alive, bool>((ref) {
  return Alive(ref);
});

class Alive extends StateNotifier<bool> {
  Alive(this.ref) : super(true);

  final Ref ref;

  set alive(bool alive) => state = alive;
  bool get alive => state;
}
