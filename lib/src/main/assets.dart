import 'package:apcc_wallet/src/assets/exchange.dart';
import 'package:apcc_wallet/src/assets/recharge.dart';
import 'package:apcc_wallet/src/assets/transfer.dart';
import 'package:apcc_wallet/src/center/pay_passwd.dart';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/event_bus.dart';
import 'package:apcc_wallet/src/common/loding.dart';
import 'package:apcc_wallet/src/common/nologin.dart';
import 'package:apcc_wallet/src/hdwallet/index.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:apcc_wallet/src/model/coins.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AssetsPage extends StatefulWidget {
  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  Map<String, Assets> _assets = new Map();
  List<Coin> _coins = new List();

  @override
  void initState() {
    coins.forEach((k, v) {
      _coins.add(v);
    });
    // TODO: implement initState
    super.initState();
    if (address != null) {
      _onRefresh();
    }
  }

  Future<void> _onRefresh() async {
    var _data = await getAssets();
    setState(() {
      _assets = _data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return NoLoginPage();
    }
    if (address.length == 0) {
      return NoWalletPage();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("资产"),
        ),
        body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: coins.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.green,
                    //z轴的高度，设置card的阴影
                    elevation: 10.0,
                    //设置shape，这里设置成了R角
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
                    clipBehavior: Clip.antiAlias,
                    semanticContainer: false,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 4,
                                  child: Stack(
                                    children: <Widget>[
                                      Text(
                                        _coins[index].symbol,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 70),
                                        child: Text(
                                          _assets.length == 0
                                              ? ""
                                              : _assets[_coins[index].symbol]
                                                  .overview,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                      )
                                    ],
                                  )),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  _assets.length == 0
                                      ? "--"
                                      : _assets[_coins[index].symbol]
                                          .blance
                                          .toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          var _exchangeSymbol = "";
                                          if (_coins[index].symbol == "USDT") {
                                            _exchangeSymbol = "MHC";
                                          } else {
                                            _exchangeSymbol = "USDT";
                                          }
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ExchangePage(
                                                _assets[_coins[index].symbol],
                                                _assets[_exchangeSymbol]);
                                          }));
                                        },
                                      text: "兑换",
                                      style: TextStyle(color: Colors.white)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return RechargePage(
                                                _assets[_coins[index].symbol]);
                                          }));
                                        },
                                      text: "充值",
                                      style: TextStyle(color: Colors.white)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                      text: "转账",
                                      style: TextStyle(color: Colors.white),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return TransferPage(
                                                _assets[_coins[index].symbol]);
                                          }));
                                        }),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                })));
  }
}
