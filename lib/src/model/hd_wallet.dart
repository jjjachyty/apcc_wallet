import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:apcc_wallet/src/common/http.dart' as comhttp;

import 'package:apcc_wallet/src/common/define.dart';
import 'package:cipher2/cipher2.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../bip39/src/bip39_base.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';


final String apiUrl = "http://119.3.108.19:8110";
final storage = new FlutterSecureStorage();
final iv = "yyyyyyyyyyyyyyyy";

class Address {
  String coin;
  String val;
  String path;
  String privateKey;
  Address({this.coin, this.val, this.path, this.privateKey});
  Map<String, dynamic> toJson() {
    return {
      "coin": this.coin,
      "val": this.val,
      "path": this.path,
      "privateKey": this.privateKey
    };
  }

  Address.fromJson(Map<String, dynamic> json)
      : this.coin = json["coin"],
        this.val = json["val"],
        this.path = json["path"],
        this.privateKey = json["privateKey"];

  static List list2Json(List<Address> address) {
    List _addrsMap = new List();
    address.forEach((val) {
      _addrsMap.add(val.toJson());
    });
    return _addrsMap.toList();
  }
}

class HDWallet {
  String mnemonic;
  List<Address> address;
}

Web3Client _mhcClient;
EtherAmount _gasPrice;

Web3Client getEthClint() {
  print("getEthClint");
  print(_mhcClient);
  return _mhcClient;
}

initMHCClient() async {
  _mhcClient = new Web3Client(apiUrl, new Client());

  _gasPrice = await _mhcClient.getGasPrice();
  print("价格===$_gasPrice");
}

//获取地址的私钥
Future<String> getAddressPrivateKey(Address addr,String password) async {
  var _key = "";
  try {
    return await Cipher2.decryptAesCbc128Padding7(
        addr.privateKey, password, iv);
  } catch (e) {
  return throw new PasswordError("密码错误");
  }
}

Future<Data> sendMHC(Address from, String to, String password, num value,
    {Uint8List data}) async {
  Data _result = Data(state: false);

  try {
    var _privateKey = await getAddressPrivateKey(from, password);

    var _key = bip32.BIP32.fromBase58(_privateKey);

    print("pk===${_key.privateKey.toString()}");

    String _tx = await _mhcClient.sendTransaction(
        EthPrivateKey.fromHex(
            bytesToHex(_key.privateKey, include0x: false, forcePadLength: 64)),
        Transaction(
          to: EthereumAddress.fromHex(to),
          gasPrice: _gasPrice,
          maxGas: 21000,
          value:
              EtherAmount.inWei(BigInt.from(10).pow(18) * BigInt.from(value)),
          data: data,
        ),
        chainId: 3333);
    _result = Data(state: true, messsage: "转账申请成功", data: _tx);
  } on ArgumentError catch (e) {
    _result = Data(
      state: false,
      messsage: "地址错误",
    );
  }on PasswordError catch(e){
    _result = Data(
      state: false,
      messsage: "钱包密码错误",
    );
  }
  return _result;
}

Future<EtherAmount> getMHCblance(String address) async {
  return await _mhcClient.getBalance(EthereumAddress.fromHex(address));
}

Future<String> createMain(String mnemonic, String password) async {
  // mnemonic =
  //     "武 蛋 敲 缝 闻 亲 矩 圣 婚 淮 霞 警"; //await bip39.generateMnemonic(lang: 'zh_cn');
  print(mnemonic);
  print(password.length);
    print(iv.length);
  final seed = bip39.mnemonicToSeed(mnemonic);
  print(HEX.encode(seed));
  final root = bip32.BIP32.fromSeed(seed);
  print(root.toBase58());
  print(root.privateKey);
  String nonce = await Cipher2.generateNonce();
  final encrypted =
      await Cipher2.encryptAesCbc128Padding7(root.toBase58(), password, iv);
  await storage.write(key: "rootPrivateKey", value: encrypted);

  var _addrs = await initAddress(root.toBase58(), password);

  var list2json = Address.list2Json(_addrs);

  var _jsonStr = json.encode(list2json);
  await storage.write(key: "address", value: _jsonStr);

  address = _addrs;
  return root.toBase58();
}

//MHC USDT 地址
Future<List<Address>> initAddress(
    String privateKeyBase58, String password) async {
  List<Address> _adds = new List();
  var mhcPath = "m/44'/3333'/0'/0/0";
  // var usdtPath = "m/44'/3333'/0'/0/0";

  var rootkey = bip32.BIP32.fromBase58(privateKeyBase58);
  //获取MHC
  var mhc = rootkey.derivePath(mhcPath);

  var pbk = privateKeyBytesToPublic(mhc.privateKey);

  var mhcAddress = EthereumAddress.fromPublicKey(pbk);

  _adds.add(Address(
      coin: "MHC",
      val: mhcAddress.hex,
      path: mhcPath,
      privateKey: await Cipher2.encryptAesCbc128Padding7(
          mhc.toBase58(), password, iv)));

  //获取USDT地址
  // var usdt = rootkey.derivePath(usdtPath);
  // var wif = usdt.toWIF();

  // var usdtWallet = btc.Wallet.fromWIF(wif);
  // print("usdtAddress=${usdtWallet.address}");

  // _adds.add(Address(
  //     coin: "USDT",
  //     val: mhcAddress.hex,
  //     path: mhcPath,
  //     privateKey: await Cipher2.encryptAesCbc128Padding7(
  //         mhc.toBase58(), password, iv)));
  return _adds;
}

//MHC USDT 地址
Future<List<Address>> getAddress() async {
  List<Address> _adds = new List();

  var _addressStr = await storage.read(key: "address");
   print("xxxxxxxxxxxxxxxx${_addressStr}");
  if (_addressStr != null) {
    var _jsonList = json.decode(_addressStr) as List;
    _jsonList.forEach((val) {
      _adds.add(Address.fromJson(val));
    });
  }
  return _adds;
}

Future<List<Address>> getAllAddress() async {
    return await getAddress();
}
