import 'package:flutter/material.dart';
import 'package:justcost/screens/home/location_pick_screen.dart';
import 'package:justcost/screens/home/place_picker_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justcost/model/media.dart';
import 'package:justcost/widget/ad_image_view.dart';
import 'package:justcost/widget/ad_video_view.dart';

class PostAdPage extends StatefulWidget {
  @override
  _PostAdPageState createState() => _PostAdPageState();
}

class _PostAdPageState extends State<PostAdPage>
    with AutomaticKeepAliveClientMixin<PostAdPage> {
  List<Media> mediaList = List<Media>();
  bool isVideo;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    var hintStyle =
        Theme.of(context).textTheme.body1.copyWith(color: Colors.grey);
    return ListView(
      children: <Widget>[
        Column(children: <Widget>[
          Container(
            margin: EdgeInsets.all(4),
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
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Text(
            'Max media uploading is 10 for videos and photos',
            style: TextStyle(color: Colors.orange),
          ),
        ),
        const Divider(),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.only(left: 16, right: 16),
          title: Text('Where do you want to sell'),
          trailing: IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: _onPlacePickerPicked),
        ),
        const Divider(),
        ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            trailing: IconButton(
                icon: Icon(Icons.place), onPressed: _onLocationPickerPicked),
            title: Text('Location')),
        const Divider(),
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.only(left: 16, right: 16),
          title: Text('Select Category'),
          trailing: IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            onPressed: null,
          ),
        ),
        const Divider(),
        ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            title: TextField(
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                  hintText: 'Add Title for your ad', hintStyle: hintStyle),
            )),
        const Divider(),
        ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 16, right: 16),

            title: TextField(
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                  hintText: 'Keyword', hintStyle: hintStyle),
            )),
        const Divider(),
        ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            title: TextField(
              keyboardType: TextInputType.phone,
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                  hintText: 'Old price', hintStyle: hintStyle),
            )),
        const Divider(),
        ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            title: TextField(
              maxLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration.collapsed(
                  hintText: 'New price', hintStyle: hintStyle),
            )),
        const Divider(),
        ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            title: TextField(
              maxLines: 1,
              keyboardType: TextInputType.phone,

              decoration: InputDecoration.collapsed(
                  hintText: 'Phone Number', hintStyle: hintStyle),
            )),
        const Divider(),
        ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            title: TextField(
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                  hintText: 'E-mail Address', hintStyle: hintStyle),
            )),
        const Divider(),
        ListTile(
            dense: true,
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            title: TextField(
              keyboardType: TextInputType.emailAddress,
              maxLines: 5,
              decoration: InputDecoration.collapsed(
                  hintText: 'more details about the Ad', hintStyle: hintStyle),
            )),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RaisedButton(
            onPressed: () {},
            child: Text('Submit Ad'),
          ),
        )
      ],
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
                  padding: const EdgeInsets.all(2),
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
                  padding: const EdgeInsets.all(2),
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

  Future _onPlacePickerPicked() async {
    var place = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PlacePickerScreen()));
  }

  Future _onLocationPickerPicked() async {
    var location = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LocationPicker()));
  }

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
              borderRadius: BorderRadius.circular(16)),
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
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
}
