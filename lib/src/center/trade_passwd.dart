import 'package:apcc_wallet/src/model/user.dart';
import 'package:apcc_wallet/src/store/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class TradePassWd extends StatefulWidget {
  var hasPasswd = false;
  TradePassWd(this.hasPasswd);

  @override
  _TradePassWdState createState() => _TradePassWdState(this.hasPasswd);
}

class _TradePassWdState extends State<TradePassWd> {
  var hasPasswd;
  _TradePassWdState(this.hasPasswd);
  var _obscureFlag = true;
  GlobalKey<FormState> _passwdForm = GlobalKey<FormState>();
  TextEditingController _passwdCtr = new TextEditingController();
  String _orgPasswd, _passwd, _passwdConf;

  Widget _initWidget() {
    return Scaffold(
        appBar: AppBar(
          title: Text("设置交易密码"),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _passwdForm,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _passwdCtr,
                  obscureText: _obscureFlag,
                  maxLength: 16,
                  validator: (val) {
                    if (val == null || val.length < 6 || val.length > 16) {
                      return "密码为6-16位字母或数字";
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "交易密码",
                      counterText: "",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            _obscureFlag = !_obscureFlag;
                          });
                        },
                      )),
                  onSaved: (val) {
                    _passwd = val;
                  },
                ),
                TextFormField(
                  validator: (val) {
                    if (val != _passwdCtr.text) {
                      return "两次密码不一致";
                    }
                  },
                  obscureText: _obscureFlag,
                  maxLength: 16,
                  decoration: InputDecoration(
                      hintText: "确认交易密码",
                      counterText: "",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            _obscureFlag = !_obscureFlag;
                          });
                        },
                      )),
                  onSaved: (val) {
                    _passwdConf = val;
                  },
                ),
                new StoreConnector<AppState, Store<AppState>>(
                    converter: (store) => store,
                    builder: (context, store) {
                      return ProgressButton(
                        color: Colors.green,
                        defaultWidget: Text(
                          "设置",
                          style: TextStyle(color: Colors.white),
                        ),
                        progressWidget: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.lightGreen)),
                        onPressed: () async {
                          var data =
                              await setTradePasswd(_passwd, _passwdConf, store);
                          if (data.state) {
                            SnackBar(
                              content: Text("设置成功"),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                      );
                    })
              ],
            ),
          ),
        ));
  }

  Widget _modifyWidget() {
    return Scaffold(
        appBar: AppBar(
          title: Text("修改交易密码"),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _passwdForm,
            child: Column(
              children: <Widget>[
                TextFormField(
                  obscureText: _obscureFlag,
                  autovalidate: true,
                  decoration: InputDecoration(
                      hintText: "原密码",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            _obscureFlag = !_obscureFlag;
                          });
                        },
                      )),
                  validator: (val) {
                    if (val == null || val.length < 6 || val.length > 16) {
                      return "密码为6-16未字母或数字组成的数";
                    }
                  },
                  onSaved: (val) {
                    this._orgPasswd = val;
                  },
                ),
                TextFormField(
                  obscureText: _obscureFlag,
                  controller: _passwdCtr,
                  autovalidate: true,
                  validator: (val) {
                    if (val == null || val.length < 6 || val.length > 16) {
                      return "密码为6-16未字母或数字组成的数";
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "新密码",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            _obscureFlag = !_obscureFlag;
                          });
                        },
                      )),
                  onSaved: (val) {
                    _passwd = val;
                  },
                ),
                TextFormField(
                  obscureText: _obscureFlag,
                  autovalidate: true,
                  decoration: InputDecoration(
                      hintText: "确认新密码",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            _obscureFlag = !_obscureFlag;
                          });
                        },
                      )),
                  validator: (val) {
                    if (val != _passwdCtr.text) {
                      return "两次密码不一致";
                    }
                  },
                  onSaved: (val) {
                    _passwdConf = val;
                  },
                ),
                SizedBox(height: 20,),
                ProgressButton(
                
                  color: Colors.green,
                  defaultWidget: Text(
                    "修改",
                    style: TextStyle(color: Colors.white),
                  ),
                  progressWidget: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
                  onPressed: () async {
                    if (_passwdForm.currentState.validate()){
                      _passwdForm.currentState.save();
                      final _result= await modifiyTradePasswd(_orgPasswd, _passwd, _passwdConf);
                      if (_result.state){
                        SnackBar(content: Text("修改成功"),);
                        Navigator.of(context).pop();
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (this.hasPasswd) {
      return _modifyWidget();
    }

    return _initWidget();
  }

  @override
  void dispose() {
    _passwdCtr.dispose();
    super.dispose();
  }
}
