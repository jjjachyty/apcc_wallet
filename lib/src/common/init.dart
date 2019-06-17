

import 'dart:convert';

import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:apcc_wallet/src/store/actions.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

void init(BuildContext context,Store store) async{
       await initSharedPreferences();
    initWallet().then((val) {
      store.dispatch(RefreshWalletsAction(val));
    });
    getStorageString("_user").then((val){
      if (val != null){
               store.dispatch( RefreshUserAction(User.fromJson(json.decode(val))));
      }
    });
   

}