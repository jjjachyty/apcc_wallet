import 'dart:convert';

import 'package:apcc_wallet/src/common/utils.dart';
import 'package:http/http.dart';

class User {
  String phone;
  String nickName;
  String avatar;
  String passWord;
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
      this.lastLoginTime,
      this.lastLoginIP,
      this.lastLoginDevice,
      this.state,
      this.idCard,
      this.accounts});

      User.fromJson(Map<String,dynamic> json):phone=json["phone"],nickName=json["nickName"],avatar=json["avatar"];
      @override
     String toString(){
        var _tmp= {'phone':this.phone,'nickName':this.nickName,'avatar':this.avatar};
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
 setStorageString("_user",user.toString());
  return user;
}
