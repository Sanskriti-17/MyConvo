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

import '../services/convertor/speech_to_text.dart';
import '../services/convertor/text_to_speech.dart';
import '../widgets/stt_bubble.dart';
import '../widgets/tts-bubble.dart';


final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User? loggedInUser = _auth.currentUser;

class ChatScreen extends StatefulWidget {

  static const id = 'chat_screen';
  ChatScreen({super.key, this.chatroomID='user1\_user2',this.user2='',this.userImg='',this.user2Id=''});
  String chatroomID;
  String user2;
  String user2Id;
  String userImg;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String message;
  String ability='';
  String? receiver;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  AudioRecorderServices recorder = AudioRecorderServices();
  AudioPlayerServices player = AudioPlayerServices();
  List oldMessageList=[];
  List newMessageList=[];
  UploadFile audioFile=UploadFile();
  bool isRecording = false;
  bool isRecordingComplete = false;
  bool uploadAudio=false;
  List<String> playMsgList=[];
  late String audioFilename;
  TextEditingController controller = TextEditingController();

  getUser() async {
    try {
      loggedInUser = _auth.currentUser;
      ability=(await getAbility(loggedInUser!.uid))!;
      receiver= await getOtherType();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getAbility(userId) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(userId);
    String? ability;
    await documentReference.get().then((snapshot) {
      ability = snapshot['ability'].toString();
    });
    return ability;
  }

  getOtherType()async{
    print(widget.user2Id);
    DocumentReference ref= FirebaseFirestore.instance.collection('users').doc(widget.user2Id);
    var type;
    await ref.get().then((value) {
     type= value['ability'];
    });
    return type;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value)async{
      await getUser();
      setState(() {});
    });
    recorder.init();
  }

  @override
  void dispose() {
    super.dispose();
    recorder.dispose();
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
          child: ability.isEmpty?const Center(
            child:CircularProgressIndicator()):Column(
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
                  final List<Widget> messageList=_streamFunction(snapshot);
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messageList,
                    ),
                  );
                },
              ),
              uploadAudio?const SizedBox(
                height: 20,
                child: Text('Sending...',style: TextStyle(color: Colors.grey),),
              ):const SizedBox(height: 0),
              ability=='blind'? _blindInputType()
                  : ability=='deaf'|| ability=='mute'?_deafInputType() :_normalInputType(),
            ],
          ),
      ),
    );
  }
  _streamFunction(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List<Widget> messageList = [];
    final messages = snapshot.data?.docs;
    for (var message in messages!) {
      var messageType = message.get('type');
      var messageContent = message.get('text');
      var messageSender = message.get('sender');//to check idf the message is send by current user or not
      var currentUser = loggedInUser;
      if (messageType == 'text') {
        if(ability=='blind'){
          final ttsItem=TtsBubble(
              text: messageContent,
              isCurrent: currentUser?.email == messageSender
          );
          messageList.add(ttsItem);
        }else {
          final messageListItem = MessageBubble(
            text: messageContent,
            isCurrent: currentUser?.email == messageSender,
            otherUser: widget.user2,
          );
          messageList.add(messageListItem);
        }
      } else {
          var audioItem = AudioBubble(
              url: messageContent,
              isCurrent: currentUser?.email == messageSender
          );
          messageList.add(audioItem);
        }
    }
    return messageList;
  }

  _blindInputType(){
    return GestureDetector(
      onTap: () {
        receiver=='deaf'? _sttFunction(): _recordingFunction();
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        decoration: kMessageContainerDecoration.copyWith(color: Colors.lightBlueAccent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isRecording?'Recoding...':'Record your voice',style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
            const SizedBox(width: 10),
            Icon(isRecording ? Icons.pause : Icons.mic,
              color: Colors.white,)
          ],
        ),

      ),
      //The above is for blind person's input
    );
  }

  _deafInputType(){
    return Container(
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
                decoration:kMessageTextFieldDecoration),
          ),
          TextButton(
            onPressed: ()  {
              controller.clear();
              _toSendTextMessage();
            },
            child: const Text(
              'send',
              style: kSendButtonTextStyle,
            ),
          ),
        ],
      ),
    );
  }
  _normalInputType(){
    return Container(
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
                decoration:kMessageTextFieldDecoration),
          ),

          IconButton(
            onPressed: ()=>  receiver=='deaf'? _sttFunction(): _recordingFunction(),
            icon:
            isRecording ? const Icon(Icons.pause) : const Icon(Icons.mic),
            color: Colors.lightBlueAccent,
          ),

          TextButton(
            onPressed: ()  {
              controller.clear();
              _toSendTextMessage();
            },
            child: const Text(
              'send',
              style: kSendButtonTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  _sttFunction ()async{
    Stt stt=Stt();
    String? content;
        if(isRecording) { stt.stopListening(); }
    else{
      await stt.startListening(result: (String text) {
        setState(() {content=text;});
      if(!stt.isListening){
        isRecording=false;
        print('THE WHOLE CONTENT IS : $content');
        message=content!;
        _toSendTextMessage();
      }
      });
    }
   setState((){
     isRecording=stt.isMicOpen;
   });
  }

  _recordingFunction()async{
    await recorder.toggleRecoding();
    audioFilename=recorder.filename!;
    isRecording = recorder.isRecording;
    isRecordingComplete = recorder.isRecordingComplete;
    setState(() {});
    _uploadingAudioToFirebase();
  }

  _uploadingAudioToFirebase()async{
    if(isRecordingComplete){
      setState(() {
        uploadAudio=true;
      });
      String url=await audioFile.upload(filePath: audioFilename);
      _firestore.collection('messages').doc(widget.chatroomID).collection('chats')
          .add({
        'type': 'audio',
        'text': url,
        'sender': loggedInUser?.email,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      });
      setState(() {
        uploadAudio=false;
      });
    }
  }

  _toSendTextMessage(){
    _firestore
        .collection('messages')
        .doc(widget.chatroomID)
        .collection('chats')
        .add({
      'type' : 'text',
      'text': message,
      'sender': loggedInUser?.email,
      'time': DateTime.now().millisecondsSinceEpoch,
    });
  }
}


