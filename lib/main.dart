import 'package:apcc_wallet/router.dart';

import 'package:apcc_wallet/src/common/init.dart';
import 'package:apcc_wallet/src/common/splashScreen.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  runApp(new MyApp());
}

// SystemUiOverlayStyle systemUiOverlayStyle =
//     SystemUiOverlayStyle(statusBarColor: Colors.transparent);
// SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
    init(context);
    //  SystemChrome.setEnabledSystemUIOverlays([]);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.indigo and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white),
        ),
        // buttonColor: Colors.blue.shade800,
        buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
            buttonColor: Colors.blue.shade800),
        appBarTheme: AppBarTheme(
            color: Colors.blue.shade800,
            actionsIconTheme: IconThemeData(color: Colors.white),
            textTheme: TextTheme(button: TextStyle(color: Colors.white))),
        primaryColor: Colors.blue.shade800,
      ),
      home: new SplashScreen(),
      routes: routes,
    );
  }
}
