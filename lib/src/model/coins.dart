import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:apcc_wallet/src/common/utils.dart';
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
  "ETH": Icon(
    IconData(0xe60c, fontFamily: 'myIcon'),
    color: Colors.red,
  ),
  "USDT": Icon(
    IconData(0xe61a, fontFamily: 'myIcon'),
    color: Colors.red,
  ),
  "MHC": Icon(
    IconData(0xe681, fontFamily: 'myIcon'),
    color: Colors.red,
  ),
  "BTC": Icon(
    IconData(0xe609, fontFamily: 'myIcon'),
    color: Colors.red,
  ),
};

var gateio =
    "https://data.gateio.co/api2/1/ticker";
Future<List<Coin>> getPrice() async {
  List<Coin> _coinPrice = new List();

  var coins = [["eth_cnyx","ETH"],["btc_cnyx","BTC"],["usdt_cnyx","USDT"]];

  _coinPrice.add(Coin(nameEn: "MHC", priceCny: 1.0, percent24h: 0));

  for (var symbol in coins) {
      final _data = await Dio().get(gateio+"/"+symbol[0]);

  

      _coinPrice.add(Coin(
          nameEn: symbol[1],
          priceCny: toDouble(_data.data["last"]),
          percent24h: toDouble(_data.data["percentChange"])));
    
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
