import 'dart:async';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/store/state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../store/actions.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;

class ImportMnemonicPage extends StatefulWidget {
  @override
  _ImportMnemonicPageState createState() => _ImportMnemonicPageState();
}

class _ImportMnemonicPageState extends State<ImportMnemonicPage> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  String _mmic = "";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("导入钱包"),
        ),
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: ainAxisSize.,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Text("请依次输入12个助记词"),
            ),
            new Form(
                key: _formKey,
                child: Container(
                  height: 300,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, crossAxisSpacing: 10),
                    itemCount: 12,
                    //GridView内边距
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (buildContext, index) {
                      return TextFormField(
                        autofocus: index == 0 ? true : false,
                        decoration: InputDecoration(
                          hintText: (index + 1).toString(),
                        ),
                        validator: (val) {
                          if (val == null || val == "") {
                            return "不能为空";
                          }
                        },
                        onSaved: (val) {
                          _mmic += val;
                        },
                      );
                    },
                  ),
                )),
            new MaterialButton(
              minWidth: 200,
              color: Colors.green,
              textColor: Colors.white,
              child: new Text("确认"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _mmic = "";
                  _formKey.currentState.save();
                  if (_mmic.length == 12) {
                    mnemonic = _mmic.split('').join(" ").toString();
                    Navigator.pushNamed(context, "/wallet/passwd");
                  }
                }
              },
            )
          ],
        )));
  }
}
