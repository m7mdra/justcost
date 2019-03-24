import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef Function OnRemoved();

class AdVideoView extends StatefulWidget {
  final File file;
  final Size size;
  final OnRemoved onRemove;

  const AdVideoView({Key key, this.file, this.size, this.onRemove})
      : super(key: key);

  @override
  _AdVideoViewState createState() => _AdVideoViewState();
}

class _AdVideoViewState extends State<AdVideoView> {
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(widget.file)
      ..setVolume(0.0)
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          ClipRRect(
            child: VideoPlayer(_videoPlayerController),
            borderRadius: new BorderRadius.circular(8.0),
          ),
          Align(
              child: IconButton(
                  icon: Icon(
                    isPlaying()
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: 40,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    isPlaying()
                        ? _videoPlayerController.pause()
                        : _videoPlayerController.play();
                    setState(() {});
                  })),
          Positioned(
            left: 85,
            top: -5,
            child: ClipOval(
              child: InkWell(
                onTap: () {
                  widget.onRemove();
                },
                child: Container(
                  color: Theme.of(context).accentColor,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  bool isPlaying() {
    return _videoPlayerController.value.initialized &&
        _videoPlayerController.value.isPlaying;
  }
}
