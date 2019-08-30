
import 'dart:convert';

import 'package:apcc_wallet/src/common/http.dart';
// final newsURL = "http://api.apcchis.com/news/list";
// final newsDetailURL = "http://api.apcchis.com/news/detail";

class News{
  String id;
      String title;
      String imgUrl;
      String content;
      String  createAt;
      News({this.id,this.title,this.imgUrl,this.content,this.createAt});
}

Future<List<News>> getNews() async{
    List<News> _news = new List();
   var response = await get("/com/news",parameters:{"order": "create_at", "sort": "desc","size":5});
   print("getNews");
  if(response.state){
    var _data = response.data["Rows"];
      for (var item in _data) {
    _news.add(News(id:item["UUID"].toString(),title:item["Title"],imgUrl: item["Banner"],content: item["Content"] ));
  }
  }

return _news;
}


Future<News> getNewsDetail(String id) async{
  var _news ;
   final response = await get("/com/newsdetail",parameters: {"uuid":id});
 
  if(response.state){
    var _data = response.data;
    _news =  News(id:_data["UUID"].toString(),title:_data["Title"],imgUrl: _data["Banner"],content: _data["Content"],createAt: _data["CreateAt"] );
  }
return _news;
}