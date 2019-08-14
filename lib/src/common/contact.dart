import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("联系我们"),),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.phone),
              trailing: Text("xxxx"),
              onTap: () async {
                if (await canLaunch("weixin://")) {
                    await launch("weixin://");
                  }
 
              },
            ),
            ListTile(
              leading: Icon(Icons.ac_unit),
              trailing: Text("xxxx"),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              trailing: Text("023-12345678"),
              onTap: (){
                launch("tel:023-12345678");
              },
            ),
            ListTile(
              leading: Icon(Icons.pin_drop,color: Colors.green,),
              trailing: Text("重庆市渝中区大坪总部城1栋3楼"),
              
            )
          ],
        ),
      ),
    );
  }
}