import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Reducer<GlobalState> buildReducer() {
  return asReducer(
    <Object, Reducer<GlobalState>>{
      GlobalAction.changeMnemonic: _onchangeMnemonic,
    },
  );
}

GlobalState _onchangeMnemonic(GlobalState state, Action action) {
  print("_onchangeMnemonic''");
  print(action.payload);
  return state.clone()..mnemonic = action.payload;
}
