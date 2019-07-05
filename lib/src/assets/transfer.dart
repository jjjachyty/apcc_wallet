import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class TransferPage extends StatefulWidget {
  Assets assets;
  String transferType;
  TransferPage(this.assets, this.transferType);
  @override
  _TransferPageState createState() =>
      _TransferPageState(this.assets, this.transferType);
}

class _TransferPageState extends State<TransferPage> {
  GlobalKey<FormState> _formkey = new GlobalKey();
  GlobalKey<FormFieldState> _payPasswdKey = new GlobalKey<FormFieldState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Assets assets;
  String transferType;
  double _amount;
  // String _errText = "";
  String _free, _payPasswd;
  _TransferPageState(this.assets, this.transferType);
  TextEditingController _addressCtl = new TextEditingController();
  bool _type = false;
  scan2() {
    Future<String> futureString = new QRCodeReader()
        .setAutoFocusIntervalInMs(200) // default 5000
        .setForceAutoFocus(true) // default false
        .setTorchEnabled(true) // default false
        .setHandlePermissions(true) // default true
        .setExecuteAfterPermissionGranted(true) // default true
        // .setFrontCamera(false) // default false
        .scan()
        .then((onValue) {
      setState(() {
        _addressCtl.text = onValue;
      });
    });
  }

  @override
  void initState() {
    transferFree(assets.symbol).then((data) {
      if (data.state) {
        setState(() {
          _free = data.data.toString();
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("${assets.symbol} 转账"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _addressCtl,
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                    hintText: "转出地址",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: scan2,
                    )),
                validator: (val) {
                  if (val == null || val == "") {
                    return "地址不能为空";
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                maxLength: assets.blance.toString().length,
                decoration: InputDecoration(
                    hintText: "可转出" + assets.blance.toString(),
                    border: OutlineInputBorder()),
                autovalidate: true,
                validator: (val) {
                  if (val == null ||
                      val == "" ||
                      double.tryParse(val) == null ||
                      double.tryParse(val) < 0 ||
                      double.tryParse(val) > assets.blance) {
                    return "金额为0至${assets.blance}之间";
                  }
                },
                onSaved: (val) {
                  setState(() {
                    _amount = double.parse(val);
                  });
                },
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  transferType == "out" ? "预计手续费 $_free ${assets.symbol}" : "",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.left,
                ),
              ),
              // SizedBox(
              //   child: Text(_errText),
              // ),
              MaterialButton(
                minWidth: double.infinity,
                color: Colors.green,
                child: Text(
                  "转账",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  var _formState = _formkey.currentState;
                  if (_formState.validate()) {
                    _formState.save();

                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          var _errText ;
                          return StatefulBuilder(builder: (context, state) {
                            return Padding(
                                padding: EdgeInsets.only(
                                    top: 5,
                                    bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom +
                                        2),
                                child: TextFormField(
                                  key: _payPasswdKey,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  autofocus: true,
                                  obscureText: true,
                                  maxLength: 16,
                                  validator: (val) {
                                    if (val == null ||
                                        val == "" ||
                                        val.length < 8 ||
                                        val.length > 16) {
                                      return "密码为8-16位数";
                                    }
                                  },
                                  onSaved: (val) {
                                    setState(() {
                                      _payPasswd = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: "支付密码",
                                      hintText: "请输入支付密码",
                                      counterText: "",
                                      errorText: _errText,
                                      border: OutlineInputBorder(),
                                      suffixIcon: ProgressButton(
                                        width: 60,
                                        height: 60,
                                        color: Colors.green,
                                        defaultWidget: Text(
                                          "确认",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        progressWidget:
                                            CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Colors.lightGreen)),
                                        onPressed: () async {
                                          if (_payPasswdKey.currentState
                                              .validate()) {
                                            _payPasswdKey.currentState.save();

                                            var _data = await transfer(
                                                assets.address,
                                                _addressCtl.text,
                                                assets.symbol,
                                                transferType,
                                                _payPasswd,
                                                _amount);
                                            if (_data.state) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pushReplacementNamed("/transfersuccess");
                                              
                                            } else {
                                               
                                               state(() {
                                              _errText = _data.messsage;
                                               }); 
                                             
                                            }
                                          }
                                          // }
                                        },
                                      )),
                                ));
                          });
                        });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
