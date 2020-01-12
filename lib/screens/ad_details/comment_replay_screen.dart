import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/comment/model/comment.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/ad_details/comment_bloc.dart';
import 'package:justcost/screens/ad_details/post_comment_bloc.dart';
import 'package:justcost/widget/comment_widget.dart';
import 'package:justcost/i10n/app_localizations.dart';

class CommentReplayScreen extends StatefulWidget {
  final Comment comment;
  final Product product;

  const CommentReplayScreen({Key key, this.comment, this.product})
      : super(key: key);

  @override
  _CommentReplayScreenState createState() => _CommentReplayScreenState();
}

class _CommentReplayScreenState extends State<CommentReplayScreen> {
  FocusNode _formNode;
  PostCommentBloc _bloc;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  TextEditingController _commentTextEditingController;

  @override
  void initState() {
    super.initState();
    _formNode = FocusNode();
    _commentTextEditingController = TextEditingController();
    _bloc = PostCommentBloc(DependenciesProvider.provide(),DependenciesProvider.provide());
    _bloc.add(CheckIfUserIsGoat());

//    _bloc.state.listen((state) {
//      if (state is PostCommentSuccess) {
//        _commentTextEditingController.clear();
//        BlocProvider.of<CommentsBloc>(context)
//            .add(LoadComments(widget.product.productId));
//        Navigator.of(context).pop();
//      }
//    });
  }

  @override
  void close() {
    super.dispose();
    _commentTextEditingController.dispose();
    _formNode.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Replay'),),
      key: _globalKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              CommentWidget(
                key: ValueKey(widget.comment.commentId),
                showReplayButton: false,
                comment: widget.comment,
                onReplayClick: (comment) {
                  FocusScope.of(context).requestFocus(_formNode);
                },
              ),
              BlocBuilder(
                bloc: _bloc,
                builder: (BuildContext context, PostState state) {
                  if (state is PostCommentLoading)
                    return IgnorePointer(
                      ignoring: true,
                      child: Opacity(
                        opacity: 0.3,
                        child: commentBox(),
                      ),
                    );
                  if (state is PostCommentFailed)
                    return Column(
                      children: <Widget>[
                        commentBox(),
                        Text(
                          AppLocalizations.of(context).failedToPostComment,
                          style: TextStyle(color: Theme.of(context).errorColor),
                        )
                      ],
                    );
                  if(state is GoatUser)
                    return IgnorePointer(
                      ignoring: true,
                      child: Opacity(
                        opacity: 0.3,
                        child: commentBox(),
                      ),
                    );
                  return commentBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commentBox() {
    return Column(
      children: <Widget>[
        Text(AppLocalizations.of(context).writeComment),
        TextField(
          keyboardType: TextInputType.multiline,
          controller: _commentTextEditingController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                borderSide: BorderSide(color: Colors.grey, width: 0.1)),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: OutlineButton(
            onPressed: () {
              _bloc.add(PostComment(
                  widget.product.productId,
                  widget.comment.commentId,
                  _commentTextEditingController.text.trim()));
            },
            child: Text(AppLocalizations.of(context).postButton),
          ),
        ),
      ],
    );
  }
}
