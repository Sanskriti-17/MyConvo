import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Tts{
  static speak(String text) async{
    final FlutterTts tts=FlutterTts();
    await tts.setLanguage('en-US');
    await tts.setPitch(1.0);
    await tts.speak(text);
  }

  static blindPlayMsg(String text,VoidCallback function)async{
    final FlutterTts tts=FlutterTts();
    await tts.speak(text).whenComplete(() => function);
    Future.delayed(const Duration(seconds: 2));
  }
}