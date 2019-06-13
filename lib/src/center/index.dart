import 'package:apcc_wallet/src/center/login.dart';
import 'package:flutter/material.dart';

class Item {
  int index;
  Widget leading;
  String text;
  Item({this.index, this.leading, this.text});
}

class UserCenter extends StatefulWidget {
  @override
  _UserCenterState createState() => _UserCenterState();
}

class _UserCenterState extends State<UserCenter> {
  List<Item> _items = new List();
  @override
  void initState() {
    _items
      // ..add(Item(index: 0, leading: Icon(Icons.person), text: "认证"))
      ..add(Item(
          index: 1,
          leading: Icon(
            Icons.info,
            color: Colors.orange,
          ),
          text: "关于我们"));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        Container(
          color: Colors.grey,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 40),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    new GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(new MaterialPageRoute(builder: (context) {
                            return UserLogin();
                          }));
                        },
                        child: Image.asset(
                          "assets/images/nologinavatar.png",
                          width: 50,
                          color: Colors.white,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "点击头像登陆",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    color: Colors.grey,
                  ),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return new ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  isThreeLine: false,
                  leading: _items[index].leading,
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(_items[index].text),
                );
              }),
        )
      ],
    )));
  }
}
