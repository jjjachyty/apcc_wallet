import 'package:apcc_wallet/src/assets/exchange.dart';
import 'package:apcc_wallet/src/assets/recharge.dart';
import 'package:apcc_wallet/src/assets/transfer_outer.dart';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/loding.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AssetsPage extends StatefulWidget {
  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  List<Assets> _assets = new List();
  Future<void> _onRefresh() async {
    var _data = await getAssets();
    if (_data.state) {
      setState(() {
        _assets = _data.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("资产"),
        ),
        body: FutureBuilder(
          future: getAssets(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              var _data = asyncSnapshot.data as Data;
              if (_data.state) {
                _assets = _data.data;
                return _assetsCard();
              } else {
                return Text(_data.messsage);
              }
            } else {
              return Loading();
            }
          },
        ));
  }

  Widget _assetsCard() {
    return RefreshIndicator(
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
                        // Expanded(
                        //   flex: 2,
                        //   child: Text(
                        //     assets[index].code,
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        // ),
                        // Expanded(
                        //   child: Text(
                        //     assets[index].symbol,
                        //     style: TextStyle(color: Colors.white),
                        //   ),
                        // )
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    // Container(
                    //     height: 70,
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: <Widget>[
                    //         Row(
                    //           children: <Widget>[
                    //             Expanded(
                    //               flex: 2,
                    //               child: Text(
                    //                 "可用",
                    //                 style: TextStyle(color: Colors.white),
                    //               ),
                    //             ),
                    //             Expanded(
                    //               flex: 2,
                    //               child: Text(
                    //                 "冻结",
                    //                 style: TextStyle(color: Colors.white),
                    //               ),
                    //             ),
                    //             Expanded(
                    //               child: Text(
                    //                 "价格",
                    //                 style: TextStyle(color: Colors.white),
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //         Divider(),
                    //         Row(
                    //           children: <Widget>[
                    //             Expanded(
                    //               flex: 2,
                    //               child: Text(
                    //                 assets[index].blance.toString(),
                    //                 style: TextStyle(color: Colors.white),
                    //               ),
                    //             ),
                    //             Expanded(
                    //               flex: 2,
                    //               child: Text(
                    //                 assets[index].freezingBlance.toString(),
                    //                 style: TextStyle(color: Colors.white),
                    //               ),
                    //             ),
                    //             Expanded(
                    //               child: Text(
                    //                 "¥" + assets[index].cnyPrice.toString(),
                    //                 style: TextStyle(color: Colors.white),
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ],
                    //     )),
                    new Table(children: <TableRow>[
                      new TableRow(children: <Widget>[
                        new TableCell(
                          child: new Center(
                            child: new Text(
                              _assets[index].blance.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        new TableCell(
                          child: new Center(
                            child: new Text(
                              _assets[index].freezingBlance.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        new TableCell(
                          child: new Center(
                            child: new Text(
                              _assets[index].priceCny.toStringAsFixed(2),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ]),
                      new TableRow(children: <Widget>[
                        new TableCell(
                          child: new Center(
                            child: new Text(
                              '可用',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        new TableCell(
                          child: new Center(
                            child: new Text(
                              '冻结',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        new TableCell(
                          child: new Center(
                            child: new Text(
                              '价格¥',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ]),
                    ]),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    String mainSymbol, exchangeSymbol;
                                    mainSymbol = _assets[index].symbol;
                                    exchangeSymbol = "USDT";
                                    if (_assets[index].symbol == "USDT") {
                                      exchangeSymbol = "MHC";
                                    }
                                    print(mainSymbol);
                                    print(exchangeSymbol);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return ExchangePage(
                                          mainSymbol, exchangeSymbol);
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
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return new Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new ListTile(
                                                leading: new Icon(
                                                    Icons.border_inner),
                                                title: new Text("平台内转账(无手续费)"),
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              new ListTile(
                                                leading: new Icon(
                                                    Icons.send),
                                                title: new Text("转出平台外(需手续费)"),
                                                onTap: () async {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return TransferPage(
                                                        _assets[index]);
                                                  }));
                                                },
                                              ),
                                            ],
                                          );
                                        });
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
        ));
  }
}
