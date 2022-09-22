import 'package:flutter/material.dart';

class SttBubble extends StatefulWidget {
  SttBubble({super.key, required this.url,required this.isCurrent});
  late String url;
  late bool isCurrent;

  @override
  State<SttBubble> createState() => _SttBubbleState();
}

class _SttBubbleState extends State<SttBubble> {


  @override
  Widget build(BuildContext context) {
    return  Row(
        mainAxisAlignment:
        widget.isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
              width: widget.url.length>27?MediaQuery.of(context).size.width*0.7:null,
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
              child: Text(widget.url,
                  style: TextStyle(
                    color: widget.isCurrent ? Colors.white : Colors.black87,
                    fontSize: 18,
                  )))
        ]);
  }
}
