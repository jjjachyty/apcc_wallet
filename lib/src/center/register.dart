import 'dart:async';

import 'package:apcc_wallet/src/center/captcha.dart' as prefix0;
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

RegExp passwdExp = RegExp(
    r'^[a-z0-9_-]{6,16}');


class UserRegister extends StatefulWidget {
  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  Timer _counter;
  var _leftCount = 0;
  int _opType = 0;
  String _phoneVal;
  String _sms1 = "", _sms2 = "", _sms3 = "", _sms4 = "";
  GlobalKey<FormFieldState> _phoneKey = new GlobalKey<FormFieldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FocusNode _sms2Node = new FocusNode() ,_sms3Node = new FocusNode(),_sms4Node = new FocusNode();
  bool _obscureFlag = true;
  var _scaffoldkey = new GlobalKey<ScaffoldState>();

  TextEditingController _passwdCtr = TextEditingController();


    void _startTimer(){
    setState(() {
        _leftCount= 60; 
      });
    _counter = countDown(59, (int left){
      setState(() {
        _leftCount= left; 
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
    return Scaffold(
      key: _scaffoldkey,
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
            autovalidate: true,
            maxLength: 16,
            obscureText: _obscureFlag,
            decoration: InputDecoration(
                hintText: "请输入6-16位密码",
                border: OutlineInputBorder(),
                counterText: "",
                suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye),onPressed: (){
                  setState(() {
                   _obscureFlag = !_obscureFlag; 
                  });
                },)
                ),
            validator: (val) {
              if (!passwdExp.hasMatch(val)) {
                return "请输入带字母或数字的6-16位密码";
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
                suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye),onPressed: (){
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
               var  _data=  await register(_phoneVal, _passwdCtr.text);
               if (_data["Status"] as bool){
                 Navigator.of(context).pop();
               }else{
                     _scaffoldkey.currentState.showSnackBar(SnackBar(
                              content: Text("注册失败"+_data["Message"]),
                              backgroundColor: Colors.red,
                            ));
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
                      hintText: "1",
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
                      hintText: "2",
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
                      hintText: "3",
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
                      hintText: "4",
                      counterText: "",
                      border: OutlineInputBorder()),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
          child: Text.rich(TextSpan(text: _leftCount==0?"重新发送":_leftCount.toString(),recognizer: TapGestureRecognizer()
                ..onTap = () async {
                   final _result = await Navigator.of(context).push(
                     PageRouteBuilder(
                       pageBuilder: (context,am1,am2){
                         return prefix0.Captcha(this._phoneVal);
                       }
                     )
                   );
                         if (_result !=null && _result as bool){
                  _startTimer();
                         }
                })),
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
            var sms = (_sms1+_sms2+_sms3+_sms4).trim();
            if (sms.length == 4 && await verificationSms(this._phoneVal,sms)) {
              setState(() {
                _opType = 2;
                _counter.cancel();
              });
            }else{
             _scaffoldkey.currentState.showSnackBar(SnackBar(
                              content: Text("验证码校验错误"),
                              backgroundColor: Colors.red,
                            ));
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
                  suffixIcon: 
                     FlatButton(
                      child: Text(
                        "下一步",
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () async {
                        if (_phoneKey.currentState.validate()) {
                          _phoneKey.currentState.save();
                         final _result = await Navigator.of(context).push(
                           PageRouteBuilder(pageBuilder: (context,animation1,animation2){
                             return prefix0.Captcha(this._phoneVal);
                             })
                         );
                         if (_result !=null && _result){
                           _startTimer();
                          setState(() {
                            _opType = 1;
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
              style: TextStyle(fontSize: 12,color: Colors.grey),
              children: [
                TextSpan(text: "用户注册协议",style: TextStyle(color: Colors.blue), recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                         print("用户注册协议");
                        },)
              ]            )),
      ],
    );
  }
}
