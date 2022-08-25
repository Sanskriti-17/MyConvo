import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/constants.dart';
import 'package:messenger/providers/general/chatroom_provider.dart';
import 'package:messenger/services/sounds/audio_player_services.dart';
import 'package:messenger/widgets/message_bubble.dart';
import 'package:messenger/services/sounds/audio_recorder_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messenger/services/sounds/upload_file.dart';
import 'package:messenger/widgets/audio_bubble.dart';
import 'package:provider/provider.dart';


final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User? loggedInUser = _auth.currentUser;

class ChatScreen extends StatefulWidget {

  static const id = 'chat_screen';
  ChatScreen({this.chatroomID='user1\_user2',this.user2='',this.userImg=''});
  String chatroomID;
  String user2;
  String userImg;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String message;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  AudioRecorderServices recorder = AudioRecorderServices();
  AudioPlayerServices player = AudioPlayerServices();
  UploadFile audioFile=UploadFile();
  bool isRecording = false;
  bool isRecordingComplete = false;
  bool isUploading=false;
  late String audioFilename;
  TextEditingController controller = TextEditingController();



  @override
  void initState() {
    super.initState();
    getUser();
    recorder.init();
  }

  @override
  void dispose() {
    super.dispose();
    recorder.dispose();
  }

  void getUser() async {
    try {
      loggedInUser = _auth.currentUser;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: widget.userImg!='null'? NetworkImage(widget.userImg): null,
              child: widget.userImg=='null'? const Icon(Icons.person,color: Colors.lightBlueAccent):null,
            ),
            const SizedBox(width: 20),
            Text(widget.user2),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body:SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .doc(widget.chatroomID)
                    .collection('chats')
                    .orderBy('time', descending: true)
                    .snapshots(),
                // to get the data/messages inside the chatroom of each users
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  List<Widget> messageList = [];
                  final messages = snapshot.data?.docs;
                  for (var message in messages!) {
                    var messageType=message.get('type') ?? 'text' ;
                      var messageContent = message.get('text');
                      var messageSender = message.get('sender');
                      var currentUser = loggedInUser;
                      if(messageType=='text') {
                        var messageListItem = MessageBubble(
                          text: messageContent,
                          email: messageSender,
                          isCurrent: currentUser?.email == messageSender,
                          otherUser :widget.user2,
                        );
                        messageList.add(messageListItem);
                      }else{
                        var audioItem=AudioBubble(
                            url: messageContent,
                            email: messageSender,
                            isCurrent: currentUser?.email==messageSender
                        );
                        messageList.add(audioItem);
                      }
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messageList,
                    ),
                  );
                },
              ),
              if(isRecordingComplete)isUploading?Container(
                height: 20,
                child: const Text('Sending...',style: TextStyle(color: Colors.grey),),
              ):const SizedBox(
                height: 20,
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                          controller: controller,
                          onChanged: (value) {
                            message = value;
                          },
                          decoration: kMessageTextFieldDecoration),
                    ),

                    IconButton(
                      onPressed: () async {
                              await recorder.toggleRecoding();
                              audioFilename=recorder.filename!;
                              isRecording = recorder.isRecording;
                              isRecordingComplete = recorder.isRecordingComplete;
                              print('completed $isRecordingComplete');
                              print('Recorder $isRecording');
                              setState(() {
                                isUploading=true;
                              });
                              if(isRecordingComplete){
                                String url=await audioFile.upload(filePath: audioFilename);
                                _firestore
                                    .collection('messages')
                                    .doc(widget.chatroomID)
                                    . //unique to two users a chatroom
                                collection('chats')
                                    .add({
                                  'type': 'audio',
                                  'text': url,
                                  'sender': loggedInUser?.email,
                                  'time': DateTime
                                      .now()
                                      .millisecondsSinceEpoch,
                                });
                              }
                              setState(() {
                                isUploading=false;
                              });
                            },
                      icon:
                          isRecording
                              ? const Icon(Icons.pause)
                                  : const Icon(Icons.mic),
                      color: Colors.lightBlueAccent,
                    ),

                    TextButton(
                      onPressed: () {
                        controller.clear();
                        _firestore
                            .collection('messages')
                            .doc(widget.chatroomID)
                            . //unique to two users a chatroom
                            collection('chats')
                            .add({
                          'type' : 'text',
                          'text': message,
                          'sender': loggedInUser?.email,
                          'time': DateTime.now().millisecondsSinceEpoch,
                        });
                      },
                      child: const Text(
                        'send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
      ),
    );
  }
}

