import 'dart:async';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';

import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;

class MnemonicPage extends StatefulWidget {
  @override
  _MnemonicPageState createState() => _MnemonicPageState();
}

class _MnemonicPageState extends State<MnemonicPage> {
  var _left = 20;
  bool _next = false;
  Timer _timer;
  @override
  void initState() {
    _getRoundMnemonic();
    _timer = countDown(20, (int count) {
      setState(() {
        _left = count;
        if (_left==0){
          _next = true;
        }
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _timer != null ? _timer.cancel() : null;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
          return new Scaffold(
              appBar: AppBar(
                title: Text("助记词"),
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
                    child: Text("请牢牢记住以下12个单词(截屏/纸记录)"),
                  ),
                  new Flexible(
                      flex: 1,
                      child: Container(
                        height: 300,
                        child: GridView.count(
                          //水平子Widget之间间距
                          crossAxisSpacing: 10.0,
                          //垂直子Widget之间间距
                          mainAxisSpacing: 10.0,
                          //GridView内边距
                          padding: EdgeInsets.all(10.0),
                          //一行的Widget数量
                          crossAxisCount: 4,
                          //子Widget宽高比例
                          childAspectRatio: 2.0,
                          //子Widget列表
                          children: _getRoundMnemonicWidget(
                              mnemonic.split(" ")),
                        ),
                      )),
                  new MaterialButton(
                    minWidth: 200,
                    color: Colors.green,
                    textColor: Colors.white,
                    child: new Text(_next ? '已记录' : _left.toString()),
                    onPressed: _left == 0
                        ? () {
                            Navigator.of(context)
                                .pushNamed("/wallet/mmicrepeat");
                          }
                        : null,
                  )
                ],
              )));
      
  }
}

String _getRoundMnemonic() {
  if (mnemonic==""){
   mnemonic = bip39.generateMnemonic(lang: 'zh_cn');
   }
  // return mmic.split(" ");
}

List<Widget> _getRoundMnemonicWidget(List<String> mmics) {
  if (mmics.length > 0 ){
  return mmics.map((item) => _getItemWidget(item)).toList();
  }
}

Widget _getItemWidget(String item) {
  return Container(
      alignment: Alignment.center,
      child: Text(
        item,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      color: Colors.green);
}

//   @override
//   Widget build(BuildContext context) {

//     // TODO: implement build
//     return new Scaffold(
//         appBar: AppBar(
//           title: Text("助记词"),
//         ),
//         body: Center(
//             // Center is a layout widget. It takes a single child and positions it
//             // in the middle of the parent.
//             child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           // mainAxisSize: ainAxisSize.,
//           children: <Widget>[
//             new Padding(
//               padding: const EdgeInsets.symmetric(vertical: 25),
//               child: Text("请牢牢记住以下12个单词(截屏/纸记录)"),
//             ),
//             new Flexible(
//                 flex: 1,
//                 child: Container(
//                   height: 300,
//                   child: GridView.count(
//                     //水平子Widget之间间距
//                     crossAxisSpacing: 10.0,
//                     //垂直子Widget之间间距
//                     mainAxisSpacing: 10.0,
//                     //GridView内边距
//                     padding: EdgeInsets.all(10.0),
//                     //一行的Widget数量
//                     crossAxisCount: 4,
//                     //子Widget宽高比例
//                     childAspectRatio: 2.0,
//                     //子Widget列表
//                     children: _getRoundMnemonicWidget(),
//                   ),
//                 )),
//             new MaterialButton(
//               minWidth: 200,
//               color: Colors.green,
//               textColor: Colors.white,
//               child: new Text('已记录'),
//               onPressed: () {
//                 Navigator.of(context).pushNamed("/wallet/mmicrepeat");
//               },
//             )
//           ],
//         )));
//   }
// }
