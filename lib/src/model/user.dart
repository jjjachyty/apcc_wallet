import 'dart:convert';
import 'dart:io';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/id_card.dart';
import 'package:dio/dio.dart';


User user;

class User {
  String uuid;
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
  int idCardAuth;
  String introduce;
  List<Account> accounts; //账户

  User(
      {this.uuid,
      this.phone,
      this.nickName,
      this.avatar,
      this.passWord,
      this.hasPayPasswd,
      this.lastLoginTime,
      this.lastLoginIP,
      this.lastLoginDevice,
      this.state,
      this.idCard,
      this.introduce,
      this.accounts,
      this.idCardAuth});

  User.fromJson(Map<String, dynamic> json)
      : uuid = json["UUID"],
        phone = json["Phone"],
        nickName = json["NickName"],
        avatar = json["Avatar"],
        idCardAuth = json["IDCardAuth"],
        introduce = json["Introduce"],
        hasPayPasswd = json["HasPayPasswd"];

  String toJson() {
    var _tmp = {
      'UUID': this.uuid,
      'Phone': this.phone,
      'NickName': this.nickName,
      'Avatar': this.avatar,
      'Introduce':this.introduce,
      'IDCardAuth': this.idCardAuth,
      'HasPayPasswd': this.hasPayPasswd
    };
    return json.encode(_tmp);
  }
}

class Account {
  String coinType; //币类型
  String address; //地址
}

void setUser(User newUser) async {
  user = newUser;
  await setStorageString("_user", user.toJson());
}

Future<User> getUser() async {
  var _userStr = await getStorageString("_user");
  if (_userStr == null) {
    return null;
  }
  user = User.fromJson(json.decode(_userStr));
  return user;
}

void loginOut() {
  user = null;
  removeStorage("_user");
  removeStorage("_token");
}

Future<Data> loginWithPW(String phone, passwd) async {
  var _data = await post("/auth/loginwithpw",
      data: {"phone": phone, "password": passwd});
  if (_data.state) {
    api.options.headers[HttpHeaders.authorizationHeader] = _data.data["Token"];
    setStorageString("_token", _data.data["Token"]);
    var _user = User.fromJson(_data.data["User"]);
    _data.data = _user;
    setUser(_user);
  }
  return _data;
}

Future<Data> loginWithSMS(String phone, sms) async {
  var _data = await post("/auth/loginwithsms",
      data: new FormData.from({"phone": phone, "sms": sms}));
  print(_data.data);
  if (_data.state) {
    api.options.headers[HttpHeaders.authorizationHeader] = _data.data["Token"];
    setStorageString("_token", _data.data["Token"]);
    var user = User.fromJson(_data.data["User"]);
    print(user.toJson());
    setUser(User.fromJson(_data.data["User"]));
  }
  return _data;
}

Future<Data> register(String phone, passwd) async {

  return await post("/auth/register", data: {"phone": phone, "password": passwd});;
}

Future<Data> setPayPasswd(String password) async {
  //  response=await dio.post("/test",data:{"id":12,"name":"wendu"})
  var _data = await post("/user/paypasswd",
      data: new FormData.from({"password": password}));

  if (_data.state) {
    setStorageString("_user", user.toJson());
  }

  return _data;
}

Future<Data> checkPhone(String phone) async {
  return await get("/auth/checkphone",
      parameters: 
          {"phone": phone});
}
Future<Data> getUserByPhone(String phone) async {
  return await get("/user/"+phone,
      parameters: null);
}

Future<Data> modifiyTradePasswd(String orgPasswd, passwdConf) async {
  return await post("/user/paypasswd",
      data: new FormData.from(
          {"orgPassword": orgPasswd, "password": passwdConf}));
}

Future<Data> modifiyLoginPasswd(String passwd) async {
  return await post("/user/loginpasswd",
      data: new FormData.from({"password": passwd}));
}

Future<Data> modifiyProfile(File image, String nickName,String introduce) async {
  var _forData = new FormData.from({"nickName": nickName,"introduce":introduce});

  if (image != null) {
    String path = image.path;

    print(await image.length());
    List<int> bytes = await image.readAsBytes();
    _forData.add("avatar", new UploadFileInfo(image, "avatar"));
  }
  var _data = await post("/user/profile", data: _forData);
  if (_data.state) {
    var _user = User.fromJson(json.decode(await getStorageString("_user")));
    if (image != null) {
      _user.avatar = _user.uuid;
    }
    if (nickName != _user.nickName) {
      _user.nickName = nickName;
    }
    setStorageString("_user", _user.toJson());
    // eventBus.fire(UserInfoUpdate(_user));
    user = _user;
  }

  return _data;
}

Future<Data> idCard(IDCard idCard) async {
  print(idCard);
  var _data = await post("/user/idcard", data: idCard.toJson());
  return _data;
}
