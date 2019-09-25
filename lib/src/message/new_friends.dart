import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/message/add_friends.dart';
import 'package:apcc_wallet/src/message/agree_friends.dart';
import 'package:apcc_wallet/src/model/im_friend.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:flutter/material.dart';

class NewFriends extends StatefulWidget {
  @override
  _NewFriendsState createState() => _NewFriendsState();
}

class _NewFriendsState extends State<NewFriends> {
  List<FriendApply> applys = new List(); 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    friendApplys().then((data){
      if (data.state){
        setState(() {
           (data.data as List).forEach((val){
          applys.add(FriendApply.fromJson(val));
        });
        });
       
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("新的朋友"),actions: <Widget>[
        MaterialButton(
          child: Text("添加新朋友",style: TextStyle(color: Colors.white),),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddFriendsPage();
            }));
          },
        )
      ],),
      body: Container(
        child: ListView.separated(
          separatorBuilder: (context,index)=>Divider(),
          itemCount: applys.length,
          itemBuilder: (context,index){
            return ListTile(
              leading: Image.network(avatarURL,width: 40,height: 40,),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(applys[index].friendNickName,style: TextStyle(),),
                  Text(applys[index].explain,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey))
                ],
              ),
              trailing: Text("申请好友"),
              onTap: () async {
               var flag = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (conext){
                    return AgreeFriendPage(applys[index]);
                  }
                ));
                if (flag as bool){
                  setState(() {
                    applys.removeAt(index);
                });
                }
                
              },
            );
          },
        ),
      ),
    );
  }
}