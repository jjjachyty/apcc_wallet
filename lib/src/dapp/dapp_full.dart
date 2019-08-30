import 'dart:async';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/dapp/common.dart';
import 'package:apcc_wallet/src/dapp/jsChannel.dart';
import 'package:apcc_wallet/src/model/dapp.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

// String selectedUrl = 'http://192.168.1.11:8080';
  // var scaffoldKey = GlobalKey<ScaffoldState>();

class DappFullPage extends StatefulWidget {
  Dapp app;
  @override
  DappFullPage(this.app);
  _DappFullPageState createState() => _DappFullPageState(this.app);
}

class _DappFullPageState extends State<DappFullPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
    StreamSubscription<WebViewStateChanged> _onStateChanged;

  Dapp app;
  _DappFullPageState(this.app);


   @override
  void initState() {
    super.initState();
    _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
  if (mounted) {
    if (state.type == WebViewState.finishLoad) {
      flutterWebViewPlugin.evalJavascript(
          "window.localStorage.setItem('address','"+address[0].val+"');"
      );
    }
  }
});
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onStateChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  WebviewScaffold(
      url: app.homePage,
      javascriptChannels: getJsChannel(),
      //  appBar: AppBar(centerTitle: true,backgroundColor: Colors.transparent,title: Text("APP2MHC",style: TextStyle(color: Colors.green),),elevation: 0,),
      withLocalStorage: true,
      withJavascript: true,      
      initialChild: 
      Builder(builder: (context){
        dappContext = context;
        return   
        Container(
        color: Colors.green,
        child: Center(
          child: Text("广告位招租,详询客服",style: TextStyle(color: Colors.white),),
        ),
      );
     })
      
    );}
}
