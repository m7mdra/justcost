import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justcost/data/user/model/user.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/image_cropper_screen.dart';
import 'package:justcost/screens/edit_profile/edit_profile_events.dart';
import 'package:justcost/screens/edit_profile/password.dart';
import 'package:justcost/screens/edit_profile/personal_information.dart';
import 'package:justcost/screens/edit_profile/update_account_information_screen.dart';
import 'package:justcost/screens/edit_profile/update_password_screen.dart';
import 'package:justcost/screens/edit_profile/update_personal_information_screen.dart';
import 'package:justcost/screens/home/profile/profile_bloc.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/widget/default_user_avatar.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';

import 'account_information.dart';
import 'edit_profile_bloc.dart';
import 'edit_profile_states.dart';
import 'package:justcost/i10n/app_localizations.dart';

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
        DependenciesProvider.provide(),
        DependenciesProvider.provide(),
        BlocProvider.of<UserProfileBloc>(context));
    _bloc.forEach((state){
      if (state is ErrorState) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => RoundedAlertDialog(
              title: Text(AppLocalizations.of(context).generalError),
              content:
              Text(AppLocalizations.of(context).failedToUpdateProfile),
              actions: <Widget>[
                FlatButton(
                  child:
                  Text(MaterialLocalizations.of(context).okButtonLabel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
      }
      if (state is PasswordChangedSuccess) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                LoginScreen(NavigationReason.password_change)));
      }

      if (state is SessionExpiredState) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                LoginScreen(NavigationReason.session_expired)));
      }
    });
//    _bloc.state.listen((state) async {
//
//    });
    _bloc.add(LoadUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editProfile),
      ),
      body: SafeArea(
          child: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, EditProfileState state) {
          print(state);
          if (state is UserLoadedState)
            return buildListView(context, state.payload);
          if (state is AccountInformationUpdateSuccessState) {
            return buildListView(context, state.user);
          }
          if (state is AvatarUpdateSuccess)
            return buildListView(context, state.payload);
          if (state is PersonalInformationUpdateSuccessState)
            return buildListView(context, state.user);
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            );
          }
          return Container();
        },
      )),
    );
  }

  ListView buildListView(BuildContext context, User user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Column(
          children: <Widget>[
            Align(
              child: ClipOval(
                  child: user.image != null && user.image.isNotEmpty
                      ? Container(
                        width: 100,
                        height: 100,
                        child: CachedNetworkImage(
                          imageUrl: '${user.image}?${Random().nextDouble()}',
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset('assets/icon/android/logo-500.png',width: 100,height: 100,),

                        ),
                      )
                      : DefaultUserAvatarWidget()),
            ),
            OutlineButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return RoundedAlertDialog(
                        title: Text(
                            AppLocalizations.of(context).uploadMethodAvatar),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                  AppLocalizations.of(context).captureImage),
                              leading: Icon(Icons.camera_alt),
                              dense: true,
                              onTap: () async =>
                                  onUpdateClick(ImageSource.camera),
                            ),
                            ListTile(
                              title: Text(
                                  AppLocalizations.of(context).pickFromGallery),
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
              child: Text(AppLocalizations.of(context).updateProfileAvatar),
            ),
            buildDivider(),
            buildTitle(AppLocalizations.of(context).personalInformation,
                () async {
              PersonalInformation newInformation = await Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => UpdatePersonalInformationScreen(
                          PersonalInformation(
                              user.name, user.gender, user.city))));
              if (newInformation != null)
                _bloc.add(UpdatePersonalInformationEvent(
                    fullName: newInformation.fullName,
                    city: newInformation.city.id,
                    gender: newInformation.gender));
            }),
            ListTile(
                contentPadding: tilePadding(),
                dense: true,
                title: Text(AppLocalizations.of(context).fullNameField),
                subtitle: Text(user.name == null || user.name.isEmpty
                    ? AppLocalizations.of(context).na
                    : user?.name)),
            ListTile(
                dense: true,
                title: Text(AppLocalizations.of(context).gender),
                subtitle: Text(user.gender == null
                    ? AppLocalizations.of(context).na
                    : user?.gender == 1
                        ? AppLocalizations.of(context).male
                        : AppLocalizations.of(context).female)),
            ListTile(
                contentPadding: tilePadding(),
                dense: true,
                title: Text(AppLocalizations.of(context).location),
                subtitle: Text(user.city == null
                    ? AppLocalizations.of(context).na
                    : Localizations.localeOf(context).languageCode == 'ar'
                        ? user.city.arName
                        : user.city.name)),
            buildDivider(),
            buildTitle(AppLocalizations.of(context).accountInformation,
                () async {
              AccountInformation information = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => UpdateAccountInformationScreen(
                          AccountInformation(user.username, user.email))));
              if (information != null)
                _bloc.add(UpdateAccountInformationEvent(
                    username: information.username,
                    password: information.currentPassword,
                    email: information.email));
            }),
            ListTile(
                contentPadding: tilePadding(),
                dense: true,
                title: Text(AppLocalizations.of(context).usernameFieldHint),
                subtitle: Text('@${user.username}')),
            ListTile(
                contentPadding: tilePadding(),
                dense: true,
                title: Text(AppLocalizations.of(context).emailFieldLabel),
                subtitle: Text(user.email == null || user.email.isEmpty
                    ? AppLocalizations.of(context).na
                    : user.email)),
            buildTitle(AppLocalizations.of(context).accountSecurity, () async {
              Password information = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => UpdatePasswordScreen()));
              if (information != null)
                _bloc.add(UpdatePasswordEvent(
                    confirmNewPassword: information.confrimPassword,
                    currentPassword: information.currentPassword,
                    newPassword: information.password));
            }),
            ListTile(
                dense: true,
                contentPadding: tilePadding(),
                title: Text(AppLocalizations.of(context).changePassword),
                subtitle:
                    Text(AppLocalizations.of(context).changePasswordSubtitle)),
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
        FlatButton(
            onPressed: onPressed,
            child: Text(AppLocalizations.of(context).updateButton))
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

      imageFile = croppedImage;
      originalFile = image;

      if (image != null && croppedImage != null) {
        _bloc.add(UpdateProfileAvatarEvent(
            originalImage: image, croppedImage: croppedImage));
      }
    }
  }
}
