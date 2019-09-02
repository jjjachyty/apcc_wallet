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
    return   PageView.builder(
            itemCount: keys.length,
            itemBuilder: (context,index){
               return     Container(
                        child: new QrImage(
                          data: _currentAddr,
                          foregroundColor: Colors.green,
                          size: 250.0,
                        ));
             
                       }
                    
              
                );
              
       
  }
}
