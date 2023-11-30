import 'package:flutter/material.dart';
import 'package:flutter_application_4/music_data.dart';
import 'package:flutter_application_4/player_service.dart';
import 'package:flutter_application_4/song_card.dart';

import 'player_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp (
      home: Scaffold(
        body: PlayerScreen(),
      ),
    );
  }
}
