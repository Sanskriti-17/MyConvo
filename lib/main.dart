import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger/providers/collection/provider_collection.dart';
import 'package:messenger/screens/Personal_info_screen.dart';
import 'package:messenger/screens/chat_screen.dart';
import 'package:messenger/screens/search_screen.dart';
import 'package:messenger/screens/set-avatar-screen.dart';
import 'package:provider/provider.dart';
import 'screens/Welcome_Screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/registration_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(const Messenger());
}

class Messenger extends StatelessWidget {
  const Messenger({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providersCollection,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute : WelcomeScreen.id,
        routes: {
          WelcomeScreen.id : (context)=> WelcomeScreen(),
          RegistrationScreen.id :(context)=> const RegistrationScreen(),
          LoginScreen.id : (context)=> const LoginScreen(),
          ChatScreen.id : (context)=> ChatScreen(),
          SearchScreen.id : (context)=> const SearchScreen(),
          SetAvatarScreen.id : (context)=> const SetAvatarScreen(),
          ProfileScreen.id : (context)=>const ProfileScreen(),
        },
      ),
    );
  }
}