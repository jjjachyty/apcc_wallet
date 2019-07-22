
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart';
final newsURL = "http://api.apcchis.com/news/list";
final newsDetailURL = "http://api.apcchis.com/news/detail";

class News{
  String id;
      String title;
      String imgUrl;
      String content;
      int  createAt;
      News({this.id,this.title,this.imgUrl,this.content,this.createAt});
}

Future<List<News>> getNews() async{
    List<News> _news = new List();
   var response = await Dio().get(newsURL);
   print("getNews");
  final _list = json.decode(response.data)["data"]["data"];
  for (var item in _list) {
    _news.add(News(id:item["id"].toString(),title:item["title"],imgUrl: item["cover"],content: item["content"] ));
  }
return _news;
}


Future<News> getNewsDetail(String id) async{
  
   final response = await Dio().get(newsDetailURL,queryParameters: {"id":id});
 
  final _data = json.decode(response.data)["data"];
 print(_data);
   final _news =  News(id:_data["id"].toString(),title:_data["title"],imgUrl: _data["cover"],content: _data["content"],createAt: _data["ctime"] );
    print(_news.content);

return _news;
}