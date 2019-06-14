
import 'dart:async';


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
