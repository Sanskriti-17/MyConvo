import 'package:flutter/material.dart';
import'package:messenger/widgets/Button_properties.dart';
import 'package:messenger/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/screens/search_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id ='login_screen';

  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth=FirebaseAuth.instance;
  bool spinner=false;
  late String email;
  late String password;
  final GlobalKey<FormState> _formKey=GlobalKey();
  final AutovalidateMode _autoValidate=AutovalidateMode.onUserInteraction;
  TextEditingController emailCtrl=TextEditingController();
  TextEditingController passwordCtrl=TextEditingController();

  Future _logInUser()async{
    try {
      final oldUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(oldUser!=null){
        Navigator.popAndPushNamed(context, SearchScreen.id);
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyConvo'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.white,
      body:ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autoValidate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!)
                        ? null
                        : 'Enter valid email';
                  },
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress ,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email=value;
                  },
                  decoration: kInputButtonStyle.copyWith(hintText: 'Enter your email'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  validator: (value){
                    return value!.isEmpty? 'Password should be of at least 6 characters' :null;
                  },
                  controller: passwordCtrl,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password=value;
                  },
                  decoration: kInputButtonStyle.copyWith(hintText: 'Enter your password'),
                ),

                const SizedBox(
                  height: 24.0,
                ),
                ButtonProperties(
                  colour: Colors.lightBlueAccent,
                  label: 'Log In',
                  onpressed: () async{
                    setState(() {
                      spinner=true;
                    });
                    if(_formKey.currentState!.validate()){
                      await _logInUser();
                    }
                    setState(() {
                      spinner=false;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Don\'s have an account?',
                        style: TextStyle(color: Colors.black87)),

                    TextButton(
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, RegistrationScreen.id);
                        },
                        child: const Text('sign up',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
