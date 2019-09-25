import 'dart:io';
import 'dart:ui';

import 'package:apcc_wallet/src/center/qrcode.dart';
import 'package:apcc_wallet/src/center/setting.dart';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

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
      padding: EdgeInsets.only(top: 0),
      shrinkWrap: true,
      children: <Widget>[
        new ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          isThreeLine: false,
          leading: Icon(
            Icons.info,
            color: Colors.indigo,
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
            color: Colors.indigo,
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
            color: Colors.indigo,
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
            color: Colors.indigo,
          ),
          trailing: Text(currentVersion.versionCode + "  "),
          title: Text("当前版本"),
        ),
      ],
    );
  }

  Widget _logined() {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      body:
      SingleChildScrollView(
        child:
       Column(
        children: <Widget>[
          Container(
              height: MediaQuery.of(context).size.height * 0.38,
              decoration: new BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/center_bg@3x.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          height: 120,
                          width: 120,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      children: <Widget>[
                                        user.avatar == ""
                                            ? Image.asset(
                                                "assets/images/money.png",
                                                fit: BoxFit.contain,
                                              )
                                            : Image.network(
                                                avatarURL,
                                                fit: BoxFit.contain,
                                              ),
                                      ],
                                    );
                                  });
                            },
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: user.avatar == ""
                                    ? AssetImage("assets/images/money.png")
                                    : CachedNetworkImageProvider(avatarURL)),
                          )),
                      SizedBox(width: 20),
                      Text(
                        user.nickName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(user.introduce,style: TextStyle(color: Colors.white,fontSize: 10),)
                ],
              )),
          Container(
              decoration: BoxDecoration(color: Colors.white),
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: <Widget>[
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      new ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        isThreeLine: false,
                        leading: Icon(
                          Icons.accessibility_new,
                          color: Colors.indigo,
                        ),
                        title: Text(
                          "我的健康",
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          Navigator.of(context).pushNamed("/healthy/index");
                        },
                      ),
                      new ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        isThreeLine: false,
                        leading: Icon(
                          Icons.blur_on,
                          color: Colors.indigo,
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        title: Text(
                          "我的二维码",
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return MyQrCode();
                          }));
                        },
                      ),
                      new ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        isThreeLine: false,
                        leading: Icon(
                          Icons.settings,
                          color: Colors.indigo,
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
                  ),
                  _item(),
                ],
              )

              // _item(),
              ),
        ],
      ),
       
      )
    );
  }

  Widget _nologin() {
    return Scaffold(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        body: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/center_bg@3x.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pushNamed("/login");
                            },
                            child: Container(
                                child: Image.asset(
                              "assets/images/nologinavatar.png",
                              width: 120,
                              color: Colors.white,
                            ))),
                        SizedBox(width: 10),
                        Text(
                          "点击头像登陆",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: _item(),
            )
          ],
        ));
  }
}
