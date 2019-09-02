import 'dart:io';
import 'dart:ui';

import 'package:apcc_wallet/src/center/setting.dart';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/user.dart';

import 'package:flutter/material.dart';

class Item {
  Function onClick;
  Widget leading;
  String text;
  Item({this.onClick, this.leading, this.text});
}

class UserCenter extends StatefulWidget {
  @override
  _UserCenterState createState() {
    return _UserCenterState();
  }
}

class _UserCenterState extends State<UserCenter> {
  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return _logined();
    } else {
      return _nologin();
    }
  }

  Widget _item() {
    return ListView(
      children: <Widget>[
        new ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          isThreeLine: false,
          leading: Icon(
            Icons.info,
            color: Colors.green,
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
          title: Text("关于我们"),
          onTap: () {
            Navigator.of(context).pushNamed("/aboutus");
          },
        ),
        new ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          isThreeLine: false,
          leading: Icon(
            Icons.contacts,
            color: Colors.green,
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
          title: Text("联系我们"),
          onTap: () {
            Navigator.of(context).pushNamed("/contactus");
          },
        ),
        new ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          isThreeLine: false,
          leading: Icon(
            Icons.bookmark,
            color: Colors.green,
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
          title: Text("使用条款"),
          onTap: () {
            Navigator.of(context).pushNamed("/notice");
          },
        ),
        new ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          isThreeLine: false,
          leading: Icon(
            Icons.stars,
            color: Colors.green,
          ),
          trailing: Text(currentVersion.versionCode + "  "),
          title: Text("当前版本"),
          // onTap: () {
          //   Navigator.of(context).pushNamed("/notice");
          // },
        ),
        Divider(),
        user == null
            ? Divider()
            : new ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                isThreeLine: false,
                leading: Icon(
                  Icons.settings,
                  color: Colors.green,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text("设置"),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return UserSetting();
                  }));
                },
              ),
      ],
    );
  }

  Widget _logined() {
    return Scaffold(
      body: Column(
        children: <Widget>[
          new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/avatar_bg.png"),
                        fit: BoxFit.fill),
                    color: Colors.green.shade500.withOpacity(0.8),
                  ),
                  child: Column(
                    children: <Widget>[
                      AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                              height: 150,
                              width: 150,
                              child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: user.avatar == ""
                                      ? AssetImage("assets/images/money.png")
                                      : NetworkImage(
                                          getAvatarURL(user.avatar)))),
                          Text(
                            user.nickName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ))),
          Expanded(child: _item()),
        ],
      ),
    );
  }

  Widget _nologin() {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                // color: Colors.green,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/avatar_bg.png"),
                      fit: BoxFit.fill),
                  gradient: RadialGradient(colors: [
                    Colors.green.shade300,
                    Colors.green.shade400,
                    Colors.green
                  ], radius: 1, tileMode: TileMode.mirror),
                ),
                padding: EdgeInsets.symmetric(vertical: 40),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    new GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pushNamed("/login");
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Image.asset(
                              "assets/images/nologinavatar.png",
                              width: 60,
                              color: Colors.white,
                            ))),
                    SizedBox(
                      height: 10,
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
        Expanded(child: _item())
      ],
    ));
  }
}
