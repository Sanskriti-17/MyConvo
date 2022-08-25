import 'package:flutter/material.dart';
import 'package:messenger/providers/general/user_data_provider.dart';
import 'package:messenger/screens/Welcome_Screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const id = 'profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth=FirebaseAuth.instance;
  String username="hello";
  setData()async{
    username=await Provider.of<UserDataProvider>(context).getCurrentUserUsername(_auth.currentUser!.uid);
  }
  
  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.lightBlueAccent,
                    size: 80,
                  ),
                ), //image will come here
                title: Padding(
                  padding: const EdgeInsets.only(top: 23),
                  child: Text(
                   username,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _auth.currentUser!.uid,
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: const [
                              Text(
                                'Edit',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, WelcomeScreen.id);
                },
                leading: Icon(Icons.logout, color:  Colors.redAccent,),
                title: Text('Log Out'),
              ),
            ],
          ),
        ));
  }
}

// class ProfilePageTile extends StatelessWidget {
//   const ProfilePageTile(
//       {super.key,
//         required this.iconData,
//         required this.label,
//         required this.onPressed});
//
//   final IconData iconData;
//   final String label;
//   final VoidCallback onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: ListTile(
//         leading: Icon(iconData),
//         iconColor: AppColors.purpleTileBgColor,
//         title: Text(label),
//       ),
//     );
//   }
// }
//
// class ProfileTile extends StatelessWidget {
//   const ProfileTile({super.key, required this.num, required this.label});
//
//   final String num;
//   final String label;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           num,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Text(
//           label,
//           style: const TextStyle(
//             color: kNotHighlighted,
//           ),
//         )
//       ],
//     );
//   }
// }
