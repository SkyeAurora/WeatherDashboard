import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBackgroundPage extends StatefulWidget {
  final Widget child;
  final String weatherCondition;

  const VideoBackgroundPage({
    Key? key,
    required this.child,
    required this.weatherCondition,
  }) : super(key: key);

  @override
  _VideoBackgroundPageState createState() => _VideoBackgroundPageState();
}

class _VideoBackgroundPageState extends State<VideoBackgroundPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      String videoPath = _getVideoPathForWeather(widget.weatherCondition);
      _controller = VideoPlayerController.asset(videoPath);
      
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        // 只有在初始化成功后才开始播放
        _controller.setLooping(true);
        _controller.setVolume(0.0); // 设置静音
        _controller.play();
      }
    } catch (e) {
      print('Video initialization error: $e');
      // 在这里可以设置一个错误状态或显示备用内容
    }
  }

  String _getVideoPathForWeather(String condition) {
    // 根据天气条件返回对应的视频路径
    switch (condition.toLowerCase()) {
      case 'thunderstorm':
        return 'assets/videos/thunderstorm.mp4';
      case 'rain':
        return 'assets/videos/rain.mp4';
      case 'snow':
        return 'assets/videos/snow.mp4';
      case 'clear':
        return 'assets/videos/clear.mp4';
      case 'clouds':
        return 'assets/videos/clouds.mp4';
      default:
        return 'assets/videos/clear.mp4';
    }
  }

  @override
  void didUpdateWidget(VideoBackgroundPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weatherCondition != widget.weatherCondition) {
      _isInitialized = false;
      _controller.dispose();
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isInitialized)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
        widget.child,
      ],
    );
  }
}