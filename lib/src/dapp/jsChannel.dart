import 'dart:async';
import 'dart:convert';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/dapp/contract.dart';
import 'package:apcc_wallet/src/dapp/dapp.dart';
import 'package:apcc_wallet/src/dapp/common.dart';
import 'package:apcc_wallet/src/model/dapp.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:web3dart/web3dart.dart';

Set<JavascriptChannel> getJsChannel() {
  Set<JavascriptChannel> _jsChannel = new Set<JavascriptChannel>();
  _jsChannel.add(_mhc());
  return _jsChannel;
}

JavascriptChannel _mhc() {
  return JavascriptChannel(
      name: 'MHC',
      onMessageReceived: (JavascriptMessage message) async {
        if (user == null) {
          Navigator.of(dappContext).pushNamed("/login");
          return null;
        }
        var _req = json.decode(message.message);
        print("_req$_req");
        var _data = _req["data"];
        var _callback = _req["callback"];

        switch (_req["method"]) {
          case "toaster": //消息提示

            Scaffold.of(dappContext).showSnackBar(
              SnackBar(
                content: Text(_data["content"]),
                backgroundColor: _data["backgroundColor"] == null
                    ? Colors.indigo
                    : Color(_data["backgroundColor"]),
                duration: Duration(seconds: 4),
              ),
            );

            break;
          case "address": //获取用户地址
            callBack(address[0].val, "", _callback);
            break;
          case "scan":
            break;
          case "close":
            Navigator.of(dappContext).pop();
            // FlutterWebviewPlugin().close();

            break;
          case "reload":
            FlutterWebviewPlugin().reload();
            break;
          case "contract_call": //智能合约payable调用
            var _vals = ContractVars.fromJson(_data);

            var contractInstance =
                getContractInstance(_vals.abiCode, _vals.name, _vals.address);
            if (contractInstance.function(_vals.method).mutability ==
                StateMutability.view) {
              call(_vals, _callback);
            } else {
              callPayable(_vals, _callback);
            }
            break;
          default:
        }
      });
}
