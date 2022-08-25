import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderServices {
  FlutterSoundRecorder? _recorder;
  bool isInitialized = false;
  late String _filename;
  final Codec _codec = Codec.aacADTS;
  String? get filename{return _filename ?? '';}
  bool get isRecording => _recorder!.isRecording;

  bool get isRecordingComplete => _recorder!.isStopped;

  Future<String> _getFilename()async{
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path;
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "${sdPath}audio_${DateTime.now().millisecondsSinceEpoch}.aac";
  }
  void init() async {
    _recorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone Permission Denied');
    }
    await _recorder!.openRecorder();
    isInitialized = true;
  }

  Future dispose() async {
    _recorder!.closeRecorder();
    _recorder = null;
    isInitialized = false;
  }

  Future _startRecording() async {
    if (isInitialized == false) return;
    _filename=await _getFilename();
    await _recorder!.startRecorder(toFile: _filename, codec: _codec);
    print('recoder$_filename');
  }
  Future _stopRecording() async {
    if (isInitialized == false) return;
    await _recorder!.stopRecorder();
    return null;
  }

  Future toggleRecoding() async {
    if (isInitialized == false) return;
    _recorder!.isRecording ? await _stopRecording() : await _startRecording();
  }
}
