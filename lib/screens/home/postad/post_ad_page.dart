import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justcost/screens/home/postad/category_picker_screen.dart';
import 'package:justcost/screens/home/postad/location_pick_screen.dart';
import 'package:justcost/screens/home/postad/place_picker_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/widget/ad_image_view.dart';
import 'package:justcost/widget/ad_video_view.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

class PostAdPage extends StatefulWidget {
  @override
  _PostAdPageState createState() => _PostAdPageState();
}

class _PostAdPageState extends State<PostAdPage>
    with AutomaticKeepAliveClientMixin<PostAdPage> {
  List<Media> mediaList = List<Media>();
  TextEditingController _adTitleController;
  TextEditingController _adKeywordController;
  TextEditingController _adOldPriceController;
  TextEditingController _adNewPriceController;
  TextEditingController _adPhoneNumberController;
  TextEditingController _adEmailController;
  TextEditingController _adDetailsController;
  String adCity;
  LatLng location;
  FocusNode _adKeywordFocusNode = FocusNode();
  FocusNode _adOldPriceFocusNode = FocusNode();
  FocusNode _adNewPriceFocusNode = FocusNode();
  FocusNode _adPhoneNumberFocusNode = FocusNode();
  FocusNode _adEmailFocusNode = FocusNode();
  FocusNode _adDetailsFocusNode = FocusNode();
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    regex = new RegExp(pattern);
    _adTitleController = TextEditingController();
    _adKeywordController = TextEditingController();
    _adOldPriceController = TextEditingController();
    _adNewPriceController = TextEditingController();
    _adPhoneNumberController = TextEditingController();
    _adEmailController = TextEditingController();
    _adDetailsController = TextEditingController();
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
    var hintStyle =
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
        const Divider(),
        ListTile(
          dense: true,
          title: Text('Where do you want to sell'),
          subtitle: Text(adCity == null ? "" : adCity),
          trailing: IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: _onPlacePickerClicked),
        ),
        const Divider(),
        ListTile(
          dense: true,
          trailing: IconButton(
              icon: Icon(Icons.place), onPressed: _onLocationPickerClicked),
          title: Text('Location'),
          subtitle: location != null
              ? Text("Location Selected.",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold))
              : Container(),
        ),
        divider(),
        ListTile(
          dense: true,
          title: Text(
            'Select Category',
          ),
          trailing: IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            onPressed: _onCategoryPickerClicked,
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
    adCity = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PlacePickerScreen()));
    setState(() {});
  }

  Future _onLocationPickerClicked() async {
    location = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LocationPickerScreen()));
    setState(() {});
  }

  Future _onCategoryPickerClicked() async {
    // ignore: unused_local_variable
    var category = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CategoryPickerScreen()));
  }

  validateEntries() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState.validate()) {
      return;
    } else {
      Future.delayed(Duration(seconds: 2))
          .then((_) => _formKey.currentState.reset());
    }
  }
}
