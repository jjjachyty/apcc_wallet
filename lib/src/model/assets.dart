import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';

class Assets {
  String code;
  String nameCn;
  String nameEn;
  String address;
  String symbol;
  double blance;
  double freezingBlance;
  double cnyPrice;
  double usdPrice;
  Assets(
      {this.code,
      this.nameCn,
      this.nameEn,
      this.address,
      this.symbol,
      this.blance,
      this.freezingBlance,
      this.cnyPrice,
      this.usdPrice});
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
  var _data = await get("/user/assets");
  print(_data);
  if (_data.state){
    var _list = _data.data as List;
    _list.forEach((asset){
      var _blance = double.tryParse(asset["Blance"])==null?0.0:double.tryParse(asset["Blance"]);
 var _freezingBlance = double.tryParse(asset["FreezingBlance"])==null?0.0:double.tryParse(asset["FreezingBlance"]);
        assets.add(Assets(code: asset["UUID"],symbol: asset["Symbol"],address: asset["Address"],blance:  _blance ,freezingBlance:_freezingBlance,nameEn:asset["NameEn"]    ));
    });
  _data.data = assets;
  }
  return _data;
}

Future<List<Assets>> getExchange(String mainSymbol, exchangeSymbol) async {
  List<Assets> assets = new List();

  await Future.delayed(Duration(seconds: 3));
  assets.add(Assets(
      code: "MedicalHealthCoin",
      nameCn: "健康医疗币",
      symbol: "HMC",
      address: "0x9d6d492bD500DA5B33cf95A5d610a73360FcaAa0",
      blance: 20000,
      freezingBlance: 200,
      cnyPrice: 1.0));
  assets.add(Assets(
      code: "USTD",
      nameCn: "泰达币",
      symbol: "USDT",
      blance: 20000,
      address: "0x9d6d492bD500DA5B33cf95A5d610a73360FcaAa0",
      freezingBlance: 0,
      cnyPrice: 6.85));

  return assets;
}
