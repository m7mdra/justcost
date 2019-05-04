import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/home/home/home_page.dart';
import 'package:justcost/screens/home/postad/post_ad_page.dart';
import 'package:justcost/screens/home/search/search_page.dart';
import 'package:justcost/screens/home/profile/profile_page.dart';
import 'package:justcost/screens/home/category/categories_page.dart';
import 'package:justcost/screens/search/search_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with  AutomaticKeepAliveClientMixin<MainScreen>{
  PageController _pageController;
  var _currentPage = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: true);
  }

  List<Widget> _notificationWidget = List.generate(10, (generator) {
    return ListTile(
      dense: true,
      leading: generator % 2 == 0
          ? Icon(
              Icons.thumb_up,
              color: Colors.blue,
            )
          : Icon(
              Icons.mode_comment,
              color: Colors.green,
            ),
      title: Text(generator % 2 == 0
          ? 'Ahmed Salah Liked your Ad'
          : 'Ahmed Salah Commented your Ad'),
      subtitle: Text('${Random().nextInt(60)} seconds ago'),
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SafeArea(
          child: Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).notificationPanel,
                        style: Theme.of(context).textTheme.title,
                      ),
                      IconButton(
                        icon: Icon(Icons.clear_all),
                        onPressed: () {
                          setState(() {
                            _notificationWidget.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.separated(
                    primary: true,
                    itemCount: _notificationWidget.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        child: _notificationWidget[index],
                        key: ObjectKey(
                            "value${Random().nextInt(_notificationWidget.length)}"),
                        onDismissed: (position) {
                          setState(() {
                            _notificationWidget.removeAt(index);
                          });
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).appName),
          actions: <Widget>[
            Builder(
              builder: (context) {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: Text(
                          '+9',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Align(
                        child: IconButton(
                            icon: Icon(Icons.notifications),
                            onPressed: () =>
                                Scaffold.of(context).openEndDrawer())),
                  ],
                );
              },
            ),
            _currentPage == 1
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchScreen()));
                    })
                : Container()
          ],
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: 5,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) return HomePage();
            if (index == 1) return SearchPage();
            if (index == 2) return PostAdPage();
            if (index == 3) return CategoriesPage();
            if (index == 4) return ProfilePage();
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          onTap: (index) {
            if (_currentPage == index) return;
            setState(() {
              _currentPage = index;
            });
            _pageController.animateToPage(_currentPage,
                duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(AppLocalizations.of(context).homePageTitle),
                activeIcon: Icon(
                  Icons.home,
                  color: Theme.of(context).accentColor,
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text(AppLocalizations.of(context).searchPageTitle),
                activeIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).accentColor,
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle),
                title: Text(AppLocalizations.of(context).postAdPageTitle),
                activeIcon: Icon(
                  Icons.add_circle,
                  color: Theme.of(context).accentColor,
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.category),
                title: Text(AppLocalizations.of(context).categoriesPageTitle),
                activeIcon: Icon(
                  Icons.category,
                  color: Theme.of(context).accentColor,
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text(AppLocalizations.of(context).profilePageTitle),
                activeIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).accentColor,
                )),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
