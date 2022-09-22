import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';
class Stt{
  final SpeechToText _stt = SpeechToText();
  bool _isSpeechEnabled = false;
  bool _isMicOpen=false;

  get isMicOpen=> _isMicOpen;
  get isListening=>_stt.isListening;

  startListening({required Function(String text) result}) async {

    _isSpeechEnabled = await _stt.initialize(
        onError: (value)=>print(value),
        onStatus: (value)=>print(value)
    );

    if(_isSpeechEnabled) {
      _isMicOpen=true;
      await _stt.listen(
          onResult: (value) => result(value.recognizedWords)
      );
    }
    else{
      await _stt.stop();
    }
    return null;
  }

  void stopListening() async {
    _isSpeechEnabled=false;
    _isMicOpen=false;
    await _stt.stop();
    //setState(() {});
  }
}