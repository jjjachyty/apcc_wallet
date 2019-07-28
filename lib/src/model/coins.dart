import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Coin {
  String uuid;
  String nameEn;
  String nameCn;
  String symbol;
  num priceCny;
  num priceUsd;
  num exchangeFree;
  num transferFree;
  String icon;
  String webSite;
  int state;
  String synopsis;
  num percent24h;
  Coin(
      {this.uuid,
      this.nameCn,
      this.nameEn,
      this.symbol,
      this.priceCny,
      this.priceUsd,
      this.exchangeFree,
      this.transferFree,
      this.icon,
      this.percent24h,
      this.webSite,
      this.synopsis,
      this.state});
  Coin.fromJson(Map<String, dynamic> json)
      : this.uuid = json["UUID"],
        this.nameCn = json["NameCn"],
        this.nameEn = json["NameEn"],
        this.symbol = json["Symbol"],
        this.priceCny = json["PriceCny"],
        priceUsd = json["PriceUsd"],
        this.exchangeFree = json["ExchangeFree"],
        this.transferFree = json["TransferFree"],
        this.icon = json["Icon"],
        this.webSite = json["WebSite"],
        this.state = json["State"],
        this.synopsis = json["synopsis"];
}

Map<String, Widget> coinIcons = {
  "ethereum": Icon(
    IconData(0xe60c, fontFamily: 'myIcon'),
    color: Colors.red,
  ),
  "tether": Icon(
    IconData(0xe61a, fontFamily: 'myIcon'),
    color: Colors.red,
  ),
  "apcc": Icon(
    IconData(0xe681, fontFamily: 'myIcon'),
    color: Colors.red,
  ),
  "bitcoin": Icon(
    IconData(0xe609, fontFamily: 'myIcon'),
    color: Colors.red,
  ),
};

var hqzapiURL =
    "https://www.hqz.com/api/index/get_index_refresh/?type=&sortby=&sort=desc&filter=&p=1";
Future<List<Coin>> getPrice() async {
  List<Coin> _coinPrice = new List();

  final _data = await Dio().get(hqzapiURL);

  var coins = _data.data["coin"]["data"];

  _coinPrice.add(Coin(nameEn: "apcc", priceCny: 1.0, percent24h: 0));

  for (var item in coins) {
    if (item["coincode"] == 'ethereum' ||
        item["coincode"] == 'tether' ||
        item["coincode"] == 'bitcoin') {
      _coinPrice.add(Coin(
          nameEn: item["coincode"],
          priceCny: item["price_cny"],
          percent24h: item["percent_24h"]));
    }
  }

  return _coinPrice;
}

void getDimCoin() async {
  var _response = await get("/dim/coins");
  if (_response.state) {
    print(_response.data);
    var _coins = _response.data as List;
    print(coins);
    _coins.forEach((coin) {
      coins[coin["Symbol"]] = Coin.fromJson(coin);
    });
  }
}
