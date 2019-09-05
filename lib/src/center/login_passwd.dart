import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

class LoginPasswd extends StatefulWidget {
  @override
  _LoginPasswdState createState() => _LoginPasswdState();
}

class _LoginPasswdState extends State<LoginPasswd> {
  var _loginPasswd, _loginPasswdConf;
  var _obscureFlag = true, _errText = "";
  TextEditingController _passwdCtl = new TextEditingController();
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("修改登录密码"),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _passwdCtl,
                  obscureText: _obscureFlag,
                  maxLength: 16,
                  validator: (val) {
                    if (!passwdExp.hasMatch(val)) {
                      return "密码为16位大小写字母及数字组合";
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "登录密码",
                      counterText: "",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            _obscureFlag = !_obscureFlag;
                          });
                        },
                      )),
                  onSaved: (val) {
                    _loginPasswd = val;
                  },
                ),
                TextFormField(
                  obscureText: _obscureFlag,
                  maxLength: 16,
                  autovalidate: true,
                  validator: (val) {
                    if (val != _passwdCtl.text) {
                      return "两次密码不一致";
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "确认登录密码",
                      counterText: "",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            _obscureFlag = !_obscureFlag;
                          });
                        },
                      )),
                ),
                SizedBox(
                  child: Text(
                    _errText,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ProgressButton(
                  color: Colors.indigo,
                  defaultWidget: Text(
                    "修改",
                    style: TextStyle(color: Colors.white),
                  ),
                  progressWidget: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
                  onPressed: () async {
                    if (_form.currentState.validate()) {
                      _form.currentState.save();
                      var _data = await modifiyLoginPasswd(_loginPasswd);
                      if (_data.state) {
                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          _errText = _data.messsage;
                        });
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
