import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:dio/dio.dart';

class Assets {
  String code;
  String nameCn;
  String nameEn;
  String address;
  String symbol;
  double blance;
  double freezingBlance;
  double priceCny;
  double priceUsd;
  Assets(
      {this.code,
      this.nameCn,
      this.nameEn,
      this.address,
      this.symbol,
      this.blance,
      this.freezingBlance,
      this.priceCny,
      this.priceUsd});
}

Future<Data> getAssets() async {
  List<Assets> assets = new List();
  // assets.add(Assets(
  //     code: "MedicalHealthCoin",
  //     name: "健康医疗币",
  //     symbol: "MHC",
  //     address: "0x9d6d492bD500DA5B33cf95A5d610a73360FcaAa0",
  //     blance: 20000,
  //     freezingBlance: 200,
  //     cnyPrice: 6.85));
  // assets.add(Assets(
  //     code: "USTD",
  //     name: "泰达币",
  //     symbol: "USDT",
  //     blance: 20000,
  //     address: "0x9d6d492bD500DA5B33cf95A5d610a73360FcaAa0",
  //     freezingBlance: 0,
  //     cnyPrice: 6.85));
  // assets.add(Assets(
  //     code: "Ethereum",
  //     name: "以太坊",
  //     symbol: "ETH",
  //     blance: 20000,
  //     freezingBlance: 0,
  //     cnyPrice: 6.85));
  var _data = await get("/assets/all");
  print(_data);
  if (_data.state){
    var _list = _data.data as List;
    _list.forEach((asset){
      var _blance = double.tryParse(asset["Blance"])==null?0.0:double.tryParse(asset["Blance"]);
 var _freezingBlance = double.tryParse(asset["FreezingBlance"])==null?0.0:double.tryParse(asset["FreezingBlance"]);

        assets.add(Assets(code: asset["UUID"],symbol: asset["Symbol"],address: asset["Address"],blance:  _blance ,freezingBlance:_freezingBlance,nameEn:asset["NameEn"],priceCny:double.tryParse(asset["PriceCny"])     ));
    });
  _data.data = assets;
  }
  return _data;
}

Future<Data> getExchange(String mainSymbol, exchangeSymbol) async {
  List<Assets> assets = new List();

  var _data = await get("/assets/exchangeassets",parameters: {"mainCoin":mainSymbol,"exchangeCoin":exchangeSymbol});
  print(_data);
  if (_data.state){
    var _list = _data.data as List;
    _list.forEach((asset){
      var _blance = double.tryParse(asset["Blance"])==null?0.0:double.tryParse(asset["Blance"]);
 var _freezingBlance = double.tryParse(asset["FreezingBlance"])==null?0.0:double.tryParse(asset["FreezingBlance"]);

        assets.add(Assets(code: asset["UUID"],symbol: asset["Symbol"],address: asset["Address"],blance:  _blance ,freezingBlance:_freezingBlance,nameEn:asset["NameEn"],priceCny:double.tryParse(asset["PriceCny"])     ));
    });
  _data.data = assets;
  }
  return _data;
}


Future<Data> exchange(String from, to,double amount) async {

  var _data = await post("/assets/exchange",data:new FormData.from({"mainCoin":to,"exchangeCoin":from,"amount":amount}) );

  return _data;
}

Future<Data> transferFree(String coin) async {
  var _data = await get("/assets/free",parameters :{"coin":coin} );
  print(_data);
  return _data;
}