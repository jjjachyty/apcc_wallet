import 'package:apcc_wallet/src/common/define.dart';
import 'package:dio/dio.dart';

class Captcha {}

Future<String> getCaptcha(String id) async {
  var  response = await dio.get("/com/captcha",queryParameters: {"phone":id});
  return response.data["Data"]["img"];
}

Future<bool> verificationCaptcha(String id,value) async {
  var  response = await dio.post("/com/captcha",queryParameters: {"phone":id,"value":value});
  return response.data["Status"];
}

Future<bool> verificationSms(String id,value ) async {
   var  response = await dio.post("/com/sms",data:new FormData.from({"phone":id,"value":value} ));
  return response.data["Status"];
}
