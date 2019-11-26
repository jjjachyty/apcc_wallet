import 'package:apcc_wallet/src/center/assessment/nurse.dart';
import 'package:flutter/material.dart';

import 'assessment/doctor.dart';

class Assessment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("专业认证"),actions: <Widget>[
        FlatButton( child: Text("我的认证",style: TextStyle(color: Colors.white),),onPressed: (){

        },)
      ],),
      body:
      Container(
        padding: EdgeInsets.all(8),
        child: ListView(children: <Widget>[
        ListTile(leading:Icon(
                  IconData(0xe628, fontFamily: 'myIcon'),color: Colors.blue,
                ),title: Text("医生"),trailing: Icon(Icons.keyboard_arrow_right),onTap: (){
                  
                   Navigator.push(context, MaterialPageRoute(builder: (context){
                    return DoctorAuthenticationPage();
                  }));
                },),
         ListTile(leading:Icon(
                  IconData(0xe625, fontFamily: 'myIcon'),color: Colors.pink,
                ),title: Text("护士"),trailing: Icon(Icons.keyboard_arrow_right),onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return NurseAuthenticationPage();
                  }));
                },),
      ],),
      )
       
    );
  }
}