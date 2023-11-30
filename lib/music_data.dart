import 'package:audioplayers/audioplayers.dart';

class Song {
  final String title;
  final List<String> artist;
  final String img;
  final String src;

  late final source = src.contains('://') ? UrlSource(src) : AssetSource(src);

  Song({
    required this.title,
    required this.artist,
    required this.img,
    required this.src,
  });
}
