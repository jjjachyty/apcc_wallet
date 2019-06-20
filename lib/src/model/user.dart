import 'dart:convert';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/store/state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:redux/redux.dart';

class User {
  String phone;
  String nickName;
  String avatar;
  String passWord;
  bool hasTradePasswd; //是否有交易密码
  String lastLoginTime;
  String lastLoginIP;
  String lastLoginDevice;
  String state; //账户状态
  IDCard idCard;
  List<Account> accounts; //账户

  User(
      {this.phone,
      this.nickName,
      this.avatar,
      this.passWord,
      this.hasTradePasswd,
      this.lastLoginTime,
      this.lastLoginIP,
      this.lastLoginDevice,
      this.state,
      this.idCard,
      this.accounts});

  User.fromJson(Map<String, dynamic> json)
      : phone = json["phone"],
        nickName = json["nickName"],
        avatar = json["avatar"],
        hasTradePasswd = json["avatar"];
  @override
  String toString() {
    var _tmp = {
      'phone': this.phone,
      'nickName': this.nickName,
      'avatar': this.avatar,
      'hasTradePasswd': this.hasTradePasswd
    };
    return json.encode(_tmp);
  }
}

//身份证
class IDCard {
  String number; //身份证号
  String sex; //性别
  String birthday; //生日
  String expirationDate; //失效日期
}

class Account {
  String coinType; //币类型
  String address; //地址
}

Future<User> login(User user, sms) async {
  //  response=await dio.post("/test",data:{"id":12,"name":"wendu"})
  await Future.delayed(Duration(seconds: 5));
  setStorageString("_user", user.toString());
  return user;
}

Future<dynamic> register(String phone, passwd) async {
  //  response=await dio.post("/test",data:{"id":12,"name":"wendu"})
  await Future.delayed(Duration(seconds: 5));
  print(phone + passwd);
  return "";
}

Future<Data> setTradePasswd(
    String passwd, passwdConf, Store<AppState> store) async {
  //  response=await dio.post("/test",data:{"id":12,"name":"wendu"})
  await Future.delayed(Duration(seconds: 5));
  store.state.user.hasTradePasswd = true;
  setStorageString("_user", store.state.user.toString());
  print(getStorageString("_user"));
  return Data(state: true);
}

Future<Data> modifiyTradePasswd(String orgPasswd, passwd, passwdConf) async {
  //  response=await dio.post("/test",data:{"id":12,"name":"wendu"})
  await Future.delayed(Duration(seconds: 5));
  print(getStorageString("_user"));
  return Data(state: true);
}
