import 'package:apcc_wallet/router.dart';

import 'package:apcc_wallet/src/common/init.dart';
import 'package:apcc_wallet/src/common/splashScreen.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

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
          textTheme: TextTheme(),
          buttonColor: Colors.blue.shade800,
          appBarTheme: AppBarTheme(color: Colors.blue.shade800),
          primarySwatch: Colors.indigo ),
      home: new SplashScreen(),
      routes: routes,
    );
  }
}
