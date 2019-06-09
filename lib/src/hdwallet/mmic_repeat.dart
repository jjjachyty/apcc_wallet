import 'package:flutter/material.dart';
import '../global_store/state.dart';

class MnemonicRepeatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MnemonicRepeatState();
  }
}

class _MnemonicRepeatState extends State<MnemonicRepeatPage> {
  @override
  Widget build(BuildContext context) {
    print("==============");

    print("=================");

    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          title: Text("助记词"),
        ),
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: ainAxisSize.,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(top: 10),
              alignment: Alignment.bottomLeft,
              child: Text("请依次输入12个单词"),
            ),
            new Flexible(
                flex: 1,
                child: Container(
                    height: 300,
                    child: new GridView.builder(
                        gridDelegate:
                            new SliverGridDelegateWithMaxCrossAxisExtent(
                          //SliverGridDelegateWithFixedCrossAxisCount可以直接指定每行（列）显示多少个Item   SliverGridDelegateWithMaxCrossAxisExtent会根据GridView的宽度和你设置的每个的宽度来自动计算没行显示多少个Item
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          maxCrossAxisExtent: 100.0,
                        ),
                        itemCount: 12,
                        itemBuilder: (BuildContext context, int index) {
                          return new TextField(
                            maxLength: 1,
                          );
                        }))),
            new MaterialButton(
              minWidth: 200,
              color: Colors.green,
              textColor: Colors.white,
              child: new Text('下一步'),
              onPressed: () {
                // ...
              },
            ),
            Align(
                alignment: Alignment.centerLeft,
                heightFactor: 1.9,
                child: Text(
                  "可点击选择:",
                )),
            Container(
                height: 80,
                child: new GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 2,
                    ),
                    itemCount: 12,
                    itemBuilder: (BuildContext context, int index) {
                      return new MaterialButton(
                        padding: EdgeInsets.zero,
                        color: Colors.green,
                        textColor: Colors.white,
                        child: new Text(
                          '离',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          // ...
                        },
                      );
                    }))
          ],
        )));
  }
}
