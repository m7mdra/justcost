import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/widget/ad_widget.dart';
import 'package:justcost/widget/story_view.dart';
import 'package:video_player/video_player.dart';

class AdStatusScreen extends StatefulWidget {
  final List<Product> products;
  final int position;

  const AdStatusScreen({Key key, this.products, this.position})
      : super(key: key);

  @override
  _AdStatusScreenState createState() => _AdStatusScreenState();
}

class _AdStatusScreenState extends State<AdStatusScreen> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.position);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Directionality(
        child: PageView(
          onPageChanged: (index) {},
          controller: _pageController,
          children: widget.products
              .map((product) => Stack(
                    children: <Widget>[
                      Story(
                        product: product,
                        onComplete: () {
                          if (widget.products.indexOf(product) ==
                              widget.products.length - 1)
                            Navigator.pop(context);

                          _pageController.animateToPage(
                              widget.products.indexOf(product) + 1,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        },
                        canGoToPreviousStory: () {
                          _pageController.animateToPage(
                              widget.products.indexOf(product) - 1,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeOut);
                        },
                      ),
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AdWidget(product: product),
                        ),
                        alignment: Alignment.bottomCenter,
                      )
                    ],
                  ))
              .toList(),
        ),
        textDirection: TextDirection.ltr,
      ),
    );
  }
}

class Story extends StatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback canGoToPreviousStory;
  final VoidCallback onNextStory;
  final Product product;
  final bool repeat;

  const Story({
    this.canGoToPreviousStory,
    Key key,
    this.onComplete,
    this.product,
    this.onNextStory,
    this.repeat = false,
  }) : super(key: key);

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> {
  final GlobalKey<StoryViewState> _globalKey = GlobalKey();
  final GlobalKey<VideoStatusState> _videoStatusKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    print(widget.product.media.map((media) => media.toJson()).join());
  }

  @override
  void dispose() {
    super.dispose();
    _globalKey?.currentState?.dispose();
    print("||||||||||||DISPOSING A STATUS||||||||||||||");
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: StoryView(
        widget.product.media.map((media) {
          if (media.flag == 1)
            return StoryItem(
                ImageStatus(
                  globalKey: _globalKey,
                  key: GlobalKey(),
                  imageUrl: media.url,
                ),
                shouldPause: (pause) {},
                duration: Duration(seconds: 5));
          else
            return StoryItem(
                VideoStatus(
                  globalKey: _globalKey,
                  videoUrl: media.url,
                  key: _videoStatusKey,
                ), shouldPause: (should) {
              if (should)
                _videoStatusKey.currentState.pause();
              else
                _videoStatusKey.currentState.play();
            }, duration: Duration(seconds: 10));
        }).toList(),
        onStoryShow: (s) {
//        onNextStory();
        },
        onComplete: () {
          widget.onComplete();
        },
        canGoPrevious: () {
          widget.canGoToPreviousStory();
        },
        progressPosition: ProgressPosition.top,
        repeat: widget.repeat,
        inline: true,
        key: _globalKey,
      ),
    );
  }
}

class ImageStatus extends StatefulWidget {
  final String imageUrl;
  final GlobalKey<StoryViewState> globalKey;

  const ImageStatus({
    Key key,
    this.imageUrl,
    this.globalKey,
  }) : super(key: key);

  @override
  ImageStatusState createState() => ImageStatusState();
}

class ImageStatusState extends State<ImageStatus> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: DefaultCacheManager().getSingleFile(widget.imageUrl),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        widget.globalKey.currentState.pause();

        if (snapshot.connectionState == ConnectionState.done) if (snapshot
            .hasError) {
          return Text(
            '${snapshot.error}',
            style: TextStyle(color: Colors.red),
          );
        } else {
          widget.globalKey.currentState.resume();
          return Center(
              child: Image.file(
            snapshot.data,
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ));
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
  VideoStatusState createState() => VideoStatusState();
}

class VideoStatusState extends State<VideoStatus> {
  VideoPlayerController controller;

  @override
  void dispose() {
    super.dispose();
    disposeVideo();
  }

  Future<void> pause() {
    return controller?.pause();
  }

  Future<void> play() {
    return controller?.play();
  }

  disposeVideo() async {
    await controller?.pause();
    await controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      builder: (context, AsyncSnapshot<File> snapshot) {
        print(snapshot);
        widget.globalKey?.currentState?.pause();
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
                  widget.globalKey?.currentState?.resume();

                  controller.play();

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
