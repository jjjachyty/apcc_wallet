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
      new AppState(mnemonic: "我 的 名 字 叫 张 力 啊 啊 啊 啊 啊", wallets: {"0x9078b46cefb2e95d1b08e240f6d38b2a2e9dff2e":1111,"0x9078b46cefb2e95d1b08e240f6d38b2a2e9dff21":222,"0x9078b46cefb2e95d1b08e240f6d38b2a2e9dff22":222,"0x9078b46cefb2e95d1b08e240f6d38b2a2e9dff23":222,"0x9078b46cefb2e95d1b08e240f6d38b2a2e9dff24":222,"0x9078b46cefb2e95d1b08e240f6d38b2a2e9dff25":222});
}
