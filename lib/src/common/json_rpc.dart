library common;

import 'dart:async';
import 'dart:convert';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:http/http.dart';

class JsonRPC {
  final String url;
  final Client client;
  final Map<String, String> headers;
  int _currentRequestId = 1;

  JsonRPC(this.url, this.client, {this.headers});

  /// Performs an RPC request, asking the server to execute the function with
  /// the given name and the associated parameters, which need to be encodable
  /// with the [json] class of dart:convert.
  ///
  /// When the request is successful, an [RPCResponse] with the request id and
  /// the data from the server will be returned. If not, an RPCError will be
  /// thrown. Other errors might be thrown if an IO-Error occurs.
  Future<Data> call(String function, [List<dynamic> params]) async {
    params ??= [];
    this.headers["Content-Type"] = 'application/json';
    
    final requestPayload = {
      'jsonrpc': '2.0',
      'method': function,
      'params': params,
      'id': _currentRequestId++,
    };
    print("RPC headers=======$headers");
    final response = await client.post(
      url,
      headers: this.headers,
      body: json.encode(requestPayload),
    );
    var data;
        print("RPC response.body=======${response.body}");

    if (response.body == "") {
      return Data(state: true, messsage: "", data: "");
    } else {
      data = json.decode(response.body) as Map<String, dynamic>;
    }
    final id = data['id'] as int;

    if (data.containsKey('error')) {
      final error = data['error'];

      final code = error['code'] as int;
      final message = error['message'] as String;
      final errorData = error['data'];

      return Data(state: false, messsage: message, data: null);
    }

    final result = data['result'];
    return Data(state: true, messsage: "", data: result);
  }
}

/// Response from the server to an rpc request. Contains the id of the request
/// and the corresponding result as sent by the server.
class RPCResponse {
  final int id;
  final dynamic result;

  const RPCResponse(this.id, this.result);
}

/// Exception thrown when an the server returns an error code to an rpc request.
class RPCError implements Exception {
  final int errorCode;
  final String message;
  final dynamic data;

  const RPCError(this.errorCode, this.message, this.data);

  @override
  String toString() {
    return 'RPCError: got code $errorCode with msg \"$message\".';
  }
}
