import 'package:apcc_wallet/router.dart';
import 'package:apcc_wallet/src/hdwallet/index.dart';
import 'package:apcc_wallet/src/hdwallet/passwd.dart';
import 'package:flutter_redux/flutter_redux.dart';
import './src/store/state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import './src/store/reducer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  /// initialState 初始化 State
  final store = new Store<AppState>(
    appReducer,
    initialState: AppState.initState(),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.green,
          ),
         
          routes: routes,
        ));
  }
}
