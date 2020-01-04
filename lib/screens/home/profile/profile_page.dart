import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/user/model/user.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/about_us/about_us_screen.dart';
import 'package:justcost/screens/contact_us/contact_us_screen.dart';
import 'package:justcost/screens/edit_profile/edit_user_profiile_screen.dart';
import 'package:justcost/screens/fqa/fqa_screen.dart';
import 'package:justcost/screens/home/profile/profile_bloc.dart';
import 'package:justcost/screens/liked_products/liked_products_screen.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/screens/myads/my_ads_screen.dart';
import 'package:justcost/screens/terms/terms_screen.dart';
import 'package:justcost/widget/default_user_avatar.dart';
import 'package:justcost/widget/guest_user_widget.dart';
import 'package:justcost/widget/settings_widget.dart';
import 'package:justcost/i10n/app_localizations.dart';

import 'package:justcost/screens/settings/settings_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  UserProfileBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = UserProfileBloc(
        DependenciesProvider.provide(), DependenciesProvider.provide());
    _bloc.dispatch(LoadProfileEvent());
    _bloc.state.listen((state) {
      if (state is LogoutSuccessState) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginScreen(NavigationReason.logout)));
      }
      if (state is SessionsExpiredState) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                LoginScreen(NavigationReason.session_expired)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: BlocBuilder(
        builder: (context, state) {
          if (state is GuestUserState)
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  GuestUserWidget(),
                  _settingsTile(context),
                  divider(),
                  _logoutTile(context)

                ],
              ),
            );
          if (state is ProfileLoadedSuccessState) return _loadUser(state.user);
          if (state is ProfileReloadFailedState) return _loadUser(state.user);
          if (state is LogoutLoading)
            return Center(child: CircularProgressIndicator());
          return Container();
        },
        bloc: _bloc,
      ),
    );
  }

  ListTile _logoutTile(BuildContext context) {
    return ListTile(
                leading: Icon(Icons.exit_to_app),
                dense: true,
                title: Text(AppLocalizations.of(context).logout),
                onTap: () => _onLogout(),
              );
  }

  ListTile _settingsTile(BuildContext context) {
    return ListTile(
                leading: Icon(Icons.settings),
                title: Text(AppLocalizations.of(context).settings),
                dense: true,
                onTap: () async {
                  var token = await FirebaseMessaging().getToken();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsScreen(token: token,)));
                },
              );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _loadUser(User user) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
              child: user.image != null && user.image.isNotEmpty
                  ? CachedNetworkImage(
                    width: 90,
                    height: 90,
                    imageUrl: '${user.image}?${Random().nextDouble()}',
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Container(width:90,height: 90,child: Center(child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => Image.asset('images/image404.png'))
                  : DefaultUserAvatarWidget()),
        ),
        SizedBox(
          width: 10,
        ),
        Text(user.name),
        OutlineButton(
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return BlocProvider.value(
                value: _bloc,
                child: EditProfileScreen(),
              );
            }));
          },
          child: Text(AppLocalizations.of(context).editProfile),
        ),
        divider(),
        ListTile(
          leading: Icon(Icons.local_offer),
          title: Text(AppLocalizations.of(context).myAds),
          dense: true,
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => MyAdsScreen()));
          },
        ),
        divider(),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text(AppLocalizations.of(context).favoriteAds),
          dense: true,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LikedProductsScreen()));
          },
        ),
        divider(),
        _settingsTile(context),
        divider(),
        ListTile(
          leading: Icon(Icons.list),
          title: Text(AppLocalizations.of(context).fqa),
          dense: true,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FQAScreen()));
          },
        ),
        divider(),
        ListTile(
          leading: Icon(Icons.info),
          title: Text(AppLocalizations.of(context).aboutUs),
          dense: true,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AboutUs()));
          },
        ),
        divider(),
        ListTile(
          leading: Icon(Icons.contacts),
          title: Text(AppLocalizations.of(context).contactUs),
          dense: true,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ContactUs()));
          },
        ),
        divider(),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text(AppLocalizations.of(context).terms),
          dense: true,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Terms()));
          },
        ),
        divider(),
        _logoutTile(context)

      ],
    );
  }

  Divider divider() => const Divider(
        height: 1,
      );

  _onLogout() {
    _bloc.dispatch(LogoutEvent());
  }
}
