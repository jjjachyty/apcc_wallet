import 'package:apcc_wallet/src/dapp/common.dart';
import 'package:apcc_wallet/src/dapp/index.dart';
import 'package:apcc_wallet/src/model/dapp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SearchAppPage extends StatefulWidget {
  @override
  _SearchAppPageState createState() => _SearchAppPageState();
}

class _SearchAppPageState extends State<SearchAppPage> {
  List<Dapp> _list = new List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              TextField(
                textInputAction: TextInputAction.search,
                autofocus: true,
                onSubmitted: (val) {
                  if (val.length == 0) {
                    _list.clear();
                    return;
                  }
                  ;
                  all({"Name": '%' + val + '%', "order": "name"}).then((page) {
                    setState(() {
                      _list = page.rows;
                    });
                  });
                },
                decoration: InputDecoration(
                    prefix: Icon(
                      Icons.search,
                      color: Colors.indigo,
                    ),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(6),
                    suffix: Text.rich(TextSpan(
                        text: "取消",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pop();
                          }))),
              ),
              _appList(),
            ],
          )),
    ));
  }

  Widget _appList() {
    return Expanded(
        child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(
                  _list[index].logo,
                  width: 60,
                  fit: BoxFit.fill,
                ),
                title: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _list[index].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _list[index].subtitle,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                trailing: Column(
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                          text: _list[index].category,
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                          children: [
                            TextSpan(
                              text: _list[index].score + "分",
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                    ),
                    Text(
                      _list[index].used + "人在使用",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
                onTap: () {
                  launchDapp(context, _list[index]);
                },
              );
            }));
  }
}
