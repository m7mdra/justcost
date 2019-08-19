import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/user/model/user.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/edit_profile/edit_user_profiile_screen.dart';
import 'package:justcost/screens/home/profile/profile_bloc.dart';
import 'package:justcost/screens/liked_products/liked_products_screen.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/screens/myads/my_ads_screen.dart';
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
    return BlocBuilder(
      builder: (context, state) {
        if (state is GuestUserState)
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                GuestUserWidget(),
                Expanded(
                    child: SettingsWidget(
                  onLogout: _onLogout,
                ))
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
                  ? Image.network(
                      '${user.image}?${Random().nextDouble()}',
                      width: 90,
                      height: 90,
                    )
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
        ListTile(
          leading: Icon(Icons.exit_to_app),
          dense: true,
          title: Text(AppLocalizations.of(context).logout),
          onTap: () => _onLogout(),
        ),
        divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(AppLocalizations.of(context).settings),
          dense: true,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
        )
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
