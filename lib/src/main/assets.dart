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
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AssetsPage extends StatefulWidget {
  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  List<Assets> _assets = new List();
  // List<Coin> _coins = new List();

  @override
  void initState() {
    // coins.forEach((k, v) {
    //   _coins.add(v);
    // });
    // TODO: implement initState
    super.initState();
    if (address != null && user != null) {
      _onRefresh();
    }
  }

  Future<void> _onRefresh() async {
    var _data = await getLocalAssets();

    var _db = await getDBAssets();
    _data.addAll(_db);
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
                itemCount: _assets.length,
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
                                        _assets[index].symbol,
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
                                              : _assets[index].baseOn,
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
                                      : _assets[index]
                                          .blance
                                          .toStringAsFixed(6),
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
                                          var _exchangeIndex = 0;
                                          if (_assets[index].symbol != "USDT") {
                                            _exchangeIndex = 1;
                                          }
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ExchangePage(_assets[index],
                                                _assets[_exchangeIndex]);
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
                                            return RechargePage(_assets[index]);
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
                                          if (user.idCardAuth == 1) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return TransferPage(
                                                  _assets[index]);
                                            }));
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    CupertinoAlertDialog(
                                                      content: Text(
                                                        "转账功能需实名认证,请先完成实名认证",
                                                      ),
                                                      actions: <Widget>[
                                                        CupertinoButton(
                                                          child: Text("去认证"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacementNamed(
                                                                    "/user/idcard");
                                                          },
                                                        ),
                                                      ],
                                                    ));
                                          }
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
