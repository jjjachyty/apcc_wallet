import 'dart:io';

import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:image_picker/image_picker.dart';

class IDCardAuth extends StatefulWidget {
  @override
  _IDCardAuthState createState() => _IDCardAuthState();
}

class _IDCardAuthState extends State<IDCardAuth> {
  File _img1, _img2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("实名认证"),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "注意事项:\n 1.\t实名认证认证成功后不可更改\n 2.\t实名认证将用于提款验证,请务必上传本人真实身份证",
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    var image =
                        await ImagePicker.pickImage(source: ImageSource.camera);

                    setState(() {
                      _img1 = image;
                    });
                  },
                  child: Icon(IconData(0xe50c, fontFamily: 'myIcon'),
                      size: 100, color: Colors.green),
                )),
                Expanded(
                  child: _img1 == null ? Text("点击左侧上传正面照") : Image.file(_img1,fit: BoxFit.fill,width: 200,height: 100,),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    var image =
                        await ImagePicker.pickImage(source: ImageSource.camera);

                    setState(() {
                      _img2 = image;
                    });
                  },
                  child: Icon(IconData(0xe616, fontFamily: 'myIcon'),
                      size: 100, color: Colors.green),
                )),
                Expanded(
                  child: _img2 == null ? Text("点击左侧上传反面照") :Image.file(_img2,fit: BoxFit.fill,width: 200,height: 100,),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ProgressButton(
              color: Colors.green,
              defaultWidget: Text(
                "认证",
                style: TextStyle(color: Colors.white),
              ),
              progressWidget: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
              onPressed: () async {
                idCardRecognition(_img1,_img2);
              },
              
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
