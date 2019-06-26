import 'dart:io';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  User user;
  Profile(this.user);

  @override
  _ProfileState createState() => _ProfileState(this.user);
}

class _ProfileState extends State<Profile> {
   User user;
  _ProfileState(this.user);
  File _image;
  GlobalKey<FormState> _nickNamekey = new GlobalKey<FormState>();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
     
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(user);
    return Scaffold(
      appBar: AppBar(title: Text("修改基本信息"),),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){getImage();},
              child: Stack(
                alignment: Alignment(0.0, 0.7),
                children: <Widget>[
                  Container(
                            height: 150,
                            width: 150,
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: _image==null? user.avatar==""?AssetImage("assets/images/money.png"):NetworkImage(user.avatar):Image.file(_image).image)
                                ),
                                Positioned(
                                
                                  child: Text("点击选择头像",style:TextStyle(color: Colors.grey,)),
                                )
                ],
              ) 
            ),
            
            SizedBox(height: 10,),
            TextFormField(
              key:_nickNamekey,
              maxLength: 8,
              initialValue: user.nickName,
              decoration: InputDecoration(hintText: "昵称",border: OutlineInputBorder(),contentPadding: EdgeInsets.all(10),labelText: "昵称"),
              validator: (val){
                if (!nickNameExp.hasMatch(val)){
                  return "昵称格式错误";
                }
              },
            ),
            SizedBox(height: 10,),
            ProgressButton(
                        color: Colors.green,
                        defaultWidget: Text(
                          "修改",
                          style: TextStyle(color: Colors.white),
                        ),
                        progressWidget: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.lightGreen)),
                        onPressed: () async {

                          if (_nickNamekey.currentState.validate()){
                           
                          }
                          
                        },
                      )
          ],
        ),
      ),
    );
  }
}