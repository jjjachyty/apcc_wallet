import 'package:apcc_wallet/src/hdwallet/mmic_repeat.dart';
import 'package:apcc_wallet/src/hdwallet/mnemonic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'src/store/state.dart';

final Map<String, WidgetBuilder> routes = {
  "/wallet/mmic":  (BuildContext context) =>new MnemonicPage(),
  "/wallet/mmicrepeat": (BuildContext context) => new MnemonicRepeatPage()
};
