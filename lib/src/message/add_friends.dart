import 'package:apcc_wallet/src/dapp/search.dart';
import 'package:flutter/material.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("添加好友"),),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              TextField(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return SearchAppPage();
            }));
          },
          // enabled: false,
          decoration: InputDecoration(
              hintText: "搜索好友ID/手机号",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              contentPadding: EdgeInsets.all(0),
              border: OutlineInputBorder()),
        ),
                FlatButton(child: Text("扫一扫添加好友"),onPressed: (){

                },),
            ],
          ),
        ),
      ),
    );
  }
}