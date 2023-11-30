// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/music_data.dart';
import 'package:flutter_application_4/player_service.dart';

class SongCard extends StatefulWidget {
  final Song song;
  final PlayerService playerService;

  const SongCard({super.key, required this.song, required this.playerService});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  late PlayerService ps = widget.playerService;
  late AudioPlayer player = ps.player;
  
  late Song song = widget.song;

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
    ps.addListener(() => setState(() {
      debugPrint('PlayerScreen: PlayerService listener called on SongCard');
    }));
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
                    Image.network(song.img, width: 60, height: 60, fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(song.title, style: titleStyle),
                          Padding(padding: EdgeInsets.only(top: 4)),
                          Text(song.artist.join(', '), style: artistStyle),
                        ],
                      ),
                    ),
                  ]),
                ),
                AnimatedIcon(Icons.restart_alt, Icons.restart_alt, false, () => player.seek(Duration.zero)),
                AnimatedIcon(Icons.pause, Icons.play_arrow, ps.isPlaying, () => !ps.isPlaying ? player.play(song.source) : player.pause()),
                Padding(padding: EdgeInsets.only(right: 16))
              ]),
              LinearProgressIndicator(
                value: ps.currentPosition.inSeconds / ps.totalDuration.inSeconds,
                color: Colors.white,
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
