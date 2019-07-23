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
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AssetsPage extends StatefulWidget {
  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  List<Assets> _assets = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefresh();
  }

  Future<void> _onRefresh() async {
    var _data = await getAssets();
    setState(() {
      _assets = _data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (address.length == 0) {
      return NoWalletPage();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("资产"),
        ),
        body:  RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.separated(
          itemCount: _assets.length,
          separatorBuilder: (context, index) => Divider(),
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
                          child: Text(
                            _assets[index].symbol,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            _assets[index].blance.toString(),
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
                          child: 
                          Text.rich(
                            TextSpan(
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    Assets mainCoin, exchangeCoin;
                                    mainCoin = _assets[index];
                                    if (_assets[index].symbol != "USDT") {
                                      exchangeCoin = _assets[1];
                                    } else {
                                      exchangeCoin = _assets[0];
                                    }
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return ExchangePage(
                                          mainCoin, exchangeCoin);
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
                                        MaterialPageRoute(builder: (context) {
                                      return RechargePage(
                                          _assets[index].address);
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
                                    if (user.hasPayPasswd) {
                                      // showModalBottomSheet(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return new Column(
                                      //         mainAxisSize: MainAxisSize.min,
                                      //         children: <Widget>[
                                      //           new ListTile(
                                      //             leading: new Icon(Icons.loop),
                                      //             title:
                                      //                 new Text("平台内转账(无手续费)"),
                                      //             onTap: () async {
                                      //               Navigator.of(context)
                                      //                   .pushReplacement(
                                      //                       MaterialPageRoute(
                                      //                           builder:
                                      //                               (context) {
                                      //                 return TransferPage(
                                      //                     _assets[index], "in");
                                      //               }));
                                      //             },
                                      //           ),
                                      //           new ListTile(
                                      //             leading: new Icon(
                                      //                 Icons.swap_horiz),
                                      //             title:
                                      //                 new Text("转出平台外(需手续费)"),
                                      //             onTap: () async {
                                                   
                                      //             },
                                      //           ),
                                      //         ],
                                      //       );
                                      //     });
                                       Navigator.of(context)
                                                        .push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                      return TransferPage(
                                                          _assets[index],
                                                          "out");
                                                    }));
                                    } else {
                                      //没有设置支付密码
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  new Text('尚未设置支付密码,请先设置支付密码'),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text('去设置'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                      return TradePassWd(false);
                                                    }));
                                                  },
                                                ),
                                              ],
                                            );
                                          });
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
          },
        )));
  }


}
