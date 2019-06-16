import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:web3dart/web3dart.dart';

class AppState {
  String mnemonic;
  Map<String, dynamic> wallets;
  User user;

  // void setwallets(Map<String, dynamic> wallets) {
  //   this._wallets = wallets;
  // }
  // void setwallets(Map<String, dynamic> wallets) {
  //   this._wallets = wallets;
  // }

  // get wallets => this._wallets;
  // get mnemonic => this._mnemonic;

  AppState({this.mnemonic, this.wallets, this.user});

  factory AppState.initialState() {
    return new AppState(mnemonic: "", wallets: new Map());
  }
}
