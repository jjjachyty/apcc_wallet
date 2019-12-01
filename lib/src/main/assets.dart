import 'package:apcc_wallet/src/assets/exchange.dart';
import 'package:apcc_wallet/src/assets/recharge.dart';
import 'package:apcc_wallet/src/assets/transfer.dart';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/nologin.dart';
import 'package:apcc_wallet/src/hdwallet/index.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AssetsPage extends StatefulWidget {
  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  List<Assets> _mhc = new List();
  List<Assets> _usdt = new List();

  // List<Coin> _coins = new List();

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  Future<void> _onRefresh() async {
    var _mhcTmp = await getLocalAssets();
    if (_mhcTmp.length > 0) {
      setState(() {
        _mhc = _mhcTmp;
      });
    }
    var _usdtTmp = await getDBAssets();
    if (_usdtTmp.length > 0) {
      setState(() {
        _usdt = _usdtTmp;
      });
    }
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
      backgroundColor: Colors.blue.shade800,
      body: Container(
          child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          new BorderRadius.vertical(top: Radius.circular(20)),
                      color: Colors.white),
                  padding: EdgeInsets.symmetric(vertical: 47, horizontal: 12),
                  // margin: EdgeInsets.symmetric(horizontal: 20),
                  child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                "下拉刷新",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                              Card(
                                color: Color.fromRGBO(136, 96, 254, 1),
                                //z轴的高度，设置card的阴影
                                elevation: 10.0,
                                //设置shape，这里设置成了R角
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
                                clipBehavior: Clip.antiAlias,
                                semanticContainer: false,
                                child: Container(
                                  height: 96,
                                  padding: EdgeInsets.all(8),
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                              flex: 4,
                                              child: Stack(
                                                children: <Widget>[
                                                  Text(
                                                    "YLC",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    child: Text(
                                                      "分布式",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                    ),
                                                    padding: EdgeInsets.only(
                                                        left: 60),
                                                  ),
                                                ],
                                              )),
                                          Expanded(
                                            flex: 6,
                                            child: Text(
                                              _mhc.length == 0
                                                  ? "--"
                                                  : _mhc[0]
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
                                      _mhc.length > 0
                                          ? Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text.rich(
                                                    TextSpan(
                                                        recognizer:
                                                            new TapGestureRecognizer()
                                                              ..onTap = () {
                                                                // Navigator.of(
                                                                //         context)
                                                                //     .push(MaterialPageRoute(
                                                                //         builder:
                                                                //             (context) {
                                                                //   return ExchangePage(
                                                                //       _mhc[0],
                                                                //       _usdt[0]);
                                                                // }));
                                                              },
                                                        text: "兑换",
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            color: Colors
                                                                .white70)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text.rich(
                                                    TextSpan(
                                                        recognizer:
                                                            new TapGestureRecognizer()
                                                              ..onTap = () {
                                                                //屏蔽USDT充值转账功能
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) {
                                                                  return RechargePage(
                                                                      _mhc[0]);
                                                                }));
                                                              },
                                                        text: "充值",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text.rich(
                                                    TextSpan(
                                                        text: "转账",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        recognizer:
                                                            new TapGestureRecognizer()
                                                              ..onTap = () {
                                                                //屏蔽USDT充值转账功能

                                                                if (user.idCardAuth ==
                                                                    1) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(MaterialPageRoute(
                                                                          builder:
                                                                              (context) {
                                                                    return TransferPage(
                                                                        _mhc[
                                                                            0]);
                                                                  }));
                                                                } else {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (_) =>
                                                                              CupertinoAlertDialog(
                                                                                content: Text(
                                                                                  "转账功能需实名认证,请先完成实名认证",
                                                                                ),
                                                                                actions: <Widget>[
                                                                                  CupertinoButton(
                                                                                    child: Text("去认证"),
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).pushReplacementNamed("/user/idcard");
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
                                          : Divider(),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                color: Color.fromRGBO(3, 168, 238, 1),
                                //z轴的高度，设置card的阴影
                                elevation: 10.0,
                                //设置shape，这里设置成了R角
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
                                clipBehavior: Clip.antiAlias,
                                semanticContainer: false,
                                child: Container(
                                  height: 96,
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                              height: 30,
                                              child: Stack(
                                                children: <Widget>[
                                                  Text(
                                                    "USDT",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 65),
                                                    child: Text(
                                                      _usdt.length == 0
                                                          ? ""
                                                          : _usdt[0].baseOn,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                    ),
                                                  )
                                                ],
                                              )),
                                          Expanded(
                                            flex: 6,
                                            child: Text(
                                              _usdt.length == 0
                                                  ? "--"
                                                  : _usdt[0]
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
                                      _usdt.length > 0
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text.rich(
                                                    TextSpan(
                                                        recognizer:
                                                            new TapGestureRecognizer()
                                                              ..onTap = () {
                                                                // Navigator.of(context).push(
                                                                //     MaterialPageRoute(
                                                                //         builder:
                                                                //             (context) {
                                                                //   return ExchangePage(
                                                                //       _usdt[0],
                                                                //       _mhc[0]);
                                                                // }));
                                                              },
                                                        text: "兑换",
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            color: Colors
                                                                .white70)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text.rich(
                                                    TextSpan(
                                                      recognizer:
                                                          new TapGestureRecognizer()
                                                            ..onTap = () {},
                                                      text: "充值",
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color: Colors.white70,
                                                        decorationColor:
                                                            Colors.white70,
                                                      ),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text.rich(
                                                    TextSpan(
                                                        text: "转账",
                                                        style: TextStyle(
                                                          color: Colors.white70,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          decorationColor:
                                                              Colors.white70,
                                                        ),
                                                        recognizer:
                                                            new TapGestureRecognizer()
                                                              ..onTap = () {}),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            )
                                          : Divider()
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      )))),
        ],
      )),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
