import 'dart:ui';

import 'package:apcc_wallet/src/center/login.dart';
import 'package:apcc_wallet/src/center/setting.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:apcc_wallet/src/store/actions.dart';
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
  @override
  _UserCenterState createState() {
    return _UserCenterState();
  }
}

class _UserCenterState extends State<UserCenter> {
  User _user;


  @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Store<AppState>>(
        onInit: (store) {
          print(store.state.user);
          _user = _user == null ? store.state.user : _user;
        },
        converter: (store) => store,
        builder: (context, store) {
          if (_user != null) {
            return _logined(store);
          } else {
            return _nologin();
          }
        });
  }

  Widget _item (){
  return  ListView(
          children: <Widget>[
            new ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              isThreeLine: false,
              leading: Icon(Icons.info),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text("关于我们"),
              onTap: (){
                Navigator.of(context).pushNamed("/aboutus");
              },
            ),
            new ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              isThreeLine: false,
              leading: Icon(Icons.message),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text("联系我们"),
              onTap: (){
                Navigator.of(context).pushNamed("/contactus");
              },
            ),
            new ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              isThreeLine: false,
              leading: Icon(Icons.get_app),
              trailing: Text("最新版本1.1.0"),
              title: Text("APP版本(1.0.0)"),
              onTap: (){
                
              },
            )
          ],
        );
  }



  Widget _logined(Store<AppState> store) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        new BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
                height: 200,
                decoration: new BoxDecoration(
                    color: Colors.green.shade500.withOpacity(0.8)),
                child: Column(
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () async{
                          final _result=  await Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                  return UserSetting();
                            }));

                          setState(() {
                           _user =  _result as User;
                          });

                          },
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: _user.avatar==""?AssetImage("assets/images/money.png"):NetworkImage(_user.avatar))),
                        Text(
                        _user.nickName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ))),
        Expanded(
            child:  _item()),
      ],
    )
    );}

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
                        onTap: () async {
                          final _user = await Navigator.of(context)
                              .push(new MaterialPageRoute(builder: (context) {
                            return UserLogin();
                          }));
                          print("user");
    print(_user);
                          setState(() {
                            this._user = _user;
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Image.asset(
                              "assets/images/nologinavatar.png",
                              width: 50,
                              color: Colors.white,
                            ))),
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
            child: _item())
      ],
    ));
  }
}
