import 'package:flutter/material.dart';
import 'package:justcost/screens/home/location_pick_screen.dart';
import 'package:justcost/screens/home/place_picker_screen.dart';
import 'package:image_picker/image_picker.dart';

class PostAdPage extends StatefulWidget {
  @override
  _PostAdPageState createState() => _PostAdPageState();
}

class _PostAdPageState extends State<PostAdPage> with AutomaticKeepAliveClientMixin<PostAdPage> {
  Widget build(BuildContext context) {
    var hintStyle =
        Theme.of(context).textTheme.body1.copyWith(color: Colors.grey);
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8),
          height: 70,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              InkWell(
                  child: Container(
                    height: 70,
                    width: 70,
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
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
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
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  }),
              const SizedBox(
                width: 4,
              ),
              Container(
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
                width: 70,
              ),
              const SizedBox(
                width: 4,
              ),
              Container(
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
                width: 70,
              ),
              const SizedBox(
                width: 4,
              ),
              Container(
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
                width: 70,
              ),
              const SizedBox(
                width: 4,
              ),
              Container(
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
                width: 70,
              ),
            ],
          ),
        ),
        const Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Text(
            'Max media uploading is 10 for videos and photos',
            style: TextStyle(color: Colors.orange),
          ),
        ),
        ListTile(
          dense: true,
          title: Text('Where do you want to sell'),
          trailing: IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: _onPlacePickerPicked),
        ),
        const Divider(),
        ListTile(
            dense: true,
            trailing: IconButton(
                icon: Icon(Icons.place), onPressed: _onLocationPickerPicked),
            title: Text('Location')),
        const Divider(),
        ListTile(
          dense: true,
          title: Text('Select Category'),
          trailing: IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            onPressed: null,
          ),
        ),
        const Divider(),
        ListTile(
            dense: true,
            title: TextField(
              decoration: InputDecoration.collapsed(
                  hintText: 'Add Title for your ad', hintStyle: hintStyle),
            )),
        const Divider(),
        ListTile(
            dense: true,
            title: TextField(
              decoration: InputDecoration.collapsed(
                  hintText: 'Old price', hintStyle: hintStyle),
            )),
        const Divider(),
        ListTile(
            dense: true,
            title: TextField(
              decoration: InputDecoration.collapsed(
                  hintText: 'New price', hintStyle: hintStyle),
            )),
        const Divider(),
        ListTile(
            dense: true,
            title: TextField(
              decoration: InputDecoration.collapsed(
                  hintText: 'Phone Number', hintStyle: hintStyle),
            )),
        const Divider(),
        ListTile(
            dense: true,
            title: TextField(
              decoration: InputDecoration.collapsed(
                  hintText: 'E-mail Address', hintStyle: hintStyle),
            )),
        const Divider(),
        ListTile(
            dense: true,
            title: TextField(
              maxLines: 5,
              decoration: InputDecoration.collapsed(
                  hintText: 'more details about the Ad', hintStyle: hintStyle),
            )),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            onPressed: () {},
            child: Text('Submit Ad'),
          ),
        )
      ],
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
}
