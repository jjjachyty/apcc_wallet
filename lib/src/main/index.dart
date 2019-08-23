import 'package:apcc_wallet/src/common/loding.dart';
import 'package:apcc_wallet/src/dapp/index.dart';
import 'package:apcc_wallet/src/dapp/test.dart';
import 'package:apcc_wallet/src/model/coins.dart';
import 'package:apcc_wallet/src/model/dapp.dart';
import 'package:apcc_wallet/src/model/news.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:apcc_wallet/src/news/detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  List<News> _news = new List();
  List<Dapp> _list = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews().then((_data) {
      setState(() {
        _news = _data;
      });
    });
    main().then((data) {
      setState(() {
        _list = data.data;
      });
    });
  }

  @override
  void dispose() {
    print("dispose");
    // TODO: implement dispose
    super.dispose();
  }

  Widget _coinPrice() {
    return Container(
        height: 200,
        child: FutureBuilder(
          future: getPrice(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final price = snapshot.data as List<Coin>;
              return ListView.separated(
                itemCount: price.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: coinIcons[price[index].nameEn],
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(price[index].nameEn),
                        flex: 2,
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "￥" + price[index].priceCny.toStringAsFixed(2),
                          style: TextStyle(
                              color: price[index].percent24h > 0
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: Text(
                            (price[index].percent24h > 0 ? "↑" : "↓") +
                                price[index].percent24h.toStringAsFixed(2) +
                                "%",
                            style: TextStyle(
                                color: price[index].percent24h > 0
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 10)),
                      )
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
              );
            } else {
              return Loading();
            }
          },
        )

        //  ListView(

        //   padding: EdgeInsets.all(8),
        //   children: <Widget>[
        //     Column(
        //       children: <Widget>[
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: <Widget>[
        //             Icon(IconData(0xe61a,fontFamily: 'myIcon'),color: Colors.green,),
        //             Text("APCC"),
        //             Expanded(child: Text("\$12.888",textAlign: TextAlign.end,),),
        //           ],
        //         ),
        //         Divider(),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: <Widget>[
        //             Icon(IconData(0xf19b,fontFamily: 'myIcon'),color: Colors.green,),
        //             Text("ETH"),
        //             Expanded(child: Text("\$12.888",textAlign: TextAlign.end,),),
        //           ],
        //         ),
        //         Divider(),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: <Widget>[
        //             Icon(IconData(0xe61a,fontFamily: 'myIcon'),color: Colors.green,),
        //             Text("USDT"),
        //             Expanded(child: Text("\$12.888",textAlign: TextAlign.end,),),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ]

        // ),
        );
  }

  Widget _newsSwiper() {
    if (_news.length == 0) {
      return Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: new Center(
            heightFactor: 250,
            child: Loading(),
          ));
    }

    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Swiper(
        pagination: SwiperPagination(
            alignment: Alignment.bottomRight,
            builder: DotSwiperPaginationBuilder(
                color: Colors.white70, // 其他点的颜色
                activeColor: Colors.white, // 当前点的颜色
                space: 2, // 点与点之间的距离
                activeSize: 10 // 当前点的大小
                )),
        onTap: (index) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewsDeatil(_news[index].id);
          }));
        },
        itemCount: _news.length,
        autoplay: true,
        autoplayDelay: 5000,
        // duration: 50000,
        itemBuilder: (context, index) {
          var _imgUr = _news[index].imgUrl;
          return Stack(
            children: <Widget>[
              ConstrainedBox(
                child: Image.network(
                  _imgUr,
                  fit: BoxFit.fill,
                ),
                constraints: new BoxConstraints.expand(),
              ),
              Positioned(
                bottom: 0,
                child: Text(
                  _news[index].title,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _usedDapp() {
    return Container(
        height: 90,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: _list == null
            ? Loading()
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          _list[index].logo,
                          height: 60,
                          width: 80,
                        ),
                        Text(
                          _list[index].name,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, PageRouteBuilder(pageBuilder:
                          (BuildContext context, Animation animation,
                              Animation secondaryAnimation) {
                        return ScaleTransition(
                            scale: animation,
                            alignment: Alignment.center,
                            child: MyApp());
                      }));
                    },
                  );
                },
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _newsSwiper(),
        Divider(),
        // Text(user==null?"推荐":"常用",style: TextStyle(fontSize: 12)),
        _usedDapp(),
        Divider(),
        _coinPrice(),
      ],
    ));
  }
}
