import 'package:apcc_wallet/src/store/actions.dart';
import 'package:redux/redux.dart';

import 'state.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    mnemonic: mnemonicReducer(state.mnemonic, action),
  );
}

final mnemonicReducer = combineReducers<String>([
  TypedReducer<String, RefreshMnemonicAction>(_refresh),
]);

String _refresh(String mnemonic, action) {
  print("mnemonic   _refresh");
  print(action);
  mnemonic = action.mnemonic;
  return mnemonic;
}
