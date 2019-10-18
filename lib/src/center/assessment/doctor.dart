import 'package:flutter/material.dart';

class DoctorAuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("医生认证"),),
      body: SingleChildScrollView(
        child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
          children: <Widget>[
              TextField(decoration: InputDecoration(labelText: "证书编码"),),
              TextField(decoration: InputDecoration(labelText: "所在机构"),),
              TextField(decoration: InputDecoration(labelText: "所在科室"),),
              TextField(decoration: InputDecoration(labelText: "当前职称"),),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                child: Text("申请认证"),onPressed: (){

              },)
          ],
        ),
        )
      ),
      ) 
    );
  }
}