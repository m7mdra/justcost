import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:justcost/bloc/like_product_bloc.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/ad_details/ad_details_bloc.dart';
import 'package:justcost/screens/ad_details/attribute_bloc.dart';
import 'package:justcost/screens/ad_details/comment_bloc.dart';
import 'package:justcost/screens/ad_details/comment_replay_screen.dart';
import 'package:justcost/screens/ad_details/post_comment_bloc.dart';
import 'package:justcost/screens/ad_details/product_comments.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/widget/comment_widget.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/icon_text.dart';
import 'package:justcost/widget/network_error_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:share/share.dart';

class AdDetailsScreen extends StatefulWidget {
  final Product product;

  const AdDetailsScreen({Key key, this.product}) : super(key: key);

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  Product product;
  AdDetailsBloc _bloc;
  CommentsBloc _commentsBloc;
  PostCommentBloc _postCommentBloc;
  TextEditingController _commentTextEditingController;
  LikeProductBloc _likeProductBloc;
  AttributesBloc _attributesBloc;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    product = widget.product;
    _commentTextEditingController = TextEditingController();
    _bloc = AdDetailsBloc(DependenciesProvider.provide());
    _commentsBloc = CommentsBloc(DependenciesProvider.provide());
    _likeProductBloc = LikeProductBloc(
        DependenciesProvider.provide(), DependenciesProvider.provide());
    _postCommentBloc = PostCommentBloc(
        DependenciesProvider.provide(), DependenciesProvider.provide());
    _attributesBloc = AttributesBloc(DependenciesProvider.provide());
    _commentsBloc.dispatch(LoadComments(product.productId));
    _bloc.dispatch(LoadEvent(product.productId));
    _postCommentBloc.dispatch(CheckIfUserIsGoat());
    _likeProductBloc.dispatch(CheckLikeEvent(product.productId));
    _attributesBloc.dispatch(LoadProductAttribute(product.productId));
    _postCommentBloc.state.listen((state) {
      if (state is PostCommentSuccess) {
        _commentTextEditingController.clear();
        _commentsBloc.dispatch(LoadComments(product.productId));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _commentsBloc.dispose();
    _likeProductBloc.dispose();
    _postCommentBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: product.media.isEmpty ? 30 : 200,
                child: Swiper(
                  autoplay: true,
                  duration: 500,
                  itemCount: product.media.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      product.media[index].url,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              BackButton(
                color: Colors.black,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconText(
                onPressed: () {},
                icon: Icon(Icons.flag),
                text: Text(AppLocalizations.of(context).reportButton),
              ),
              BlocBuilder(
                bloc: _likeProductBloc,
                builder: (BuildContext context, LikeState state) {
                  print(state);
                  if (state is LikeLoading || state is LikeIdle)
                    return IconText(
                        icon: Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                        ),
                        text: Text(AppLocalizations.of(context).saveButton),
                        onPressed: null);
                  if (state is LikeLoaded) return likeWidget(state.isLiked);
                  if (state is LikeToggled) return likeWidget(state.isLiked);
                  if (state is UserSessionExpired) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            LoginScreen(NavigationReason.session_expired)));
                    return IgnorePointer(
                      child: likeWidget(false),
                    );
                  }
                  if (state is GoatUserState)
                    return IconText(
                      onPressed: () {
                        scaffoldKey.currentState
                          ..hideCurrentSnackBar(
                              reason: SnackBarClosedReason.hide)
                          ..showSnackBar(SnackBar(
                              content: Text(AppLocalizations.of(context)
                                  .guestAccountMessage)));
                      },
                      icon: Icon(Icons.favorite_border),
                      text: Text(AppLocalizations.of(context).saveButton),
                    );
                  return IgnorePointer(
                    child: likeWidget(false),
                  );
                },
              ),
              IconText(
                onPressed: () async {
                  await Share.share('Checkout hot sales at Justcost');
                },
                icon: Icon(Icons.share),
                text: Text(AppLocalizations.of(context).shareButton),
              ),
            ],
          ),
          const Divider(
            height: 1,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    product.title,
                    style: Theme.of(context).textTheme.title,
                    maxLines: 2,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 4, bottom: 4),
                      color: Theme.of(context).accentColor,
                      child: Text(
                        AppLocalizations.of(context).discountPercentage(
                            ((product.regPrice - product.salePrice) /
                                    product.regPrice *
                                    100)
                                .round()),
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ),
                    Text(
                      '${product.salePrice} AED',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: Text(
              "${DateFormat.MMMMEEEEd().format(DateTime.fromMicrosecondsSinceEpoch(product.postedOn))}",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: Text(product.description),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: BlocBuilder(
              bloc: _attributesBloc,
              builder: (BuildContext context, AttributesState state) {
                if (state is AttributesLoading)
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                      strokeWidth: 2,
                    ),
                  );
                if (state is AttributesNetworkError)
                  return NetworkErrorWidget(
                    onRetry: () {
                      _attributesBloc
                          .dispatch(LoadProductAttribute(product.productId));
                    },
                  );
                if (state is AttributesError)
                  return GeneralErrorWidget(
                    onRetry: () {
                      _attributesBloc
                          .dispatch(LoadProductAttribute(product.productId));
                    },
                  );
                if (state is AttributesLoaded) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(state.attributes[index].group),
                          Text(state.attributes[index].val),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 2,
                      );
                    },
                    itemCount: state.attributes.length,
                  );
                }
                return Container();
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconText(
                  icon: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  text: Text(product.customerName),
                ),
                Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        var url = 'tel:+${product.mobile}';
                        if (await canLaunch(url))
                          launch(url);
                        else
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: SnackBar(
                                  content: Text(AppLocalizations.of(context)
                                      .phoneNumberNotAvaliable))));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: IconText(
                          icon: Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 15,
                          ),
                          text: Text(
                            ' ${product.mobile} ',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () async {
                        var url = "geo:${product.location}";
                        if (product.location != null &&
                            product.location.isNotEmpty &&
                            await canLaunch(url))
                          await launch(url);
                        else
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(AppLocalizations.of(context)
                                  .locationNotAvaliable)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: IconText(
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 15,
                          ),
                          text: Text(
                            AppLocalizations.of(context).viewLocationButton,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: BlocBuilder(
              bloc: _postCommentBloc,
              builder: (BuildContext context, PostState state) {
                if (state is GoatUser) {
                  return Stack(
                    children: <Widget>[

                      IgnorePointer(
                        ignoring: true,
                        child: Opacity(
                          opacity: 0.3,
                          child: commentBox(),
                        ),
                      )
                    ],
                  );
                }
                if (state is NormalUser) return commentBox();
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
                return commentBox();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: BlocBuilder(
              bloc: _commentsBloc,
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
                      _commentsBloc.dispatch(LoadComments(product.productId));
                    },
                  );
                if (state is CommentsNetworkError)
                  return NetworkErrorWidget(
                    onRetry: () {
                      _commentsBloc.dispatch(LoadComments(product.productId));
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
                  print(
                      "Should 'show more comments button?' ${state.comments.length < 4 ? state.comments.length : 4 == 4}");
                  return Column(
                    children: <Widget>[
                      ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          return CommentWidget(
                            showReplayButton: true,
                            key: ValueKey(state.comments[index].commentId),
                            comment: state.comments[index],
                            onReplayClick: (comment) async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                        child: CommentReplayScreen(
                                          comment: comment,
                                          product: product,
                                        ),
                                        value: _commentsBloc,
                                      )));
                            },
                          );
                        },
                        itemCount: state.comments.length < 4
                            ? state.comments.length
                            : 4,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 1,
                          );
                        },
                      ),
                      state.comments.length > 4
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              child: OutlineButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider.value(
                                                value: _commentsBloc,
                                                child: ProductComments(
                                                  comments: state.comments,
                                                  product: product,
                                                ),
                                              )));
                                },
                                child: Text(AppLocalizations.of(context)
                                    .showAllCommentButton),
                              ),
                            )
                          : Container()
                    ],
                  );
                }
                return Container();
              },
            ),
          )
        ],
      )),
    );
  }

  IconText likeWidget(bool isLiked) {
    return IconText(
      onPressed: () {
        _likeProductBloc.dispatch(ToggleLike(product.productId));
      },
      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
      text: Text(AppLocalizations.of(context).saveButton),
    );
  }

  Widget commentBox() {
    return Column(
      children: <Widget>[
        Text(AppLocalizations.of(context).writeComment),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: 3,
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
              _postCommentBloc.dispatch(PostComment(product.productId, null,
                  _commentTextEditingController.text.trim()));
            },
            child: Text(AppLocalizations.of(context).postButton),
          ),
        ),
      ],
    );
  }
}
