import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:joro/song.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class SongScreen extends StatefulWidget {
  SongScreen({required this.song});

  final Song song;

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Stream<PositionData> get _positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position: position,
              duration: duration ?? Duration.zero,
              bufferedPosition: bufferedPosition));

  @override
  void initState() {
    var _audioAsset = _audioPlayer.setAsset('assets/audio/${widget.song.url}');
    //var _audioUrl = _audioPlayer.setUrl(
    //  'https://soundcloud.com/lakeyinspired/warm-nights?utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing');
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.song.url);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            widget.song.coverUrl,
            fit: BoxFit.cover,
          ),
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.0),
                ],
                stops: const [0.0, 0.4, 0.6],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.deepPurple.shade200,
                    Colors.deepPurple.shade800,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15.0, 8, 8, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.song.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    widget.song.description,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.bookmark_add_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                  stream: _positionDataStream,
                                  builder: (context, snapshot) {
                                    final playerState = snapshot.data;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ProgressBar(
                                        barHeight: 8,
                                        baseBarColor: Colors.grey[600],
                                        bufferedBarColor: Colors.grey,
                                        progressBarColor: Colors.red,
                                        thumbColor: Colors.red,
                                        timeLabelTextStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        progress: playerState?.position ??
                                            Duration.zero,
                                        buffered:
                                            playerState?.bufferedPosition ??
                                                Duration.zero,
                                        total: playerState?.duration ??
                                            Duration.zero,
                                        onSeek: _audioPlayer.seek,
                                      ),
                                    );
                                  }),
                              StreamBuilder(
                                  stream: _audioPlayer.playerStateStream,
                                  builder: (context, snap) {
                                    final playerState = snap.data;
                                    final playing = playerState?.playing;
                                    final processState =
                                        playerState?.processingState;
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0),
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.shuffle,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                       const SizedBox(
                                          width: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 18.0),
                                          child: IconButton(
                                            onPressed: () {
                                              _audioPlayer.seekToPrevious();
                                            },
                                            icon: const Icon(
                                              Icons.skip_previous_rounded,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        !(playing ?? false)
                                            ? IconButton(
                                                onPressed: () {
                                                  _audioPlayer.play();
                                                },
                                                icon: const Icon(
                                                  Icons
                                                      .play_circle_fill_rounded,
                                                  size: 60,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : processState !=
                                                    ProcessingState.completed
                                                ? IconButton(
                                                    onPressed: () {
                                                      _audioPlayer.pause();
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .pause_circle_filled_outlined,
                                                      size: 60,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons
                                                        .play_circle_fill_rounded,
                                                    size: 60,
                                                    color: Colors.white,
                                                  ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 18.0),
                                          child: IconButton(
                                            onPressed: () {
                                              _audioPlayer.seekToNext();
                                            },
                                            icon: const Icon(
                                              Icons.skip_next_rounded,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0),
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.repeat,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PositionData {
  Duration position;
  Duration duration;
  Duration bufferedPosition;

  PositionData(
      {required this.position,
      required this.duration,
      required this.bufferedPosition});
}
