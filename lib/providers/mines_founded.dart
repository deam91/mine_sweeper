import 'package:flutter_riverpod/flutter_riverpod.dart';

final minesFounded = StateNotifierProvider<MinesFounded, int>((ref) {
  return MinesFounded(ref);
});

class MinesFounded extends StateNotifier<int> {
  MinesFounded(this.ref) : super(0);

  final Ref ref;

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }

  void decrement() {
    state--;
  }
}
