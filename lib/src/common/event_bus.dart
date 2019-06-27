import 'package:apcc_wallet/src/model/user.dart';
import 'package:event_bus/event_bus.dart';
//Bus初始化
EventBus eventBus = EventBus();

class UserLoggedInEvent{
  UserLoggedInEvent();
}
class UserLoggedOutEvent{
  UserLoggedOutEvent();
}

class UserInfoUpdate{
  User user;
  UserInfoUpdate(this.user);
}