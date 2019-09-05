//密码支付成功提示窗
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/payDialog.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:web3dart/json_rpc.dart';
import 'common.dart';

_showPaySuccessed(BuildContext context, String txs) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
            child: PayDialog(
                child: Container(
                    height: 230,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.check_circle,
                          color: Colors.indigo,
                          size: 50,
                        ),
                        Text("支付成功"),
                        Text("请15秒后刷新结果"),
                        Divider(),
                        MaterialButton(
                          child: Text("完成"),
                          color: Colors.indigo,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Navigator.of(context).pop();
                          },
                          minWidth: 200,
                        )
                      ],
                    ))));
      });
}

showPasswd(ContractVars vals, String callBackName) {
  GlobalKey<FormFieldState> passwordKey = new GlobalKey<FormFieldState>();

  var _password = "";
  var _payError;
  showDialog(
      barrierDismissible: false,
      context: dappContext,
      builder: (context) {
        return StatefulBuilder(builder: (context, state) {
          return PayDialog(
              child: Container(
                  height: 230,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("请输入支付密码"),
                        trailing: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                            FlutterWebviewPlugin().show();
                          },
                        ),
                      ),
                      Divider(),
                      TextFormField(
                        key: passwordKey,
                        keyboardType: TextInputType.text,
                        maxLength: 16,
                        obscureText: true,
                        autofocus: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "请输入16位支付密码",
                            errorText: _payError),
                        validator: (val) {
                          if (!passwdExp.hasMatch(val)) {
                            return "密码格式错误";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _password = val;
                        },
                      ),
                      Divider(),
                      ProgressButton(
                          color: Colors.indigo,
                          defaultWidget: Text(
                            "确认",
                            style: TextStyle(color: Colors.white),
                          ),
                          progressWidget: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.lightGreen)),
                          onPressed: () async {
                            state(() {
                              _payError = null;
                            });
                            if (passwordKey.currentState.validate()) {
                              passwordKey.currentState.save();

                              print(
                                  "vals.method====callContractPayable====${vals.method}");
                              try {
                                var val = await callContractPayable(
                                    vals.abiCode,
                                    vals.address,
                                    vals.name,
                                    vals.method,
                                    _password,
                                    vals.parameters,
                                    gas: vals.gas,
                                    value: vals.value);
                                print(
                                    "---callContractPayable-------------------$val");

                                callBack(val, "", callBackName);
                                Navigator.of(context).pop();
                                FlutterWebviewPlugin().show();

                                _showPaySuccessed(context, val);
                              } on ArgumentError catch (e) {
                                print(e);
                                state(() {
                                  _payError = "传入参数错误" + e.toString();
                                });
                              } on RPCError catch (e) {
                                if (e.errorCode == -32000) {
                                  state(() {
                                    _payError = "Gas+余额不足";
                                  });
                                }
                              } catch (e) {
                                state(() {
                                  _payError = e.toString();
                                });
                              }
                            }
                          }),
                    ],
                  )));
        });
      });
}
