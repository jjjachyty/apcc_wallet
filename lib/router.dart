import 'package:apcc_wallet/src/center/captcha.dart';
import 'package:apcc_wallet/src/center/id_auth.dart';
import 'package:apcc_wallet/src/center/login_passwd.dart';
import 'package:apcc_wallet/src/center/profile.dart';
import 'package:apcc_wallet/src/center/register.dart';
import 'package:apcc_wallet/src/assets/main/receive.dart';
import 'package:apcc_wallet/src/assets/main/send.dart';
import 'package:apcc_wallet/src/common/about.dart';
import 'package:apcc_wallet/src/common/contact.dart';
import 'package:apcc_wallet/src/hdwallet/mmic_repeat.dart';
import 'package:apcc_wallet/src/hdwallet/mnemonic.dart';
import 'package:apcc_wallet/src/hdwallet/passwd.dart';
import 'package:apcc_wallet/src/main/main.dart';
import 'package:apcc_wallet/src/news/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'src/store/state.dart';

final Map<String, WidgetBuilder> routes = {
  "/main": (BuildContext context) => new MainPage(),
  "/wallet/mmic": (BuildContext context) => new MnemonicPage(),
  "/wallet/mmicrepeat": (BuildContext context) => new MnemonicRepeatPage(),
  "/wallet/passwd": (BuildContext context) => new WalletPasswdPage(),
  "/coin/main/receive": (BuildContext context) => new MainCoinReceive(),
  // "/news/detail": (BuildContext context) => new NewsDeatil(),
  "/aboutus": (BuildContext context) => new AboutUs(),
  "/contactus": (BuildContext context) => new ContactUs(),
  "/register": (BuildContext context) => new UserRegister(),
  "/loginpasswd": (BuildContext context) => new LoginPasswd(),
  "/user/idcard": (BuildContext context) => new IDCardRecognition(),
};
