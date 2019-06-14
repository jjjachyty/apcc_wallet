import 'package:apcc_wallet/src/coin/main/send.dart';
import 'package:apcc_wallet/src/hdwallet/passwd.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:apcc_wallet/src/store/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:redux/redux.dart';
import 'package:web3dart/web3dart.dart';

class MainCoinReceive extends StatefulWidget {
  @override
  _MainCoinReceiveState createState() => _MainCoinReceiveState();
}

class _blance {
  String address;
  EtherAmount amount;
  _blance({this.address, this.amount});
}

class _MainCoinReceiveState extends State<MainCoinReceive> {
  List<_blance> _keys = new List();
  var _online = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  dispose() {
    _keys.clear();
    super.dispose();
  }

  _getData(Store<AppState> store) {
    var keys = store.state.wallets.keys;
    _keys.clear();
    for (var key in keys) {
      getETHblance(key).then((amount) {
        setState(() {
          _online = true;
          _keys.add(new _blance(address: key, amount: amount));
        });
      }).catchError((onError) {
        setState(() {
          _keys.add(new _blance(address: key, amount: EtherAmount.zero()));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    return Container(
        child: new StoreConnector<AppState, Store<AppState>>(
            onInit: (store) {
              _getData(store);
            },
            converter: (store) => store,
            builder: (context, store) {
              return Center(
                  child: Column(children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: _size.width * 0.8,
                        alignment: Alignment.center,
                        child: _online
                            ? null
                            : Text(
                                "钱包服务器无法连接,请稍后再试",
                                style: TextStyle(color: Colors.red),
                              ),
                      ),
                      Container(
                          width: _size.width * 0.2,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            tooltip: "新增",
                            icon: Icon(Icons.add, color: Colors.green),
                            onPressed: () {
                              Navigator.of(context).pushNamed("/wallet/mmic");
                            },
                          ))
                    ],
                  ),
                ),
                Expanded(
                    child: new Swiper(
                        loop: false,
                        viewportFraction: 0.9,
                        scale: 0.9,
                        itemHeight: 200,
                        //  itemWidth: 300,
                        itemCount: _keys.length,
                        itemBuilder: (context, index) {
                          return Center(
                              child: Column(
                            children: <Widget>[
                              new QrImage(
                                data: _keys[index].address.toString(),
                                foregroundColor: Colors.green,
                                //  size: 250.0,
                              ),
                              Card(
                                  elevation: 5.0,
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          _keys[index].address.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(top: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.attach_money,
                                                  color: Colors.green,
                                                ),
                                                Text(
                                                  _keys[index]
                                                      .amount
                                                      .getInEther
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontFamily: 'Raleway',
                                                      fontSize: 25),
                                                )
                                              ],
                                            )),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.send,
                                              color: _online
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                            onPressed: _online
                                                ? () {
                                                    Navigator.of(context).push(
                                                        new MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                      return new MainCoinSend(
                                                          _keys[index].address,
                                                          _keys[index]
                                                              .amount
                                                              .getInEther
                                                              .toString());
                                                    }));
                                                  }
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ));
                        }))
              ]));
            }));
  }
}
