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

  factory AppState.initState() =>
      new AppState(mnemonic: "我 的 名 字 叫 张 力 啊 啊 啊 啊 啊", wallets: new Map());
}
