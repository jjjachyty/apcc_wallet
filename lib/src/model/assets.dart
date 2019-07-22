import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
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

class AssetLog {
  String uuid;
  String fromAddress;
  String fromUser;
  String fromCoin;
  String fromPreblance;
  String fromBlance;
  String fromPriceCny;
  String toUser;
  String toCoin;
  String toAddress;
  String toPreblance;
  String toBlance;
  String toPriceCny;
  String createAt;
  int payType;
  int state;
  AssetLog(
      {this.uuid,
      this.fromAddress,
      this.fromCoin,
      this.fromUser,
      this.fromPreblance,
      this.fromBlance,
      this.fromPriceCny,
      this.toUser,
      this.toCoin,
      this.toAddress,
      this.toBlance,
      this.toPreblance,
      this.toPriceCny,
      this.payType,
      this.createAt,
      this.state,
      });
}

Future<List<Assets>> getAssets() async {
  List<Assets> assets = new List();
  for (var addr in address) {
      double _blacnce = 0;
     switch (addr.coin) {
       case "MHC":
        var _amount =  await getMHCblance(addr.val);
        _blacnce = _amount.getInEther.toDouble();
         break;
      case "USDT":
        _blacnce = 100;
  
     }
          assets.add(Assets(address: addr.val,symbol: addr.coin,blance: _blacnce,priceCny: 6.8));

  }

  return assets;
}

Future<Data> getExchange(String mainSymbol, exchangeSymbol) async {
  List<Assets> assets = new List();

  var _data = await get("/assets/exchangeassets",
      parameters: {"mainCoin": mainSymbol, "exchangeCoin": exchangeSymbol});
  print(_data);
  if (_data.state) {
    var _list = _data.data as List;
    _list.forEach((asset) {
      var _blance = double.tryParse(asset["Blance"]) == null
          ? 0.0
          : double.tryParse(asset["Blance"]);
      var _freezingBlance = double.tryParse(asset["FreezingBlance"]) == null
          ? 0.0
          : double.tryParse(asset["FreezingBlance"]);

      assets.add(Assets(
          code: asset["UUID"],
          symbol: asset["Symbol"],
          address: asset["Address"],
          blance: _blance,
          freezingBlance: _freezingBlance,
          nameEn: asset["NameEn"],
          priceCny: double.tryParse(asset["PriceCny"])));
    });
    _data.data = assets;
  }
  return _data;
}

 double getExchangeRate(String mainSymbol, exchangeSymbol) {
   return toDouble(coinPrice[mainSymbol]) / toDouble(coinPrice[exchangeSymbol]);
}


Future<Data> exchange(String from, to, double amount) async {
  var _data = await post("/assets/exchange",
      data: new FormData.from(
          {"mainCoin": to, "exchangeCoin": from, "amount": amount}));

  return _data;
}

Future<Data> transferFree(String coin) async {
  var _data = await get("/assets/free", parameters: {"coin": coin});
  return _data;
}

Future<Data> transfer(String fromAddress, toAddress, symbol, transferType,
    payPasswd, double amount) async {
  var _data = await post("/assets/transfer",
      data: new FormData.from({
        "transferType": transferType,
        "fromAddress": fromAddress,
        "toAddress": toAddress,
        "symbol": symbol,
        "amount": amount,
        "payPasswd": payPasswd
      }));
  return _data;
}

Future<PageData> orders(String coin,payType,page) async {
  List<AssetLog> _orders = new List();
  var _data = await get("/assets/orders",
      parameters: {"FromCoin": coin, "order": "create_at", "sort": "desc","page":page,"PayType":payType});
  print("orders-------------------------------------");
  print(_data.data);
  var _pageData = PageData.fromJson(_data.data);
  var _rows = _pageData.rows as List;
  _rows.forEach((item) {
    _orders.add(AssetLog(uuid: item["UUID"], fromUser:item["FromUser"] ,fromCoin: item["FromCoin"],fromAddress: item["FromAddress"],fromPreblance: item["FromPreblance"].toString(),fromBlance: item["FromBlance"].toString(),
    fromPriceCny: item["FromPriceCny"].toString(),toUser: item["ToUser"],toCoin: item["ToCoin"],toAddress: item["ToAddress"],toPreblance: item["ToPreblance"].toString(),toBlance: item["ToBlance"].toString(),toPriceCny: item["ToPriceCny"].toString(),payType: item["PayType"],createAt: item["CreateAt"], state: item["State"]));
  });
  _pageData.rows = _orders;
  return _pageData;
}
