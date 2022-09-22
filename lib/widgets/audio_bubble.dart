import 'package:flutter/material.dart';
import 'package:messenger/services/sounds/audio_player_services.dart';


class AudioBubble extends StatefulWidget {
  AudioBubble({required this.url,required this.isCurrent});
  late String url;
  late bool isCurrent;

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  AudioPlayerServices player=AudioPlayerServices();
  Duration position=Duration.zero;
  Duration audioLength=Duration.zero;
  bool isPlaying=false;
  Duration previousDuration=Duration.zero;

  Future updatePosition()async {
    final data = await player.setData();
    setState(() {
      position = data!['progress']!;
      print('position: ${position.inMilliseconds.toDouble()}');
    });
  }
  Future updateDuration()async {
    final data = await player.setData();
    setState(() {
      audioLength=data!['duration']!;
      print('audiolength: ${audioLength.inMilliseconds.toDouble()}');
    });

  }
  @override
  void initState(){
    player.init();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.isCurrent? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
            GestureDetector(
              onTap: ()async{
                await updateDuration();
                await updatePosition();
                await player.togglePlayer(
                    filename: widget.url,
                    whenFinished: () async{
                      isPlaying=player.isPlaying;
                      setState(() {});
                    });
                setState(() {
                  isPlaying=player.isPlaying;
                });
                do{
                  await updatePosition();
                  await updateDuration();
                }while(isPlaying);
                print('Player $isPlaying');
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: widget.isCurrent?
                    const BorderRadiusDirectional.only(
                        topStart: Radius.circular(30),
                        bottomEnd: Radius.circular(30),
                        bottomStart: Radius.circular(30)
                    )
                        : const BorderRadiusDirectional.only(
                        topEnd: Radius.circular(30),
                        bottomStart: Radius.circular(30),
                        bottomEnd: Radius.circular(30)
                    ),
                    color: widget.isCurrent?Colors.lightBlueAccent:Colors.grey.shade200,
                  ),
                  child:  Row(
                    children: [
                      Icon(
                        player.isPlaying? Icons.pause: Icons.play_arrow,
                        color: widget.isCurrent?Colors.white:Colors.lightBlueAccent,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Slider(
                                activeColor: widget.isCurrent
                                    ? Colors.white
                                    : Colors.lightBlueAccent,
                                inactiveColor: Colors.white,
                                value: position.inMilliseconds.toDouble(),
                                min: 0.0,
                                max: audioLength.inMilliseconds.toDouble()+1,
                                //adding 1 ,so position never gets bigger than duration even after the song ends and color does not become grey
                                onChanged: (value) async {
                                  setState(() {});
                                }),
                    ],
                  )
              ),
            )
          ]
        );
  }
}
