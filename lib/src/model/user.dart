import 'dart:convert';
import 'dart:io';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/store/state.dart';
import 'package:dio/dio.dart';

import 'package:redux/redux.dart';

class User {
  String phone;
  String nickName;
  String avatar;
  String passWord;
  bool hasPayPasswd; //是否有交易密码
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
      this.hasPayPasswd,
      this.lastLoginTime,
      this.lastLoginIP,
      this.lastLoginDevice,
      this.state,
      this.idCard,
      this.accounts});

  User.fromJson(Map<String, dynamic> json)
      : phone = json["Phone"],
        nickName = json["NickName"],
        avatar = json["Avatar"],
        hasPayPasswd = json["HasPayPasswd"];
  @override
  String toString() {
    var _tmp = {
      'Phone': this.phone,
      'NickName': this.nickName,
      'Avatar': this.avatar,
      'HasPayPasswd': this.hasPayPasswd
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

Future<Data> loginWithPW(String phone, passwd) async {
    var _data=await post("/auth/loginwithpw",data:{"phone":phone,"password":passwd});
    print(_data.data);
    if (_data.state){
        api.options.headers[HttpHeaders.authorizationHeader]=_data.data["Token"];
        setStorageString("_token", _data.data["Token"]);
        var user = User.fromJson(_data.data["User"]);
        print(user.toString());
        setStorageString("_user",user.toString() );
    }
  return _data;
}


Future<Data> loginWithSMS(String phone, sms) async {
 var _data=await post("/auth/loginwithsms",data:new FormData.from({"phone":phone,"sms":sms}));
    print(_data.data);
    if (_data.state){
        api.options.headers[HttpHeaders.authorizationHeader]=_data.data["Token"];
        setStorageString("_token", _data.data["Token"]);
        var user = User.fromJson(_data.data["User"]);
        print(user.toString());
        setStorageString("_user",user.toString() );
    }
  return _data;
}

Future<dynamic> register(String phone, passwd) async {
  var response=await api.post("/auth/register",data:{"phone":phone,"password":passwd});
  return response.data;
}

Future<Data> setPayPasswd(
    String password, Store<AppState> store) async {
  //  response=await dio.post("/test",data:{"id":12,"name":"wendu"})
  var _data=await post("/user/paypasswd",data:new FormData.from({"password":password}));

  if (_data.state){
      store.state.user.hasPayPasswd = true;
      setStorageString("_user", store.state.user.toString());
      print(getStorageString("_user"));
  }

  return _data;
}

Future<Data> modifiyTradePasswd(String orgPasswd,  passwdConf) async {
   

  return await post("/user/paypasswd",data:new FormData.from({"orgPassword":orgPasswd,"password":passwdConf}));
}
Future<Data> modifiyLoginPasswd(String passwd) async {
   

  return await post("/user/loginpasswd",data:new FormData.from({"password":passwd}));
}
