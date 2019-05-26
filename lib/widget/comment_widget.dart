import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:justcost/data/comment/model/comment.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final VoidCallback onReplayClick;
  final VoidCallback onReportClick;

  const CommentWidget(
      {Key key, this.comment, this.onReplayClick, this.onReportClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                child: Text('A'),
              ),
              const SizedBox(
                width: 4,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Name of Name'),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        children: <Widget>[
                          FlutterRatingBarIndicator(
                            rating: 3,
                            itemSize: 12,
                            emptyColor:
                                Theme.of(context).accentColor.withAlpha(40),
                            itemPadding: const EdgeInsets.all(0),
                          ),
                          Text('150 Ratings'),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    '12 Feb, 2017',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ],
          ),
          Text(
              'Ever wish you could get the Cliff Notes for writing popular posts?'),
          Row(
            children: <Widget>[
              OutlineButton(onPressed: () {}, child: Text('Replay')),
              const SizedBox(
                width: 8,
              ),
              OutlineButton(onPressed: () {}, child: Text('Report')),
            ],
          ),
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ReplayWidget();
            },
            itemCount: 2,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 4,
              );
            },
          )
        ],
      ),
    );
  }
}

class ReplayWidget extends StatelessWidget {
  final Replay replay;

  const ReplayWidget({Key key, this.replay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            CircleAvatar(
              child: Text('A'),
            ),
            const SizedBox(
              width: 4,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Name of Name'),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  '12 Feb, 2017',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ],
        ),
        Text(
            'Ever wish you could get the Cliff Notes for writing popular posts?'),
      ],
    );
  }
}
