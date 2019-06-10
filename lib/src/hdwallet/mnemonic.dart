import 'package:apcc_wallet/src/store/state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../store/actions.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;

class MnemonicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        onInit: (store) {
          store.dispatch(RefreshMnemonicAction(_getRoundMnemonic()));
        },
        // {store.dispatch(RefreshMnemonicAction(_getRoundMnemonic()))},
        builder: (context, store) {
          print("mnemonic====================");

          print(store);
          print("mnemonic====================");

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
                              store.state.mnemonic.split(" ")),
                        ),
                      )),
                  new MaterialButton(
                    minWidth: 200,
                    color: Colors.green,
                    textColor: Colors.white,
                    child: new Text('已记录'),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/wallet/mmicrepeat");
                    },
                  )
                ],
              )));
        });
  }
}

// class MnemonicPage extends StatefulWidget {
//   // final  Store<AppState> store;
//   // MnemonicPage(this.store);

//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _MnemonicPageState();
//   }

// }

String _getRoundMnemonic() {
  return bip39.generateMnemonic(lang: 'zh_cn');

  // return mmic.split(" ");
}

List<Widget> _getRoundMnemonicWidget(List<String> mmics) {
  return mmics.map((item) => _getItemWidget(item)).toList();
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
