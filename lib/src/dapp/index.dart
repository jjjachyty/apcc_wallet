import 'dart:async';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/dapp/jsChannel.dart';
import 'package:apcc_wallet/src/model/dapp.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(app.name),
        centerTitle: true,
        actions: <Widget>[
        IconButton(icon: Icon(Icons.close),onPressed: (){
          Navigator.of(context).pop();
        },),
        SampleMenu(_controller.future),

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
          // javascriptChannels: getJsChannel(context,_controller.future,app),
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith(app.homePage)) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) async {
            print('Page finished loading: $url');
            (await _controller.future).evaluateJavascript(
        'localStorage["address"] = "'+address[0].val+'";');

          },
        );
      }));
    
  }

 
}

enum MenuOptions {
  about,
  reload,
}

class SampleMenu extends StatelessWidget {
  SampleMenu(this.controller);

  final Future<WebViewController> controller;
  final CookieManager cookieManager = CookieManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.about:
                
                break;
              case MenuOptions.reload:
              controller.data.reload();
              break;
              
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
            PopupMenuItem<MenuOptions>(
                  value: MenuOptions.reload,
                  child: const Text('刷新'),
                  enabled: controller.hasData,
                ),
                PopupMenuItem<MenuOptions>(
                  value: MenuOptions.about,
                  child: const Text('说明'),
                  enabled: controller.hasData,
                ),

              ],
        );
      },
    );
  }
}