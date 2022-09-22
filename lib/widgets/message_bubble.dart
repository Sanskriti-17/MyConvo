import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {super.key, required this.text,required this.isCurrent,required this.otherUser});

  late String text;
  late bool isCurrent;
  late String otherUser;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isCurrent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
            Container(
              width: text.length>27?MediaQuery.of(context).size.width*0.7:null,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: isCurrent
                      ? const BorderRadiusDirectional.only(
                          topStart: Radius.circular(30),
                          bottomEnd: Radius.circular(30),
                          bottomStart: Radius.circular(30))
                      : const BorderRadiusDirectional.only(
                          topEnd: Radius.circular(30),
                          bottomStart: Radius.circular(30),
                          bottomEnd: Radius.circular(30)),
                  color: isCurrent
                      ? Colors.lightBlueAccent
                      : Colors.grey.shade200,
                ),
                child: Text(text,
                    style: TextStyle(
                      color: isCurrent ? Colors.white : Colors.black87,
                      fontSize: 18,
                    )))
        ]);
  }
}
