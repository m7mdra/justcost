import 'dart:math';

import 'package:flutter/material.dart';
import 'package:justcost/screens/home/post_ad_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'profile_page.dart';
import 'categories_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  var _currentPage = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: ListView.separated(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                dense: true,
                leading: index % 2 == 0
                    ? Icon(
                        Icons.thumb_up,
                        color: Colors.blue,
                      )
                    : Icon(
                        Icons.mode_comment,
                        color: Colors.green,
                      ),
                title: Text(index % 2 == 0
                    ? 'Ahmed Salah Liked your Ad'
                    : 'Ahmed Salah Commented your Ad'),
                subtitle: Text('${Random().nextInt(60)} seconds ago'),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          ),
        ),
        appBar: AppBar(
          title: Text('Just Cost'),
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
          ],
        ),
        body: SafeArea(
            child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: <Widget>[
            HomePage(),
            SearchPage(),
            PostAdPage(),
            CategoriesPage(),
            ProfilePage()
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          onTap: (index) {
            if (_currentPage == index) return;
            setState(() {
              _currentPage = index;
            });
            _pageController.animateToPage(_currentPage,
                duration: Duration(milliseconds: 100), curve: Curves.easeIn);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                activeIcon: Icon(
                  Icons.home,
                  color: Theme.of(context).accentColor,
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text('Search'),
                activeIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).accentColor,
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle),
                title: Text('Post Ad'),
                activeIcon: Icon(
                  Icons.add_circle,
                  color: Theme.of(context).accentColor,
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.category),
                title: Text('Categories'),
                activeIcon: Icon(
                  Icons.category,
                  color: Theme.of(context).accentColor,
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
                activeIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).accentColor,
                )),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
