import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';

abstract class GlobalBaseState<T extends Cloneable<T>> implements Cloneable<T> {
  String get mnemonic;
  set mnemonic(String mnemonic);
}

class GlobalState implements GlobalBaseState<GlobalState> {
  @override
  String mnemonic; //助记词

  @override
  GlobalState clone() {
    return GlobalState();
  }
}
