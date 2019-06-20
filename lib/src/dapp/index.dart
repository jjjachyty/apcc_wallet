import 'package:apcc_wallet/src/dapp/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Dapps extends StatelessWidget {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: 'https://www.baidu.com',
      appBar: new AppBar(
        title: const Text('Widget webview'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.chevron_left),onPressed: (){
            
          }),
          IconButton(icon: Icon(Icons.close),onPressed: (){

          },)
        ],
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.redAccent,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}
