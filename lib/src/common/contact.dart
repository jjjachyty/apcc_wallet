import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("联系我们"),),
      body: Container(
        child: Text("""
        微信：xxxx
        微博: xxxx
        电话: 023-xxxxxx
        """),
      ),
    );
  }
}