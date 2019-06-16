import 'package:apcc_wallet/src/center/login.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:apcc_wallet/src/store/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class Item {
  Function onClick;
  Widget leading;
  String text;
  Item({this.onClick, this.leading, this.text});
}

class UserCenter extends StatefulWidget {
  User user;

  @override
  UserCenter({this.user});
  _UserCenterState createState() {
    print("createState---------------");
    print(user);
    return _UserCenterState(user);
  }
}

class _UserCenterState extends State<UserCenter> {
  User user;
  _UserCenterState(this.user);
  List<Item> _items = new List();

  bool _loginFlag = false;
  @override
  void initState() {
    _items
      // ..add(Item(index: 0, leading: Icon(Icons.person), text: "认证"))
      ..add(Item(
          onClick: () {},
          leading: Icon(
            Icons.info,
            color: Colors.green,
          ),
          text: "关于我们"))
      ..add(Item(
          onClick: () {},
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.green,
          ),
          text: "退出"));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Store<AppState>>(
        onInit: (store) {
          user = user == null ? store.state.user : null;

          if (user != null) {
            this._loginFlag = true;
          }
        },
        converter: (store) => store,
        builder: (context, store) {
          if (_loginFlag) {
            return _logined();
          } else {
            return _nologin();
          }
        });
  }

  Widget _logined() {
    return Scaffold(
        body: Column(
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
                        child: Image.network(
                          user.avatar,
                          width: 50,
                          color: Colors.white,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      user.nickName,
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
            child: ListView(
          children: <Widget>[
            new ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              isThreeLine: false,
              leading: Icon(Icons.info),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text("关于我们"),
            ),
            FlatButton(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "退出登录",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {},
            ),
          ],
        )),
      ],
    ));
  }

  Widget _nologin() {
    return Scaffold(
        body: Column(
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
            child: ListView(
          children: <Widget>[
            new ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              isThreeLine: false,
              leading: Icon(Icons.info),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text("关于我们"),
            )
          ],
        ))
      ],
    ));
  }
}
