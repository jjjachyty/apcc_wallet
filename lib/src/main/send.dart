import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart'as scanner;

class Send extends StatefulWidget {
  @override
  _SendState createState() => _SendState();
}





class _SendState extends State<Send> {
String barcode = "";

  Future scan() async {
    try {
      String barcode = await scanner.scan();
      setState(() => this.barcode = barcode);
    } catch (e) {
      if (e.code == scanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("发送")),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: "请输入转账地址",
                suffixIcon: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: scan,
                        )
              ),
            )
          ],
        ),
      ),
    );
  }
}




