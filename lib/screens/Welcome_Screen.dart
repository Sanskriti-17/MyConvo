import 'auth/registration_screen.dart';
import 'auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:messenger/widgets/Button_properties.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id='welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}
class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyConvo'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(
                    height: 48.0,
                  ),
                  ButtonProperties(
                    colour: Colors.lightBlueAccent,
                    label: 'Log In',
                    onpressed: (){
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                  ),
                  ButtonProperties(
                      colour: Colors.blueAccent,
                      onpressed: (){
                        Navigator.pushNamed(context, RegistrationScreen.id);
                      },
                      label: 'Register'
                  )
                ]
            )
        )
    );
  }
}
