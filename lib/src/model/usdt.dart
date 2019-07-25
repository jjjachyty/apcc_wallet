import 'dart:convert';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:http/http.dart';
import 'package:apcc_wallet/src/common/json_rpc.dart';
final String usdtRPCUrl = "http://119.3.108.19:8110";

JsonRPC _usdtclient;

initUSDTClient(){
  String basicAuth = 
'Basic '+ base64Encode(utf8.encode('mhcusdt:mhcusdtpasswd'));
 _usdtclient = new JsonRPC(usdtRPCUrl,new Client(),headers:{"authorization":basicAuth} );
}

Future<Data> getUSDTblance(String address) async {
  return   _usdtclient.call("omni_getbalance",[address,1]);
}
