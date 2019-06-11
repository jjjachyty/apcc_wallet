import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:flutter/material.dart';


class WalletPasswdPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _WalletPasswdState();
  }
}

class _WalletPasswdState extends State<WalletPasswdPage> {
    var _obscureFlag = true;
    String _passwd,_passwdConf ;
    TextEditingController _passwdContrl = new TextEditingController();
      GlobalKey<FormState> _passwdForm = new GlobalKey<FormState>();
 void _onSubmit() {
   //测试

   Create("陕 以 海 字 太 粪 针 亡 带 朱 仓 辞","1234567890123456");
   
    final form = _passwdForm.currentState;
    if(form.validate()) {
      form.save();
      showDialog(context: context, builder: (ctx)=> new AlertDialog(
        content:  new Text('$_passwd $_passwdConf'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(title: Text("钱包密码"),centerTitle: true,),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form (
          key:_passwdForm,
         child: new Column(
          children: <Widget>[
            
            new TextFormField(
              controller: _passwdContrl,
              obscureText: _obscureFlag,
              maxLength: 16,
              autovalidate: true,
              decoration: new InputDecoration(hintText: "请输入密码",counterText: "",suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye),onPressed: (){
                setState((){
                  _obscureFlag = !_obscureFlag;
                });
              },)),
              validator: (val){
                return val.length < 6?"密码长度至少6位":null;
              },
              onSaved: (val){
                this._passwd=val;
              },
            ),
          new TextFormField(
              obscureText: _obscureFlag,
              maxLength: 16,
              decoration: new InputDecoration(hintText: "请输入密码",counterText: "",suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye),onPressed: (){
                setState((){
                  _obscureFlag = !_obscureFlag;
                });
              },)),
              autovalidate: true,
              validator: (val){
  
                 return (val != _passwdContrl.text)?"两次密码不一致":null;
              },
              
              onSaved: (val){
                this._passwdConf=val;
              },
            ),
            new MaterialButton(minWidth: 200,child: new Text('确认', style: const TextStyle(color: Colors.white),),onPressed: _onSubmit, color: Theme.of(context).primaryColor,)
          ],
        ))
      ) ,
    );
  }
}
