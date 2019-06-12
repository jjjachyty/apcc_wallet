import 'package:apcc_wallet/src/main/send.dart';
import 'package:flutter/material.dart';

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
 
    pages..add(Index())..add(Receive())..add(Send());
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
            icon: new Icon(Icons.blur_on),
            title: new Text('接收'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.send),
            title: new Text('发送'),
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