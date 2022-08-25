import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatRoomProvider extends ChangeNotifier {
 String _chatroomId = 'user1\_user2';
  Map<String, dynamic> _chatroomData={};
  String? _otherUserImg;

  setChatroomID(String user1, String user2) {
    if (user1.substring(0, 1).codeUnitAt(0) >
        user2.substring(0, 1).codeUnitAt(0)) {
      _chatroomId = '$user2\_$user1';
      notifyListeners();
      return _chatroomId;
    } else {
      _chatroomId = '$user1\_$user2';
      notifyListeners();
      return _chatroomId;
    }

  }

  get chatroomId {
    _chatroomId == 'user1\_user2' ? null : _chatroomId;
  }

  get chatroomData {
    _chatroomData.isEmpty ? null : _chatroomData;
  }

  setOtherUserImg(String? imgPath){
    _otherUserImg=imgPath;
    print('here');
    notifyListeners();
  }

  get otherUserImg=>_otherUserImg;

  createChatroom(String chatroomId, Map<String, dynamic> chatroomData) async {
    _chatroomId = chatroomId;
    _chatroomData = chatroomData;
    print(_chatroomId);
    FirebaseFirestore.instance
        .collection('messages')
        .doc(_chatroomId)
        .collection('chats');
    notifyListeners();
    return await FirebaseFirestore.instance
        .collection('messages')
        .doc(_chatroomId)
        .set(chatroomData);

  }
}
