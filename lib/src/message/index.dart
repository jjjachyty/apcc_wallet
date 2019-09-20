import 'package:apcc_wallet/src/message/add_friends.dart';
import 'package:apcc_wallet/src/message/contacts_page.dart';
import 'package:flutter/material.dart';

class MessageIndex extends StatefulWidget {
  @override
  _MessageIndexState createState() => _MessageIndexState();
}

class _MessageIndexState extends State<MessageIndex>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("聊天"),
          centerTitle: true,
          bottom: TabBar(
          indicatorColor: Colors.white,
        tabs: <Widget>[
          new Tab(
            icon: new Icon(Icons.question_answer),
          ),
          new Tab(
            icon: new Icon(Icons.supervisor_account),
          ),
        ],
        controller: _tabController,
      )),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new Center(child: new Text('待开放')),
          new Center(child: new Text('待开放')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
