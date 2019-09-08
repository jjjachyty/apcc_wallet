import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:apcc_wallet/src/hdwallet/private_key.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

class WalletPasswdPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _WalletPasswdState();
  }
}

class _WalletPasswdState extends State<WalletPasswdPage> {
  var _obscureFlag = true;
  String _passwd, _passwdConf;
  TextEditingController _passwdContrl = new TextEditingController();
  GlobalKey<FormState> _passwdForm = new GlobalKey<FormState>();

  Future _onSubmit() async {
    final form = _passwdForm.currentState;
    if (form.validate()) {
      form.save();
      var privateKey = await createMain(mnemonic, _passwdConf);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return PrivateKeyPage(privateKey);
      }), (route) => false);

      new Future.delayed(Duration(seconds: 1), () {
        post("/user/paypasswd", data: FormData.from({"payPassword": _passwd}));
      });
    }
  }

  Widget _buildWidget() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
            key: _passwdForm,
            child: new Column(
              children: <Widget>[
                new TextFormField(
                  controller: _passwdContrl,
                  obscureText: _obscureFlag,
                  maxLength: 16,
                  autovalidate: true,
                  decoration: new InputDecoration(
                      hintText: "请输入密码",
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
                  onSaved: (val) {
                    this._passwd = val;
                  },
                ),
                new TextFormField(
                  obscureText: _obscureFlag,
                  maxLength: 16,
                  decoration: new InputDecoration(
                      hintText: "请输入密码",
                      counterText: "",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            _obscureFlag = !_obscureFlag;
                          });
                        },
                      )),
                  autovalidate: true,
                  validator: (val) {
                    return (val != _passwdContrl.text) ? "两次密码不一致" : null;
                  },
                  onSaved: (val) {
                    this._passwdConf = val;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ProgressButton(
                    defaultWidget: Text(
                      "创建",
                      style: TextStyle(color: Colors.white),
                    ),
                    progressWidget: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
                    onPressed: () async {
                      await _onSubmit();
                    }),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("钱包密码"),
        centerTitle: true,
      ),
      body: _buildWidget(),
    );
  }
}
