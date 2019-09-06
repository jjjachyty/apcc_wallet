import 'package:apcc_wallet/src/assets/scan.dart';
import 'package:apcc_wallet/src/assets/transfer_list.dart';
import 'package:apcc_wallet/src/assets/transfer_success.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

class TransferPage extends StatefulWidget {
  Assets assets;
  TransferPage(this.assets);
  @override
  _TransferPageState createState() => _TransferPageState(this.assets);
}

class _TransferPageState extends State<TransferPage> {
  GlobalKey<FormState> _formkey = new GlobalKey();

  Assets assets;
  double _amount;
  String _errText;
  String _payPasswd;
  num _free;
  _TransferPageState(this.assets);
  TextEditingController _addressCtl = new TextEditingController();
  bool _type = false;


  @override
  void initState() {
    if (assets.symbol == "USDT") {
      Future.delayed(Duration(microseconds: 500), () {
        var dialog = CupertinoAlertDialog(
          content: Text(
            "USDT转出平台暂只支持以太坊 ERC-20 代币转账(0x),请勿使用Omni协议地址",
          ),
          actions: <Widget>[
            CupertinoButton(
              child: Text("已知晓"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
        showDialog(context: context, builder: (_) => dialog);
      });
    }
    transferFree(assets.symbol).then((data) {
      setState(() {
        _free = data;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("${assets.symbol} 转账"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (buildContext) {
                return TransferListPage(assets.symbol, assets.address.val);
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
                      onPressed: () async{
                      String _value =  await  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return ScanPage();
                        }));
                        print("_value");
                        setState(() {
                          _addressCtl.text = _value;
                        });
                      },
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
                maxLength: 18,
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
                      double.tryParse(val) + _free > assets.blance) {
                    return "转出金额为0至${assets.blance}(含手续费)之间";
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
                  "预计手续费 $_free ${assets.symbol}",
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
                    if (val == null || val == "" || val.length != 16) {
                      return "支付密码为16位数";
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
                  color: Colors.indigo,
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
                          assets, _addressCtl.text, _payPasswd, _amount);
                      if (_data.state) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (build) {
                          return TransferSuccessPage("转账成功");
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
