import 'package:apcc_wallet/src/model/user.dart';

class RefreshMnemonicAction {
  final String mnemonic;

  RefreshMnemonicAction(this.mnemonic);
}

class RefreshWalletsAction {
  final Map<String, dynamic> wallets;
  RefreshWalletsAction(this.wallets);
}

class RefreshUserAction {
  final User user;
  RefreshUserAction(this.user);
}
