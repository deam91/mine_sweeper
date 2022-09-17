import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioProvider = StateNotifierProvider<AudioManager, bool>((ref) {
  return AudioManager(ref);
});

class AudioManager extends StateNotifier<bool> {
  AudioManager(this._ref) : super(false) {
    _init();
  }

  final Ref _ref;

  late AudioPlayer audioPlayer;

  _init() async {
    if (kDebugMode) {
      await AudioPlayer.global.changeLogLevel(LogLevel.info);
    }
    await AudioPlayer.global.setGlobalAudioContext(AudioContextConfig(
      duckAudio: true,
      forceSpeaker: true,
      stayAwake: true,
    ).build());
    audioPlayer = AudioPlayer(playerId: 'custom_timer_audioPlayer');
  }

  clear() async {
    await audioPlayer.release();
  }

  setWonResources() async {
    await audioPlayer.release();
    await audioPlayer.setSource(AssetSource('sounds/select.mp3'));
  }

  playWon() async {
    await audioPlayer.play(AssetSource('sounds/success.mp3'),
        mode: PlayerMode.lowLatency);
    state = true;
  }

  playBlown() async {
    await audioPlayer.play(AssetSource('sounds/mines-blown.mp3'),
        mode: PlayerMode.lowLatency);
  }

  playItemSelection() async {
    await audioPlayer.play(AssetSource('sounds/select.mp3'),
        mode: PlayerMode.lowLatency);
  }
}
