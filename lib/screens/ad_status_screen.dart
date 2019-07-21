import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/story_view.dart';
import 'package:video_player/video_player.dart';

class AdStatusScreen extends StatefulWidget {
  final Product product;

  const AdStatusScreen({Key key, this.product}) : super(key: key);

  @override
  _AdStatusScreenState createState() => _AdStatusScreenState();
}

class _AdStatusScreenState extends State<AdStatusScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Story(
            product: widget.product,
            globalKey: GlobalKey(),
            onComplete: () {},
          ),
          Align(
            child: AdWidget(product: widget.product),
            alignment: Alignment.bottomCenter,
          )
        ],
      ),
    );
  }
}

class Story extends StatelessWidget {
  final VoidCallback onComplete;
  final VoidCallback canGoToPreviousStory;
  final Product product;

  const Story({
    this.canGoToPreviousStory,
    Key key,
    @required this.globalKey,
    this.onComplete,
    this.product,
  }) : super(key: key);

  final GlobalKey<StoryViewState> globalKey;

  @override
  Widget build(BuildContext context) {
    return StoryView(
      product.media.map((media) {
        if (media.flag == 1)
          return StoryItem(
              ImageStatus(
                globalKey: globalKey,
                imageUrl: media.url,
              ),
              duration: Duration(seconds: 5));
        else
          return StoryItem(
              VideoStatus(
                globalKey: globalKey,
                videoUrl: media.url,
              ),
              duration: Duration(seconds: 10));
      }).toList(),
      onStoryShow: (s) {
        print("Showing a story");
      },
      onComplete: () {
        print("Completed a cycle");
        onComplete();
      },
      canGoPrevious: () {
        canGoToPreviousStory();
        print("canGoToPreviousStory");
      },
      progressPosition: ProgressPosition.top,
      repeat: false,
      inline: true,
      key: globalKey,
    );
  }
}

class ImageStatus extends StatelessWidget {
  final String imageUrl;
  final GlobalKey<StoryViewState> globalKey;

  const ImageStatus({
    Key key,
    this.imageUrl,
    this.globalKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: DefaultCacheManager().getSingleFile(imageUrl),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) if (snapshot
            .hasError) {
          return Text(
            '${snapshot.error}',
            style: TextStyle(color: Colors.red),
          );
        } else {
          return Center(child: Image.file(snapshot.data));
        }
        else
          return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class VideoStatus extends StatefulWidget {
  final String videoUrl;
  final GlobalKey<StoryViewState> globalKey;

  const VideoStatus({
    Key key,
    @required this.globalKey,
    this.videoUrl,
  }) : super(key: key);

  @override
  _VideoStatusState createState() => _VideoStatusState();
}

class _VideoStatusState extends State<VideoStatus> {
  VideoPlayerController controller;

  @override
  void dispose() {
    super.dispose();
    if (controller != null) controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      builder: (context, AsyncSnapshot<File> snapshot) {
        print(snapshot);
        widget.globalKey.currentState.pause();
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError)
            return Container(
              child: Text(
                'error occurred: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.black,
            );

          if (snapshot.hasData) {
            controller = VideoPlayerController.file(snapshot.data);

            return FutureBuilder<void>(
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  widget.globalKey.currentState.resume();

                  controller.play();
                  controller.setLooping(true);

                  return Center(
                    child: AspectRatio(
                      child: VideoPlayer(controller),
                      aspectRatio: controller.value.aspectRatio,
                    ),
                  );
                } else
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
              },
              future: controller.initialize(),
            );
          }
          return Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        } else {
          return Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }
      },
      future: DefaultCacheManager().getSingleFile(widget.videoUrl),
    );
  }
}
