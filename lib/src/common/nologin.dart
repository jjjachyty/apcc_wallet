import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class NoLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(TextSpan(text: "未登录,请先", children: <TextSpan>[
        TextSpan(
            text: "登录",
            style: TextStyle(color: Colors.green),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pushNamed("/login");
              })
      ])),
    );
  }
}
