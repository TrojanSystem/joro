import 'package:joro/song.dart';

class PlayList {
  String title;
  String imageUrl;
  List<Song> songs;

  PlayList({required this.title, required this.songs, required this.imageUrl});

  static List<PlayList> playList = [
    PlayList(
        title: 'Rock & Roll',
        songs: Song.songs,
        imageUrl:
            'https://images.unsplash.com/photo-1629276301820-0f3eedc29fd0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80'),
    PlayList(
        title: 'Hip Hop',
        songs: Song.songs,
        imageUrl:
        'https://images.unsplash.com/photo-1601643157091-ce5c665179ab?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2072&q=80'),
    PlayList(
        title: 'Rap',
        songs: Song.songs,
        imageUrl:
        'https://images.unsplash.com/photo-1600962815726-457c46a12681?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1888&q=80'),
    PlayList(
        title: 'Blues',
        songs: Song.songs,
        imageUrl:
        'https://images.unsplash.com/photo-1555552855-44331d696762?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80'),
  ];
}
