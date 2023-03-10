import 'package:flutter/material.dart';
import 'package:joro/playList.dart';
import 'package:joro/song.dart';
import 'package:joro/song_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Song> song = Song.songs;
    List<PlayList> playList = PlayList.playList;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 60,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.grid_view_rounded,
              color: Colors.white,
            ),
          ),
          actions: const [
            CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  'http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcQjVCJMbseIAEjcb1XuiGMc87zPg0WFJTeJ7frMFIGTBM5ul7VRr8CAiCZHvyxif6IJKs0dzuCPYGZjXZE',
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const _DiscoverMusic(),
              Column(
                children: [
                  _HeaderSection(
                    title: 'Trending Music',
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: song.length,
                      itemBuilder: (context, index) {
                        return SongCard(song: song[index]);
                      },
                    ),
                  ),
                  _HeaderSection(
                    title: 'Playlists',
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: playList.length,
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade800,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(5),
                      height: 80,
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(playList[index].imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    playList[index].title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${playList.length} songs',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              )),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.play_circle_fill_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: const _BottomNavigation(),
      ),
    );
  }
}

class SongCard extends StatelessWidget {
  const SongCard({
    Key? key,
    required this.song,
  }) : super(key: key);

  final Song song;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(song.coverUrl), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.only(right: 15),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.35,
          height: 50,
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: TextStyle(
                          color: Colors.deepPurple.shade800,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        song.description,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.deepPurple.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => SongScreen(song: song),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.play_circle_fill_rounded,
                  ),
                  color: Colors.deepPurple.shade800,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  _HeaderSection({required this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 8, 18, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const Text(
            'View more',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoverMusic extends StatelessWidget {
  const _DiscoverMusic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 8, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const Text(
            'Enjoy your favorite music',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                size: 28,
              ),
              isDense: true,
              hintText: 'Search',
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          )
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.deepPurple.shade800,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
        BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill_rounded), label: 'Play'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Profile'),
      ],
    );
  }
}
