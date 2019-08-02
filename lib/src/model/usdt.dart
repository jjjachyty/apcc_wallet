import 'dart:convert';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:dio/dio.dart';



Future<List<Assets>> getUSDT() async {
  List<Assets> _assets = new List();
   var _data =  await get("/assets/all");
   print("getUSDT_data$_data");
   if (_data.state){
     (_data.data as List).forEach((val){
       _assets.add(Assets.fromJson(val));
     });
   }

   return _assets;
}

