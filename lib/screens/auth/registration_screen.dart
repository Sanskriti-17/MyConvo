import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/constants.dart';
import 'package:messenger/screens/entry%20screen/set-avatar-screen.dart';
import 'package:messenger/widgets/Button_properties.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/screens/auth/login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:messenger/services/navigation_management.dart';
import '../../services/data management/data_management.dart';
import '../../services/data management/stored_string_collection.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  const RegistrationScreen({Key? key}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  final _firebase = FirebaseFirestore.instance;
  bool spinner = false;
  late String firstname;
  late String lastname;
  late String username;
  late String email;
  late String password;
  late String docId;
  List<String> specialList = ['blind', 'deaf', 'mute', 'none'];
  String specialAbility = 'none';
  late Map<String, dynamic> userData;
  final _formKey = GlobalKey<FormState>();
  final AutovalidateMode _autoValidate = AutovalidateMode.onUserInteraction;
  TextEditingController firstnameCtrl = TextEditingController();
  TextEditingController lastnameCtrl = TextEditingController();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyConvo'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            return (value?.isEmpty)! ? 'Required Field' : null;
                          },
                          autofocus: true,
                          controller: firstnameCtrl,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            firstname = value;
                          },
                          decoration: kInputButtonStyle.copyWith(
                              hintText: 'First Name'),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            return (value?.isEmpty)! ? 'Required Field' : null;
                          },
                          controller: lastnameCtrl,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            lastname = value;
                          },
                          decoration:
                              kInputButtonStyle.copyWith(hintText: 'Last Name'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    validator: (value) {
                      return (value?.length)! < 5
                          ? 'Username should have at least 5 characters'
                          : null;
                    },
                    controller: usernameCtrl,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      username = value;
                    },
                    decoration:
                        kInputButtonStyle.copyWith(hintText: 'Username'),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      const Text('Speacial Ability :'),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                          child: DropdownButtonFormField(
                        decoration: kInputButtonStyle,
                        value: specialAbility,
                        items: specialList.map((item) => DropdownMenuItem<String>(
                            value: item, child: Text(item))).toList(),
                        onChanged: (item) => setState(() => specialAbility = item!),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!)
                          ? null
                          : 'Enter valid email';
                    },
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kInputButtonStyle.copyWith(hintText: 'Email'),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                      validator: (value) {
                        return (value?.length)! < 6
                            ? 'Password should have at least 6 characters'
                            : null;
                      },
                      controller: passwordCtrl,
                      textAlign: TextAlign.center,
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration:
                          kInputButtonStyle.copyWith(hintText: 'Password')),
                  const SizedBox(
                    height: 24.0,
                  ),
                  ButtonProperties(
                      colour: Colors.blueAccent,
                      onpressed: () async {
                        setState(() {
                          spinner = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          await _registerUser();
                        } else {
                          setState(() => _autoValidate);
                        }
                        setState(() => spinner = false);
                      },
                      label: 'Register'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Already have an account?',
                          style: TextStyle(color: Colors.black87)),
                      TextButton(
                          onPressed: () {
                            Navigation.pushNamedAndReplace(
                                context, LoginScreen.id);
                          },
                          child: const Text(
                            'sign in',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _registerUser() async {
    try {
      print(password);
      print(email);


      final UserCredential newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        userData = {
          'firstname': firstname,
          'lastname': lastname,
          'ability': specialAbility,
          'username': username,
          'sender': email,
          'profileImg': 'null',
        };
        final docId=_auth.currentUser!.uid;
        await _firebase
            .collection('users').doc(docId)
            .set(userData);

        Navigation.intentNamed(context, SetAvatarScreen.id);
        await DataManagement.storeStringData(StoredString.userAuthId, _auth.currentUser!.uid);
      }

    } catch (e) {
      print(e);
      _snackBar(e.toString());
    }
  }

  _snackBar(String error){
    final snackBar=SnackBar(
      content: Text(error,style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.redAccent,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
}
