import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class VideoBackgroundPage extends StatefulWidget {
  const VideoBackgroundPage({super.key});
  @override
  _VideoBackgroundPageState createState() => _VideoBackgroundPageState();
}
class _VideoBackgroundPageState extends State<VideoBackgroundPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
    _controller.play();
    // _controller.setVolume(0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return  
        Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio:16 / 9,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        );
}
}