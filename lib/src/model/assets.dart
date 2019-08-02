import 'dart:convert';
import 'dart:typed_data';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:apcc_wallet/src/model/usdt.dart';
import 'package:apcc_wallet/src/model/usdt_eth.dart';
import 'package:apcc_wallet/src/model/wallet.dart';
import 'package:dio/dio.dart';
import 'package:web3dart/web3dart.dart';

class Assets {
  String code;
  String nameCn;
  String nameEn;
  Address address;
  String symbol;
  String baseOn;
  num blance;
  num freezingBlance;
  num priceCny;
  num priceUsd;
  Assets(
      {this.code,
      this.nameCn,
      this.nameEn,
      this.address,
      this.symbol,
      this.blance,
      this.freezingBlance,
      this.priceCny,
      this.priceUsd,
      this.baseOn});
  Assets.fromJson(Map<String, dynamic> json)
      : this.symbol = json["Symbol"],
        this.baseOn = json["BaseOn"],
        this.address = Address(val: json["Address"]),
        this.blance = json["Blance"],
        this.freezingBlance = json["FreezingBlance"];
}

class AssetLog {
  String uuid;
  String fromAddress;
  String fromUser;
  String fromCoin;
  num fromAmount;
  num fromPriceCny;
  String toUser;
  String toCoin;
  String toAddress;
  String exchangeTxs;
  num toAmount;
  num toPriceCny;
  String createAt;
  int payType;
  num free;
  int state;
  String sendTxs;
  String sendAddress;
  String sendTime;

  AssetLog({
    this.uuid,
    this.fromAddress,
    this.fromCoin,
    this.fromUser,
    this.fromAmount,
    this.fromPriceCny,
    this.exchangeTxs,
    this.toUser,
    this.toCoin,
    this.toAddress,
    this.toAmount,
    this.toPriceCny,
    this.payType,
    this.free,
    this.createAt,
    this.state,
    this.sendAddress,
    this.sendTxs,
    this.sendTime,
  });
  AssetLog.fromJson(Map<String, dynamic> item)
      : this.uuid = item["UUID"],
        this.fromUser = item["FromUser"],
        this.fromCoin = item["FromCoin"],
        this.fromAddress = item["FromAddress"],
        this.fromAmount = item["FromAmount"],
        this.fromPriceCny = item["FromPriceCny"],
        this.exchangeTxs=item["ExchangeTxs"],
        this.toUser = item["ToUser"],
        this.toCoin = item["ToCoin"],
        this.toAddress = item["ToAddress"],
        this.toAmount = item["toAmount"],
        this.toPriceCny = item["ToPriceCny"],
        this.payType = item["PayType"],
        this.free = item["Free"],
        this.createAt = item["CreateAt"],
        this.state = item["State"],
        this.sendAddress = item["SendAddress"],
        this.sendTxs = item["SendTxs"],
        this.sendTime = item["SendTime"];
  Map<String, dynamic> toJson() {
    return {
      "uuid": this.uuid,
      "fromUser": this.fromUser,
      "fromCoin": this.fromCoin,
      "fromAddress": this.fromAddress,
      "fromAmount": this.fromAmount,
      "fromPriceCny": this.fromPriceCny,
      "exchangeTxs":this.exchangeTxs,
      "toUser": this.toUser,
      "toCoin": this.toCoin,
      "toAddress": this.toAddress,
      "toAmount": this.toAmount,
      "toPriceCny": this.toPriceCny,
      "payType": this.payType,
      "free": this.free,
      "createAt": this.createAt,
      "state": this.state,
      "sendAddress": this.sendAddress,
      "sendTxs": this.sendTxs,
      "sendTime": this.sendTime,
    };
  }
}

class Exchange {
  String uuid;
  String user;
  String fromCoin;
  String fromAddress;
  String receiveAddress;
  String receiveTxs;
  String toCoin;
  String toAddress;
  String sendTxs;
  String sendAt;
  num amount;
  num free;
  num rate;
  String createAt;
  int state;
  Exchange(
      {this.uuid,
      this.user,
      this.fromCoin,
      this.fromAddress,
      this.receiveAddress,
      this.receiveTxs,
      this.toCoin,
      this.toAddress,
      this.sendTxs,
      this.sendAt,
      this.amount,
      this.free,
      this.rate,
      this.createAt,
      this.state});
  Map<String, dynamic> toJson() {
    return {
      "uuid": this.uuid,
      "user": this.user,
      "fromCoin": this.fromCoin,
      "fromAddress": this.fromAddress,
      "receiveAddress": this.receiveAddress,
      "receiveTxs": this.receiveTxs,
      "toCoin": this.toCoin,
      "toAddress": this.toAddress,
      "sendTxs": this.sendTxs,
      "sendAt": this.sendAt,
      "free": this.free,
      "amount": this.amount,
      "rate": this.rate,
      "createAt": this.createAt,
      "state": this.state
    };
  }
}

