import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();

  late AudioPlayer _audioPlayer;
  late AudioPlayer _effectPlayer;
  String? _currentSound;

  factory AudioService() {
    return _instance;
  }

  AudioService._internal() {
    _audioPlayer = AudioPlayer();
    _effectPlayer = AudioPlayer();
  }

  Future<void> playSound(String soundPath) async {
    try {
      if (_currentSound == soundPath && _audioPlayer.playing) {
        return;
      }

      await _audioPlayer.stop();
      _currentSound = soundPath;

      await _audioPlayer.setAsset(soundPath);
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.play();
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> playEffect(String soundPath) async {
    try {
      final player = AudioPlayer();
      await player.setAsset(soundPath);
      await player.play();
      // Dispose after playing
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          player.dispose();
        }
      });
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
      _currentSound = null;
    } catch (e) {
      // Silent fail
    }
  }

  bool get isPlaying => _audioPlayer.playing;
  String? get currentSound => _currentSound;

  void dispose() {
    _audioPlayer.dispose();
    _effectPlayer.dispose();
  }
}
