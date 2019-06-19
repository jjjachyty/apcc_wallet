import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CoinPrice{
  String code;
  double priceUsd;
  double priceCny;
  double percent24h;
  CoinPrice({this.code,this.priceCny,this.priceUsd,this.percent24h});
}

Map<String,Widget> coinIcons = {"ethereum":Icon(IconData(0xe60c,fontFamily: 'myIcon'),color: Colors.red,),
"tether":Icon(IconData(0xe61a,fontFamily: 'myIcon'),color: Colors.red,),
"apcc":Icon(IconData(0xe681,fontFamily: 'myIcon'),color: Colors.red,),
"bitcoin":Icon(IconData(0xe609,fontFamily: 'myIcon'),color: Colors.red,),

};



var apiURL ="https://www.hqz.com/api/index/get_index_refresh/?type=&sortby=&sort=desc&filter=&p=1"; 
Future<List<CoinPrice>> getPrice() async {
  List<CoinPrice>   _coinPrice = new List();

   final _data =  await Dio().get(apiURL);

   var  coins = _data.data["coin"]["data"];

  _coinPrice.add(CoinPrice(code: "apcc",priceCny: 1.05,percent24h: 0));

   for (var item in coins) {
     if (item["coincode"] =='ethereum' || item["coincode"] =='tether' || item["coincode"]=='bitcoin'){
       _coinPrice.add(CoinPrice(code: item["coincode"],priceCny: item["price_cny"],percent24h: item["percent_24h"]));
       }
   }

  return _coinPrice;
}