import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UploadFile with ChangeNotifier {
  UploadTask? _uploadTask;

  Future<String> upload({required String filePath}) async {
    final userId=FirebaseAuth.instance.currentUser?.uid;
    final fileName="${DateTime.now().toString()}.acc";
    print(fileName);
    final path = 'user_$userId/record/$fileName';
    print(path);
    final file = File(filePath);//actual file path
    print(file);
    final ref = FirebaseStorage.instance.ref().child(path);

    _uploadTask = ref.putFile(file);
    final snapshot = await _uploadTask!.whenComplete(() => () {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print(urlDownload);
    return urlDownload;
  }
}