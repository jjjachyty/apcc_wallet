import 'dart:async';

import 'package:apcc_wallet/src/center/index.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/main/main.dart';
import 'package:apcc_wallet/src/model/captcha.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:apcc_wallet/src/store/actions.dart';
import 'package:apcc_wallet/src/store/state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

RegExp phoneExp = RegExp(
    r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

class UserRegister extends StatefulWidget {
  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  Timer _countdonwn;
  var _leftCount = 0;
  int _opType = 2;
  String _phoneVal;
  String _sms1, _sms2, _sms3, _sms4;
  GlobalKey<FormFieldState> _phoneKey = new GlobalKey<FormFieldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextEditingController _passwdCtr = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    if (_countdonwn != null) {
      _countdonwn.cancel();
    }
    _passwdCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        body: Column(
          children: <Widget>[
            new Stack(children: <Widget>[
              Image.network(
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561036531223&di=55a931822b6fe5faefbe8b276b821c75&imgtype=jpg&src=http%3A%2F%2Fres.rongzi.com%2Fcontent%2Fupload%2Fimages%2Fueditor%2F20160606%2F6360080025278760485574019.jpg",
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.fill,
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                child: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    "注册",
                  ),
                ),

                // backgroundColor: Colors.transparent,
              )
            ]),
            Container(
              padding: EdgeInsets.all(8),
              child: _opType == 0
                  ? _phone()
                  : _opType == 1 ? _smsCode() : _passwd(),
            ),
            SizedBox(
              height: 10,
            ),
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
                          setState(() {
                            _opType = 0;
                          });
                        },
                      text: '去登录',
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                      ))
                ])),
          ],
        ));
  }

  Widget _passwd() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _passwdCtr,
            maxLength: 16,
            obscureText: true,
            decoration: InputDecoration(
                hintText: "请输入6-16位密码",
                border: OutlineInputBorder(),
                counterText: ""),
            validator: (val) {
              if (val == "" || val.length < 6 || val.length > 16) {
                return "请输入6-16位密码";
              }
            },
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            maxLength: 16,
            obscureText: true,
            decoration: InputDecoration(
                hintText: "请再次输入密码",
                border: OutlineInputBorder(),
                counterText: ""),
            validator: (val) {
              if (val != _passwdCtr.text) {
                return "两次密码不一致";
              }
            },
          ),
          SizedBox(
            height: 15,
          ),
          ProgressButton(
            color: Colors.green,
            defaultWidget: Text(
              "注册",
              style: TextStyle(color: Colors.white),
            ),
            progressWidget: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await register(_phoneVal, _passwdCtr.text);
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
          child: Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return "";
                      }
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                        hintText: "1",
                        counterText: "",
                        border: OutlineInputBorder()),
                    onSaved: (val) {
                      _sms1 = val;
                    },
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return "";
                      }
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "2",
                        counterText: "",
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return "";
                      }
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "3",
                        counterText: "",
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return "";
                      }
                    },
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                        hintText: "4",
                        counterText: "",
                        border: OutlineInputBorder()),
                  ),
                )
              ],
            ),
          ),
        ),
        ProgressButton(
          color: Colors.green,
          defaultWidget: Text(
            "确认",
            style: TextStyle(color: Colors.white),
          ),
          progressWidget: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
          onPressed: () async {
            if (_formKey.currentState.validate() || await verificationSms()) {
              setState(() {
                _opType = 2;
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
                  // hintText: "手���号",
                  prefixIcon: Icon(
                    Icons.phone_iphone,
                    color: Colors.green,
                  ),
                  suffixStyle: TextStyle(),
                  suffixIcon: Container(
                    color: Colors.green,
                    width: 80,
                    height: 55,
                    padding: EdgeInsets.zero,
                    child: IconButton(
                      icon: Text(
                        "下一步",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_phoneKey.currentState.validate()) {
                          _phoneKey.currentState.save();
                          await Navigator.of(context).pushNamed("/captcha");

                          setState(() {
                            _opType = 1;
                          });
                        }
                      },
                    ),
                  ),
                  border: OutlineInputBorder()),
              onSaved: (val) {
                _phoneVal = val;
              },
            ))
      ],
    );
  }
}
