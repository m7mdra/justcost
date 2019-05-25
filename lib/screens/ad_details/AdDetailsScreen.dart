import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justcost/data/product/model/product.dart';
import 'package:justcost/screens/ad_details/ad_details_bloc.dart';
import 'package:justcost/screens/ad_details/comment_bloc.dart';
import 'package:justcost/widget/general_error.dart';
import 'package:justcost/widget/icon_text.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:justcost/widget/network_error_widget.dart';

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

  @override
  void initState() {
    super.initState();
    product = widget.product;
    _bloc = AdDetailsBloc(DependenciesProvider.provide());
    _commentsBloc = CommentsBloc(DependenciesProvider.provide());
    _commentsBloc.dispatch(LoadComments(product.productId));
    _bloc.dispatch(LoadEvent(product.productId));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _commentsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: product.media.isEmpty ? 30 : 200,
                child: Swiper(
                  itemCount: product.media.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      product.media[index],
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
                text: Text('Report'),
              ),
              IconText(
                onPressed: () {},
                icon: Icon(Icons.favorite),
                text: Text('Save'),
              ),
              IconText(
                onPressed: () {},
                icon: Icon(Icons.share),
                text: Text('Share'),
              ),
            ],
          ),
          const Divider(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Mobile & Tabs',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 16,
                    color: Colors.grey,
                  ),
                  Text(
                    'Mobile',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 16,
                    color: Colors.grey,
                  ),
                  Text(
                    'OPPO',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Text(product.postedOn)
            ],
          ),
          Row(
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
                      '${((product.regPrice - product.salePrice) / product.regPrice * 100).round()}% OFF',
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
          Text(product.description),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Model'),
              Text('Find X'),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Brand'),
              Text('OPPO'),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Condition'),
              Text('NEW'),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Usage'),
              Text('Never used'),
            ],
          ),
          const Divider(),
          Row(
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
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconText(
                      icon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      text: Text(
                        ' ${product.mobile} ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: IconText(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      text: Text(
                        ' View Location',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Text('Write a comment'),
          TextField(
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  borderSide: BorderSide(color: Colors.grey, width: 0.1)),
            ),
          ),
          FlutterRatingBar(
            initialRating: 0,
            fillColor: Theme.of(context).accentColor,
            borderColor: Theme.of(context).accentColor.withAlpha(60),
            allowHalfRating: true,
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: OutlineButton(
              onPressed: () {},
              child: Text('POST'),
            ),
          ),
          BlocBuilder(
            bloc: _commentsBloc,
            builder: (BuildContext context, CommentsState state) {
              if (state is CommentsLoading)
                return Center(
                  child: CircularProgressIndicator(),
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
                return Column(
                  children: <Widget>[
                    Icon(Icons.mode_comment),
                    Text('No Comments added, be the first to comment')
                  ],
                );
              if (state is CommentsLoaded)
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Row(
                      children: <Widget>[
                        CircleAvatar(
                          child: Text('U'),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(state.comments[index].customerName),
                            FlutterRatingBarIndicator(
                              fillColor: Theme.of(context).accentColor,
                              rating:
                                  state.comments[index].rate[0].rate.toDouble(),
                              itemSize: 15,
                              itemCount: 5,
                              emptyColor:
                                  Theme.of(context).accentColor.withAlpha(60),
                              itemPadding: const EdgeInsets.all(0),
                            ),
                            Text(state.comments[index].comment),
                            ListView.builder(
                              
                              itemBuilder: (context, index) {
                                return Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      child: Text('U'),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(state.comments[index]
                                            .replies[index].customerName),
                                        FlutterRatingBarIndicator(
                                          fillColor:
                                              Theme.of(context).accentColor,
                                          rating: state.comments[index]
                                              .replies[index].rate[0].rate
                                              .toDouble(),
                                          itemSize: 15,
                                          itemCount: 5,
                                          emptyColor: Theme.of(context)
                                              .accentColor
                                              .withAlpha(60),
                                          itemPadding: const EdgeInsets.all(0),
                                        ),
                                        Text(state.comments[index]
                                            .replies[index].comment),
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    )
                                  ],
                                );
                              },
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(16),
                              itemCount: state.comments[index].replies.length,
                            )
                          ],
                        )
                      ],
                    );
                  },
                  itemCount: state.comments.length,
                );
            },
          )
        ],
      )),
    );
  }
}
