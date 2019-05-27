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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                child: comment.commentPic == null
                    ? Image.asset('assets/images/default-avatar.png')
                    : Image.network(comment.commentPic),
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
                      Text(comment.customerName),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        children: <Widget>[
                          FlutterRatingBarIndicator(
                            rating: comment.rate[0].rate.toDouble(),
                            itemSize: 12,
                            emptyColor:
                                Theme.of(context).accentColor.withAlpha(40),
                            itemPadding: const EdgeInsets.all(0),
                          ),
                          Text('${comment.rate[0].ratings} Ratings'),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    comment.postedOn,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ],
          ),
          Text(comment.comment),
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
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ReplayWidget(
                replay: comment.replies[index],
              );
            },
            itemCount: comment.replies.length,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            CircleAvatar(
                child: replay.commentPic == null
                    ? Image.asset('assets/images/default-avatar.png')
                    : Image.network(replay.commentPic)),
            const SizedBox(
              width: 4,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(replay.customerName),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  replay.postedOn,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ],
        ),
        Text(replay.comment),
      ],
    );
  }
}
