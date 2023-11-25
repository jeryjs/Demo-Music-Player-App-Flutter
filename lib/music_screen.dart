// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/mini_player.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  bool _isPlaying = false;
  AudioPlayer player = AudioPlayer();

  Duration _currentPosition = Duration(seconds: 0);
  Duration _totalDuration = Duration(seconds: 1);

  String formatDuration(Duration d) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60)).replaceFirst(RegExp('0'), '');
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

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
          ? Icon(icn1, key: ValueKey<int>(1), size: 60, color: Colors.white)
          : Icon(icn2, size: 60, color: Colors.white)
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    player.setSource(AssetSource('song1.mp3'));
    player.onPlayerStateChanged.listen((PlayerState s) {
      debugPrint('Current player state: $s');
      setState(() => _isPlaying = s == PlayerState.playing);
    });
    player.onPositionChanged.listen((Duration d) {
      // debugPrint('Current position: $d');
      setState(() => _currentPosition = d);
    });
    player.onDurationChanged.listen((Duration d) {
      setState(() => _totalDuration = d);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF375C77),
        title: Row(children: [
          Icon(Icons.arrow_back_ios, color: Colors.white),
          SizedBox(width: 10),
          Text('Now Playing', style: TextStyle(color: Colors.white)),
        ]),
        actions: [
          Icon(Icons.more_vert, color: Colors.white),
          SizedBox(width: 8)
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF375C77),
              Color(0xFF121212),
            ],
          ),
        ),
        child: Column(children: [
          Expanded(child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 70)),
              Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage('https://th.bing.com/th/id/OIP.PbnNIseyMPefxbYlhsAuBwAAAA?rs=1&pid=ImgDetMain'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 90)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mutyala Dhaarani', style: TextStyle(color: Colors.white, fontSize: 18)),
                        Padding(padding: EdgeInsets.only(top: 4)),
                        Text('Harris Jayaraj, Karthik, Meghna', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                      ],
                    ),
                    Icon(Icons.info_outline, size: 24, color: Colors.white)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
                        trackShape: RectangularSliderTrackShape(),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.white.withOpacity(0.2),
                        value: _currentPosition.inSeconds.toDouble(),
                        max: _totalDuration.inSeconds.toDouble(),
                        onChanged: (value) => setState(() => player.seek(Duration(seconds: value.toInt()))),
                      ),
                    ),
                    Positioned(
                      bottom: 2, right: 0, left: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatDuration(_currentPosition), style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                            Text(formatDuration(_totalDuration), style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous_outlined, size: 40, color: Colors.white),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Clicked Prev"), duration: Duration(seconds: 1))),
                  ),
                  AnimatedIcon(
                    Icons.pause_circle, Icons.play_circle, _isPlaying, () => _isPlaying ? player.pause() : player.resume()
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next_outlined, size: 40, color: Colors.white),
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Clicked Next"), duration: Duration(seconds: 1))),
                  ),
                ],
              )
            ],
          )
          ),
          MiniPlayer(player: player),
        ]
      ),
    ),
    );
  }
}
