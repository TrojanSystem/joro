class Song {
  String title;
  String description;
  String url;
  String coverUrl;

  Song(
      {required this.url,
      required this.coverUrl,
      required this.title,
      required this.description});

  static List<Song> songs = [
    Song(
      url: 'assets/audio/tsedal.mp3',
      coverUrl: 'assets/images/tsedal.jpg',
      title: 'Tsedal',
      description: 'Eyobed ft Beek Geez',
    ),
    Song(
      url: 'assets/audio/maroon.mp3',
      coverUrl: 'assets/images/maroon.png',
      title: 'Girls Like You',
      description: 'Maroon 5',
    ),
    Song(
      url: 'assets/audio/demon.mp3',
      coverUrl: 'assets/images/demon.jpg',
      title: 'Demon',
      description: 'Imagine Dragon',
    )
  ];
}
