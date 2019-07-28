import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/json_rpc.dart';
import 'package:cipher2/cipher2.dart';
import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../bip39/src/bip39_base.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bitcoin_flutter/bitcoin_flutter.dart' as btc;

final String apiUrl = "http://119.3.108.19:8110";
final storage = new FlutterSecureStorage();

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
Future<String> getAddressPrivateKey(String addr, password) async {
  var _key = "";
  try {
    Address _fromAddress;
    address.forEach((addr) {
      if (addr.val == addr) {
        _fromAddress = addr;
      }
    });

    return await Cipher2.decryptAesCbc128Padding7(
        _fromAddress.privateKey, password, password);
  } catch (e) {
    throw Exception("钱包密码错误");
  }
  return _key;
}

Future<Data> sendMHC(String from, String to, String password, num value,
    {Uint8List data}) async {
  Data _result;

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
  print(password);
  final seed = bip39.mnemonicToSeed(mnemonic);
  print(HEX.encode(seed));
  final root = bip32.BIP32.fromSeed(seed);
  print(root.toBase58());
  print(root.privateKey);

  final encrypted = await Cipher2.encryptAesCbc128Padding7(
      root.toBase58(), password, password);
  // _saveJsonFile(encrypted, "rootkey.key");
  await storage.write(key: "rootPrivateKey", value: root.toBase58());

  var _addrs = await getAddress(root.toBase58());

  var list2json = Address.list2Json(_addrs);
  var _jsonStr = json.encode(list2json);

  // _saveJsonFile(_jsonStr, "wallet.dat");
  address = _addrs;
  return root.toBase58();
}

//MHC USDT 地址
Future<List<Address>> getAddress(String privateKeyBase58) async {
  List<Address> _adds = new List();
  var mhcPath = "m/44'/3333'/0'/0/0";
  // var usdtPath = "m/44'/3333'/0'/0/0";

  var rootkey = bip32.BIP32.fromBase58(privateKeyBase58);
  //获取MHC
  var mhc = rootkey.derivePath(mhcPath);

  var pbk = privateKeyBytesToPublic(mhc.privateKey);

  print("publicKey=${pbk.length}");

  var mhcAddress = EthereumAddress.fromPublicKey(pbk);
  print("mhcAddress=$mhcAddress");
  _adds.add(Address(
      coin: "MHC",
      val: mhcAddress.hex,
      path: mhcPath,
      privateKey: mhc.toBase58()));

  //获取USDT地址
  // var usdt = rootkey.derivePath(usdtPath);
  // var wif = usdt.toWIF();

  // var usdtWallet = btc.Wallet.fromWIF(wif);
  // print("usdtAddress=${usdtWallet.address}");

  _adds.add(Address(
      coin: "USDT",
      val: mhcAddress.hex,
      path: mhcPath,
      privateKey: mhc.toBase58()));
  return _adds;
}

// 读取 json 数据
Future<Map<String, dynamic>> _readWallets() async {
  try {
    Map<String, dynamic> wallets = new Map();
    List<String> walletsFiles = new List();
    var directory = await getApplicationDocumentsDirectory();
    for (var item in directory.listSync()) {
      if (item.path.contains(".wallet")) {
        print(item.path);
        walletsFiles.add(item.path);
      }
    }
    for (var item in walletsFiles) {
      String key =
          item.substring(item.lastIndexOf("/") + 1, item.lastIndexOf("."));
      wallets[key] = await _getWallets(item);
    }
    return wallets;
  } catch (err) {
    print(err);
  }
}

Future<List<Address>> getAllAddress() async {
  List<Address> _adds = new List();
  String _rootPrivateKey = await storage.read(key: "rootPrivateKey");
  print("pk=======$_rootPrivateKey");
  if (_rootPrivateKey != null) {
    ///data/user/0/com.example.apcc_wallet/app_flutter/wallet.dat
    return await getAddress(_rootPrivateKey);
  }
  return null;
}

Future<List<dynamic>> _getWallets(String walletsFile) async {
  print(walletsFile);
  final file = new File(walletsFile);
  if (await file.exists()) {
    String str = await file.readAsString();
    var _decode = json.decode(str);
    print("str=${_decode}");
    return _decode;
  }
  return null;
}

//读取文件
_saveJsonFile(String json, String name) async {
  try {
    String appDocDirPath = await _localPath();

    print('文档目录: ' + appDocDirPath + "/" + name);

    final file = new File('$appDocDirPath/$name');
    if (!file.existsSync()) {
      file.writeAsString(json);
      return;
    }
    print(name + "该地址钱包已存在");
  } catch (err) {
    print(err);
    rethrow;
  }
}

Future<String> _localPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
