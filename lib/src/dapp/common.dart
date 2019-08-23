import 'dart:convert';

import 'package:apcc_wallet/src/model/dapp.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContractVars{
  @required String abiCode ;
  @required String address;
  @required String name;
  @required String method;
  List<dynamic> parameters;
  num gas;
  BigInt value;
  ContractVars(this.abiCode,this.address,this.name,this.method,{this.parameters,this.gas});
  ContractVars.fromJson(Map<String, dynamic> data):this.abiCode=data["abiCode"],this.address=data["address"],this.name=data["name"],this.method=data["method"],this.parameters=getParameters(data["parameters"]),
  this.gas=data["gas"]??2100,this.value=BigInt.from(data["value"]??0);
}





Future<WebViewController> dappController;
Dapp app;
BuildContext dappContext;

//回调浏览器callback方法
void callBack(dynamic callbackParams, String error,String callback) async {
  if (callback != null) {
    (await dappController)
        .evaluateJavascript("window.mhcCallBacks." +
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
  return json.encode({"state": err==""?true:false, "data": returnParameter(params), "error": err});
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
