// import 'dart:convert';

import 'dart:convert';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/dapp/dapp.dart';
import 'package:apcc_wallet/src/dapp/dapp_full.dart';
import 'package:apcc_wallet/src/dapp/developing.dart';
import 'package:apcc_wallet/src/model/dapp.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:web3dart/web3dart.dart';

class ContractVars {
  @required
  String abiCode;
  @required
  String address;
  @required
  String name;
  @required
  String method;
  List<dynamic> parameters;
  num gas;
  BigInt value;
  ContractVars(this.abiCode, this.address, this.name, this.method,
      {this.parameters, this.gas});
  ContractVars.fromJson(Map<String, dynamic> data)
      : this.abiCode = data["abiCode"],
        this.address = data["address"],
        this.name = data["name"],
        this.method = data["method"],
        this.parameters = getParameters(data["parameters"]),
        this.gas = data["gas"] ?? 2100,
        this.value = BigInt.from(data["value"] ?? 0);
}

final dappController = FlutterWebviewPlugin();
Dapp app;
BuildContext dappContext;

//回调浏览器callback方法
void callBack(dynamic callbackParams, String error, String callback) async {
  if (callback != null) {
    dappController
        .evalJavascript("window.mhcCallBacks." +
            callback +
            "(" +
            returnCallBack(callbackParams, error) +
            ")")
        .then((value) {
      print(value);
    }).catchError((err) {
      print(err);
    });
  }
}

//处理浏览器传值
List getParameters(dynamic parameters) {
  var _newParams = new List();
  parameters.forEach((item) {
    switch (item["type"]) {
      case "address":
        _newParams.add(EthereumAddress.fromHex(item["value"]));
        break;
      case "bigInt":
        _newParams.add(BigInt.from(item["value"]));
        break;

      default:
        _newParams.add(item["value"]);
    }
  });
  return _newParams;
}

//处理消息
returnCallBack(dynamic params, String err) {
  return json.encode({
    "state": err == "" ? true : false,
    "data": returnParameter(params),
    "error": err
  });
}

//处理返回参数
String returnParameter(dynamic params) {
  if (params is List) {
    return json.encode(caseList(params));
  } else if (params is EthereumAddress) {
    return params.hex;
  } else {
    return params.toString();
  }
}

//递归处理List
List caseList(items) {
  var _newParams = new List();
  (items as List).forEach((item) {
    if (item is BigInt) {
      _newParams.add(item.toString());
    } else if (item is EthereumAddress) {
      _newParams.add(item.hex);
    } else if (item is List) {
      _newParams.addAll(caseList(item));
    } else {
      _newParams.add(item);
    }
  });
  return _newParams;
}

//Dapp 检查
launchDapp(BuildContext context, Dapp app) {
  if(user==null){
        showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              content: Text(
                "尚未登录,请先登录",
              ),
              actions: <Widget>[
                CupertinoButton(
                  child: Text("确定"),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/login");
                  },
                ),
              ],
            ));
  }else if (address == null || address.length == 0) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              content: Text(
                "Dapp需要使用本地钱包地址,请先创建钱包或者导入钱包",
              ),
              actions: <Widget>[
                CupertinoButton(
                  child: Text("确定"),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/wallet/new");
                  },
                ),
              ],
            ));
  } else {
    if (app.homePage == "") {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Developing(app);
      }));
    } else {
      if (app.fullScreen==1){
      Navigator.push(context, PageRouteBuilder(pageBuilder:
          (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
        return ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: DappFullPage(app));
      }));
      }else{
              Navigator.push(context, PageRouteBuilder(pageBuilder:
          (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
        return ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: DappPage(app));
      }));
      }

    }
  }
}
