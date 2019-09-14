import 'package:flutter/material.dart';
import 'package:justcost/data/comment/model/comment.dart';
import 'package:justcost/i10n/app_localizations.dart';

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final bool showReplayButton;
  final ValueChanged<Comment> onReplayClick;
  final ValueChanged<Comment> onReportClick;

  const CommentWidget(
      {Key key,
      this.comment,
      this.onReplayClick,
      this.onReportClick,
      this.showReplayButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              comment.commentPic == null
                  ? Image.asset(
                      'assets/images/default-avatar.png',
                      width: 50,
                      height: 50,
                    )
                  : Image.network(
                      comment.commentPic,
                      width: 50,
                      height: 50,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        comment.customerName,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                  Text(
                    comment.postedOn,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width - 120,
                    child: Text(
                      comment.comment,
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.visible,
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ],
          ),
          showReplayButton
              ? OutlineButton(
                  onPressed: () {
                    onReplayClick(comment);
                  },
                  child: Text(AppLocalizations.of(context).replayButton))
              : Container(height: 8,),
          const SizedBox(
            width: 8,
          ),
          ListView.separated(
            primary: false,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ReplayWidget(
                replay: comment.replies[index],
                key: ValueKey(comment.replies[index].commentId),
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
            replay.commentPic == null
                ? Image.asset(
                    'assets/images/default-avatar.png',
                    width: 50,
                    height: 50,
                  )
                : Image.network(
                    replay.commentPic,
                    width: 50,
                    height: 50,
                  ),
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
                Container(
                  width: MediaQuery.of(context).size.width - 150,
                  child: Text(
                    replay.comment,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.visible,
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
