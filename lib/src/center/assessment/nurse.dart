import 'package:apcc_wallet/src/model/user_occupation.dart';
import 'package:flutter/material.dart';

class NurseAuthenticationPage extends StatefulWidget {
  @override
  _NurseAuthenticationPageState createState() =>
      _NurseAuthenticationPageState();
}

class _NurseAuthenticationPageState extends State<NurseAuthenticationPage> {
  GlobalKey<FormState> _formKey = new GlobalKey();
  String _certificateCode,
      _province,
      _city,
      _county,
      _certificateOrganization,
      _workingOrganization,
      _title,
      _seniority,
      _introduction;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("护士认证"),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (val) {
                        if (val == null || val == "") {
                          return "证书编号不能为空";
                        }
                      },
                      onSaved: (val) {
                        this._certificateCode = val;
                      },
                      decoration: InputDecoration(
                          labelText: "证书编码", border: OutlineInputBorder()),
                    ),
                    Container(
                      height: 100,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: TextFormField(
                                  validator: (val) {
                                    if (val == null || val == "") {
                                      return "所在省/市不能为空";
                                    }
                                  },
                                  onSaved: (val) {
                                    this._certificateCode = val;
                                  },
                                  decoration: InputDecoration(
                                      labelText: "所在省",
                                      border: OutlineInputBorder()))),
                          Expanded(
                              child: TextFormField(
                                  validator: (val) {
                                    if (val == null || val == "") {
                                      return "所在市不能为空";
                                    }
                                  },
                                  onSaved: (val) {
                                    this._certificateCode = val;
                                  },
                                  decoration: InputDecoration(
                                      labelText: "所在市",
                                      border: OutlineInputBorder()))),
                          Expanded(
                              child: TextFormField(
                                  validator: (val) {
                                    if (val == null || val == "") {
                                      return "所在区/县/镇不能为空";
                                    }
                                  },
                                  onSaved: (val) {
                                    this._certificateCode = val;
                                  },
                                  decoration: InputDecoration(
                                      labelText: "所在区/县/镇",
                                      border: OutlineInputBorder()))),
                        ],
                      ),
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val == null || val == "") {
                          return "所在机构不能为空";
                        }
                      },
                      onSaved: (val) {
                        this._certificateCode = val;
                      },
                      decoration: InputDecoration(
                          labelText: "所在机构", border: OutlineInputBorder()),
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val == null || val == "") {
                          return "所在科室不能为空";
                        }
                      },
                      onSaved: (val) {
                        this._certificateCode = val;
                      },
                      decoration: InputDecoration(
                          labelText: "所在科室", border: OutlineInputBorder()),
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val == null || val == "") {
                          return "当前职称不能为空";
                        }
                      },
                      onSaved: (val) {
                        this._certificateCode = val;
                      },
                      decoration: InputDecoration(
                          labelText: "当前职称", border: OutlineInputBorder()),
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val == null || val == "") {
                          return "工龄不能为空";
                        }
                      },
                      onSaved: (val) {
                        this._certificateCode = val;
                      },
                      decoration: InputDecoration(
                          labelText: "工龄", border: OutlineInputBorder()),
                    ),
                    TextFormField(
                      maxLines: 3,
                      validator: (val) {
                        if (val == null || val == "") {
                          return "个人简介不能为空";
                        }
                      },
                      onSaved: (val) {
                        this._certificateCode = val;
                      },
                      decoration: InputDecoration(
                          labelText: "个人简介", border: OutlineInputBorder()),
                    ),
                    MaterialButton(
                      color: Theme.of(context).primaryColor,
                      child: Text("申请认证"),
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          _formKey.currentState.save();
                                                  var _data = applyOccupation(UserOccupation());

                        }
                      },
                    )
                  ],
                ),
              )),
        ));
  }
}
