import 'dart:convert';
import 'dart:io';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/coin_price.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:apcc_wallet/src/model/version.dart';
import 'package:apcc_wallet/src/store/actions.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

void init(BuildContext context, Store store) async {
  await initSharedPreferences();
  // initWallet().then((val) {
  //   store.dispatch(RefreshWalletsAction(val));
  // });
  // getStorageString("_user").then((val) {
  //   if (val != null) {
  //     store.dispatch(RefreshUserAction(User.fromJson(json.decode(val))));
  //   }
  // });
  var token = await getStorageString("_token");
  print("toke=${token}");

  api = new Dio(BaseOptions(baseUrl: apiURL, connectTimeout: 5000,
      // receiveTimeout: 5000,
      headers: {HttpHeaders.authorizationHeader: token}));

  api.interceptors
      .add(InterceptorsWrapper(onResponse: (Response response) async {
    print("onResponse");
    print("response${response}");
  }, onError: (DioError err) async {
    print("onError");
    print(err.response);
    if (err.response != null && err.response.statusCode == 401 && token != "") {
      print("api.interceptors");
      api.lock();
      token = await refreshToken(
          err.request.headers[HttpHeaders.authorizationHeader]); //获取新token
      print(token);
      api.options.headers[HttpHeaders.authorizationHeader] = token;
      api.unlock();

      var request = err.response.request; //千万不要调用 err.request
      request.headers[HttpHeaders.authorizationHeader] =
          token; //这里要单独修改之前请求里的token请求头为最新的token。
      try {
        var response = await api.request(request.path,
            data: request.data,
            queryParameters: request.queryParameters,
            cancelToken: request.cancelToken,
            options: request,
            onReceiveProgress:
                request.onReceiveProgress //TODO 差一个onSendProgress
            );
        return response;
      } on DioError catch (e) {
        return e;
      }
    }
  }));

  //获取版本号
  newestVersion = await getVersion();
  //初始化用户
  user = await getUser();
  //获取MHC和USDT价格
  getDimCoin();
  //地址
  address = await getAllAddress();
  
  initMHCClient();
}
