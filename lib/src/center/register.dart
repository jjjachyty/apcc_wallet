import 'dart:async';

import 'package:apcc_wallet/src/center/captcha.dart' as prefix0;

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';

import 'package:apcc_wallet/src/model/captcha.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

class UserRegister extends StatefulWidget {
  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  Timer _counter;
  var _leftCount = 0;
  int _opType = 0;
  String _phoneVal;
  String _sms1 = "", _sms2 = "", _sms3 = "", _sms4 = "", _errorText;
  GlobalKey<FormFieldState> _phoneKey = new GlobalKey<FormFieldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _sms2Node = new FocusNode(),
      _sms3Node = new FocusNode(),
      _sms4Node = new FocusNode();
  bool _obscureFlag = true;
  var _scaffoldkey = new GlobalKey<ScaffoldState>();

  TextEditingController _passwdCtr = TextEditingController();

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
  void dispose() {
    super.dispose();
    if (_counter != null) {
      _counter.cancel();
    }
    _passwdCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          
            body: 
            Stack(
              children: <Widget>[
AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
Center(
              child: 
            Container(
                 height: 390,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(Radius.circular(20.0)),
                ),
                // margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  Text(
                    "注册",
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    "SIGN UP",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // _opType == 0
                      // ? _phone()
                      // : _opType == 1 ? _smsCode() : _passwd(),
                       _passwd(),
                  Divider(),
                  Text.rich(new TextSpan(
                      text: '已有账号? ',
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w400),
                      children: [
                        TextSpan(
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pop();
                              },
                            text: '去登录',
                            style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.indigo,
                              fontWeight: FontWeight.w400,
                            ))
                      ])),
                ])),
            ),
              ],
            ),
            
            backgroundColor: Colors.transparent));
  }

  Widget _passwd() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _passwdCtr,
            autovalidate: true,
            maxLength: 16,
            obscureText: _obscureFlag,
            decoration: InputDecoration(
                hintText: "请输入16位密码",
                border: OutlineInputBorder(),
                counterText: "",
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    setState(() {
                      _obscureFlag = !_obscureFlag;
                    });
                  },
                )),
            validator: (val) {
              if (!passwdExp.hasMatch(val)) {
                return "请输入包含大小写字母及数字的16位密码";
              }
            },
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            maxLength: 16,
            obscureText: _obscureFlag,
            autovalidate: true,
            decoration: InputDecoration(
              hintText: "请再次输入密码",
              border: OutlineInputBorder(),
              counterText: "",
              suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    setState(() {
                      _obscureFlag = !_obscureFlag;
                    });
                  }),
            ),
            validator: (val) {
              if (val != _passwdCtr.text) {
                return "两次密码不一致";
              }
            },
          ),
          SizedBox(
            height: 20,
            child: Text(_errorText ?? "", style: TextStyle(color: Colors.red)),
          ),
          ProgressButton(
            defaultWidget: Text(
              "注册",
              style: TextStyle(color: Colors.white),
            ),
            progressWidget: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
            onPressed: () async {
           
              if (_formKey.currentState.validate()) {
                var _data = await register(_phoneVal, _passwdCtr.text);
                if (_data.state) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  var dialog = CupertinoAlertDialog(
                    content: Text(
                      "恭喜,注册成功",
                    ),
                    actions: <Widget>[
                      CupertinoButton(
                        child: Text("去登录"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                  showDialog(context: context, builder: (_) => dialog);
                } else {
                  setState(() {
                    _errorText = _data.messsage;
                  });
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _smsCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 100,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 50,
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      _sms1 = val;
                    });
                    if (val != "") {
                      FocusScope.of(context).requestFocus(_sms2Node);
                    }
                  },
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  decoration: InputDecoration(
                      // hintText: "1",
                      counterText: "",
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  focusNode: _sms2Node,
                  onChanged: (val) {
                    setState(() {
                      _sms2 = val;
                    });
                    if (val != "") {
                      FocusScope.of(context).requestFocus(_sms3Node);
                    }
                  },
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      // hintText: "2",
                      counterText: "",
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  focusNode: _sms3Node,
                  onChanged: (val) {
                    setState(() {
                      _sms3 = val;
                    });
                    if (val != "") {
                      FocusScope.of(context).requestFocus(_sms4Node);
                    }
                  },
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      // hintText: "3",
                      counterText: "",
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  focusNode: _sms4Node,
                  onChanged: (val) {
                    setState(() {
                      _sms4 = val;
                    });
                  },
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  decoration: InputDecoration(
                      // hintText: "4",
                      counterText: "",
                      border: OutlineInputBorder()),
                ),
              )
            ],
          ),
        ),
        Text(
          _errorText ?? "",
          style: TextStyle(color: Colors.red),
        ),
        SizedBox(
          height: 30,
          child: Text.rich(TextSpan(
              text: _leftCount == 0 ? "重新发送" : _leftCount.toString(),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final _result = await Navigator.of(context)
                      .push(PageRouteBuilder(pageBuilder: (context, am1, am2) {
                    return prefix0.Captcha(this._phoneVal);
                  }));
                  if (_result != null && _result as bool) {
                    _startTimer();
                  }
                })),
        ),
        ProgressButton(
          defaultWidget: Text(
            "确认",
            style: TextStyle(color: Colors.white),
          ),
          progressWidget: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
          onPressed: () async {
            var sms = (_sms1 + _sms2 + _sms3 + _sms4).trim();
            if (sms.length == 4 && await verificationSms(this._phoneVal, sms)) {
              setState(() {
                _errorText = "";
                _opType = 2;
                _counter.cancel();
              });
            } else {
              setState(() {
                _errorText = "短信验证码校验失败";
              });
            }
          },
        ),
      ],
    );
  }

  Widget _phone() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              key: _phoneKey,
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
                  errorText: _errorText,
                  // prefixIcon: Icon(
                  //   Icons.phone_iphone,
                  //   color: Colors.indigo,
                  // ),
                  suffixStyle: TextStyle(),
                  suffixIcon: FlatButton(
                    child: Text(
                      "下一步",
                      style: TextStyle(color: Colors.indigo),
                    ),
                    onPressed: () async {
                      if (_phoneKey.currentState.validate()) {
                        _phoneKey.currentState.save();
                        var _phonecanreg = await checkPhone(this._phoneVal);
                        if (_phonecanreg.state) {
                          final _result = await Navigator.of(context).push(
                              PageRouteBuilder(pageBuilder:
                                  (context, animation1, animation2) {
                            return prefix0.Captcha(this._phoneVal);
                          }));
                          if (_result != null && _result) {
                            _startTimer();
                            setState(() {
                              _opType = 1;
                            });
                          }
                        } else {
                          setState(() {
                            _errorText = _phonecanreg.messsage;
                          });
                        }
                      }
                    },
                  ),
                  border: OutlineInputBorder()),
              onSaved: (val) {
                setState(() {
                  _phoneVal = val;
                });
              },
            )),
        Text.rich(TextSpan(
            text: "点击下一步表示已经同意",
            style: TextStyle(fontSize: 12, color: Colors.grey),
            children: [
              TextSpan(
                text: "用户注册协议",
                style: TextStyle(color: Colors.indigo),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pushNamed("/notice");
                  },
              )
            ])),
      ],
    );
  }
}
