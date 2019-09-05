import 'package:flutter/material.dart';

class NoWalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "暂未发现钱包,请",
            style: TextStyle(fontSize: 20),
          ),
          BigMenu(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 50,
            ),
            text: Text(
              "创建钱包",
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            tap: () {
              Navigator.of(context).pushNamed('/wallet/mmic');
            },
          ),
          Text(
            "或者",
            style: TextStyle(fontSize: 20),
          ),
          BigMenu(
            icon: Icon(
              Icons.input,
              color: Colors.white,
              size: 50,
            ),
            text: Text(
              "导入钱包",
              style: TextStyle(fontSize: 28, color: Colors.white),
            ),
            tap: () {
              Navigator.of(context).pushNamed('/wallet/importmmic');
            },
          )
        ],
      ),
    ));
  }
}

class BigMenu extends StatelessWidget {
  final Widget icon;

  final Widget text;

  final Function tap;

  BigMenu({this.icon, this.text, this.tap});
  void _click() {
    this.tap();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        this._click();
      },
      child: Card(
        color: Colors.indigoAccent,
        //z轴的高度，设置card的阴影
        elevation: 20.0,
        //设置shape，这里设置成了R角
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
        clipBehavior: Clip.antiAlias,
        semanticContainer: false,
        child: Container(
          color: Colors.indigo,
          width: 200,
          height: 150,
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[icon, text],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
