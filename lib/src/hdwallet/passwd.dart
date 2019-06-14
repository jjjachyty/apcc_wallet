import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:apcc_wallet/src/store/actions.dart';
import 'package:apcc_wallet/src/store/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog pr;

class WalletPasswdPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _WalletPasswdState();
  }
}

class _WalletPasswdState extends State<WalletPasswdPage> {
  var _obscureFlag = true;
  String _passwd, _passwdConf;
  TextEditingController _passwdContrl = new TextEditingController();
  GlobalKey<FormState> _passwdForm = new GlobalKey<FormState>();



  void _onSubmit(Store<AppState> store) {
    
  

    //测试
 
    final form = _passwdForm.currentState;
    if (form.validate()) {

     
      form.save();

      new Future.delayed(Duration(seconds: 1), () {
             createMain(store.state.mnemonic, _passwdConf).then((mp) {
        store.dispatch(RefreshWalletsAction(mp));
      });
  
                  showDialog(
          context: context,
          barrierDismissible: true,
          builder: (ctx) => new AlertDialog(
                content: Container(
                  height: 150,
                  child: Column(children: <Widget>[
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center ,
                      
                      children: <Widget>[
                      Icon(Icons.sentiment_very_satisfied,color: Colors.green,),
                        new Text('创建成功')
                    ]),
                   
                    new Text("地址:"+store.state.wallets.keys.first,style: Theme.of(context).textTheme.caption,)
                ],
                ) ) ,
                actions: <Widget>[
                  RaisedButton(
                    textColor: Colors.white,
                    onPressed: () { 
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamedAndRemoveUntil("/index", (Route<dynamic> route) => false);},
                    child: Text("确认"),
                  )
                ],
              ));

      });
 
  


  
        print("=============1==============");

      
 print('submitting to backend...');
  


   



    }
  }


  Widget _buildWidget(){
   return   new Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
              key: _passwdForm,
              child: new Column(
                children: <Widget>[
                  new TextFormField(
                    controller: _passwdContrl,
                    obscureText: _obscureFlag,
                    maxLength: 16,
                    autovalidate: true,
                    decoration: new InputDecoration(
                        hintText: "请输入密码",
                        counterText: "",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              _obscureFlag = !_obscureFlag;
                            });
                          },
                        )),
                    validator: (val) {
                      return val.length < 6 ? "密码长度至少6位" : null;
                    },
                    onSaved: (val) {
                      this._passwd = val;
                    },
                  ),
                  new TextFormField(
                    obscureText: _obscureFlag,
                    maxLength: 16,
                    decoration: new InputDecoration(
                        hintText: "请输入密码",
                        counterText: "",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              _obscureFlag = !_obscureFlag;
                            });
                          },
                        )),
                    autovalidate: true,
                    validator: (val) {
                      return (val != _passwdContrl.text) ? "两次密码不一致" : null;
                    },
                    onSaved: (val) {
                      this._passwdConf = val;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  new StoreConnector<AppState, Store<AppState>>(
                      converter: (store) => store,
                      builder: (context, store) {
                        return new RaisedButton(
                          child: new Text(
                            '创建',
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                          
                              _onSubmit(store);
                            
                          },
                          color: Theme.of(context).primaryColor,
                        );
                      })
                ],
              )));
  }

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage('创建中...');


    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("钱包密码"),
        centerTitle: true,
      ),
      body: _buildWidget(),
      );
   
  }
}
