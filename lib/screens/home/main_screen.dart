import 'package:flutter/material.dart';
import 'package:justcost/screens/home/post_ad_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'notification_page.dart';
import 'categories_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  var _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Just Cost'),
          actions: <Widget>[
            Stack(
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
                Align(child: IconButton(icon:Icon(Icons.notifications),onPressed: (){},)),
              ],
            )
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
            NotificationPage()
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
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), title: Text('Search')),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle), title: Text('Post add')),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), title: Text('Categories')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('profile')),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
