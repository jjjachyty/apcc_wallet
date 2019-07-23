import 'package:apcc_wallet/src/assets/usdt_buy.dart';
import 'package:apcc_wallet/src/assets/usdt_sell.dart';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/loding.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

class ExchangePage extends StatefulWidget {
  Assets mainCoin, exchangeCoin;
  ExchangePage(this.mainCoin, this.exchangeCoin);

  @override
  _ExchangePageState createState() =>
      _ExchangePageState(this.mainCoin, this.exchangeCoin);
}

class _ExchangePageState extends State<ExchangePage> {
  Assets mainCoin, exchangeCoin;
  String _errText;
  String _payPasswd;
  double _amount;
  _ExchangePageState(this.mainCoin, this.exchangeCoin);
  double _exchangeOutput = 0;
  GlobalKey<EditableTextState> _amountKey = new GlobalKey<EditableTextState>();
  GlobalKey<ScaffoldState> _scoffoldKey = GlobalKey<ScaffoldState>();
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  var _futureBuilderFuture;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

 @override
  void initState() {
    // _futureBuilderFuture = getExchange(mainCoin.symbol, exchangeCoin.symbol);
    // TODO: implement initState
    super.initState();
  }
 
 
Widget _form(){
             
                  // Assets _mainCoin = _data.data [0];
                  // Assets _exchangeCoin = _data.data[1];
                  double _exchangeRate = getExchangeRate(mainCoin.symbol,exchangeCoin.symbol);
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
                            labelText: "${mainCoin.symbol}",
                            errorText: _errText,
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
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "可兑换 ${_exchangeOutput.toStringAsFixed(6)} ${exchangeCoin.symbol}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
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
                      errorText: _errText,
                      border: OutlineInputBorder())),
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
                         print("$_amount  ${mainCoin.blance} ");
                         if (_formKey.currentState.validate()){
                           _formKey.currentState.save();
                        
                          if ( _amount==null|| _amount <0||_amount> mainCoin.blance) {
                            setState(() {
                             _errText = "金额必须大于0且小于可用金额";
                            });
                          } else {
                          
                           setState(() {
                             _errText = null;
                            });
                             var _data = await exchange(mainCoin,exchangeCoin,_payPasswd,_amount);
                             if (_data.state){
                                 Navigator.of(context).pop();
                                  
                             }else{
                               setState(() {
                             _errText = _data.messsage;
                            });
                           
                            }
                          } }
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
            IconButton(icon: Icon(Icons.menu),onPressed: (){
              
            },)
          ],
          title: Text("${mainCoin.symbol} 兑换 ${exchangeCoin.symbol}"),
        ),
        body: Container(
            padding: EdgeInsets.all(8),
            child: _form(),
             
            ));
  }
}
