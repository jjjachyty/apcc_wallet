import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';

enum GlobalAction { changeMnemonic }

class GlobalActionCreator {
  static Action onchangeMnemonic(String mnemonic) {
    return Action(GlobalAction.changeMnemonic, payload: mnemonic);
  }
}
