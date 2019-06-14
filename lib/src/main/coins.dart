
import 'package:apcc_wallet/src/coin/main/receive.dart';
import 'package:flutter/material.dart';


class Coins extends StatelessWidget {
  TabController _tabController ;

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new AppBar(

          title: new TabBar(
            tabs: <Widget>[
              new Tab(text: "MAIN",),
              new Tab(text: "ETH",),
              new Tab(text: "USDT",),
            ],
            controller: _tabController,
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new MainCoinReceive(),
            new Center(child: new Text('开发中')),
            new Center(child: new Text('开发中')),
          ],
        ),
      ),
    );
  }
}
