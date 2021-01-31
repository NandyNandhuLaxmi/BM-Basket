import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'basket.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  static List<Widget> _screen = <Widget>[
    Basket(), Profile()
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screen,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.home, size: 30),
            title: Text("Home", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.person, size: 30),
            title: Text("Profile", style: TextStyle(fontWeight: FontWeight.w600)),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Color(0xFFE2E2E2),
        onTap: _onItemTapped,
      ),
      
    );
  }
}

