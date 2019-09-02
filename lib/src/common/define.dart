import 'package:apcc_wallet/src/model/coins.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:apcc_wallet/src/model/version.dart';

class Data {
  bool state;
  String messsage;
  dynamic data;
  Data({this.state, this.messsage, this.data});
}

class PageData {
  String orderBy;
  String sort;
  int totalRows;
  int pageSize;
  int pageCount;
  int currentPage;
  dynamic rows;
  PageData(
      {this.orderBy,
      this.sort,
      this.totalRows,
      this.pageSize,
      this.pageCount,
      this.currentPage,
      this.rows});
  PageData.fromJson(Map<String, dynamic> json)
      : this.orderBy = json["Page"]["OrderBy"],
        this.sort = json["Page"]["Sort"],
        this.totalRows = json["Page"]["TotalRows"],
        this.pageSize = json["Page"]["PageSize"],
        this.pageCount = json["Page"]["PageCount"],
        this.currentPage = json["Page"]["CurrentPage"],
        this.rows = json["Rows"];
}

RegExp phoneExp = RegExp(
    r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

RegExp passwdExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{16,16}$');
RegExp nickNameExp = RegExp(r'^[\w\u4e00-\u9fa5]{1,8}$');

var avatarURL = "http://avatar.apcchis.com/";
var newestVersion = Version(versionCode: "0.0.8");
var currentVersion = Version(versionCode: "0.0.8");

var payTypes = {
  1000: "货币兑换",
  1001: "内部转账",
  1002: "转出平台",
  1003: "金额解冻",
  1004: "转入平台"
};

var mnemonic = "";
//本地钱包所以的地址
List<Address> address;
//
//USDT价格
Map<String, Coin> coins = new Map();
// Map<String, String> coinReceiveAddress = new Map();

class PasswordError extends Error {
  /** Message describing the assertion error. */
  final Object message;
  PasswordError([this.message]);
  String toString() => "密码错误";
}
