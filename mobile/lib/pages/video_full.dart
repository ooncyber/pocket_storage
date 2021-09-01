import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoFull extends StatefulWidget {
  VideoFull({this.url});
  String url = '';
  @override
  _VideoFullState createState() => _VideoFullState();
}

class _VideoFullState extends State<VideoFull> {
  VideoPlayerController controller;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    controller = VideoPlayerController.network(widget.url)
      ..initialize()
      ..setVolume(1);
    print('Variavel widget.url: ${widget.url}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chewie(
        controller: ChewieController(videoPlayerController: controller),
      ),
    );
  }
}
