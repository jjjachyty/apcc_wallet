import 'package:apcc_wallet/src/store/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:redux/redux.dart';

class Receive extends StatefulWidget {
  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  String _currentAddr;
  List keys;

  Widget _addressList() {
    return ListView.separated(
        // shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => new Divider(),
        itemCount: keys.length,
        itemBuilder: (buildContext, index) {
          return ListTile(
            leading: new Icon(Icons.blur_on),
            isThreeLine: false,
            trailing: new Icon(Icons.keyboard_arrow_right),
            title: new Text(
              keys[index],
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              setState(() {
                _currentAddr = keys[index];
              });
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, Store<AppState>>(
      onInit: (store){
         keys = store.state.wallets.keys.toList();

           _currentAddr = keys[0];
      },
        converter: (store) => store,
        builder: (context, store) {
          return Scaffold(
              appBar: AppBar(title: Text("接收"),centerTitle: true,),
              body: Center(
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: new QrImage(
                          data: _currentAddr,
                          foregroundColor: Colors.green,
                          size: 250.0,
                        )),
                        Expanded(
                          child: _addressList(),
                        ),
                       
                    
                  ],
                ),
              ));
        });
  }
}
