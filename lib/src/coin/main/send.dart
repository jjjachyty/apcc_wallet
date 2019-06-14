import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:apcc_wallet/src/store/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:redux/redux.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
var gasLimit = 0.00003;


class MainCoinSend extends StatefulWidget {
  final String from, blance;
  MainCoinSend(this.from, this.blance);
  @override
  _MainCoinSendState createState() => _MainCoinSendState(from, blance);
}

class _MainCoinSendState extends State<MainCoinSend> {
  String to,amount;
  final String from, blance;
    var _showpasswd = true;

  _MainCoinSendState(this.from, this.blance);
  GlobalKey<FormState> _sendForm = new GlobalKey<FormState>();

  scan2() {
    Future<String> futureString = new QRCodeReader()
        .setAutoFocusIntervalInMs(200) // default 5000
        .setForceAutoFocus(true) // default false
        .setTorchEnabled(true) // default false
        .setHandlePermissions(true) // default true
        .setExecuteAfterPermissionGranted(true) // default true
        // .setFrontCamera(false) // default false
        .scan();
  }

  void _onSubmit(Store<AppState> store) {
    //测试
    final form = _sendForm.currentState;
    String _passwd; 
    bool _valid= false;
    if (form.validate()) {
      form.save();
      print(to);
      print(amount);
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (ctx) => new AlertDialog(
        
                content: Container(
                  
                  alignment: Alignment.center,
                  height: 150,
                  child: TextFormField(
                  obscureText: true,
                    decoration: InputDecoration(hintText: "密码" ),
                    autovalidate: true,
                    validator: (val){
                      if (val=="" || val.length <6 || val.length > 16){
                        return "请输入6-16位密码";
                      }
                      _valid=true;
                    },
                    onSaved: (val){
                      _passwd = val;
                    },
                  ),
                ),
                actions: <Widget>[
    ProgressButton(
    defaultWidget: const Text('确认',style: TextStyle(color: Colors.white),),
    progressWidget: const CircularProgressIndicator(backgroundColor: Colors.white,valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
    width: 100,
    height: 40,
    onPressed: () async {
      if( _valid ){
      print("111111111111111");
                  sendETH(store.state.wallets[from].toString(), to, _passwd, amount);

        int score = await Future.delayed(
            const Duration(milliseconds: 3000), () => 50);
        // // After [onPressed], it will trigger animation running backwards, from end to beginning
          return () {
        // // Optional returns is returning a VoidCallback that will be called
        // // after the animation is stopped at the beginning.
        // // A best practice would be to do time-consuming task in [onPressed],
        // // and do page navigation in the returned VoidCallback.
        // // So that user won't missed out the reverse animation.
          };
          }
    },
),
                 
                ],
              ));
      // sendMain(walletJson,to,passwd,amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    var fromSort = this.from.substring(0, 5) +
        "[....]" +
        this.from.substring(this.from.length - 5, this.from.length);
    return Scaffold(
        appBar: AppBar(
          title: Text("转账"),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.all(8),
            child: new Form(
              key: _sendForm,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(fromSort),
                      Text(
                        this.blance,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val == "") {
                        return "地址不正确";
                      }
                    },
                    
                    onSaved: (val){
                      setState(() {
                       this.to = val; 
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "请输入转账地址",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: scan2,
                        )),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (valStr) {
                      try {
                        var val = double.parse(valStr);
                        if (val <= 0 || val+gasLimit > double.parse(this.blance)) {
                          return "转出金额(含手续费)为0至$blance之间";
                        }
                      } catch (e) {
                        return "金额错误";
                      }
                        
                      
                    },

                    onSaved: (val){
                      setState(() {
                       this.amount = val; 
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "请输入转账金额",
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text("预估手续费"),
                      Text("$gasLimit")
                    ],
                  ),
                  new StoreConnector<AppState, Store<AppState>>(
                      converter: (store) => store,
                      builder: (context, store) {
                        return new RaisedButton(
                          child: new Text(
                            '转出',
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                          
                              _onSubmit(store);
                            
                          },
                          color: Theme.of(context).primaryColor,
                        );
                      }),
                
                ],
              ),
            )));
  }
}
