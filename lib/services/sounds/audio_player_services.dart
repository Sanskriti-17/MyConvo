import 'package:flutter/animation.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioPlayerServices {
  FlutterSoundPlayer? _player;

  bool get isPlaying => _player!.isPlaying;

  Future init() async {
    _player = FlutterSoundPlayer();
    await _player!.openPlayer();
  }

  Future dispose() async {
    await _player!.closePlayer();
    _player = null;
  }


  Future<Map<String, Duration>?> setData()async{
    return await _player!.getProgress();
  }

  void updateData(int duration,int position)async{
    _player!.updateProgress(duration: duration, position: position);
  }

  Future seek(Duration value)async{
    await _player!.seekToPlayer(value);
  }

  Future playerState()async{
    return await _player!.getPlayerState();
  }

  Future _startPlaying(String filename,VoidCallback whenFinished) async {
    print('it was here $filename');
    await _player!
        .startPlayer(fromURI: filename, whenFinished: whenFinished);
  }

  Future _stopPlaying() async {
    await _player!.stopPlayer();
  }

  Future togglePlayer({required String  filename,required VoidCallback whenFinished}) async {
    _player!.isPlaying
        ? await _stopPlaying()
        : await _startPlaying(filename,whenFinished);
  }
}
