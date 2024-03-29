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
      final flutterWebViewPlugin = FlutterWebviewPlugin();

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
      backgroundColor: Color.fromRGBO(0, 74, 149, 1),
      body: Column(
        mainAxisSize: MainAxisSize.min,
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
              hintText: "点击搜索DAPP",
              hintStyle: TextStyle(
                color: Colors.white54,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white54,
              ),
              contentPadding: EdgeInsets.all(0),
              border: OutlineInputBorder()),
        ));
  }

  Widget _appList() {
    return Expanded(
        child: Container(
      child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                 launchDapp(context, _list[index]);
              },
              child: Card(
                //z轴的高度，设置card的阴影
                elevation: 10.0,
                //设置shape，这里设置成了R角
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
                clipBehavior: Clip.antiAlias,
                semanticContainer: false,
                child: Container(
                  height: 91,
                  padding: EdgeInsets.symmetric(horizontal: 23, vertical: 23),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _list[index].logo,
                              width: 44,
                              height: 44,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                _list[index].name,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              Text(
                                _list[index].subtitle,
                                style: TextStyle(fontSize: 11,color: Colors.blue.shade200),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text.rich(
                            TextSpan(
                                text: _list[index].category,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                                children: [
                                  TextSpan(
                                    text: _list[index].score + "分",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                          ),
                          Text(
                            _list[index].used + "人在使用",
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ],
                  ),
                ))
            ); 
          }),
      padding: EdgeInsets.symmetric(horizontal: 12),
    ));
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
        height: MediaQuery.of(context).size.width * 0.5,
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
            launchDapp(context, _list[index]);
          },
        ));
  }
}
