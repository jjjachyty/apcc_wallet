import 'package:apcc_wallet/src/assets/usdt_buy.dart';
import 'package:apcc_wallet/src/assets/usdt_sell.dart';
import 'package:apcc_wallet/src/common/define.dart';
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
  GlobalKey<EditableTextState> _amountKey = new GlobalKey<EditableTextState>();
  var _futureBuilderFuture;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

 @override
  void initState() {
    _futureBuilderFuture = getExchange(mainSymbol, exchangeSymbol);
    // TODO: implement initState
    super.initState();
  }
 
 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$exchangeSymbol 兑换 $mainSymbol"),
        ),
        body: Container(
            padding: EdgeInsets.all(8),
            child: FutureBuilder(
              future: _futureBuilderFuture,
              builder: (context, exchanges) {
                if (exchanges.hasData) {
                  var _data = exchanges.data as Data;
                  if (_data.state){
                  Assets _mainCoin = _data.data [0];
                  Assets _exchangeCoin = _data.data[1];
                  double _exchangeRate =
                     _mainCoin.priceCny / _exchangeCoin.priceCny ;

                  return Form(
                      child: Column(
                    children: <Widget>[
                      TextField(
                        key: _amountKey,
                        autocorrect: true,
                        // autovalidate: true,
                        maxLength: _mainCoin.blance.toString().length,
                        onChanged: (val) {
                          _amount = double.tryParse(val);

                          if (_amount == null) {
                            setState(() {
                              _exchangeOutput = 0;
                            });
                          } else {
                            setState(() {
                              _amount= _amount;
                              _exchangeOutput = _amount * _exchangeRate;
                            });
                          }
                        },
                        // validator: (val){
                        //   var _val = double.tryParse(val);
                        //   if (_val==null || _val > _mainCoin.blance){
                        //     return "金额必须大于0且小于可用金额";
                        //   }
                
                        // },
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
                              "汇率=1:${_exchangeRate.toStringAsFixed(6)}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "可兑换 ${_exchangeOutput.toStringAsFixed(6)} ${mainSymbol}",
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
                         
                          if (_amount <0||_amount>_exchangeCoin.blance) {
                            setState(() {
                             _errText = "金额必须大于0且小于可用金额";
                            });
                          } else {
                          
                           setState(() {
                             _errText = null;
                            });
                             var _data = await exchange(exchangeSymbol,mainSymbol,_amount);
                             if (!_data.state){
                               _errText = _data.messsage;
                             }
                             Navigator.of(context).pop();
                          }
                          // }
                        },
                      )
                    ],
                  ));
                }else{
                  return Text(_data.messsage);
                }} else {
                  return Loading();
                }
              },
            )));
  }
}
