import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justcost/data/brand/model/brand.dart';
import 'package:justcost/data/category/model/category.dart';
import 'package:justcost/data/city/model/city.dart';
import 'package:justcost/data/city/model/country.dart';
import 'package:justcost/data/product/model/post_ad.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/screens/brand/brand_page.dart';
import 'package:justcost/screens/city/city_picker_screen.dart';
import 'package:justcost/screens/postad/category_picker_screen.dart';
import 'package:justcost/screens/postad/location_pick_screen.dart';
import 'package:justcost/screens/postad/post_ad_bloc.dart';
import 'package:justcost/util/tuple.dart';
import 'package:justcost/widget/ad_image_view.dart';
import 'package:justcost/widget/ad_video_view.dart';
import 'package:justcost/widget/guest_user_widget.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

class PostAdPage extends StatefulWidget {
  @override
  _PostAdPageState createState() => _PostAdPageState();
}

class _PostAdPageState extends State<PostAdPage> {
  List<Media> mediaList = List<Media>();
  TextEditingController _adTitleController;
  TextEditingController _adKeywordController;
  TextEditingController _adOldPriceController;
  TextEditingController _adNewPriceController;
  TextEditingController _adPhoneNumberController;
  TextEditingController _adEmailController;
  TextEditingController _adDetailsController;
  LatLng location;
  City city;
  PostAdBloc _bloc;
  FocusNode _adKeywordFocusNode = FocusNode();
  FocusNode _adOldPriceFocusNode = FocusNode();
  FocusNode _adNewPriceFocusNode = FocusNode();
  FocusNode _adPhoneNumberFocusNode = FocusNode();
  FocusNode _adEmailFocusNode = FocusNode();
  FocusNode _adDetailsFocusNode = FocusNode();
  Pattern _pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Category _category;
  Category _parentCategory;
  Brand _brand;

