import 'package:apcc_wallet/src/center/index.dart';
import 'package:apcc_wallet/src/dapp/app.dart';
import 'package:apcc_wallet/src/dapp/index.dart';
import 'package:apcc_wallet/src/main/coins.dart';
import 'package:flutter/material.dart';

import 'dapp.dart';
import 'index.dart';
import 'receive.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int _currentMain = 0;
  void onTabTapped(int Main) {
    setState(() {
      _currentMain = Main;
    });
  }

  List<Widget> pages = List<Widget>();

  @override
  void initState() {
    pages..add(Index())..add(Coins())..add(WebViewExample())..add(UserCenter());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentMain,
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('首页'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.attach_money),
            title: new Text('资产'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.apps),
            title: new Text('Dapp'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('我的'),
          ),
        ],
      ),
      body: pages[_currentMain],
    );
  }
}
