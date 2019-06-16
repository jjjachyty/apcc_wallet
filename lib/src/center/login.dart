import 'dart:async';

import 'package:apcc_wallet/src/center/index.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/main/main.dart';
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

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  Timer _countdonwn;
  var _leftCount = 0;
  GlobalKey<FormState> _loginForm = new GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_countdonwn != null) {
      _countdonwn.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   title: Text("登录"),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        body: Column(
          children: <Widget>[
            new Stack(children: <Widget>[
              Image.network(
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561258674&di=3f890ec18f85e5c686951197f9d206ec&imgtype=jpg&er=1&src=http%3A%2F%2Fwww.gmqgroup.com%2Fdata%2Fupload%2Fueditor%2F20180412%2F5acf19258e7f9.jpg",
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    "登录",
                  ),
                ),

                // backgroundColor: Colors.transparent,
              ),
            ]),
            Form(
              key: _loginForm,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      validator: (phone) {
                        if (!phoneExp.hasMatch(phone)) {
                          return "手机号码不正确";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "手机号",
                          contentPadding: EdgeInsets.zero,
                          counterText: "",
                          // hintText: "手机号",
                          prefixIcon: Icon(
                            Icons.phone_iphone,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width * 0.66,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              validator: (sms) {
                                if (sms == null || sms.length != 4) {
                                  return "请输入正确的验证码";
                                }
                              },
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0),
                                  labelText: "验证码",
                                  hintText: "验证码",
                                  counterText: "",
                                  prefixIcon: Icon(
                                    Icons.sms,
                                    color: Colors.green,
                                  ),
                                  border: OutlineInputBorder()),
                            )),
                        FlatButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            _leftCount == 0 ? "发送验证码" : _leftCount.toString(),
                            style: TextStyle(color: Colors.green),
                          ),
                          onPressed: _leftCount == 0
                              ? () {
                                  setState(() {
                                    _leftCount = 60;
                                  });
                                  //验证
                                  _countdonwn =
                                      countDown(_leftCount, (int count) {
                                    setState(() {
                                      _leftCount = count;
                                    });
                                  });
                                }
                              : null,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      obscureText: true,
                      maxLength: 16,
                      validator: (val) {
                        if (val.length < 6) {
                          return "密码为6-16位";
                        }
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          labelText: "密码",
                          hintText: "密码",
                          counterText: "",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    new StoreConnector<AppState, Store<AppState>>(
                        converter: (store) => store,
                        builder: (context, store) {
                          return new ProgressButton(
                            color: Colors.green,
                            defaultWidget: Text(
                              "登录",
                              style: TextStyle(color: Colors.white),
                            ),
                            progressWidget: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.lightGreen)),
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
                                var user = await login(
                                    User(
                                        phone: "15520010009",
                                        passWord: "12121212",
                                        nickName: "0009",
                                        avatar:
                                            "http://b-ssl.duitang.com/uploads/item/201608/21/20160821230024_MyCYK.thumb.700_0.jpeg"),
                                    "1245");
                                // // Optional returns is returning a VoidCallback that will be called
                                // // after the animation is stopped at the beginning.
                                // // A best practice would be to do time-consuming task in [onPressed],
                                // // and do page navigation in the returned VoidCallback.
                                // // So that user won't missed out the reverse animation.
                                print("user");
                                if (user.nickName != "") {
                                  store.dispatch(RefreshUserAction(user));
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) {
                                    return MainPage();
                                  }), (router) => false);
                                }
                              }
                              ;
                              // }
                            },
                          );
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    new Text.rich(
                      new TextSpan(
                          text: '点击发送按钮代表已同意 ',
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400),
                          children: [
                            new TextSpan(
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    print("xxx");
                                  },
                                text: '用户协议',
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400,
                                )),
                            new TextSpan(
                                text: ' 和 ',
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w400,
                                )),
                            new TextSpan(
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    print("object");
                                  },
                                text: '隐私政策',
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400,
                                )),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
