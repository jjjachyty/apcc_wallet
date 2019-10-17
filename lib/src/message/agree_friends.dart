import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/model/im_friend.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class AgreeFriendPage extends StatelessWidget {
  FriendApply apply;
  AgreeFriendPage(this.apply);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: "images/nologinavatar.png",
                      image: apply.friendAvatar == ""
                          ? "images/nologinavatar.png"
                          : imageHost +
                              apply.friendAvatar +
                              ".webp?" +
                              DateTime.now().toString(),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "昵称:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(apply.friendNickName)
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "ID:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(apply.friendID)
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Text(
                    "签名:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    apply.friendIntroduce,
                    maxLines: 3,
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Text(
                    "理由:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    apply.explain,
                    maxLines: 3,
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                minWidth: double.maxFinite,
                color: Colors.blue.shade700,
                child: Text(
                  "同意",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  var _data =
                      await friendAgree(apply);
                  if (_data.state) {
                    Toast.show("申请成功", context);
                    Navigator.of(context).pop(true);
                  }
                },
              )
            ],
          ),
        )));
  }
}
