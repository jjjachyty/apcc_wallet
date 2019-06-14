import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:web3dart/web3dart.dart';

class AppState {
  String mnemonic;
  Map<String, dynamic> wallets;


  // void setwallets(Map<String, dynamic> wallets) {
  //   this._wallets = wallets;
  // }
  // void setwallets(Map<String, dynamic> wallets) {
  //   this._wallets = wallets;
  // }

  // get wallets => this._wallets;
  // get mnemonic => this._mnemonic;

  AppState({this.mnemonic, this.wallets});

  factory AppState.initialState() {
 return new AppState(mnemonic: "", wallets:new Map());
  }
}

