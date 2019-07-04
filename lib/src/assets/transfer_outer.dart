import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class TransferPage extends StatefulWidget {
  Assets assets;
  TransferPage(this.assets);
  @override
  _TransferPageState createState() => _TransferPageState(this.assets);
}

class _TransferPageState extends State<TransferPage> {
  GlobalKey<FormState> _formkey = new GlobalKey();
  Assets assets;
  String _errText = "";
  String _free;
  _TransferPageState(this.assets);
  TextEditingController _addressCtl = new TextEditingController();
  bool _type= false;
    scan2() {
    Future<String> futureString = new QRCodeReader()
        .setAutoFocusIntervalInMs(200) // default 5000
        .setForceAutoFocus(true) // default false
        .setTorchEnabled(true) // default false
        .setHandlePermissions(true) // default true
        .setExecuteAfterPermissionGranted(true) // default true
        // .setFrontCamera(false) // default false
        .scan().then((onValue){
              setState(() {
               _addressCtl.text = onValue;
              });
        });
  }
  
@override
  void initState() {
    transferFree(assets.symbol).then((data){
      if (data.state){
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
        title: Text("转账"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              
              TextFormField(
                controller: _addressCtl,
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
                maxLength: assets.blance.toString().length,
                decoration: InputDecoration(
                    hintText: "可转出" + assets.blance.toString(),
                    border: OutlineInputBorder()),
                    autovalidate: true,
                validator: (val) {
                  if (val == null ||
                      val == "" ||
                      double.tryParse(val) < 0 ||
                      double.tryParse(val) > assets.blance) {
                    return "金额为0至${assets.blance}之间";
                  }
                },
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "预计手续费 $_free",
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                child: Text(_errText),
              ),
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
                          print(MediaQuery.of(context).viewInsets.bottom);
                          return Padding(
                              padding: EdgeInsets.only(
                                  top: 5,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          2),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                autofocus: true,
                                obscureText: true,
                                maxLength: 16,
                                decoration: InputDecoration(
                                    labelText: "支付密码",
                                    hintText: "请输入支付密码",
                                    counterText: "",
                                    border: OutlineInputBorder(),
                                    suffixIcon: ProgressButton(
                                      width: 60,
                                      height: 60,
                                      color: Colors.green,
                                      defaultWidget: Text(
                                        "确认",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      progressWidget: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.lightGreen)),
                                      onPressed: () async {
                                        // }
                                      },
                                    )),
                              ));
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
