import 'dart:convert';
import 'dart:typed_data';
import 'package:bip32/bip32.dart' as bip32;

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:apcc_wallet/src/model/usdt.dart';
// import 'package:apcc_wallet/src/model/usdt_eth.dart';
import 'package:apcc_wallet/src/model/wallet.dart';
import 'package:dio/dio.dart';
import 'package:web3dart/crypto.dart';
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

class TransferLog {
  String uuid;
  String fromAddress;
  String fromUser;
  String fromCoin;
  num priceCny;
  String toUser;
  String coin;
  String toAddress;
  num amount;
  String createAt;
  int payType;
  num free;
  int state;
  String sendTxs;
  String sendAddress;
  String sendAt;

  TransferLog({
    this.uuid,
    this.fromAddress,
    this.fromCoin,
    this.fromUser,
    this.amount,
    this.toUser,
    this.coin,
    this.toAddress,
    this.payType,
    this.free,
    this.createAt,
    this.state,
    this.sendAddress,
    this.sendTxs,
    this.sendAt,
  });
  TransferLog.fromJson(Map<String, dynamic> item)
      : this.uuid = item["UUID"],
        this.fromUser = item["FromUser"],
        this.fromCoin = item["FromCoin"],
        this.fromAddress = item["FromAddress"],
        this.amount = item["Amount"],
        this.toUser = item["ToUser"],
        this.coin = item["Coin"],
        this.toAddress = item["ToAddress"],
        this.priceCny = item["PriceCny"],
        this.payType = item["PayType"],
        this.free = item["Free"],
        this.createAt = item["CreateAt"],
        this.state = item["State"],
        this.sendAddress = item["SendAddress"],
        this.sendTxs = item["SendTxs"],
        this.sendAt = item["SendAt"];
  Map<String, dynamic> toJson() {
    return {
      "uuid": this.uuid,
      "fromUser": this.fromUser,
      "fromCoin": this.fromCoin,
      "fromAddress": this.fromAddress,
      "amount": this.amount,
      "priceCny": this.priceCny,
      "toUser": this.toUser,
      "coin": this.coin,
      "toAddress": this.toAddress,
      "payType": this.payType,
      "free": this.free,
      "createAt": this.createAt,
      "state": this.state,
      "sendAddress": this.sendAddress,
      "sendTxs": this.sendTxs,
      "sendAt": this.sendAt,
    };
  }
}

class Exchange {
  String uuid;
  String user;
  String fromCoin;
  String fromAddress;
  num fromPriceCny;
  String sendAddress;
  String toCoin;
  String toAddress;
  num toPriceCny;

  String sendTxs;
  String sendAt;
  num fromAmount;
  num toAmount;
  num free;
  num rate;
  String createAt;
  int state;
  Exchange(
      {this.uuid,
      this.user,
      this.fromCoin,
      this.fromAddress,
      this.fromPriceCny,
      this.sendAddress,
      this.toCoin,
      this.toAddress,
      this.sendTxs,
      this.sendAt,
      this.fromAmount,
      this.toAmount,
      this.toPriceCny,
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
      "fromPriceCny": this.fromPriceCny,
      "toPriceCny": this.toPriceCny,
      "sendAddress": this.sendAddress,
      "toCoin": this.toCoin,
      "toAddress": this.toAddress,
      "sendTxs": this.sendTxs,
      "sendAt": this.sendAt,
      "free": this.free,
      "amount": this.fromAmount,
      "toAmount": this.toAmount,
      "rate": this.rate,
      "createAt": this.createAt,
      "state": this.state
    };
  }
}

class MHCTransferLog {
  String txHash;
  int blockNumber;
  String blockHash;
  String from;
  String to;
  num gas;

  num gasPrice;
  num gasUsed;
  num value;
  int nonce;
  num free;
  int status;
  num tokenValue;
  String tokenTo;
  String inputData;
  String createAt;

