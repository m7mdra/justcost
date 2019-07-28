import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/comment/model/comment.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/ad_details/comment_bloc.dart';
import 'package:justcost/screens/ad_details/comment_replay_screen.dart';
import 'package:justcost/widget/comment_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/network_error_widget.dart';

class ProductComments extends StatefulWidget {
  final List<Comment> comments;
  final Product product;

  const ProductComments({Key key, this.comments, this.product})
      : super(key: key);

  @override
  _ProductCommentsState createState() => _ProductCommentsState();
}

class _ProductCommentsState extends State<ProductComments> {
  CommentsBloc _bloc;
  Product product;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: SafeArea(
        child: BlocBuilder(
          bloc: _bloc,
          builder: (BuildContext context, CommentsState state) {
            if (state is CommentsLoading)
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            if (state is CommentsError)
              return GeneralErrorWidget(
                onRetry: () {
                  _bloc.dispatch(LoadComments(product.productId));
                },
              );
            if (state is CommentsNetworkError)
              return NetworkErrorWidget(
                onRetry: () {
                  _bloc.dispatch(LoadComments(product.productId));
                },
              );
            if (state is NoComments)
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.add_comment,
                      size: 60,
                    ),
                    Text(AppLocalizations.of(context).noCommentFound)
                  ],
                ),
              );
            if (state is CommentsLoaded) {

              return ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return CommentWidget(
                    showReplayButton: true,
                    comment: state.comments[index],
                    onReplayClick: (comment) async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                                child: CommentReplayScreen(
                                  comment: comment,
                                  product: product,
                                ),
                                value: _bloc,
                              )));
                    },
                  );
                },
                itemCount:
                    state.comments.length  ,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 1,
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
