import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/model/im_friend.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ApplyFriendPage extends StatelessWidget {
  User user;
  ApplyFriendPage(this.user);
 TextEditingController explanCtl =new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: 
      SingleChildScrollView(
        child: 
      
      Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                placeholder: "assets/images/nologinavatar.png",
                image: user.avatar==""?"assets/images/nologinavatar.png": imageHost +
                    user.avatar +
                    ".webp?" +
                    DateTime.now().toString(),
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
                        SizedBox(height: 30,),

            Text(
              user.nickName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text.rich(TextSpan(text: "ID:",children: [
              TextSpan(
                text: user.phone
                ,style: TextStyle(fontWeight: FontWeight.w400)
              )
            ],style: TextStyle(fontWeight: FontWeight.bold))),
            Text(user.introduce),
            SizedBox(height: 30,),
            TextField(
              maxLines: 3,
              maxLength: 25,
              controller: explanCtl,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(hintText: "请输入添加好友说明",border: OutlineInputBorder()),
            ),
            MaterialButton(
              minWidth: double.maxFinite,
              color: Colors.blue.shade700,
              child: Text(
                "添加好友",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: ()async {
                print(explanCtl.text);
               var _data =  await friendApply(FriendApply(friendID: user.uuid,explain: explanCtl.text));
               if (_data.state){
                 Toast.show("申请成功", context);
                 Navigator.of(context).pop();
               }
              },
            )
          ],
        ),
      ))
    );
  }
  
}
