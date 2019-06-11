class RefreshMnemonicAction {
  final String mnemonic;

  RefreshMnemonicAction(this.mnemonic);
}

class RefreshWalletsAction {
  final Map<String, dynamic> wallets;
  RefreshWalletsAction(this.wallets);
}
