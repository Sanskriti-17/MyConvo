import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/providers/general/chatroom_provider.dart';
import 'package:messenger/widgets/search_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'personal_info_screen.dart';
import 'package:messenger/services/navigation_management.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const id='search_screen';
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final _firestore=FirebaseFirestore.instance;
  TextEditingController searchCtrl=TextEditingController();
  String? profileImg;
  final _auth=FirebaseAuth.instance;

  getCurrentUserEmailID(){
    return _auth.currentUser?.email;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatRoomProvider>(
      create: (context)=>ChatRoomProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('People'),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: () async{
               Navigation.intentNamed(context, ProfileScreen.id);
              },
            )
          ],
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream:  _firestore.collection('users').snapshots(),
            builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final usersData=snapshot.data!.docs;
                    List <SearchTile> userList=[];
                    for(var singleUser in usersData){
                       bool event = singleUser.get('sender')==getCurrentUserEmailID();
                       if(!event) {
                         userList.add(SearchTile(
                             imgLink: singleUser.get('profileImg'),
                             userName: singleUser.get('username'),
                             userId: singleUser.id,
                             email: singleUser.get('sender')));
                       }
                      }
                    return userList.isEmpty ? const Center(
                      child: Text('No users using this app'))
                    : ListView(
                        children: userList
                    );
                   },
            ),
        ),
      ),
    );
  }
}



