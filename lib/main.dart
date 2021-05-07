import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MaterialApp(
    title: 'Reading and Writing Files',
    home: FlutterDemo(),
  ));
}

class FlutterDemo extends StatefulWidget {
  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://player.vimeo.com/external/414250471.sd.mp4?s=650db63649b5f3567e359d5bcd7c409a0d848728&profile_id=139&oauth2_token_id=57447761');
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        tooltip: _controller.value.isPlaying ? 'Pause' : 'Play',
        child: _controller.value.isPlaying
            ? Icon(Icons.pause_circle_filled_outlined)
            : Icon(Icons.play_circle_filled_outlined),
      ),
    );
  }
}
