import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:dio/dio.dart';

/**
 *非分布式钱包
 */
Future<Data> send(String fromAddress, String toAddress, String symbol,
    String payPasswd, String transferType, num amount) async {
  return await post("/assets/transfer",
      data: FormData.from({
        "fromAddress": fromAddress,
        "toAddress": toAddress,
        "symbol": symbol,
        "amount": amount,
        "payPasswd": payPasswd,
        "transferType": transferType
      }));
}

//非MHC平台转账
Future<num> getTransferFree(String symbol) async {
  var _data = await get("/assets/transferfree", parameters: {"symbol": symbol});
  if (_data.state) {
    return _data.data;
  }
  return -1;
}
