class AppState {
  String mnemonic;

  AppState({this.mnemonic});

  factory AppState.initial() => AppState(mnemonic: "");
}