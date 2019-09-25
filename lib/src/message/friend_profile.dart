import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/message/chart.dart';
import 'package:apcc_wallet/src/model/im_friend.dart';
import 'package:flutter/material.dart';

class FriendPofilePage extends StatelessWidget {
  Friend friend;
  FriendPofilePage(this.friend);
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
                      placeholder: "assets/images/loading.gif",
                      image: friend.friendAvatar == ""
                          ? "assets/images/nologinavatar.png"
                          : imageHost +
                              friend.friendAvatar +
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
                          Text(friend.friendNickName)
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "ID:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(friend.friendID)
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
                    friend.friendIntroduce,
                    maxLines: 3,
                  )
                ],
              ),
              SizedBox(height: 20,),
             
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                minWidth: double.maxFinite,
                color: Colors.blue.shade700,
                child: Text(
                  "发消息",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  var chart = MessageChartPage(friend);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context){
                      return chart;
                    }
                  ));
                },
              )
            ],
          ),
        )));
  }
  
}