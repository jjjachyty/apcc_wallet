import 'package:apcc_wallet/src/model/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  List<news> _news = new List();
  @override
  void initState() {
    print("initState");
    getNews().then((val) {
      setState(() {
        _news = val;
      });
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  
  }
  Widget _coinPrice(){
    return Container(
      height: 100,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context,index){
          return Column(
            children: <Widget>[
              Row(
                
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(IconData(0xe61a,fontFamily: 'myIcon'),color: Colors.green,),
                  Text("ETH"),
                  Expanded(child: Text("\$12.888",textAlign: TextAlign.end,),), 
                ],
              )
            ],
          );
        },
      ),
    );
  }
  Widget _newsSwiper(){return        Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: Swiper(
            onTap: (index){
              print(index);
            },
            itemCount: _news.length,
            autoplay: true,
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
