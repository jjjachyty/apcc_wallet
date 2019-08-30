import 'package:apcc_wallet/src/common/loding.dart';
import 'package:apcc_wallet/src/model/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class NewsDeatil extends StatelessWidget {
  String titleID;
  NewsDeatil(this.titleID);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNewsDetail(this.titleID),
      builder: (context, snapshot) {
        /*表示数据成功返回*/
        if (snapshot.hasData) {
          final _news = snapshot.data as News;
          // var _creteAt = new DateTime.fromMillisecondsSinceEpoch(_news.createAt*1000);

          return Scaffold(
            appBar: AppBar(
              title: Text("新闻"),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _news.title,
                  style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "发布时间${_news.createAt}",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                  textAlign: TextAlign.end,
                ),
                Expanded(
                  child: new MarkdownBody(
                    data: _news.content,
                  ),
                )
              ],
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
