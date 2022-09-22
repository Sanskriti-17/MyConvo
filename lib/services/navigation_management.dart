import 'package:flutter/material.dart';

class Navigation {
  static void intentNamed(BuildContext context, String routeName){
    Navigator.pushNamed(context, routeName);
  }
  static void intentStraightNamed(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }
  static void pushNamedAndReplace(BuildContext context, String routeName){
    Navigator.pushReplacementNamed(context, routeName);
  }
  static void remove(BuildContext context){
    Navigator.pop(context);
  }
}
