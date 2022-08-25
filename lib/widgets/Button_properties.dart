import 'package:flutter/material.dart';

class ButtonProperties extends StatelessWidget {
  ButtonProperties({this.colour=Colors.lightBlueAccent,required this.onpressed,required this.label});

  final Color colour;
  final VoidCallback onpressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          textColor: Colors.white,
          onPressed: onpressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            label,
          ),
        ),
      ),
    );
  }
}
