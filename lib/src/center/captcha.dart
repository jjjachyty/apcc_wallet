import 'package:apcc_wallet/src/model/captcha.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

class Captcha extends StatefulWidget {
  String phone;
  @override
  _CaptchaState createState() => _CaptchaState();
}

class _CaptchaState extends State<Captcha> {
  var _scaffoldkey = new GlobalKey<ScaffoldState>();

  var _capturl =
      "https://image-static.segmentfault.com/294/057/2940574844-5a40a8a328ff1_articlex";
  GlobalKey<FormFieldState> _input = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text("验证码"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Image.network(
              _capturl,
              height: 200,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                key: _input,
                maxLength: 6,
                validator: (val) {
                  if (val == null || val.length != 6) {
                    return "请输入6位验证码";
                  }
                },
                decoration: InputDecoration(
                  errorText: null,
                  hintText: "请输入图片上的验证码",
                  border: OutlineInputBorder(),
                  suffixIcon: Container(
                    color: Colors.green,
                    width: 80,
                    height: 55,
                    padding: EdgeInsets.zero,
                    child: new ProgressButton(
                      color: Colors.green,
                      defaultWidget: Text(
                        "确认",
                        style: TextStyle(color: Colors.white),
                      ),
                      progressWidget: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
                      onPressed: () async {
                        if (_input.currentState.validate()) {
                          if (await verificationCaptcha()) {
                            Navigator.of(context).pop();
                          } else {
                            _scaffoldkey.currentState.showSnackBar(SnackBar(
                              content: Text("验证码校验错误,请重新输入"),
                              backgroundColor: Colors.red,
                            ));
                            _input.currentState.reset();

                            setState(() {
                              _capturl =
                                  "https://image-static.segmentfault.com/294/057/2940574844-5a40a8a328ff1_articlex";
                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
