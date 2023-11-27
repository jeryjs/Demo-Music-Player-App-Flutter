// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MiniPlayer extends StatefulWidget {
  final AudioPlayer player;

  const MiniPlayer({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  bool _isPlaying = false;
  Duration _currentPosition = Duration(seconds: 0);
  Duration _totalDuration = Duration(seconds: 1);

  String imageUrl = 'https://th.bing.com/th/id/OIP.PbnNIseyMPefxbYlhsAuBwAAAA?rs=1&pid=ImgDetMain';
  TextStyle titleStyle = TextStyle(color: Colors.white, fontSize: 16);
  TextStyle artistStyle = TextStyle(color: Colors.white, fontSize: 12);

  // ignore: non_constant_identifier_names
  Widget AnimatedIcon(icn1, icn2, toggle, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: toggle
          ? Icon(icn1, key: ValueKey<int>(1), size: 30, color: Colors.white)
          : Icon(icn2, size: 30, color: Colors.white)
      ),
    );
  }



  @override
  void initState() {
    super.initState();
    widget.player.onPlayerStateChanged.listen((PlayerState s) {
      setState(() => _isPlaying = s == PlayerState.playing);
    });
    widget.player.onPositionChanged.listen((Duration d) {
      // debugPrint('Current position: $d');
      setState(() => _currentPosition = d);
    });
    widget.player.onDurationChanged.listen((Duration d) {
      setState(() => _totalDuration = d);
    });
  }

  @override
  void dispose() {
    widget.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Color(0xFF244055),
          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Row(children: [
                Expanded(child: 
                  Row(children: [
                    SizedBox(width: 16, height: 80),
                    Image.asset('assets/image1.jpg', width: 60, height: 60, fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mutyala Dhaarani', style: titleStyle),
                          Padding(padding: EdgeInsets.only(top: 4)),
                          Text('Harris Jayaraj', style: artistStyle),
                        ],
                      ),
                    ),
                  ]),
                ),
                AnimatedIcon(Icons.restart_alt, Icons.restart_alt, false, () => widget.player.seek(Duration.zero)),
                AnimatedIcon(Icons.pause, Icons.play_arrow, _isPlaying, () => !_isPlaying ? widget.player.play(AssetSource('song1.mp3')) : widget.player.pause()),
                Padding(padding: EdgeInsets.only(right: 16))
              ]),
              LinearProgressIndicator(
                value: _currentPosition.inSeconds / _totalDuration.inSeconds,
                backgroundColor: Colors.grey[800],
                borderRadius: BorderRadius.circular(50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
