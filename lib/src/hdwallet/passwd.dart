import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/hdwallet/private_key.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:apcc_wallet/src/store/actions.dart';
import 'package:apcc_wallet/src/store/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:progress_dialog/progress_dialog.dart';


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
    
     var _pk = "";

    //测试
 
    final form = _passwdForm.currentState;
    if (form.validate()) {

     
      form.save();

      new Future.delayed(Duration(seconds: 1), () {
             createMain(mnemonic, _passwdConf).then((privateKey) {
               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                 return PrivateKeyPage(privateKey);
               }),(route)=>false);
      });
  
              

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
