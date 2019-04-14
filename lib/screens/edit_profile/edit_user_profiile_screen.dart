import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justcost/data/user/model/auth_response.dart';
import 'package:justcost/data/user/user_repository.dart';
import 'package:justcost/image_cropper_screen.dart';
import 'package:justcost/screens/edit_profile/edit_profile_events.dart';
import 'package:justcost/screens/edit_profile/password.dart';
import 'package:justcost/screens/edit_profile/personal_information.dart';
import 'package:justcost/screens/edit_profile/update_account_information_screen.dart';
import 'package:justcost/screens/edit_profile/update_personal_information_screen.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/widget/progress_dialog.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'package:justcost/dependencies_provider.dart';

import 'account_information.dart';
import 'edit_profile_bloc.dart';
import 'edit_profile_states.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File imageFile;
  File originalFile;
  EditProfileBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = EditProfileBloc(
        DependenciesProvider.provide(), DependenciesProvider.provide());
    _bloc.state.listen((state) {
      if (state is ErrorState) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => RoundedAlertDialog(
                  title: Text('Error'),
                  content: Text(state.message),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
      if (state is PasswordChangedSuccess) {
        Navigator.of(context).pop();
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => RoundedAlertDialog(
                  title: Text('Password changed successfully'),
                  content:
                      Text("Log in again to continue using the application."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )).then((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));
        });
      }

      if (state is SessionExpiredState) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => RoundedAlertDialog(
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                  content: Text('Session Expired, log in again'),
                )).then((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SafeArea(
          child: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, EditProfileState state) {
          if (state is UserLoadedState) buildListView(context, state.payload);
          if (state is AccountInformationUpdateSuccessState)
            buildListView(context, state.payload);
          if (state is AvatarUpdateSuccess)
            buildListView(context, state.payload);
          if (state is PersonalInformationUpdateSuccessState)
            buildListView(context, state.payload);
          if (state is LoadingState) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => ProgressDialog(
                      message: "Please wait while trying to update profile...",
                    ));
            return buildListView(context, state.payload);
          }
        },
      )),
    );
  }

  ListView buildListView(BuildContext context, Payload payload) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Column(
          children: <Widget>[
            Align(
              child: ClipOval(
                  child: Image.asset(
                payload != null && payload.photo != null
                    ? payload.photo
                    : 'assets/images/default-avatar.png',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )),
            ),
            OutlineButton(
              onPressed: () {
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
                              onTap: () async =>
                                  onUpdateClick(ImageSource.camera),
                            ),
                            ListTile(
                              title: Text('Pick Image from gallery'),
                              leading: Icon(Icons.image),
                              dense: true,
                              onTap: () async =>
                                  onUpdateClick(ImageSource.gallery),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Text('Update Profile Avatar'),
            ),
            buildDivider(),
            buildTitle('Personal Information', () async {
              PersonalInformation newInformation = await Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => UpdatePersonalInformationScreen(
                          PersonalInformation(payload.fullName, payload.gender,
                              payload.address))));
              if (newInformation != null)
                _bloc.dispatch(UpdatePersonalInformationEvent(
                    fullName: newInformation.fullName,
                    address: newInformation.address,
                    gender: newInformation.gender));
            }),
            ListTile(
                contentPadding: tilePadding(),
                dense: true,
                title: Text('Full name'),
                subtitle: Text(
                    payload.fullName == null || payload.fullName.isEmpty
                        ? 'Not added'
                        : payload.fullName)),
            ListTile(
                dense: true,
                title: Text('Gender'),
                subtitle: Text(payload.gender == null || payload.gender.isEmpty
                    ? 'Not Added'
                    : payload.gender)),
            ListTile(
                contentPadding: tilePadding(),
                dense: true,
                title: Text('Address'),
                subtitle: Text(
                    payload.address == null || payload.address.isEmpty
                        ? 'Not added'
                        : payload.address)),
            buildDivider(),
            buildTitle('Account Information', () async {
              AccountInformation information = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => UpdateAccountInformationScreen()));
              if (information != null)
                _bloc.dispatch(UpdateAccountInformationEvent(
                    username: information.username,
                    password: information.currentPassword,
                    email: information.email));
            }),
            ListTile(
                contentPadding: tilePadding(),
                dense: true,
                title: Text('Username'),
                subtitle: Text('@${payload.username}')),
            ListTile(
                contentPadding: tilePadding(),
                dense: true,
                title: Text('Email Address'),
                subtitle: Text(payload.email)),
            buildTitle('Account Security ', () async {
              Password information = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => UpdateAccountInformationScreen()));
              if (information != null)
                _bloc.dispatch(UpdatePasswordEvent(
                    confirmNewPassword: information.confrimPassword,
                    currentPassword: information.currentPassword,
                    newPassword: information.password));
            }),
            ListTile(
                dense: true,
                contentPadding: tilePadding(),
                title: Text('Chnage Password'),
                subtitle: Text('**********')),
          ],
        ),
      ],
    );
  }

  EdgeInsets tilePadding() =>
      const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0);

  Widget buildTitle(String sectionTitle, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(sectionTitle),
        FlatButton(onPressed: onPressed, child: Text('Update'))
      ],
    );
  }

  Divider buildDivider() {
    return const Divider(
      height: 1,
      indent: 0,
    );
  }

  onUpdateClick(ImageSource source) async {
    var image = await ImagePicker.pickImage(
        source: source == ImageSource.camera
            ? ImageSource.camera
            : ImageSource.gallery);
    if (image != null) {
      var croppedImage =
          await Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ImageCropperScreen(
                    imageFile: image,
                  )));

      setState(() {
        imageFile = croppedImage;
        originalFile = image;
      });
      if (image != null && croppedImage != null) {
        _bloc.dispatch(UpdateProfileAvatarEvent(
            originalImage: image, croppedImage: croppedImage));
      }
    }
  }
}
