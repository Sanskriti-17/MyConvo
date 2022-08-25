import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class UserDataProvider extends ChangeNotifier{
  get getCurrentUserDocId=>FirebaseAuth.instance.currentUser!.uid;
  get getAllUserData {return FirebaseFirestore.instance.collection('users').snapshots();}
  getSingleUserData(String docId)=>FirebaseFirestore.instance.collection('users').doc(docId);
}