import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/screens/Welcome_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const id = 'profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DocumentSnapshot<Object?>? data;
  final userId=FirebaseAuth.instance.currentUser!.uid;
  DocumentReference<Object?> getUserData(userId) {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(userId);
    return documentReference;
  }

  setData()async{
    DocumentReference<Object?> ref=getUserData(userId);
    data= await ref.get().then((value) => value);
    setState(() {});
  }

  @override
  void initState() {

    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         IconButton(
                             onPressed: (){
                               Navigator.pop(context);
                             }, icon: const Icon(Icons.arrow_back,color: Colors.white,size: 35,)),
                         Center(
                           child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: data?['profileImg']!=null?NetworkImage(data?['profileImg']??''):null,
                              radius: 80,
                            ),
                         ),
                          ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 23),
                            child: Text(
                              data?['username']??'',
                              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    userId,
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ProfileTile(label: 'First Name', value: data?['firstname']??'', onTap: (){}),
                  ProfileTile(label: 'Last Name', value: data?['lastname']??'', onTap: (){}),
                  ProfileTile(label:'Special Ability',value: data?['ability']??'',onTap:(){}),
                ],
              ),
              ListTile(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, WelcomeScreen.id);
                },
                tileColor: Colors.white,
                //shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.lightBlueAccent,width: 2)),
                leading: const Icon(Icons.logout, color:  Colors.redAccent,),
                title: const Text('Log Out',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.redAccent),),
              ),
            ],
          ),
        ));
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.label,
    required this.value,
    required this.onTap
  });
  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      leading: Text('$label :',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
      title: Text(value??''),
    );
  }
}
// GestureDetector(
// onTap: () {},
// child: Container(
// decoration: BoxDecoration(
// border: Border.all(color: Colors.blueAccent),
// borderRadius: BorderRadius.circular(30)),
// padding: const EdgeInsets.symmetric(horizontal: 5),
// child: Row(
// children: const [
// Text(
// 'Edit',
// style: TextStyle(color: Colors.blueAccent),
// ),
// Icon(
// Icons.edit,
// color: Colors.blueAccent,
// size: 18,
// ),
// ],
// ),
// ),
// ),