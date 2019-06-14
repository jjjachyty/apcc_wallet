import 'package:apcc_wallet/src/store/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MnemonicRepeatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MnemonicRepeatState();
  }
}

class _MnemonicRepeatState extends State<MnemonicRepeatPage> {
  List<List<dynamic>> _controllers;
  int _currentIndex = 0;
  var _inputs, _tips;
  var _mmics ;
  @override
  initState() {
    super.initState();
    _controllers = [
      [new TextEditingController(), new FocusNode()],
      [new TextEditingController(), new FocusNode()],
      [new TextEditingController(), new FocusNode()],
      [new TextEditingController(), new FocusNode()],
      [new TextEditingController(), new FocusNode()],
      [new TextEditingController(), new FocusNode()],
      [new TextEditingController(), new FocusNode()],
      [new TextEditingController(), new FocusNode()],
      [new TextEditingController(), new FocusNode()],
      [new TextEditingController(), new FocusNode()],
      [new TextEditingController(), new FocusNode()],
      [new TextEditingController(), new FocusNode()],
    ];

    _inputs = GridView.builder(
        gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
          //SliverGridDelegateWithFixedCrossAxisCount可以直接指定每行（列）显示多少个Item   SliverGridDelegateWithMaxCrossAxisExtent会根据GridView的宽度和你设置的每个的宽度来自动计算没行显示多少个Item
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          maxCrossAxisExtent: 100.0,
        ),
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) {
          return new TextField(
            controller: _controllers[index][0],
            focusNode: _controllers[index][1],
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onTap: () {
              _currentIndex = index;
              print(_currentIndex);
            },
            onEditingComplete: () {
              if (_currentIndex < 11) {
                FocusScope.of(context)
                    .requestFocus(_controllers[_currentIndex + 1][1]);
                _currentIndex++;
              }
            },
            maxLength: 1,
            decoration:
                InputDecoration(hintText: '${index + 1}', counterText: ""),
          );
        });

    _tips =  new StoreConnector<AppState, String>(
            converter: (store) => store.state.mnemonic,
            builder: (context, mmic) {
                print(mmic);
               _mmics = mmic.split(" ");
               _mmics.shuffle();
             

              return new GridView.builder(
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
                  _mmics[index],
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  _controllers[_currentIndex][0].text = _mmics[index];
                  if (_currentIndex < 11) {
                    FocusScope.of(context)
                        .requestFocus(_controllers[_currentIndex + 1][1]);
                    _currentIndex++;
                  }
                },
              );
            },
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _showMsg() {
    // final mySnackBar = SnackBar(
    //   content: new Text('我是SnackBar'),
    //   backgroundColor: Colors.red,
    //   duration: Duration(seconds: 1),
    //   action: new SnackBarAction(
    //       label: '我是scackbar按钮',
    //       onPressed: () {
    //         print('点击了snackbar按钮');
    //       }),
    // );
    // Scaffold.of(context).showSnackBar(mySnackBar);

    showDialog(
        context: context,
        builder: (ctx) => new AlertDialog(
              content: new Text('输入单词与原单词不一致'),
            ));
  }

  @override
  Widget build(BuildContext context) {
    print(context);
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
                flex: 1, child: Container(height: 300, child: _inputs)),
            new MaterialButton(
              minWidth: 200,
              color: Colors.green,
              textColor: Colors.white,
              child: new Text('下一步'),
              onPressed: () {
                print("下一步");
                var inputmmic = "";
                _controllers.forEach((e) {
                  inputmmic += e[0].text;
                });
                if (inputmmic != _mmics) {
                  Navigator.pushNamed(context, "/wallet/passwd");
                } else {
                  _showMsg();
                }
              },
            ),
            Align(
                alignment: Alignment.centerLeft,
                heightFactor: 1.9,
                child: Text(
                  "可点击选择:",
                )),
            Container(height: 80, child: _tips)
          ],
        )));
  }
}
