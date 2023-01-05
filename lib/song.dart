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
      url: 'tsedal.mp3',
      coverUrl: 'assets/images/tsedal.jpg',
      title: 'Tsedal',
      description: 'Eyobed ft Beek Geez',
    ),
    Song(
      url: 'maroon.mp3',
      coverUrl: 'assets/images/maroon.png',
      title: 'Girls Like You',
      description: 'Maroon 5',
    ),
    Song(
      url: 'demon.mp3',
      coverUrl: 'assets/images/demon.jpg',
      title: 'Demon',
      description: 'Imagine Dragon',
    )
  ];
}
