import 'package:apcc_wallet/src/dapp/pay.dart';
import 'package:apcc_wallet/src/dapp/dapp.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'common.dart';

call(ContractVars vals, String callBackName) async {
  try {
    var _callbackParams = await callContract(
        vals.abiCode, vals.address, vals.name, vals.method, vals.parameters);
    callBack(_callbackParams, "", callBackName);
  } catch (e) {
    callBack("", e.toString(), callBackName);
  }
}

callPayable(ContractVars vals, String callBackName) async {
  var _price = await getGasPrice();
  var _gasMHC = _price.getInWei *
      BigInt.from(vals.gas) /
      BigInt.from(1000000000000000000);
  FlutterWebviewPlugin().hide();

  Scaffold.of(dappContext).showBottomSheet((context) {
    return Container(
        height: 300,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: <Widget>[
            ListTile(
                // leading: Image(
                //   image: CachedNetworkImageProvider(_app.logo),
                //   width: 40,
                //   height: 40,
                // ),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                    FlutterWebviewPlugin().show();
                  },
                ),
                title: Text.rich(TextSpan(
                  text: "该操作需要支付MHC",
                  style: TextStyle(color: Colors.indigo),
                ))),
            Divider(),
            ListTile(
              enabled: false,
              leading: Text("金额"),
              trailing: Text(
                  (vals.value / BigInt.from(1000000000000000000)).toString() +
                      "MHC"),
            ),
            ListTile(
              enabled: false,
              leading: Text("Gas"),
              trailing: Text(_gasMHC.toStringAsFixed(8) + " MHC"),
            ),
            ListTile(
              enabled: false,
              leading: Text("Gas单价"),
              trailing: Text(_price.getInWei.toString() + " Wei"),
            ),
            ProgressButton(
                defaultWidget: Text(
                  "支付",
                  style: TextStyle(color: Colors.white),
                ),
                progressWidget: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
                onPressed: () async {
                  Navigator.of(context).pop();
                  showPasswd(vals, callBackName);
                }),
          ],
        ));
  });

  // showModalBottomSheet(
  //     // isScrollControlled: true,

  //     context: dappContext,
  //     builder: (BuildContext context) {
  //       return Container(
  //           height: 300,
  //           padding: EdgeInsets.symmetric(horizontal: 8),
  //           child: Column(
  //             children: <Widget>[
  //               ListTile(
  //                   // leading: Image(
  //                   //   image: CachedNetworkImageProvider(_app.logo),
  //                   //   width: 40,
  //                   //   height: 40,
  //                   // ),
  //                   trailing: IconButton(
  //                     icon: Icon(Icons.close),
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                       FlutterWebviewPlugin().show();
  //                     },
  //                   ),
  //                   title: Text.rich(TextSpan(
  //                     text: "该操作需要支付MHC",
  //                     style: TextStyle(color: Colors.indigo),
  //                   ))),
  //               Divider(),
  //               ListTile(
  //                 enabled: false,
  //                 leading: Text("金额"),
  //                 trailing: Text((vals.value / BigInt.from(1000000000000000000)).toString() + "MHC"),
  //               ),
  //               ListTile(
  //                 enabled: false,
  //                 leading: Text("Gas"),
  //                 trailing: Text(_gasMHC.toStringAsFixed(8) + " MHC"),
  //               ),
  //               ListTile(
  //                 enabled: false,
  //                 leading: Text("Gas单价"),
  //                 trailing: Text(_price.getInWei.toString() + " Wei"),
  //               ),
  //               ProgressButton(
  //                   color: Colors.indigo,
  //                   defaultWidget: Text(
  //                     "支付",
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                   progressWidget: CircularProgressIndicator(
  //                       backgroundColor: Colors.white,
  //                       valueColor:
  //                           AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
  //                   onPressed: () async {
  //                     Navigator.of(context).pop();
  //                     showPasswd(vals,callBackName);
  //                   }),
  //             ],
  //           ));
  //     },
  //     elevation: 10.0);
}

// transfer(ContractVars vals, String callBackName) async {
//   print("methods ${vals.method}");
//   var _price = await getGasPrice();
//   var _gasMHC =
//       _price.getInWei * BigInt.from(vals.gas) / BigInt.from(1000000000000000000);
//   showModalBottomSheet(
//       // isScrollControlled: true,
//       context: dappContext,
//       builder: (BuildContext context) {
//         return Container(
//             height: 250,
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: Column(
//               children: <Widget>[
//                 ListTile(
//                     trailing: IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     title: Text.rich(TextSpan(
//                       text: "该操作需要支付MHC",
//                       style: TextStyle(color: Colors.indigo),
//                     ))),
//                 Divider(),
//                                 ListTile(
//                   enabled: false,
//                   leading: Text("金额"),
//                   trailing: Text(vals.parameters[1].toString() + "MHC"),
//                 ),
//                 ListTile(
//                   enabled: false,
//                   leading: Text("Gas"),
//                   trailing: Text(_gasMHC.toString() + " MHC"),
//                 ),
//                 ProgressButton(
//                     color: Colors.indigo,
//                     defaultWidget: Text(
//                       "支付",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     progressWidget: CircularProgressIndicator(
//                         backgroundColor: Colors.white,
//                         valueColor:
//                             AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
//                     onPressed: () async {
//                       Navigator.of(context).pop();

//                       showPasswd(vals,callBackName );
//                     }),
//               ],
//             ));
//       },
//       elevation: 10.0);
// }
