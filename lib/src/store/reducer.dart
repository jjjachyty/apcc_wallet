import 'package:apcc_wallet/src/store/actions.dart';
import 'package:redux/redux.dart';

import 'state.dart';

// AppState appReducer(AppState state, action) {
//   return AppState(appReducer(state, action));
// }

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, RefreshMnemonicAction>(_refresh),
  TypedReducer<AppState, RefreshWalletsAction>(_refreshWallets),
]);

AppState _refresh(AppState state, action) {
  print("mnemonic   _refresh");
  print(action);
  state.mnemonic = action.mnemonic;
  return state;
}

AppState _refreshWallets(AppState state, action) {
  print("_refreshWallets   _refresh");
  print(action);
  state.wallets = action.wallets;
  return state;
}
