

import 'dart:io';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

import 'event_bus.dart';

var apiURL = "http://192.168.1.11:9090/api/wallet/v1";

Dio  api ;


Future<Data> post(String path,{dynamic data, }) async{
  Data _data ;
  try{
   var  _response =   await api.post(path,data: data);
   _data = Data(state: _response.data["Status"],messsage: _response.data["Message"],data:_response.data["Data"]);
  }on DioError catch(e) {
      print(e.type); 
      if( e.type == DioErrorType.RECEIVE_TIMEOUT){
        _data = Data(state:false,messsage: "请求超时,请重试");
      }else{
      _data = Data(state:false,messsage: e.message);
      }
  }
  print(_data.messsage);
  return _data;
}


Future<Data> get(String path,{dynamic parameters, }) async{
  Data _data ;
  try{
   var  _response =   await api.get(path,queryParameters: parameters);
   _data = Data(state: _response.data["Status"],messsage: _response.data["Message"],data:_response.data["Data"]);
  }on DioError catch(e) {
      print(e.type); 
      if( e.type == DioErrorType.RECEIVE_TIMEOUT){
        _data = Data(state:false,messsage: "请求超时,请重试");
      }else{
      _data = Data(state:false,messsage: e.message);
      }
  }
  print(_data.messsage);
  return _data;
}


  ///获取新token
  Future<String> refreshToken(String token) async {
    String _token ; //获取当前token
   
  
    try {
      var response = await Dio(BaseOptions(
    baseUrl: apiURL,
    connectTimeout: 5000,
    receiveTimeout: 50000,
    headers: {HttpHeaders.authorizationHeader:token}
   )).post("/auth/refreshtoken");


   if (response.data["Status"]){
      _token = response.data['Data']['Token']; //获取返回的新token
      print('oldtoke=${token}   newToken:$_token');
   }

    } on DioError catch (e) {
      if (e.response == null) {
        print('DioError:${e.message}');
      } else {
        if (e.response.statusCode == 422) {
          print('422Error:${e.response.data['msg']}');
          //422状态码代表异地登录，token失效，发送登录失效事件，以便app弹出登录页面
          eventBus.fire(UserLoggedInEvent());
        }
      }
    }
    return _token;
  }

// class RefreshTokenInterceptor extends Interceptor {
//   @override
//   onError(DioError err) async {
//     if (err.response != null && err.response.statusCode == 401 && token != "") {
     
//       api.lock();
//       var token = await getToken(); //获取新token
//       api.options.headers[HttpHeaders.authorizationHeader] = token;
//       api.unlock();

//       var request = err.response.request; //千万不要调用 err.request
//       request.headers['Authorization'] = token; //这里要单独修改之前请求里的token请求头为最新的token。
//       try {
//         var response = await api.request(request.path,
//             data: request.data,
//             queryParameters: request.queryParameters,
//             cancelToken: request.cancelToken,
//             options: request,
//             onReceiveProgress:request.onReceiveProgress //TODO 差一个onSendProgress
//             );
//         return response;
//       } on DioError catch (e) {
//         return e;
//       }
//     }
//     super.onError(err);
//   }

//   ///获取新token
//   Future<String> getToken() async {
//     String _token = token; //获取当前token
   
  
//     try {
//       var response = await api.post("/refreshtoken");
//       _token = response.data['Data']['Token']; //获取返回的新token
//       print('newToken:$token');
//     } on DioError catch (e) {
//       if (e.response == null) {
//         print('DioError:${e.message}');
//       } else {
//         if (e.response.statusCode == 422) {
//           print('422Error:${e.response.data['msg']}');
//           //422状态码代表异地登录，token失效，发送登录失效事件，以便app弹出登录页面
//           eventBus.fire(UserLoggedInEvent());
//         }
//       }
//     }
//     return token;
//   }
// }
