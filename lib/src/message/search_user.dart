import 'package:apcc_wallet/src/dapp/common.dart';
import 'package:apcc_wallet/src/dapp/index.dart';
import 'package:apcc_wallet/src/message/apply_friends.dart';
import 'package:apcc_wallet/src/model/dapp.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SearchUserPage extends StatefulWidget {
  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  var _flag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              TextField(
                maxLength: 11,
                textInputAction: TextInputAction.search,
                autofocus: true,
                onSubmitted: (val) async {
                  if (val.length > 0) {
                    var _data = await getUserByPhone(val);
                    if (_data.state) {
                      var _user = User.fromJson(_data.data);
                      print(_user.nickName);
                      if (_user.nickName != "") {
                        var pg = ApplyFriendPage(_user);

                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return pg;
                        }));
                      }else{
                        setState(() {
                          _flag = true;
                        });
                      }
                    }
                  }
                },
                decoration: InputDecoration(
                    prefix: Icon(
                      Icons.search,
                      color: Colors.indigo,
                    ),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(6),
                    suffix: Text.rich(TextSpan(
                        text: "取消",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pop();
                          }))),
              ),
              _flag==true?Container(
                child: Text("无该用户"),
              ):Text(""),
            ],
          )),
    ));
  }
}
