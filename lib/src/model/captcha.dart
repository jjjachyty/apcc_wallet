import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:dio/dio.dart';

class Captcha {}

Future<String> getCaptcha(String id) async {
  var  response = await api.get("/com/captcha",queryParameters: {"phone":id});
  return response.data["Data"]["img"];
}

Future<Data> verificationCaptcha(String id,value) async {
  return await post("/com/captcha",data: new FormData.from({"phone":id,"value":value}));
}

Future<bool> verificationSms(String id,value ) async {
   var  response = await api.post("/com/sms",data:new FormData.from({"phone":id,"value":value} ));
  return response.data["Status"];
}
