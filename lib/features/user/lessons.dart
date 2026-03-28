import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

import '../../core/styles/themes.dart';

class Lessons extends StatefulWidget {
  final String videoUrl;
  const Lessons({super.key, required this.videoUrl});

  @override
  State<Lessons> createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  VideoPlayerController? _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // تخطي الفيديو للأمام أو الخلف
  void skipForward() {
    final current = _controller!.value.position;
    final maxDuration = _controller!.value.duration;
    Duration newPosition = current + Duration(seconds: 10);
    if (newPosition > maxDuration) newPosition = maxDuration;
    _controller!.seekTo(newPosition);
  }

  void skipBackward() {
    final current = _controller!.value.position;
    Duration newPosition = current - Duration(seconds: 10);
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    _controller!.seekTo(newPosition);
  }

  Widget buildControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          VideoProgressIndicator(
            _controller!,
            allowScrubbing: true,
            padding: EdgeInsets.all(10),
            colors: VideoProgressColors(
              playedColor: primaryColor,
              backgroundColor: Colors.white.withOpacity(0.3),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.replay_10, color: Colors.white, size: 30),
                onPressed: skipBackward,
              ),
              IconButton(
                icon: Icon(
                  _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    _controller!.value.isPlaying
                        ? _controller!.pause()
                        : _controller!.play();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_10, color: Colors.white, size: 30),
                onPressed: skipForward,
              ),
              IconButton(
                icon: Icon(
                  _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () async {
                  setState(() {
                    _isFullScreen = !_isFullScreen;
                  });

                  if (_isFullScreen) {
                    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                    await SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeLeft,
                      DeviceOrientation.landscapeRight,
                    ]);
                  } else {
                    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                    await SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _controller!.value.isInitialized
              ? Stack(
            children: [
              Center(
                child: _isFullScreen
                    ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: VideoPlayer(_controller!),
                )
                    : AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!,),
                ),
              ),
              buildControls(),
            ],
          )
              : CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
