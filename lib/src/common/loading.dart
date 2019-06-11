import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final bool visible;

  LoadingWidget({Key key, this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Offstage(
        offstage: visible,
        child: new Stack(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
              child: new Center(
                child: SpinKitFadingCircle(
                  color: Colors.blueAccent,
                  size: 30.0,
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
              child: new Center(
                child: new Text("兄台莫急噻~~"),
              ),
            ),
          ],
        ));
  }
}
