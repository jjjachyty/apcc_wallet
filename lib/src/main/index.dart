import 'package:apcc_wallet/src/common/loding.dart';
import 'package:apcc_wallet/src/model/coin_price.dart';
import 'package:apcc_wallet/src/model/news.dart';
import 'package:apcc_wallet/src/news/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  List<News> _news = new List();

  @override
  void initState() {
    getNews().then((val) {
      setState(() {
        _news = val;
      });
    });
    print("initState");

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    print("dispose");
    // TODO: implement dispose
    super.dispose();
  }

  Widget _coinPrice() {
    return Container(
        height: 300,
        child: FutureBuilder(
          future: getPrice(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final price = snapshot.data as List<CoinPrice>;
              return ListView.separated(
                itemCount: price.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: coinIcons[price[index].code],
                      title: Text(price[index].code),
                      trailing: Container(
                        width: 130,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "￥",
                              style: TextStyle(fontSize: 10),
                            ),
                            Text(
                              price[index].priceCny.toStringAsFixed(2),
                              style: TextStyle(
                                  color: price[index].percent24h > 0
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 18),
                            ),
                            Text(
                              price[index].percent24h > 0 ? "↑" : "↓",
                              style: TextStyle(fontSize: 10),
                            ),
                            Text(
                                price[index].percent24h.toStringAsFixed(2) +
                                    "%",
                                style: TextStyle(
                                    color: price[index].percent24h > 0
                                        ? Colors.red
                                        : Colors.green,
                                    fontSize: 10)),
                          ],
                        ),
                      ));
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
      return new Center(
        heightFactor: 6,
        child: new Text('加载中...'),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        _newsSwiper(),
        _coinPrice(),
      ],
    ));
  }
}
