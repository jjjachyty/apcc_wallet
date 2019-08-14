import 'dart:async';

import 'package:apcc_wallet/src/dapp/jsChannel.dart';
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
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    used(app.uuid);
  }

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
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'http://192.168.1.11:8080',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            print("onWebViewCreatedonWebViewCreatedonWebViewCreated");
            _controller.complete(webViewController);
          },
          // TODO(iskakaushik): Remove this when collection literals makes it to stable.
          // ignore: prefer_collection_literals
          javascriptChannels: getJsChannel(context,_controller.future,app),
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith(app.homePage)) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
        );
      }));
    
  }

 
}