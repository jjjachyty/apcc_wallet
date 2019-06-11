import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bs58check/bs58check.dart';

import '../bip39/src/bip39_base.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:path_provider/path_provider.dart';

class Address {
  String val;
  String path;
  String privateKey;
}

class HDWallet {
  String mnemonic;
  List<Address> address;
}

Future<Map<String, dynamic>> Create(String mnemonic, String passwd) async {
  // mnemonic =
  //     "武 蛋 敲 缝 闻 亲 矩 圣 婚 淮 霞 警"; //await bip39.generateMnemonic(lang: 'zh_cn');
  print(mnemonic);
  // assert(bip39.validateMnemonic(mnemonic,lang: 'zh_cn'));
  final seed = bip39.mnemonicToSeed(mnemonic);
  print(bip39.mnemonicToSeedHex(mnemonic));
  final root = bip32.BIP32.fromSeed(seed);
  print(root.toBase58());
  var path = root.derivePath("m/44'/60'/0'/0/0");
  print(path.toBase58());
  print(path.toString());
  print(HEX.encode(path.privateKey));

  Credentials fromHex = EthPrivateKey.fromHex(HEX.encode(path.privateKey));
  var address = await fromHex.extractAddress();

  Wallet wt = Wallet.createNew(fromHex, passwd, new Random.secure());
  _saveJsonFile(wt.toJson(), address.hex);
  return {address.hex: wt.toJson()};
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
      wallets[key] = await _getWallets(walletsFiles);
    }
    return wallets;
  } catch (err) {
    print(err);
  }
}

Future<List> _getWallets(List<String> walletsFiles) async {
  List<dynamic> wallets = new List();

  for (var i = 0; i < walletsFiles.length; i++) {
    final file = new File(walletsFiles[i]);
    String str = await file.readAsString();
    wallets.add(json.decode(str));
  }
  return wallets;
}

//读取文件
_saveJsonFile(String json, String name) async {
  try {
    String appDocDirPath = await _localPath();

    print('文档目录: ' + appDocDirPath + name);

    final file = new File('$appDocDirPath/$name.wallet');
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
