
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart';
final newsURL = "http://api.apcchis.com/news/list";
class news{
  String id;
      String title;
      String imgUrl;
      String content;
      news({this.id,this.title,this.imgUrl,this.content});
}

Future<List<news>> getNews() async{
    List<news> _news = new List();
   final response = await Dio().get(newsURL);
   print("getNews");
  final _list = json.decode(response.data)["data"]["data"];
  for (var item in _list) {
    _news.add(news(id:item["id"].toString(),title:item["title"],imgUrl: item["cover"],content: item["content"] ));
  }
return _news;
}