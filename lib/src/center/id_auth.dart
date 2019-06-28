import 'dart:io';

import 'package:apcc_wallet/src/model/id_card.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:image_picker/image_picker.dart';

class IDCardRecognition extends StatefulWidget {
  @override
  _IDCardRecognitionState createState() => _IDCardRecognitionState();
}

class _IDCardRecognitionState extends State<IDCardRecognition> {
  File _img1, _img2;
  IDCard _idcard;
  String _errText = "";
  bool _show = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("实名认证"),
      ),
      body: Container(
          height: 400,
          width: double.infinity,
          padding: EdgeInsets.all(8),
          child: _show ? _showText() : _choiseImg()),
    );
  }

  Widget _choiseImg() {
    return Column(
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
                    await ImagePicker.pickImage(source: ImageSource.gallery);

                setState(() {
                  _img1 = image;
                });
              },
              child: Icon(IconData(0xe50c, fontFamily: 'myIcon'),
                  size: 100, color: Colors.green),
            )),
            Expanded(
              child: _img1 == null
                  ? Text("点击左侧上传正面照")
                  : Image.file(
                      _img1,
                      width: 200,
                      height: 100,
                    ),
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
                    await ImagePicker.pickImage(source: ImageSource.gallery);

                setState(() {
                  _img2 = image;
                });
              },
              child: Icon(IconData(0xe616, fontFamily: 'myIcon'),
                  size: 100, color: Colors.green),
            )),
            Expanded(
              child: _img2 == null
                  ? Text("点击左侧上传反面照")
                  : Image.file(
                      _img2,
                      width: 200,
                      height: 100,
                    ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          _errText,
          style: TextStyle(color: Colors.red),
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
            var _data = await recognition(_img1, _img2);
            if (_data.state) {
              IDCard _cd = IDCard.fromJSON(_data.data["Cards"][0]);
              var _endtime = DateTime.parse(
                  _cd.validDate.split("-")[1].replaceAll(".", "-"));
              print(_endtime);
              if (_endtime.isAfter(DateTime.now())) {
                setState(() {
                  print(_data.data["Cards"][0]);
                  this._idcard = _cd;
                  this._show = !this._show;
                  this._errText = "";
                });
              } else {
                setState(() {
                  _errText = "该身份证已过期,无效";
                });
              }
            } else {
              setState(() {
                _errText = _data.messsage;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _showText() {
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text("姓名")),
            Expanded(
              flex: 3,
              child: Text(this._idcard.name),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(child: Text("性别")),
            Expanded(
              child: Text(this._idcard.gender),
            ),
            Expanded(
              child: Text("名族"),
            ),
            Expanded(
              child: Text(_idcard.race),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(child: Text("生日")),
            Expanded(
              flex: 3,
              child: Text(this._idcard.birthday),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(child: Text("地址")),
            Expanded(
              flex: 3,
              child: Text(this._idcard.address),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(child: Text("身份证号")),
            Expanded(
              flex: 3,
              child: Text(this._idcard.number),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(child: Text("签发机关")),
            Expanded(
              flex: 3,
              child: Text(this._idcard.issuedBy),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(child: Text("有效期")),
            Expanded(
              flex: 3,
              child: Text(this._idcard.validDate),
            )
          ],
        ),
        FlatButton(
          child: Text("信息有误,重新认证", style: TextStyle(color: Colors.green)),
          onPressed: () {
            setState(() {
              this._show = !this._show;
              this._errText = "";
            });
          },
        ),
        SizedBox(
          child: Text(_errText),
        ),
        new ProgressButton(
            color: Colors.green,
            defaultWidget: Text(
              "确认无误",
              style: TextStyle(color: Colors.white),
            ),
            progressWidget: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen)),
            onPressed: () async {
              print(_idcard.address);
              var _data = await idCard(this._idcard);
              if (_data.state) {
                Navigator.of(context).pop();
              } else {
                _errText = _data.messsage;
              }
            })
      ],
    );
  }
}
