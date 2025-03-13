import 'package:audioplayers/audioplayers.dart';

class SoundEffects {
  static final AudioPlayer _effectPlayer = AudioPlayer(); // For sound effects
  static final AudioPlayer _backgroundPlayer =
      AudioPlayer(); // For background music

  // Play the money sound effect (without stopping background music)
  static Future<void> playMoneySound() async {
    await _effectPlayer.play(AssetSource('sounds/money.mp3'));
  }

  // Start playing background music on loop
  static Future<void> playBackgroundMusic() async {
    try {
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundPlayer.setVolume(0.20);
      await _backgroundPlayer.play(AssetSource('sounds/background.mp3'));
    } catch (_) {
      print("Browser, so music doesn't start");
    }
  }

  // Stop background music
  static Future<void> pauseBackgroundMusic() async {
    await _backgroundPlayer.pause();
  }

  static Future<void> resumeBackgroundMusic() async {
    await _backgroundPlayer.resume();
  }
}
