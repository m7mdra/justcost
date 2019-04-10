import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/user/model/auth_response.dart';
import 'package:justcost/screens/edit_profile/edit_user_profiile_screen.dart';
import 'package:justcost/screens/home/profile/profile_bloc.dart';
import 'package:justcost/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/screens/register/register_screen.dart';
import 'package:justcost/widget/guest_user_widget.dart';
import 'package:justcost/widget/rounded_edges_alert_dialog.dart';
import 'package:justcost/widget/settings_widget.dart';

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
        DependenciesProvide.provide(), DependenciesProvide.provide());
    _bloc.dispatch(LoadProfileEvent());
    _bloc.state.listen((state) {
      if (state is LogoutSuccessState)
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      if (state is SessionsExpiredState) {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => RoundedAlertDialog(
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: (){
                    Navigator.pop(context);
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
        if (state is ProfileLoadedSuccessState)
          return _loadUsers(state.userPayload);
        if (state is ProfileReloadFailedState)
          return _loadUsers(state.userPayload);
        return Container();
      },
      bloc: _bloc,
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _loadUsers(Payload userPayload) {
    return Column(
      children: <Widget>[
        ClipOval(
            child: userPayload != null && userPayload.photo != null
                ? CachedNetworkImage(
                    imageUrl: userPayload.photo,
                    width: 90,
                    height: 90,
                  )
                : Image.asset('assets/images/default-avatar.png',
                    width: 90, height: 90)),
        SizedBox(
          width: 10,
        ),
        Text(
          'Ahmed Salah',
        ),
        Text('Membership: GOLDEN'),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Level '),
              Container(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: Text(
                  ' 19 ',
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.black),
              ),
              Text(' | '),
              Text('Votes '),
              Container(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: Text(
                  '1999',
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    color: Colors.green),
              ),
            ],
          ),
        ),
        OutlineButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfileScreen()));
          },
          child: Text('Edit Profile'),
        ),
        Expanded(
          child: SettingsWidget(
            onLogout: _onLogout,
          ),
        ),
      ],
    );
  }

  void _onLogout() {
    _bloc.dispatch(LogoutEvent());
  }
}
