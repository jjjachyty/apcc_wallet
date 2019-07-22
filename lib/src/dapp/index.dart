import 'package:apcc_wallet/src/model/dapp.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DappPage extends StatefulWidget {
  Dapp app;
  DappPage(this.app);
  @override
  _DappPageState createState() => _DappPageState(this.app);
}

class _DappPageState extends State<DappPage> {
   Dapp app;
  _DappPageState(this.app);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(app.name),
        centerTitle: true,
        actions: <Widget>[
        IconButton(icon: Icon(Icons.close),onPressed: (){
          Navigator.of(context).pop();
        },)
      ],),
      body: Container(
        child: _context(),
      ),
    );
  }

  Widget _context(){
    if (app.homePage.length >0){
      return WebView(
          initialUrl: app.homePage,);
    }else{
 return Center(child:Text( "开发中"));
    }
  }
}