  MHCTransferLog({
    this.txHash,
    this.blockNumber,
    this.blockHash,
    this.from,
    this.to,
    this.gas,
    this.gasPrice,
    this.gasUsed,
    this.value,
    this.free,
    this.status,
    this.tokenValue,
    this.tokenTo,
    this.nonce,
    this.inputData,
    this.createAt,
  });
  MHCTransferLog.fromJson(Map<String, dynamic> item)
      : this.txHash = item["TxHash"],
        this.blockNumber = item["BlockNumber"],
        this.blockHash = item["BlockHash"],
        this.from = item["From"],
        this.to = item["To"],
        this.gas = item["Gas"],
        this.gasPrice = item["GasPrice"],
        this.gasUsed = item["GasUsed"],
        this.value = item["Value"],
        this.nonce = item["Nonce"],
        this.free = item["Free"],
        this.status = item["Status"],
        this.tokenValue = item["TokenValue"],
        this.tokenTo = item["TokenTo"],
        this.inputData = item["InputData"],
        this.createAt = item["CreateAt"];
  Map<String, dynamic> toJson() {
    return {
      "txHash": this.txHash,
      "blockNumber": this.blockNumber,
      "blockHash": this.blockHash,
      "from": this.from,
      "to": this.to,
      "gas": this.gas,
      "nonce": this.nonce,
      "gasPrice": this.gasPrice,
      "gasUsed": this.gasUsed,
      "value": this.value,
      "free": this.free,
      "nonce": this.nonce,
      "status": this.status,
      "tokenValue": this.tokenValue,
      "tokenTo": this.tokenTo,
      "inputData": this.inputData,
      "createAt": this.createAt
    };
  }
}

Future<List<Assets>> getLocalAssets() async {
  List<Assets> assets = new List();
  for (var addr in address) {
    double _blacnce = 0;

    var _amount = await getMHCblance(addr.val);
    _blacnce = (_amount.getInWei / BigInt.from(1000000000000000000)).toDouble();

    assets.add(
        Assets(address: addr, symbol: addr.coin, blance: _blacnce, baseOn: ""));
  }
  return assets;
}

Future<List<Assets>> getDBAssets() async {
  List<Assets> assets = new List();
  var _usdtAssets = await getDBCoins();

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
  return coins[mainSymbol].priceCny / coins[exchangeSymbol].priceCny;
}

//exchange货币兑换
Future<Data> exchange(
    Assets from, Assets to, String password, num amount) async {
  Data _data;
  // // var _data = await post("/assets/", data: exchange.toJson());
  // if (_data.state) {
  switch (from.symbol + to.symbol) {
    case "USDTMHC":
      _data = await post("/exchange/usdt2mhc",
          data: FormData.from({
            "fromAddress": from.address.val,
            "password": password,
            "toAddress": to.address.val,
            "amount": amount
          }));

      break;
    case "MHCUSDT":
      var _privateKey = await getAddressPrivateKey(from.address, password);
      var _key = bip32.BIP32.fromBase58(_privateKey);

      _data = await post("/exchange/mhc2usdt",
          data: FormData.from({
            "privateKey": bytesToHex(_key.privateKey,
                include0x: false, forcePadLength: 64),
            // "exchangeAddress": coinReceiveAddress[from.symbol],
            "toAddress": to.address.val,
            "amount": amount
          }));
      break;
    default:
    // }
  }

  return _data;
}

//兑换费率
Future<Data> exchangeFree(String mainCoin) async {
  var _data =
      await get("/assets/exchangefree", parameters: {"mainCoin": mainCoin});
  return _data;
}

//获取转账手续费
Future<num> transferFree(String coin) async {
  switch (coin) {
    case "MHC":
      return await getMHCFree();
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
      return await sendUSDT(from.address.val, toAddress, amount, password);
    default:
  }
}

Future<PageData> transferList(String coin, address, page) async {
  print("orders$coin $address");

  List<TransferLog> _orders = new List();
  var _data = await get("/assets/logs", parameters: {
    "coin": coin,
    "address": address,
    "order": "create_at",
    "sort": "desc",
    "page": page
  });
  print(_data.data);
  var _pageData = PageData.fromJson(_data.data);
  var _rows = _pageData.rows as List;
  _rows.forEach((item) {
    _orders.add(TransferLog.fromJson(item));
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
        toCoin: item["ToCoin"],
        toAddress: item["ToAddress"],
        sendAddress: item["SendAddress"],
        sendTxs: item["SendTxs"].toString(),
        fromAmount: item["FromAmount"],
        fromPriceCny: item["FromPriceCny"],
        toAmount: item["ToAmount"],
        toPriceCny: item["ToPriceCny"],
        free: item["Free"],
        rate: item["Rate"],
        createAt: item["CreateAt"],
        state: item["State"],
        sendAt: item["SendAt"]));
  });
  _pageData.rows = _orders;
  return _pageData;
}

Future<PageData> mhctransferList(String address, page) async {
  List<MHCTransferLog> _orders = new List();
  var _data = await get("/assets/mhclogs", parameters: {
    "address": address,
    "order": "create_at",
    "sort": "desc",
    "page": page
  });
  print(_data.data);
  var _pageData = PageData.fromJson(_data.data);
  var _rows = _pageData.rows as List;
  _rows.forEach((item) {
    _orders.add(MHCTransferLog.fromJson(item));
  });
  _pageData.rows = _orders;
  return _pageData;
}
