import 'package:apcc_wallet/src/assets/usdt_buy.dart';
import 'package:apcc_wallet/src/assets/usdt_sell.dart';
import 'package:apcc_wallet/src/common/loding.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

class ExchangePage extends StatefulWidget {
  String mainSymbol, exchangeSymbol;
  ExchangePage(this.mainSymbol, this.exchangeSymbol);

  @override
  _ExchangePageState createState() =>
      _ExchangePageState(this.mainSymbol, this.exchangeSymbol);
}

class _ExchangePageState extends State<ExchangePage> {
  String mainSymbol, exchangeSymbol;
  String _errText;
  double _amount;
  _ExchangePageState(this.mainSymbol, this.exchangeSymbol);
  double _exchangeOutput = 0;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$mainSymbol 兑换 $exchangeSymbol"),
        ),
        body: Container(
            padding: EdgeInsets.all(8),
            child: FutureBuilder(
              future: getExchange(mainSymbol, exchangeSymbol),
              builder: (context, exchanges) {
                if (exchanges.hasData) {
                  Assets _mainCoin = exchanges.data[0];
                  Assets _exchangeCoin = exchanges.data[1];
                  double _exchangeRate =
                      _exchangeCoin.cnyPrice / _mainCoin.cnyPrice;

                  return Form(
                      child: Column(
                    children: <Widget>[
                      TextField(
                        maxLength: _mainCoin.blance.toString().length,
                        onChanged: (val) {
                          _amount = double.tryParse(val);

                          if (_amount == null) {
                            setState(() {
                              _exchangeOutput = 0;
                            });
                          } else {
                            setState(() {
                              _exchangeOutput = _amount * _exchangeRate;
                            });
                          }
                        },
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "${_mainCoin.symbol}",
                            errorText: _errText,
                            hintText: "可用" + _mainCoin.blance.toString()),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "汇率=$_exchangeRate",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "可兑换 ${_exchangeOutput} ${_mainCoin.symbol}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ProgressButton(
                        color: Colors.green,
                        defaultWidget: Text(
                          "兑换",
                          style: TextStyle(color: Colors.white),
                        ),
                        progressWidget: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.lightGreen)),
                        onPressed: () async {
                          if (_amount > 0 && _amount <= _mainCoin.blance) {
                          } else {
                            setState(() {
                              _errText = "金额为0至${_mainCoin.blance}";
                            });
                          }
                          // }
                        },
                      )
                    ],
                  ));
                } else {
                  return Loading();
                }
              },
            )));
  }
}
