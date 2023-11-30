import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/music_data.dart';

class PlayerService extends ChangeNotifier {
  AudioPlayer? _player;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  AudioPlayer get player {
    _player ??= AudioPlayer(playerId: 'player');
    return _player!;
  }

  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;

  PlayerService() {
    player.onPlayerStateChanged.listen((PlayerState s) {
      _isPlaying = s == PlayerState.playing;
      notifyListeners();
    });
    player.onPositionChanged.listen((Duration d) {
      _currentPosition = d;
      notifyListeners();
    });
    player.onDurationChanged.listen((Duration d) {
      _totalDuration = d;
      notifyListeners();
    });
  }

  final songs = [
    Song(title: 'Mutyala Dhaarani', artist: ['Harris Jayaraj', 'Karthik', 'Meghna'], img: 'https://th.bing.com/th/id/OIP.PbnNIseyMPefxbYlhsAuBwAAAA?rs=1&pid=ImgDetMain', src: 'song1.mp3'),
    Song(title: 'Pink Blood', artist: ['Dima Lancaster'], img: 'https://lh3.googleusercontent.com/cTCzajjNwxzm3zWmO0KZ4E4OCWzMJ-hGqbkjegsN714YdPdGNl66VHWvkOR7JT6TAStxwjLJqaen55qy=w544-h544-l90-rj', src: 'song2.webm'),
    Song(title: 'Suzume', artist: ['Toaka', 'RADWIMPS'], img: 'https://lh3.googleusercontent.com/PiwbntpwpN5Fak7XyeP3l9zcxy-bq1zMfU1mhHMP4w7y_9leKyVGRHM84_LxRFOzHdwaU9O6hKrlFm4=w544-h544-l90-rj', src: 'song3.mp3'),
  ];

}