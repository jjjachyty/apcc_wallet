import 'dart:io';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class Version extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return    Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "新版本${newestVersion.versionCode}发布",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          actions: <Widget>[
            FlatButton(
              child: Text("去更新",style: TextStyle(color: Colors.white),),
              onPressed: () async{
  if (Platform.isIOS) {
              if (await canLaunch(newestVersion.iosDownloadUrl)) {
                await launch(newestVersion.iosDownloadUrl);
              } else {
                throw 'Could not launch ${newestVersion.iosDownloadUrl}';
              }
              //ios相关代码
            } else if (Platform.isAndroid) {
              if (await canLaunch(newestVersion.androidDownloadUrl)) {
                await launch(newestVersion.androidDownloadUrl);
              } else {
                throw 'Could not launch ${newestVersion.androidDownloadUrl}';
              }
            }
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                child: Text("发布时间 ${newestVersion.releaseTime}",style: TextStyle(fontSize: 12),),
              ),
              Expanded(
                child: new MarkdownBody(data: "${newestVersion.releaseNote}"),//SingleChildScrollView(child: Text("${newestVersion.releaseNote}"),) ,
              ),
             
            ],
          ),
        ),
      );
  }
}