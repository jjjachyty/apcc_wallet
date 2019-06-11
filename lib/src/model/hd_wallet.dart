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

Create(String mnemonic, String passwd) async {
  mnemonic =
      "武 蛋 敲 缝 闻 亲 矩 圣 婚 淮 霞 警"; //await bip39.generateMnemonic(lang: 'zh_cn');
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
  print(address.hex);
  Wallet wt = Wallet.createNew(fromHex, passwd, new Random.secure());
  print(wt.toJson());
  _saveJsonFile(wt.toJson(), address.hex);
  _readWallets();
}

// 读取 json 数据
_readWallets() async {
  try {
    List<String> walletsFiles = new List();
    List<dynamic> wallets = new List();
    await getApplicationDocumentsDirectory().then((directory) async{
           directory.list().forEach((e) {
      if (e.path.contains(".wallet")) {
        print(e.path);
        walletsFiles.add(e.path);
      }
    });

       print(walletsFiles.toString());
   print("-----");
  for (var i = 0; i < walletsFiles.length; i++) {
       final file = new File(walletsFiles[i]);
      String str = await file.readAsString();
      wallets.add(json.decode(str));
    }

    }).then((onValue){
            print("------1-----");

 wallets.forEach((f){
      print(f.toString());
      print("-----2------");
    });
    });
    
      print("----3-------");

 

  

   

  
  

 
  } catch (err) {
    print(err);
  }
}

//读取文件
Future _saveJsonFile(String json, String name) async {
  try {
    String appDocDirPath = await _localPath();

    print('文档目录: ' + appDocDirPath + name);
    final file = new File('$appDocDirPath/$name.wallet');
    return file.writeAsString(json);
  } catch (err) {
    print(err);
  }
}

Future<String> _localPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

//   Future<String> _localPath() async {
//     try {

//         var appDocDir = await getApplicationDocumentsDirectory();
//         String appDocPath = appDocDir.path;

//         print('文档目录: ' + appDocPath);
//         return appDocPath;
//     }
//     catch(err) {
//         print(err);
//     }
// }

// _localFile(path,name) async {
//   return new File('$path/$name.wallet');
// }
