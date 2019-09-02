import 'package:apcc_wallet/src/center/profile.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


// class UserSetting extends StatefulWidget {
//   @override
//   _UserSettingState createState() => _UserSettingState();
// }

class UserSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     
          return Scaffold(
              appBar: AppBar(
                title: Text("设置"),
                centerTitle: true,
              ),
              body: Container(
                padding: EdgeInsets.all(8),
                child: ListView(
                  children: <Widget>[
                    new ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      isThreeLine: false,
                      leading: Icon(
                        Icons.account_box,
                        color: Colors.green,
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: Text("基本信息"),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return Profile();
                        }));
                      },
                    ),
                    new ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      isThreeLine: false,
                      leading: Icon(
                        Icons.verified_user,
                        color: Colors.green,
                      ),
                      trailing: (user != null && user.idCardAuth != 0)
                          ? Text(
                              "已认证",
                              style: TextStyle(color: Colors.green),
                            )
                          : Icon(Icons.keyboard_arrow_right),
                      title: Text("实名认证"),
                      onTap: () {
                        if (user.idCardAuth == 1) {
                        } else {
                          Navigator.of(context).pushNamed("/user/idcard");
                        }
                      },
                    ),
                    // new ListTile(
                    //   dense: true,
                    //   contentPadding: EdgeInsets.zero,
                    //   isThreeLine: false,
                    //   leading: Icon(
                    //     Icons.lock_outline,
                    //     color: Colors.green,
                    //   ),
                    //   trailing: Icon(Icons.keyboard_arrow_right),
                    //   title: Text("支付密码"),
                    //   onTap: () {
                    //     Navigator.of(context)
                    //         .push(MaterialPageRoute(builder: (context) {
                    //       return TradePassWd(store.state.user.hasPayPasswd);
                    //     }));
                    //   },
                    // ),
                    new ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      isThreeLine: false,
                      leading: Icon(
                        Icons.lock_outline,
                        color: Colors.green,
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      title: Text("登录密码"),
                      onTap: () {
                        Navigator.of(context).pushNamed("/loginpasswd");
                      },
                    ),
                    FlatButton(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "退出登录",
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () {
                        // eventBus.fire(UserInfoUpdate(null));
                        loginOut();
                        // print("1111111111111111111");
                        Navigator.of(context).pop();
                        // print("222222222222222222222");
                      },
                    ),
                  ],
                ),
              ));
        
  }
}
