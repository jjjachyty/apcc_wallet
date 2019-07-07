import 'package:apcc_wallet/src/assets/transfer_list.dart';
import 'package:apcc_wallet/src/assets/transfer_success.dart';
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

  Assets assets;
  String transferType;
  double _amount;
  String _errText;
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
      appBar: AppBar(
        title: Text("${assets.symbol} 转账"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (buildContext) {
                return TransferListPage();
              }));
            },
          )
        ],
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
                    labelText: "地址",
                    hintText: "转出地址",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.filter_center_focus),
                      onPressed: scan2,
                    )),
                validator: (val) {
                  if (val == null || val == "") {
                    return "地址不能为空";
                  }
                  if (val == assets.address) {
                    return "转出地址与待转地址相同";
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                maxLength: assets.blance.toString().length,
                decoration: InputDecoration(
                    labelText: "金额 可转出" + assets.blance.toString(),
                    // hintText: "可转出" + assets.blance.toString(),
                    counterText: "",
                    border: OutlineInputBorder()),
                validator: (val) {
                  if (val == null ||
                      val == "" ||
                      double.tryParse(val) == null ||
                      double.tryParse(val) <= 0 ||
                      double.tryParse(val) + double.tryParse(_free) >
                          assets.blance) {
                    return "转出金额(含手续费)为0至${assets.blance}之间";
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
              Divider(),
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
                      labelText: "支付密码",
                      hintText: "请输入支付密码",
                      counterText: "",
                      errorText: _errText,
                      border: OutlineInputBorder())),
              SizedBox(
                height: 10,
              ),
              ProgressButton(
                  color: Colors.green,
                  defaultWidget: Text(
                    "转账",
                    style: TextStyle(color: Colors.white),
                  ),
                  progressWidget: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
                  onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      _formkey.currentState.save();

                      var _data = await transfer(
                          assets.address,
                          _addressCtl.text,
                          assets.symbol,
                          transferType,
                          _payPasswd,
                          _amount);
                      if (_data.state) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (build) {
                          return TransferSuccessPage(this.transferType);
                        }));
                      } else {
                        setState(() {
                          _errText = _data.messsage;
                        });
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
