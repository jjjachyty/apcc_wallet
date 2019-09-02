import 'package:apcc_wallet/src/common/define.dart';
import 'package:flutter/material.dart';

class MnemonicRepeatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MnemonicRepeatState();
  }
}

class _MnemonicRepeatState extends State<MnemonicRepeatPage> {
  int _currentIndex = 0;
  var _mmics;
  List<String> _inputsVal = new List(12);
  @override
  initState() {
    super.initState();
     print(mnemonic);
    _mmics = mnemonic.split(" ");
    _mmics.shuffle();
  
  }

  Widget _inputs() {
    return GridView.builder(
        gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
          //SliverGridDelegateWithFixedCrossAxisCount可以直接指定每行（列）显示多少个Item   SliverGridDelegateWithMaxCrossAxisExtent会根据GridView的宽度和你设置的每个的宽度来自动计算没行显示多少个Item
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          maxCrossAxisExtent: 100.0,
        ),
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) {
          return 
          GestureDetector(
            onTap: (){
              setState(() {
                _inputsVal[index]=(index+1).toString();
                _currentIndex = index;
              });
              

            },
            child:
          Container(
            alignment: Alignment.center,
            height: 10,
            width: 10,
            child: Text(
              _inputsVal[index] == null ? (index+1).toString() : _inputsVal[index],
              
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  
                  fontWeight: FontWeight.bold),
            ),
          ));
        });
  }

  Widget _tips() {
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
            // _controllers[_currentIndex][0].text = _mmics[index];
            // if (_currentIndex < 11) {
            //   FocusScope.of(context)
            //       .requestFocus(_controllers[_currentIndex + 1][1]);
            //   _currentIndex++;
            // }
            setState(() {
              _inputsVal[_currentIndex] = _mmics[index];
              _currentIndex++;
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _showMsg() {
    showDialog(
        context: context,
        builder: (ctx) => new AlertDialog(
              title: Icon(
                Icons.error,
                color: Colors.red,
                size: 50,
              ),
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
                flex: 1, child: Container(height: 300, child: _inputs())),
            new MaterialButton(
              minWidth: 200,
              color: Colors.green,
              textColor: Colors.white,
              child: new Text('下一步'),
              onPressed: () {
                print("下一步");
                var _trimVal = "";
                _inputsVal.forEach((e){
                  if (e !=null){
 _trimVal= _trimVal + e;
                  }
                 
                });
                print(_trimVal);
                print(mnemonic.replaceAll(" ", ""));
                if (_trimVal == mnemonic.replaceAll(" ", "")) {
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
            Container(height: 80, child: _tips())
          ],
        )));
  }
}
