import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("联系我们"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(
                IconData(0xe600, fontFamily: 'myIcon'),
                color: Colors.green,
              ),
              trailing: Text("yaxingda001（13308313620）"),
              onTap: () async {
                if (await canLaunch("weixin://")) {
                  await launch("weixin://");
                }
              },
            ),
            ListTile(
              leading: Icon(
                IconData(0xe63d, fontFamily: 'myIcon'),
                color: Colors.green,
              ),
              trailing: Text("..."),
            ),
            ListTile(
              leading: Icon(
                IconData(0xe65c, fontFamily: 'myIcon'),
                color: Colors.green,
              ),
              trailing: Text("392851289"),
            ),
            ListTile(
              leading: Icon(Icons.phone,color: Colors.green,),
              trailing: Text("023-68899565"),
              onTap: () {
                launch("tel:023-12345678");
              },
            ),
            ListTile(
              leading: Icon(
                Icons.pin_drop,
                color: Colors.green,
              ),
              trailing: Text("重庆市渝中区大坪协信总部城D区1栋3楼"),
            )
          ],
        ),
      ),
    );
  }
}
