import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrivateKeyPage extends StatelessWidget {
  String privateKey;
  PrivateKeyPage(this.privateKey);
  GlobalKey<ScaffoldState> scaffold = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed("/main");
          },
        ),
        title: Text("创建成功"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(
              "请保存好您的私钥",
              style: TextStyle(fontSize: 20),
            ),
            Divider(),
            Text(
              privateKey,
              style: TextStyle(fontSize: 15),
            ),
            Divider(),
            FlatButton(
              child: Text(
                "复制",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: privateKey));
                scaffold.currentState.showSnackBar(SnackBar(
                  content: Text("复制成功"),
                  backgroundColor: Colors.green,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
