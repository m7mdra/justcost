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
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        onPageChanged: (index) {
        },
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
              Story(
                product: widget.products[index],
                globalKey: GlobalKey(),
                onComplete: () {
                  if (index == widget.products.length-1) Navigator.pop(context);

                  _pageController.animateToPage(index + 1,
                      duration: Duration(milliseconds: 200), curve: Curves.easeInOut);

                },
                canGoToPreviousStory: () {
                  _pageController.animateToPage(index - 1,
                      duration: Duration(milliseconds: 200), curve: Curves.easeOut);
                },
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AdWidget(product: widget.products[index]),
                ),
                alignment: Alignment.bottomCenter,
              )
            ],
          );
        },
        itemCount: widget.products.length,
      ),
    );
  }
}

class Story extends StatelessWidget {
  final VoidCallback onComplete;
  final VoidCallback canGoToPreviousStory;
  final VoidCallback onNextStory;
  final Product product;

  const Story({
    this.canGoToPreviousStory,
    Key key,
    @required this.globalKey,
    this.onComplete,
    this.product,
    this.onNextStory,
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
//        onNextStory();
      },
      onComplete: () {
        onComplete();
      },
      canGoPrevious: () {
        canGoToPreviousStory();
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
        globalKey.currentState.pause();

        if (snapshot.connectionState == ConnectionState.done) if (snapshot
            .hasError) {
          return Text(
            '${snapshot.error}',
            style: TextStyle(color: Colors.red),
          );
        } else {
          globalKey.currentState.resume();
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