Future<List<Assets>> getLocalAssets() async {
  List<Assets> assets = new List();
  for (var addr in address) {
    double _blacnce = 0;

    var _amount = await getMHCblance(addr.val);
    _blacnce = _amount.getInEther.toDouble();
    assets.add(
        Assets(address: addr, symbol: addr.coin, blance: _blacnce, baseOn: ""));
  }
  return assets;
}

Future<List<Assets>> getDBAssets() async {
  List<Assets> assets = new List();
  var _usdtAssets = await getUSDT();
  print("_blance======${_usdtAssets.first.symbol}");
  assets.add(Assets(
      address: _usdtAssets.first.address,
      symbol: _usdtAssets.first.symbol,
      blance: (_usdtAssets.first.blance),
      baseOn: _usdtAssets.first.baseOn));
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
  return toDouble(coins[mainSymbol].priceCny) /
      toDouble(coins[exchangeSymbol].priceCny);
}

//exchange货币兑换
Future<Data> exchange(
    Assets from, Assets to, String password, num amount) async {
  AssetLog _assetLog = AssetLog(
    fromCoin: from.symbol,
    fromAddress: from.address.val,
    fromAmount: amount,
    toCoin: to.symbol,
    toAddress: to.address.val
  );
  Data _data;
  // // var _data = await post("/assets/", data: exchange.toJson());
  // if (_data.state) {
  switch (from.symbol + to.symbol) {
    case "USDTMHC":
      break;
    case "MHCUSDT":
      _data = await sendMHC(
          from.address, coinReceiveAddress[from.symbol], password, amount);
      if (_data.state) {
        _assetLog.exchangeTxs = _data.data;
      }
      break;
    default:
    // }
  }
       _data = await post("/assets/exchange", data: json.encode(_assetLog.toJson()));

  return _data;
}

//兑换费率
Future<Data> exchangeFree(String mainCoin) async {
  var _data =
      await get("/assets/exchangefreerate", parameters: {"mainCoin": mainCoin});
  return _data;
}

//获取转账手续费
Future<num> transferFree(String coin) async {
  switch (coin) {
    case "MHC":
      break;
    case "USDT":
      return getTransferFree("USDT");
    default:
  }
}

Future<Data> exchangerate(String mainCoin, String exchangeCoin) async {
  var _data = await get("/assets/exchangerate",
      parameters: {"mainCoin": mainCoin, "exchangeCoin": exchangeCoin});
  return _data;
}

//同币种转账
Future<Data> transfer(
    Assets from, String toAddress, String password, num amount) async {
  switch (from.symbol) {
    case "MHC":
      return await sendMHC(from.address, toAddress, password, amount);
      break;
    case "USDT":
      return await send(
          from.address.val, toAddress, "USDT", password, "out", amount);
    default:
  }
  ;
}

Future<PageData> orders(String coin, payType, page) async {
  List<AssetLog> _orders = new List();
  var _data = await get("/assets/logs", parameters: {
    "FromCoin": coin,
    "order": "create_at",
    "sort": "desc",
    "page": page,
    "PayType": payType
  });
  print("orders-------------------------------------");
  print(_data.data);
  var _pageData = PageData.fromJson(_data.data);
  var _rows = _pageData.rows as List;
  _rows.forEach((item) {
    _orders.add(AssetLog.fromJson(item));
  });
  _pageData.rows = _orders;
  return _pageData;
}

Future<PageData> exchangeList(String mainCoin, exchangeCoin, page) async {
  List<Exchange> _orders = new List();
  var _data = await get("/assets/exchanges", parameters: {
    "FromCoin": mainCoin,
    "ToCoin": exchangeCoin,
    "order": "create_at",
    "sort": "desc",
    "page": page
  });
  print(_data.data);
  var _pageData = PageData.fromJson(_data.data);
  var _rows = _pageData.rows as List;
  _rows.forEach((item) {
    _orders.add(Exchange(
        uuid: item["UUID"],
        user: item["User"],
        fromCoin: item["FromCoin"],
        fromAddress: item["FromAddress"],
        receiveAddress: item["ReceiveAddress"],
        receiveTxs: item["ReceiveTxs"],
        toCoin: item["ToCoin"],
        toAddress: item["ToAddress"],
        sendTxs: item["SendTxs"].toString(),
        amount: item["Amount"],
        free: item["Free"],
        rate: item["Rate"],
        createAt: item["CreateAt"],
        state: item["State"],
        sendAt: item["SendAt"]));
  });
  _pageData.rows = _orders;
  return _pageData;
}
