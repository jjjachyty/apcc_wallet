
class Data {
  bool state;
  String messsage;
  dynamic data;
  Data({this.state,this.messsage,this.data});
}


RegExp phoneExp = RegExp(
    r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');

RegExp passwdExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,16}$');
RegExp nickNameExp = RegExp(
    r'^[\w\u4e00-\u9fa5]{1,8}$');