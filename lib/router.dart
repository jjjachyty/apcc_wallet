
import 'package:apcc_wallet/src/center/id_auth.dart';
import 'package:apcc_wallet/src/center/login.dart';
import 'package:apcc_wallet/src/center/login_passwd.dart';
import 'package:apcc_wallet/src/center/notice.dart';
import 'package:apcc_wallet/src/center/register.dart';
import 'package:apcc_wallet/src/center/setting.dart';

import 'package:apcc_wallet/src/common/about.dart';
import 'package:apcc_wallet/src/common/contact.dart';
import 'package:apcc_wallet/src/common/version.dart';
import 'package:apcc_wallet/src/hdwallet/import_mnemonic.dart';
import 'package:apcc_wallet/src/hdwallet/index.dart';
import 'package:apcc_wallet/src/hdwallet/mmic_repeat.dart';
import 'package:apcc_wallet/src/hdwallet/mnemonic.dart';
import 'package:apcc_wallet/src/hdwallet/passwd.dart';
import 'package:apcc_wallet/src/healthy/index.dart';
import 'package:apcc_wallet/src/main/main.dart';
import 'package:flutter/material.dart';


final Map<String, WidgetBuilder> routes = {
  "/main": (BuildContext context) => new MainPage(),
  "/wallet/new": (BuildContext context) => new NoWalletPage(),
  "/wallet/mmic": (BuildContext context) => new MnemonicPage(),
  "/wallet/importmmic": (BuildContext context) => new ImportMnemonicPage(),

  "/wallet/mmicrepeat": (BuildContext context) => new MnemonicRepeatPage(),
  "/wallet/passwd": (BuildContext context) => new WalletPasswdPage(),
  // "/news/detail": (BuildContext context) => new NewsDeatil(),
  "/aboutus": (BuildContext context) => new AboutUs(),
  "/contactus": (BuildContext context) => new ContactUs(),
  "/register": (BuildContext context) => new UserRegister(),
  "/loginpasswd": (BuildContext context) => new LoginPasswd(),
  "/login": (BuildContext context) => new UserLogin(),
  "/notice": (BuildContext context) => new Notice(),
  "/user/idcard": (BuildContext context) => new IDCardRecognition(),
  "/user/setting": (BuildContext context) => new UserSetting(),
  "/version": (BuildContext context) => new VersionPage(),
  "/healthy/index":(BuildContext context) => new HealthyPage(),
  // "/transfersuccess": (BuildContext context) => new TransferSuccessPage(),
};
