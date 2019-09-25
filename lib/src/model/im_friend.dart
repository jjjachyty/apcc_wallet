import 'dart:convert';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';

class Friend {
  String uuid;
	String userID;
	String friendID;   
	String label;  
	String createTime; 
	String updateTime;
  String friendAvatar  ; 
	String friendNickName  ; 
	String friendPhone ; 
	String friendIntroduce;
  String nameIndex;
  Friend({this.uuid,this.userID,this.friendID,this.label,this.createTime,this.updateTime,this.friendAvatar,this.friendIntroduce,this.friendNickName,this.friendPhone,this.nameIndex});
  Friend.fromJson(Map<String,dynamic> json):
  this.uuid=json["UUID"],
  this.userID=json["UserID"],
  this.friendID=json["FriendID"],
  this.label=json["Lable"],
  this.createTime=json["CreateTime"],
  this.updateTime=json["UpdateTime"],
  this.friendAvatar=json["FriendAvatar"],
  this.friendIntroduce=json["FriendIntroduce"],
  this.friendNickName=json["FriendNickName"],
  this.friendPhone=json["FriendPhone"];
    String toJson(){
    var _json = {
      "UUID":this.uuid,
      "UserID":this.userID,
      "FriendID":this.friendID,
      "Label":this.label,
      "CreateTime":this.createTime,
      "UpdateTime":this.updateTime,
      "FriendAvatar":this.friendAvatar,
      "FriendNickName":this.friendNickName,
      "FriendPhone":this.friendPhone,
      "FriendIntroduce":this.friendIntroduce,
    };
    return json.encode(_json);
  }
}

class FriendApply {
  String uuid;
	String userID;
	String friendID;   
	String explain;  
  String reply;  
	String createTime; 
	String updateTime;
  String friendAvatar  ; 
	String friendNickName  ; 
	String friendPhone ; 
	String friendIntroduce; 
  FriendApply({this.uuid,this.userID,this.friendID,this.explain,this.reply,this.createTime,this.updateTime,this.friendAvatar,this.friendIntroduce,this.friendNickName,this.friendPhone});
    FriendApply.fromJson(Map<String,dynamic> json):
  this.uuid=json["UUID"],
  this.userID=json["UserID"],
  this.friendID=json["FriendID"],
  this.explain=json["Explain"],
  this.reply=json["Reply"],
  this.createTime=json["CreateTime"],
  this.updateTime=json["UpdateTime"],
  this.friendAvatar=json["FriendAvatar"],
  this.friendIntroduce=json["FriendIntroduce"],
  this.friendNickName=json["FriendNickName"],
  this.friendPhone=json["FriendPhone"];
  String toJson(){
    var _json = {
      "UUID":this.uuid,
      "UserID":this.userID,
      "FriendID":this.friendID,
      "Explain":this.explain,
      "Reply":this.reply,
      "CreateTime":this.createTime,
      "UpdateTime":this.updateTime,
      "FriendAvatar":this.friendAvatar,
      "FriendNickName":this.friendNickName,
      "FriendPhone":this.friendPhone,
      "FriendIntroduce":this.friendIntroduce,
    };
    return json.encode(_json);
  }
}


Future<Data> friendApply(FriendApply apply) async {

  return await post("/im/friend/apply", data: apply.toJson());
}

Future<Data> friendApplys() async {

  return await get("/im/friend/applys");
}

Future<Data> friendAgree(FriendApply friend) async {

  return await post("/im/friend/agree", data: friend.toJson());
}

Future<Data> myFriends() async {

  return await get("/im/friend/list");
}