import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:joro/main_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:syncfusion_flutter_sliders/sliders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    var _audioAsset = _audioPlayer.setAsset('assets/audio/Post.mp3');
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0XFF144771),
              Color(0XFF071A2C),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: _positionDataStream,
                builder: (context, snap) {
                  final playerState = snap.data;

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
                      progress: playerState?.position ?? Duration.zero,
                      buffered: playerState?.bufferedPosition ?? Duration.zero,
                      total: playerState?.duration ?? Duration.zero,
                      onSeek: _audioPlayer.seek,
                    ),
                  );
                },
              ),
              Controller(
                audioPlayer: _audioPlayer,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Controller extends StatefulWidget {
  Controller({required this.audioPlayer});

  AudioPlayer audioPlayer;

  @override
  State<Controller> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  double _value = 0.0;
  bool isShowing = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isShowing
            ? SfSlider.vertical(
                min: 0.0,
                max: 100.0,
                value: _value,
                interval: 20,
                showTicks: true,
                showLabels: true,
                minorTicksPerInterval: 1,
                onChanged: (dynamic value) {
                  setState(() {
                    _value = value;
                  });
                },
              )
            : Container(),
        IconButton(
          onPressed: () {
            setState(() {
              isShowing = !isShowing;
              widget.audioPlayer.setVolume(_value);
            });
          },
          icon: const Icon(
            Icons.volume_up_outlined,
            color: Colors.white,
            size: 80,
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        StreamBuilder(
            stream: widget.audioPlayer.playerStateStream,
            builder: (context, snap) {
              final playerState = snap.data;
              final playing = playerState?.playing;
              final processState = playerState?.processingState;
              if (!(playing ?? false)) {
                return IconButton(
                  onPressed: () {
                    widget.audioPlayer.play();
                  },
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 80,
                  ),
                );
              } else if (processState != ProcessingState.completed) {
                return IconButton(
                  onPressed: () {
                    widget.audioPlayer.pause();
                  },
                  icon: const Icon(
                    Icons.pause_circle_filled,
                    color: Colors.white,
                    size: 80,
                  ),
                );
              }
              return const Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white,
                size: 80,
              );
            }),
      ],
    );
  }
}
