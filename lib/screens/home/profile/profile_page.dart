import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justcost/data/user/model/user.dart';
import 'package:justcost/dependencies_provider.dart';
import 'package:justcost/screens/edit_profile/edit_user_profiile_screen.dart';
import 'package:justcost/screens/home/profile/profile_bloc.dart';
import 'package:justcost/screens/login/login_screen.dart';
import 'package:justcost/widget/default_user_avatar.dart';
import 'package:justcost/widget/guest_user_widget.dart';
import 'package:justcost/widget/settings_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  UserProfileBloc _bloc;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _bloc.dispatch(LoadProfileEvent());

  }
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
        ClipOval(
            child: user.image != null && user.image.isNotEmpty
                ? Image.network(
                    user.image,
                    width: 90,
                    height: 90,
                  )
                : DefaultUserAvatarWidget()),
        SizedBox(
          width: 10,
        ),
        Text(user.name),
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
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return BlocProvider.value(
                value: _bloc,
                child: EditProfileScreen(),
              );
            }));
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

  Future _onLogout() {
    _bloc.dispatch(LogoutEvent());
  }
}
