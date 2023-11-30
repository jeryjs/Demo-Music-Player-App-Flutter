import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/music_data.dart';
import 'package:flutter_application_4/player_service.dart';

import 'song_card.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  PlayerService ps = PlayerService();
  late AudioPlayer player = ps.player;

  late Song song = ps.songs[1];

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
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: toggle
          ? Icon(icn1, key: const ValueKey<int>(1), size: 60, color: Colors.white)
          : Icon(icn2, size: 60, color: Colors.white)
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    player.setSource(song.source);
    ps.addListener(() => setState(() {
      debugPrint('PlayerScreen: PlayerService listener called on PlayerScreen');
    }));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF375C77),
        title: const Row(children: [
          Icon(Icons.arrow_back_ios, color: Colors.white),
          SizedBox(width: 10),
          Text('Now Playing', style: TextStyle(color: Colors.white)),
        ]),
        actions: const [
          Icon(Icons.more_vert, color: Colors.white),
          SizedBox(width: 8)
        ],
      ),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF375C77),
                Color(0xFF121212),
              ],
            ),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 70)),
                Container(
                  height: 350,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(song.img),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 90)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(song.title, style: const TextStyle(color: Colors.white, fontSize: 18)),
                          const Padding(padding: EdgeInsets.only(top: 4)),
                          Text(song.artist.join(', '), style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                        ],
                      ),
                      const Icon(Icons.info_outline, size: 24, color: Colors.white)
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
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0),
                          trackShape: const RectangularSliderTrackShape(),
                          trackHeight: 2,
                        ),
                        child: Slider(
                          activeColor: Colors.white,
                          inactiveColor: Colors.white.withOpacity(0.2),
                          value: ps.currentPosition.inSeconds.toDouble(),
                          max: ps.totalDuration.inSeconds.toDouble(),
                          onChanged: (value) => player.seek( Duration(seconds: value.toInt()) ),
                        ),
                      ),
                      Positioned(
                        bottom: 2, right: 0, left: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatDuration(ps.currentPosition), style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                              Text(formatDuration(ps.totalDuration), style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
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
                      icon: const Icon(Icons.skip_previous_outlined, size: 40, color: Colors.white),
                      onPressed: () => setState(() {
                        song = ps.songs[ps.songs.indexOf(song)-1];
                        player.setSource(song.source);
                      }),
                    ),
                    AnimatedIcon(
                      Icons.pause_circle, Icons.play_circle, ps.isPlaying, () => ps.isPlaying ? player.pause() : player.resume()
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next_outlined, size: 40, color: Colors.white),
                      onPressed: () => setState(() {
                        song = ps.songs[ps.songs.indexOf(song)+1];
                        player.setSource(song.source);
                      }),
                    ),
                  ],
                )
              ],
            )),
           SongCard(key: ValueKey(song), song: song, playerService: ps),
          ],
        ),
      ),
      // bottomNavigationBar: SizedBox(height:154, child: SongCard(song: song, playerService: ps)),
    );
  }
}