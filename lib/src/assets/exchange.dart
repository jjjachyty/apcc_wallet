import 'package:apcc_wallet/src/assets/exchange_list.dart';
import 'package:apcc_wallet/src/assets/transfer_list.dart';
import 'package:apcc_wallet/src/assets/usdt_buy.dart';
import 'package:apcc_wallet/src/assets/usdt_sell.dart';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/loding.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

import 'transfer_success.dart';

class ExchangePage extends StatefulWidget {
  Assets mainCoin, exchangeCoin;
  ExchangePage(this.mainCoin, this.exchangeCoin);

  @override
  _ExchangePageState createState() =>
      _ExchangePageState(this.mainCoin, this.exchangeCoin);
}

class _ExchangePageState extends State<ExchangePage> {
  Assets mainCoin, exchangeCoin;
  String _errText = "";
  bool _tomhc = true;
  String _payPasswd;
  double _amount;
  num _exchangeFree = 0, _exchangeRate = 0;
  _ExchangePageState(this.mainCoin, this.exchangeCoin);
  double _exchangeOutput = 0;
  GlobalKey<EditableTextState> _amountKey = new GlobalKey<EditableTextState>();
  GlobalKey<ScaffoldState> _scoffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    // _futureBuilderFuture = getExchange(mainCoin.symbol, exchangeCoin.symbol);
    // TODO: implement initState
    super.initState();
    var _symbol = mainCoin.symbol;
    if (_symbol == "MHC") {
      _symbol = exchangeCoin.symbol;
    }
    exchangeFree(_symbol).then((data) {
      if (data.state) {
        setState(() {
          _exchangeFree = data.data;
        });
      }
    });
    exchangerate(mainCoin.symbol, exchangeCoin.symbol).then((data) {
      if (data.state) {
        _exchangeRate = data.data;
      }
    });
  }

  Widget _form() {
    // Assets _mainCoin = _data.data [0];
    // Assets _exchangeCoin = _data.data[1];
    // double _exchangeRate = getExchangeRate(mainCoin.symbol,exchangeCoin.symbol);
    //  _mainCoin.priceCny / _exchangeCoin.priceCny ;

    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextField(
              key: _amountKey,
              autocorrect: true,
              // autovalidate: true,
              maxLength: mainCoin.blance.toString().length,
              onChanged: (val) {
                _amount = double.tryParse(val);

                if (_amount == null || _amount < _exchangeFree) {
                  setState(() {
                    _exchangeOutput = 0;
                  });
                } else {
                  num _output = 0;
                  if (mainCoin.symbol == "MHC") {
                    _output = (_amount - _exchangeFree) * _exchangeRate;
                  } else {
                    _output = (_amount * _exchangeRate) - _exchangeFree;
                  }

                  setState(() {
                    _amount = _amount;
                    _exchangeOutput = _output;
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
                  helperText: "手续费:[" + _exchangeFree.toString() + "] MHC",
                  border: OutlineInputBorder(),
                  labelText: "${mainCoin.symbol}",
                  hintText: "可用" + mainCoin.blance.toString()),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "汇率=1:${_exchangeRate.toStringAsFixed(6)}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "可兑换 ${_exchangeOutput.toStringAsFixed(6)} ${exchangeCoin.symbol}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
            TextFormField(
                keyboardType: TextInputType.text,
                // textInputAction: TextInputAction.next,
                obscureText: true,
                maxLength: 16,
                validator: (val) {
                  if (val == null ||
                      val == "" ||
                      val.length < 8 ||
                      val.length > 16) {
                    return "支付密码为8-16位数";
                  }
                },
                onSaved: (val) {
                  setState(() {
                    _payPasswd = val;
                  });
                },
                decoration: InputDecoration(
                    labelText: "钱包密码",
                    hintText: "请输入钱包密码",
                    counterText: "",
                    border: OutlineInputBorder())),
            SizedBox(
              height: 10,
            ),
            Text(
              _errText,
              style: TextStyle(color: Colors.red),
            ),
            ProgressButton(
              color: Colors.green,
              defaultWidget: Text(
                "兑换",
                style: TextStyle(color: Colors.white),
              ),
              progressWidget: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  if (_amount == null ||
                      _amount < _exchangeFree ||
                      _amount > mainCoin.blance) {
                    setState(() {
                      _errText = "金额必须大于手续费且小于可用金额";
                    });
                  } else {
                    setState(() {
                      _errText = "";
                    });
                    var _data = await exchange(
                        mainCoin, exchangeCoin, _payPasswd, _amount);

                    if (_data.state) {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (build) {
                        return TransferSuccessPage(_data.data["ReceiveTxs"]);
                      }));
                    } else {
                      setState(() {
                        _errText = _data.messsage;
                      });
                    }
                  }
                }
                // }
              },
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scoffoldKey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TransferListPage(mainCoin.symbol, "1000");
                }));
              },
            )
          ],
          title: Text("${mainCoin.symbol} 兑换 ${exchangeCoin.symbol}"),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: _form(),
        ));
  }
}
