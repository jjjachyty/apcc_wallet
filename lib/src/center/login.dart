import 'dart:async';

import 'package:apcc_wallet/src/center/captcha.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

RegExp phoneExp = RegExp(
    r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  Timer _counter;
  var _leftCount = 0;
  var _phoneVal, _passwordVal, _smsVal, _errText;
  bool _opType = true, _obscureFlag = true;

  GlobalKey<FormState> _loginForm = new GlobalKey<FormState>();
  GlobalKey<FormFieldState> _phoneKey = new GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> _smsKey = new GlobalKey<FormFieldState>();

  TextEditingController _phoneCtr = new TextEditingController();
  @override
  void dispose() {
    super.dispose();
    if (_counter != null) {
      _counter.cancel();
    }
    _phoneCtr.dispose();
  }

  void _startTimer() {
    setState(() {
      _leftCount = 60;
    });
    _counter = countDown(59, (int left) {
      setState(() {
        _leftCount = left;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_bg.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                body: Center(
                    child: Container(
                        height: 350,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              new BorderRadius.all(Radius.circular(20.0)),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                          Text(
                            "登录",
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            "LOGIN IN",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _opType ? _passwdLogin() : _smsLogin(),
                        ]))),
                backgroundColor: Colors.transparent)));
  }

  Widget _passwdLogin() {
    return Form(
        key: _loginForm,
        child: Column(children: <Widget>[
          TextFormField(
            key: _phoneKey,
            controller: _phoneCtr,
            keyboardType: TextInputType.phone,
            maxLength: 11,
            validator: (phone) {
              if (!phoneExp.hasMatch(phone)) {
                return "手机号码不正确";
              }
            },
            decoration: InputDecoration(
                labelText: "手机号",
                // contentPadding: EdgeInsets.zero,
                counterText: "",
                // hintText: "手机号",
                // prefixIcon: Icon(
                //   Icons.phone_iphone,
                //   color: Colors.indigo,
                // ),
                border: OutlineInputBorder()),
            onSaved: (val) {
              setState(() {
                _phoneVal = val;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: _obscureFlag,
            maxLength: 16,
            validator: (val) {
              if (val.length < 6) {
                return "密码为6-16位";
              }
            },
            decoration: InputDecoration(
                // contentPadding: EdgeInsets.zero,
                labelText: "密码",
                hintText: "密码",
                counterText: "",
                errorText: _errText,
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    setState(() {
                      this._obscureFlag = !this._obscureFlag;
                    });
                  },
                ),
                // prefixIcon: Icon(
                //   Icons.lock,
                //   color: Colors.indigo,
                // ),
                border: OutlineInputBorder()),
            onSaved: (val) {
              setState(() {
                _passwordVal = val;
              });
            },
          ),
          SizedBox(
              height: 30,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _opType = false;
                  });
                },
                child: Text(
                  "短信验证码登录",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.end,
                ),
              )),
          ProgressButton(
            color: Colors.indigo,
            defaultWidget: Text(
              "登录",
              style: TextStyle(color: Colors.white),
            ),
            progressWidget: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
            onPressed: () async {
              var _formState = _loginForm.currentState;
              if (_formState.validate()) {
                _formState.save();

                // int score = await Future.delayed(
                //     const Duration(milliseconds: 3000), () {
                //   print("object close");
                // });
                // // // // After [onPressed], it will trigger animation running backwards, from end to beginning

                // return () async {
                var _data = await loginWithPW(_phoneVal, _passwordVal);

                if (_data.state) {
                  // eventBus.fire(UserInfoUpdate(null));
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    _errText = _data.messsage;
                  });
                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text(_data.messsage)));
                }
              }

              // }
            },
          ),
          SizedBox(
            height: 20,
          ),
          _goRegister(),
        ]));
  }

  Widget _smsCode() {
    return TextField(
      decoration: InputDecoration(hintText: "请输入验证码"),
    );
  }

  Widget _smsLogin() {
    return Form(
        key: _loginForm,
        child: Container(
            child: Column(children: <Widget>[
          TextFormField(
            key: _phoneKey,
            controller: _phoneCtr,
            keyboardType: TextInputType.phone,
            maxLength: 11,
            validator: (phone) {
              if (!phoneExp.hasMatch(phone)) {
                return "手机号码不正确";
              }
            },
            decoration: InputDecoration(
                labelText: "手机号",
                // contentPadding: EdgeInsets.zero,
                counterText: "",
                // hintText: "手机号",
                // prefixIcon: Icon(
                //   Icons.phone_iphone,
                //   color: Colors.indigo,
                // ),
                border: OutlineInputBorder()),
            onSaved: (val) {
              setState(() {
                _phoneVal = val;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Image.network(
              //   "https://image-static.segmentfault.com/294/057/2940574844-5a40a8a328ff1_articlex",
              //   height: 40,
              //   width: MediaQuery.of(context).size.width * 0.5,
              // ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextFormField(
                    key: _smsKey,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    validator: (sms) {
                      if (sms == null || sms.length != 4) {
                        return "请输入正确的验证码";
                      }
                    },
                    decoration: InputDecoration(
                        // contentPadding: EdgeInsets.zero,
                        labelText: "验证码",
                        hintText: "验证码",
                        counterText: "",
                        // prefixIcon: Icon(
                        //   Icons.sms,
                        //   color: Colors.indigo,
                        // ),
                        border: OutlineInputBorder()),
                    onSaved: (val) {
                      setState(() {
                        _smsVal = val;
                      });
                    },
                  )),

              FlatButton(
                padding: EdgeInsets.zero,
                child: Text(
                  _leftCount == 0 ? "发送验证码" : _leftCount.toString(),
                  style: TextStyle(color: Colors.indigo),
                ),
                onPressed: _leftCount == 0
                    ? () async {
                        if (_phoneKey.currentState.validate()) {
                          _phoneKey.currentState.save();
                          final _result = await Navigator.of(context).push(
                              PageRouteBuilder(pageBuilder:
                                  (context, animation1, animation2) {
                            return Captcha(this._phoneVal);
                          }));
                          if (_result != null && _result) {
                            _startTimer();
                          }
                        } else {
                          _phoneKey.currentState.validate();
                        }
                      }
                    : null,
              )
            ],
          ),
          SizedBox(
              height: 30,
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _opType = true;
                  });
                },
                child: Text(
                  "使用密码登录",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
              )),
          SizedBox(
            width: double.infinity,
            child: new ProgressButton(
              color: Colors.indigo,
              defaultWidget: Text(
                "登录",
                style: TextStyle(color: Colors.white),
              ),
              progressWidget: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
              onPressed: () async {
                var _formState = _loginForm.currentState;
                if (_formState.validate()) {
                  _formState.save();

                  var _data = await loginWithSMS(_phoneVal, _smsVal);
                  if (_data.state) {
                    Navigator.of(context)
                        .pop(User.fromJson(_data.data["User"]));
                  } else {
                    _smsKey.currentState.reset();
                    _smsKey.currentState.validate();
                  }
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _goRegister(),
        ])));
  }

  Widget _goRegister() {
    return Text.rich(new TextSpan(
        text: '还没账号? ',
        style: new TextStyle(
            fontSize: 14.0,
            color: Colors.grey[500],
            fontWeight: FontWeight.w400),
        children: [
          TextSpan(
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushNamed("/register");
                },
              text: '去注册',
              style: new TextStyle(
                fontSize: 14.0,
                color: Colors.indigo,
                fontWeight: FontWeight.w400,
              ))
        ]));
  }
}
