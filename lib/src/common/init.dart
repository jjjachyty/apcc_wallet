import 'dart:io';
import 'package:apcc_wallet/src/model/coins.dart';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/hd_wallet.dart';

import 'package:apcc_wallet/src/model/user.dart';
import 'package:apcc_wallet/src/model/version.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';


void init(BuildContext context) async {
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
  if (token ==null){
    token = "";
  }
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
  //初始化货币兑换接收地址
  // coinReceiveAddress["USDT"] = "0xC05dEb0C5e841Aa564f41f769335BC96D75Ade65";
  // coinReceiveAddress["MHC"] = "0xC05dEb0C5e841Aa564f41f769335BC96D75Ade65";

  // storage.delete(key:"rootPrivateKey");
  // storage.delete(key: "address");
  // getUSDT();

// var contractAbi="[{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"users\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"denominator\",\"outputs\":[{\"name\":\"\",\"type\":\"uint16\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"unfreezeTime\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"address\"}],\"name\":\"assets\",\"outputs\":[{\"name\":\"totalAmount\",\"type\":\"uint64\"},{\"name\":\"freezeAmount\",\"type\":\"uint64\"},{\"name\":\"molecule\",\"type\":\"uint16\"},{\"name\":\"count\",\"type\":\"uint16\"},{\"name\":\"index\",\"type\":\"uint16\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"constant\":false,\"inputs\":[{\"name\":\"_ownerAddress\",\"type\":\"address\"}],\"name\":\"changeOwner\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_addr\",\"type\":\"address\"},{\"name\":\"_frozenMount\",\"type\":\"uint32\"},{\"name\":\"_molecule\",\"type\":\"uint16\"}],\"name\":\"add\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_address\",\"type\":\"address\"}],\"name\":\"del\",\"outputs\":[],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"unfreeze\",\"outputs\":[],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"leftFreeze\",\"outputs\":[{\"name\":\"total\",\"type\":\"uint64\"},{\"name\":\"once\",\"type\":\"uint64\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"}]";
// var contractAddress="0x0D857Fbc85BC6a603298e21668cd84815BA924CB";
// var contractName="MhcThaw";
//  var txs =  await callContractPayable(contractAbi,contractAddress,contractName,"add","22222222222222Qq",[EthereumAddress.fromHex("0x88761000d7fb6080490d54800fe5252e1a35d84d"),BigInt.from(500),BigInt.from(2)]);
// print("TXs=============================$txs");

}

