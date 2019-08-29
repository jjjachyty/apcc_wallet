import 'package:apcc_wallet/src/center/index.dart';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/event_bus.dart';
import 'package:apcc_wallet/src/common/version.dart';
import 'package:apcc_wallet/src/main/assets.dart';
import 'package:apcc_wallet/src/main/dapp.dart';
import 'package:flutter/material.dart';

import 'dapp.dart';
import 'index.dart';


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

  void _listener() {
    eventBus.on<UserLoggedInEvent>().listen((event) {
      Navigator.of(context).pushNamed("/login");
    });
  }

  List<Widget> pages = List<Widget>();

  @override
  void initState() {
    pages..add(Index())..add(AssetsPage())..add(DappsPage())..add(UserCenter());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _listener();

    if (newestVersion.versionCode != "" &&
        currentVersion.versionCode != newestVersion.versionCode) {
      return Version();
    } else {
      // TODO: implement build
      return Scaffold(
        resizeToAvoidBottomInset: true,
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
}
