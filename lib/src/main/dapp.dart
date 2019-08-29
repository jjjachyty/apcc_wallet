import 'package:apcc_wallet/src/dapp/common.dart';
import 'package:apcc_wallet/src/dapp/developing.dart';
import 'package:apcc_wallet/src/dapp/search.dart';
import 'package:apcc_wallet/src/dapp/dapp.dart';
import 'package:apcc_wallet/src/dapp/jsChannel.dart';
import 'package:apcc_wallet/src/model/dapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class DappsPage extends StatefulWidget {
  @override
  _DappsPageState createState() => _DappsPageState();
}

class _DappsPageState extends State<DappsPage> {
  List<Dapp> _list = new List();
  List<Dapp> _listSwiper = new List();
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    all({"order": "used", "sort": "desc"}).then((page) {
      setState(() {
        _list = page.rows;
        _listSwiper..add(_list[0])..add(_list[1])..add(_list[2])..add(_list[3]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _swiper(),
          _searchBar(),
          _appList(),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextField(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return SearchAppPage();
            }));
          },
          // enabled: false,
          decoration: InputDecoration(
              hintText: "点击搜索Dapp",
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.all(0),
              border: OutlineInputBorder()),
        ));
  }

  Widget _appList() {
    return Expanded(
        child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(
                  _list[index].logo,
                  width: 60,
                  fit: BoxFit.fill,
                ),
                title: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _list[index].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _list[index].subtitle,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                trailing: Column(
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                          text: _list[index].category,
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                          children: [
                            TextSpan(
                              text: _list[index].score + "分",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                    ),
                    Text(
                      _list[index].used + "人在使用",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                onTap: () {
                   launchDapp(context,_list[index]);
                },
              );
            }));
  }

  Widget _swiper() {
    if (_listSwiper.length == 0) {
      return new Center(
        heightFactor: 6,
        child: new Text('加载中...'),
      );
    }
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 200.0,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return (Image.network(
              _listSwiper[index].banner,
              fit: BoxFit.fill,
            ));
          },
          itemCount: _listSwiper.length,
          pagination: SwiperPagination(
              alignment: Alignment.bottomRight,
              builder: DotSwiperPaginationBuilder(
                  color: Colors.white70, // 其他点的颜色
                  activeColor: Colors.white, // 当前点的颜色
                  space: 2, // 点与点之间的距离
                  activeSize: 10 // 当前点的大小
                  )),
          // control: new SwiperControl(),
          scrollDirection: Axis.horizontal,
          autoplay: true,
          autoplayDelay: 5000,
          onTap: (index) {
                launchDapp(context,_list[index]);
          },
        ));
  }
}
