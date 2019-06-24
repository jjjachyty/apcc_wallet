import 'dart:io';

import 'package:dio/dio.dart';

class Data {
  bool state;
  String msg;
  dynamic data;
  Data({this.state,this.msg,this.data});
}

var apiURL = "http://192.168.1.11:9090/api/wallet/v1";

var dio = Dio(BaseOptions(
    baseUrl: apiURL,
    connectTimeout: 5000,
    receiveTimeout: 50000,
    headers: {HttpHeaders.userAgentHeader: 'dio', 'common-header': 'xx'},
   ));