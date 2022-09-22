import 'package:flutter/material.dart';
import '../services/convertor/text_to_speech.dart';
class TtsBubble extends StatefulWidget {
  TtsBubble(
      {super.key, required this.text, required this.isCurrent});

  late String text;
  late bool isCurrent;
  @override
  State<TtsBubble> createState() => _TtsBubbleState();
}

class _TtsBubbleState extends State<TtsBubble> {
  @override
  Widget build(BuildContext context) {
    return  Row(
        mainAxisAlignment:
        widget.isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              Tts.speak(widget.text);
            },
            child: Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: widget.isCurrent
                      ? const BorderRadiusDirectional.only(
                      topStart: Radius.circular(30),
                      bottomEnd: Radius.circular(30),
                      bottomStart: Radius.circular(30))
                      : const BorderRadiusDirectional.only(
                      topEnd: Radius.circular(30),
                      bottomStart: Radius.circular(30),
                      bottomEnd: Radius.circular(30)),
                  color: widget.isCurrent
                      ? Colors.lightBlueAccent
                      : Colors.grey.shade200,
                ),
                child: Text('Text-to-Speech message',
                    style: TextStyle(
                      color: widget.isCurrent ? Colors.white : Colors.black87,
                      fontSize: 18,
                    ))),
          )
        ]);
  }
}

