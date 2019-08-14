import 'dart:async';
import 'dart:convert';

import 'package:apcc_wallet/src/model/dapp.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:web3dart/web3dart.dart';
import 'package:webview_flutter/webview_flutter.dart';

Set<JavascriptChannel> getJsChannel(
    BuildContext context, Future<WebViewController> controller, Dapp app) {
  print("webViewControllerwebViewControllerwebViewController");
  Set<JavascriptChannel> _jsChannel = new Set<JavascriptChannel>();
  _jsChannel.add(_mhc(context, controller, app));
  return _jsChannel;
}

JavascriptChannel _mhc(
    BuildContext context, Future<WebViewController> controller, Dapp app) {
  // final _controller = controller;
  return JavascriptChannel(
      name: 'Mhc',
      onMessageReceived: (JavascriptMessage message) async {
        var _req = json.decode(message.message);
        print("_req$_req");
        var _data = _req["data"];
        var _callback = _req["callback"];
        var _callbackParams;
        switch (_req["method"]) {
          case "Toaster":
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(_data["content"]),
                backgroundColor: _data["backgroundColor"] == null
                    ? Colors.green
                    : Color(_data["backgroundColor"]),
                duration: Duration(seconds: 4),
              ),
            );
            break;
          case "GetAddress":
            var _call = "" + _callback + "('123123123123132123132')";

            return "11";
            break;
          case "callContract":
            var _abiCode = _data["abiCode"];
            var _address = _data["address"];
            var _name = _data["name"];
            var _functionName = _data["functionName"];
            var _parameters = _data["parameters"];
            _callbackParams = await callContract(_abiCode, _address, _name,
                _functionName, getParameters(_parameters));
            break;
          case "callContractPayable":
            var _abiCode = _data["abiCode"];
            var _address = _data["address"];
            var _name = _data["name"];
            var _functionName = _data["functionName"];
            var _parameters = _data["parameters"];
            var _gas = _data["gas"];
            var _price = await getGasPrice();
            var _gasMHC = _price.getInWei *
                BigInt.from(_gas) /
                BigInt.from(1000000000000000000);
            Scaffold.of(context).showBottomSheet((builder) {
              return Container(
                height: 250,
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: <Widget>[
                    ListTile(
                        trailing: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        title: Text.rich(TextSpan(
                            text: app.name,
                            style: TextStyle(color: Colors.green),
                            children: <InlineSpan>[
                              TextSpan(
                                  text: "请求支付",
                                  style: TextStyle(color: Colors.black))
                            ]))),
                    Divider(),
                    ListTile(
                      enabled: false,
                      leading: Text("Gas"),
                      trailing: Text(_gasMHC.toString() + " MHC"),
                    ),
                    ListTile(
                      enabled: false,
                      leading: Text("Gas单价"),
                      trailing: Text(_price.getInWei.toString() + " Wei"),
                    ),
                    ProgressButton(
                        color: Colors.green,
                        defaultWidget: Text(
                          "支付",
                          style: TextStyle(color: Colors.white),
                        ),
                        progressWidget: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.lightGreen)),
                        onPressed: () async {}),
                  ],
                ),
              );
            }, elevation: 100.0);
            // _callbackParams = await callContract(_abiCode, _address, _name,
            //     _functionName, getParameters(_parameters));
            break;
          default:
        }

        if (_callback != null) {
          (await controller)
              .evaluateJavascript("window.mhcCallBacks." +
                  _callback +
                  "(" +
                  returnParameter(_callbackParams) +
                  ")")
              .then((value) {
            print(value);
          }).catchError((err) {
            print(err);
          });
        }
      });
}

List getParameters(List _parameters) {
  var _newParams = new List();
  _parameters.forEach((item) {
    switch (item["type"]) {
      case "address":
        _newParams.add(EthereumAddress.fromHex(item["value"]));
        break;
      case "bigInt":
        _newParams.add(BigInt.from(item["value"]));
        break;

      default:
    }
  });
  return _newParams;
}

String returnParameter(dynamic params) {
  if (params is List) {
    return json.encode(caseList(params));
  } else if (params is BigInt) {
    return params.toString();
  } else if (params is EthereumAddress) {
    return params.hex;
  } else {
    return params.toString();
  }
}

List caseList(items) {
  var _newParams = new List();
  (items as List).forEach((item) {
    if (item is BigInt) {
      _newParams.add((item as BigInt).toString());
    } else if (item is EthereumAddress) {
      _newParams.add((item as EthereumAddress).hex);
    } else if (item is List) {
      _newParams.addAll(caseList(item));
    } else {
      _newParams.add(item);
    }
  });
  return _newParams;
}
