import 'dart:typed_data';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:apcc_wallet/src/model/usdt.dart';
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

class Exchange{
  String     	uuid;          
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
	int  state;   
  Exchange({this.uuid,this.user,this.fromCoin,this.fromAddress,this.receiveAddress,this.receiveTxs, this.toCoin,this.toAddress,this.sendTxs,this.sendAt,this.amount,this.free,this.rate,this.createAt,this.state});       
  Map<String,dynamic> toJson(){
    return {"uuid":this.uuid,"user":this.user,"fromCoin":this.fromCoin,"fromAddress":this.fromAddress,"receiveAddress":this.receiveAddress,"receiveTxs":this.receiveTxs,
   "toCoin": this.toCoin,"toAddress":this.toAddress,"sendTxs":this.sendTxs,"sendAt": this.sendAt, "free":this.free,"amount":this.amount, "rate":this.rate,"createAt":this.createAt,"state":this.state};
  }
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
        var _blance = await getUSDTblance(addr.val);
        print("_blance======${_blance.data}");
  
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

//exchange货币兑换
Future<Data> exchange(Assets from, Assets to,String password ,num amount) async {
  Exchange exchange = Exchange(fromCoin: from.symbol,fromAddress: from.address,receiveAddress:  coinReceiveAddress[from.symbol] , toCoin: to.symbol,toAddress: to.address,amount: amount);
  var _data = await sendMHC(from.address, exchange.receiveAddress, password, amount );
  if (_data.state){
    exchange.receiveTxs = _data.data;
   _data = await post("/assets/exchange",
      data: exchange.toJson());
  }
  

  return _data;
}

//兑换费率
Future<Data> exchangeFree(String coin) async {
  var _data = await get("/assets/exchangefree", parameters: {"coin": coin});
  return _data;
}

Future<Data> transferFree(String coin) async {
  var _data = await get("/assets/free", parameters: {"coin": coin});
  return _data;
}
Future<Data> exchangerate(String mainCoin,String exchangeCoin) async {
  var _data = await get("/assets/exchangerate", parameters: {"mainCoin": mainCoin,"exchangeCoin":exchangeCoin});
  return _data;
}


//同币种转账
Future<Data> transfer(String fromAddress, String toAddress,String password,num amount) async {


  return await sendMHC(fromAddress,toAddress,password,amount);;
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


Future<PageData> exchangeList(String mainCoin,exchangeCoin,page) async {
  List<Exchange> _orders = new List();
  var _data = await get("/assets/exchanges",
      parameters: {"FromCoin": mainCoin, "ToCoin":exchangeCoin, "order": "create_at", "sort": "desc","page":page});
  print(_data.data);
  var _pageData = PageData.fromJson(_data.data);
  var _rows = _pageData.rows as List;
  _rows.forEach((item) {
    _orders.add(Exchange(uuid: item["UUID"], user:item["User"] ,fromCoin: item["FromCoin"],fromAddress: item["FromAddress"],receiveAddress: item["ReceiveAddress"],receiveTxs: item["ReceiveTxs"],
    toCoin: item["ToCoin"],toAddress: item["ToAddress"],sendTxs: item["SendTxs"].toString(),amount: item["Amount"],free: item["Free"],rate: item["Rate"],createAt: item["CreateAt"], state: item["State"],sendAt: item["SendAt"]));
  });
  _pageData.rows = _orders;
  return _pageData;
}