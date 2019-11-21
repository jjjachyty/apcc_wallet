import 'package:flutter/material.dart';

class DoctorAuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("医生认证"),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(16),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          labelText: "证书编码", border: OutlineInputBorder()),
                    ),
                    Container(
                      height: 100,
                      child: Row(
                        children: <Widget>[
                          Expanded(child:
                          TextField(
                            decoration: InputDecoration(
                                labelText: "所在省/市"
                                , border: OutlineInputBorder()
                          ))),
                          Expanded(child:TextField(
                            decoration: InputDecoration(
                                labelText: "所在区/县", border: OutlineInputBorder())
                                
                          )),
                        ],
                      ),
                    ),
                   
                    TextField(
                      decoration: InputDecoration(
                          labelText: "所在机构", border: OutlineInputBorder()),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "所在科室", border: OutlineInputBorder()),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "当前职称", border: OutlineInputBorder()),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "工龄", border: OutlineInputBorder()),
                    ),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                          labelText: "个人简介", border: OutlineInputBorder()),
                    ),
                    MaterialButton(
                      color: Theme.of(context).primaryColor,
                      child: Text("申请认证"),
                      onPressed: () {},
                    )
                  ],
                ),
              )),
        ));
  }
}