  @override
  void initState() {
    super.initState();
    regex = new RegExp(_pattern);
    _bloc = PostAdBloc(
        DependenciesProvider.provide(), DependenciesProvider.provide());
    _bloc.dispatch(CheckIfUserIsNotAGoat());
    _adTitleController = TextEditingController();
    _adKeywordController = TextEditingController();
    _adOldPriceController = TextEditingController();
    _adNewPriceController = TextEditingController();
    _adPhoneNumberController = TextEditingController();
    _adEmailController = TextEditingController();
    _adDetailsController = TextEditingController();
    _bloc.state.listen((state) {
      //TODO refactor code.
      if (state is PostAdFailed) {
        showDialog(
            context: context,
            builder: (context) => RoundedAlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to post ad, try again'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      }
      if (state is PostAdError) {
        showDialog(
            context: context,
            builder: (context) => RoundedAlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to post ad, try again'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      }
      if (state is PostAdNetworkError) {
        showDialog(
            context: context,
            builder: (context) => RoundedAlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to post ad, try again'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _adTitleController.dispose();
    _adKeywordController.dispose();
    _adOldPriceController.dispose();
    _adNewPriceController.dispose();
    _adPhoneNumberController.dispose();
    _adEmailController.dispose();
    _adDetailsController.dispose();
    _adKeywordFocusNode.dispose();
    _adOldPriceFocusNode.dispose();
    _adNewPriceFocusNode.dispose();
    _adPhoneNumberFocusNode.dispose();
    _adEmailFocusNode.dispose();
    _adDetailsFocusNode.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post An Ad'),
      ),
      key: _scaffoldKey,
      body: SafeArea(
        child: BlocBuilder(
          bloc: _bloc,
          builder: (BuildContext context, PostAdStatus state) {
            print(state);
            if (state is GoatUser)
              return Stack(
                children: <Widget>[
                  Opacity(
                    opacity: 0.2,
                    child: IgnorePointer(
                      child: postAdForm(),
                      ignoring: true,
                    ),
                  ),
                  Container(
                    child: buildGuestUserWidget(),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ],
              );
            if (state is PostAdLoading) return buildLoadingWidget();
            if (state is PostAdSuccess) return buildSuccessWidget(context);

            return postAdForm();
          },
        ),
      ),
    );
  }

  Padding buildGuestUserWidget() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GuestUserWidget(),
    );
  }

  Center buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CircularProgressIndicator(),
          Text('Please wait while trying to post your ad...')
        ],
      ),
    );
  }

  Center buildSuccessWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 60,
            ),
            Text(
              'Ad Submited Successfully',
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'your Ad is under approval, you will be notified once the AD is approved.',
              textAlign: TextAlign.center,
            ),
            OutlineButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Continue'),
            )
          ],
        ),
      ),
    );
  }

  Widget postAdForm() {
    final hintStyle =
        Theme.of(context).textTheme.body1.copyWith(color: Colors.grey);
    return ListView(
      children: <Widget>[
        Column(children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                _imagePicker(),
                Expanded(child: buildListView())
              ],
            ),
          ),
        ]),
        const Padding(
          padding:
              const EdgeInsets.only(left: 16.0, right: 16, bottom: 0, top: 0),
          child: Text(
            'Max media uploading is 4 for videos and photos',
            style: TextStyle(color: Colors.orange),
          ),
        ),
        divider(),
        ListTile(
          dense: true,
          title: Text('Where do you want to sell'),
          subtitle: Text(city == null ? '' : city.name),
          trailing: IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: _onPlacePickerClicked),
        ),
        divider(),
        ListTile(
          dense: true,
          trailing: IconButton(
              icon: Icon(Icons.place), onPressed: _onLocationPickerClicked),
          title: Text('Location'),
          subtitle: Text(location != null ? "Location Selected." : '',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ),
        divider(),
        ListTile(
          dense: true,
          title: Text(
            'Select Category',
          ),
          subtitle: Text(_category != null ? _category.name : ''),
          trailing: IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            onPressed: _onCategoryPickerClicked,
          ),
        ),
        divider(),
        ListTile(
          dense: true,
          title: Text(
            'Select Brand',
          ),
          subtitle: Text(_brand != null ? _brand.name : ''),
          trailing: IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            onPressed: _onBrandPickerClicked,
          ),
        ),
        divider(),
        Form(
          key: _formKey,
          child: buildInputFields(hintStyle),
        ),
        divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RaisedButton(
            onPressed: () => validateEntries(),
            child: Text('Submit Ad'),
          ),
        )
      ],
    );
  }

  Column buildInputFields(TextStyle hintStyle) {
    return Column(
      children: <Widget>[
        TextFormField(
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_adKeywordFocusNode);
          },
          validator: (title) {
            return title.isEmpty ? "Title Can not be Empty" : null;
          },
          maxLines: 1,
          controller: _adTitleController,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 10),
              hintText: 'Add Title for your ad',
              labelText: 'Ad Title',
              errorBorder: InputBorder.none,
              hintStyle: hintStyle),
        ),
        divider(),
        TextFormField(
          focusNode: _adKeywordFocusNode,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_adOldPriceFocusNode);
          },
          validator: (keyword) {
            return keyword.isEmpty ? "Keyword Can not be Empty" : null;
          },
          maxLines: 1,
          controller: _adKeywordController,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 10),
              border: InputBorder.none,
              hintText: 'Keyword to make your ad easier to find',
              labelText: 'Keyword',
              hintStyle: hintStyle),
        ),
        divider(),
        TextFormField(
          focusNode: _adOldPriceFocusNode,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_adNewPriceFocusNode);
          },
          validator: (oldPrice) {
            return oldPrice.isEmpty ? "old Price Can not be Empty" : null;
          },
          controller: _adOldPriceController,
          keyboardType: TextInputType.phone,
          maxLines: 1,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 10),
              hintText: 'Old Price Of your Product',
              suffixText: 'AED',
              labelText: 'Old Price',
              hintStyle: hintStyle),
        ),
        divider(),
        TextFormField(
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_adPhoneNumberFocusNode);
          },
          validator: (newPrice) {
            return newPrice.isEmpty ? "New Price Can not be Empty" : null;
          },
          focusNode: _adNewPriceFocusNode,
          maxLines: 1,
          controller: _adNewPriceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 10),
              hintText: 'New price of the Product',
              labelText: 'New Price',
              suffixText: 'AED',
              hintStyle: hintStyle),
        ),
        divider(),
        TextFormField(
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_adEmailFocusNode);
          },
          validator: (phoneNumber) {
            return phoneNumber.isEmpty ? "Phone Number Can not be Empty" : null;
          },
          maxLines: 1,
          focusNode: _adPhoneNumberFocusNode,
          controller: _adPhoneNumberController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 10),
              labelText: 'Phone Number',
              hintText: 'Contact Phone Number',
              hintStyle: hintStyle),
        ),
        divider(),
        TextFormField(
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(_adDetailsFocusNode);
          },
          validator: (mail) {
            if (mail.isEmpty)
              return "Email Field can not be empty";
            else if (!regex.hasMatch(mail))
              return "Invalid email address";
            else
              return null;
          },
          controller: _adEmailController,
          maxLines: 1,
          focusNode: _adEmailFocusNode,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 10),
              labelText: 'E-mail Address',
              hintText: 'Contact Email Address',
              hintStyle: hintStyle),
        ),
        divider(),
        TextFormField(
          focusNode: _adDetailsFocusNode,
          controller: _adDetailsController,
          keyboardType: TextInputType.text,
          onEditingComplete: () => validateEntries(),
          maxLines: 5,
          maxLength: 250,
          validator: (text) {
            if (text.isEmpty)
              return "Details field can not be empty";
            else if (text.length < 100)
              return "Details must be more than 100 character";
          },
          maxLengthEnforced: true,
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 10),
              hintText: 'more details about the Ad',
              labelText: 'Ad Details',
              alignLabelWithHint: true,
              hintStyle: hintStyle),
        )
      ],
    );
  }

  Divider divider() {
    return const Divider(
      height: 1,
      indent: 1,
    );
  }

  ListView buildListView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: mediaList.length,
      itemBuilder: (BuildContext context, int index) {
        var media = mediaList[index];
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: media.type == Type.Image
              ? Padding(
                  padding: const EdgeInsets.all(3),
                  child: AdImageView(
                    file: media.file,
                    size: Size(100, 100),
                    key: ObjectKey('object$index'),
                    onRemove: () {
                      setState(() {
                        mediaList.removeAt(index);
                      });
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(3),
                  child: AdVideoView(
                    key: ObjectKey('object$index'),
                    file: media.file,
                    size: Size(100, 100),
                    onRemove: () {
                      setState(() {
                        mediaList.removeAt(index);
                      });
                    },
                  ),
                ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _imagePicker() {
    return InkWell(
        child: Container(
          height: 90,
          width: 90,
          alignment: Alignment.center,
          child: Icon(
            Icons.photo_camera,
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(8)),
        ),
        onTap: () {
          if (mediaList.length == 4) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Max media upload is 4'),
              duration: Duration(seconds: 1),
            ));
          } else
            showDialog(
                context: context,
                builder: (context) {
                  return RoundedAlertDialog(
                    title: Text('Select Media to add to the uploads'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text('Capture Image'),
                          leading: Icon(Icons.camera_alt),
                          dense: true,
                          onTap: () async {
                            Navigator.pop(context);
                            var image = await ImagePicker.pickImage(
                                source: ImageSource.camera);
                            if (image != null)
                              setState(() {
                                mediaList
                                    .add(Media(file: image, type: Type.Image));
                              });
                          },
                        ),
                        ListTile(
                          title: Text('Pick Image from gallery'),
                          leading: Icon(Icons.image),
                          dense: true,
                          onTap: () async {
                            Navigator.pop(context);
                            var image = await ImagePicker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null)
                              setState(() {
                                mediaList
                                    .add(Media(file: image, type: Type.Image));
                              });
                          },
                        ),
                        ListTile(
                          title: Text('Capture Video'),
                          leading: Icon(Icons.videocam),
                          dense: true,
                          onTap: () async {
                            Navigator.pop(context);
                            var video = await ImagePicker.pickVideo(
                                source: ImageSource.camera);
                            if (video != null)
                              setState(() {
                                mediaList
                                    .add(Media(file: video, type: Type.Video));
                              });
                          },
                        ),
                        ListTile(
                          title: Text('Pick Video from gallery'),
                          leading: Icon(Icons.video_library),
                          dense: true,
                          onTap: () async {
                            Navigator.pop(context);
                            var video = await ImagePicker.pickVideo(
                                source: ImageSource.gallery);
                            if (video != null)
                              setState(() {
                                mediaList
                                    .add(Media(file: video, type: Type.Video));
                              });
                          },
                        ),
                      ],
                    ),
                  );
                });
        });
  }

  Future _onPlacePickerClicked() async {
    City city = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CityPickerScreen()));
    setState(() {
      this.city = city;
    });
  }

  Future _onLocationPickerClicked() async {
    var location = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LocationPickerScreen()));
    setState(() {
      this.location = location;
    });
  }

  Future _onCategoryPickerClicked() async {
    Tuple2 category = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CategoryPickerScreen()));
    setState(() {
      _parentCategory = category.item1;

      if (category.item2 == null)
        this._category = category.item1;
      else
        this._category = category.item2;
    });
  }

  _onBrandPickerClicked() async {
    if (_category == null)
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('select Category first')));
    else {
      Brand brand = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BrandPage(
                categoryId: _parentCategory.id,
              )));
      setState(() {
        this._brand = brand;
      });
    }
  }

  validateEntries() {
    FocusScope.of(context).requestFocus(FocusNode());
    var adTitle = _adTitleController.text.trim();
    var adKeyword = _adKeywordController.text.trim();
    var adOldPrice = _adOldPriceController.text.trim();
    var adNewPrice = _adNewPriceController.text.trim();
    var adPhoneNumber = _adPhoneNumberController.text.trim();
    var adEmail = _adEmailController.text.trim();
    var adDescription = _adDetailsController.text.trim();

    if (adTitle.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Title field is required.')));
      return;
    }
    if (adEmail.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Email field is required.')));
      return;
    }
    if (!regex.hasMatch(adEmail)) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Email field is invalid.')));
      return;
    }
    if (adKeyword.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Keyword field is required.')));
      return;
    }
    if (adOldPrice == null || adOldPrice.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('old price field is required.')));
      return;
    }
    if (adNewPrice == null || adNewPrice.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('new price field is required.')));
      return;
    }
    if (double.parse(adNewPrice) >= double.parse(adOldPrice)) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content:
              Text('New price must be lower and not equal to the old price.')));
      return;
    }
    if (adPhoneNumber.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Phone number field is required.')));
      return;
    }

    if (adDescription.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Description field is required.')));
      return;
    }
    if (mediaList.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Media is empty, add atleast one image or video')));
      return;
    }
    if (city == null) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Select the place of the ad')));
      return;
    }
    if (location == null) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Select the location of the ad')));
      return;
    }
    if (_category == null) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Select the category of the ad')));
      return;
    }
    _bloc.dispatch(SubmitAd(PostAd(
      media: mediaList.map((f) => f.file).toList(),
      image: mediaList[0].file,
      category: _category,
      regularPrice: double.parse(adOldPrice),
      salePrice: double.parse(adNewPrice),
      isPaid: 0,
      keyword: adKeyword,
      isWholeSale: 0,
      status: 1,
      title: adTitle,
      city: city,
      lat: location.latitude,
      lng: location.longitude,
      description: adDescription,
      brandId: _brand.id,
    )));
  }
}
