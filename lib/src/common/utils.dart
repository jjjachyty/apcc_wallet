
import 'dart:async';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:shared_preferences/shared_preferences.dart';
    SharedPreferences prefs ;

    initSharedPreferences() async{
      if (prefs == null){
        prefs =  await SharedPreferences.getInstance();
        return prefs;
      }
      return prefs;
      
    }

  Future<String> getStorageString(String key) async{
      return prefs.getString(key);
  }

  Future<bool> setStorageString(String key,val) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.setString(key,val);
  }

  Future<bool> removeStorage(String key) async{
      return prefs.remove(key);
  }
/// 倒计时
  Timer countDown(int seconds,Function fun(int count)) {
    var _timer;

     _timer =  Timer.periodic(new Duration(seconds: 1), (timer){
      print(seconds);
      fun(seconds);
      if(seconds == 0){
        _timer.cancel();
        return;
      }
      
      seconds--;
    });

    return _timer;
  }


  double toDouble(String val){
     var _db = double.tryParse(val);
     if (_db ==null){
       return 0;
     }
     return _db;
  }

