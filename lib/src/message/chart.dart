import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/model/im_friend.dart';
import 'package:apcc_wallet/src/model/message.dart';
import 'package:apcc_wallet/src/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MessageChartPage extends StatefulWidget {
  Friend friend;
  MessageChartPage(this.friend);
  @override
  _MessageChartPageState createState() => _MessageChartPageState(this.friend);
}

class _MessageChartPageState extends State<MessageChartPage> {
  Friend friend;
  int pageNumber = 0;
  List<Message> messages = new List();
  _MessageChartPageState(this.friend);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   more();
  }
   

Future<void>  more() async{
  pageNumber++;
 getMessages(friend.friendID, pageNumber).then((msgs) {
      setState(() {
        messages = msgs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friend.friendNickName),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: 
              RefreshIndicator(
                onRefresh: more,
                child: 
              Container(
                // height: MediaQuery.of(context).size.height*0.8,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ListView.separated(
                  separatorBuilder: (context,index)=>Divider(),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    //朋友发送的
                    if (messages[index].sender == friend.friendID) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            child: CachedNetworkImage(
                              imageUrl:
                                  imageHost + friend.friendAvatar + ".webp",
                                 
                            ),
                          ),
                          SizedBox(width: 10,),
                           Column(
                            children: <Widget>[
                              Text(messages[index].sendTime,style: TextStyle(fontSize: 10),),
                              Container(
                            width: messages[index].content.length>19? MediaQuery.of(context).size.width*0.7:(messages[index].content.length*20).toDouble(),
                            padding: EdgeInsets.all(8),
                            color: Colors.blue.shade700,
                            child: Text(messages[index].content,style: TextStyle(color: Colors.white),maxLines: 90,overflow: TextOverflow.ellipsis,),
                          ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(messages[index].sendTime,style: TextStyle(fontSize: 10),),
                              Container(
                                alignment: Alignment.center,
                            width: messages[index].content.length>19? MediaQuery.of(context).size.width*0.7:(messages[index].content.length*25).toDouble(),
                            padding: EdgeInsets.all(8),
                            color: Colors.blue.shade700,
                            child: Text(messages[index].content,style: TextStyle(color: Colors.white),maxLines: 90,overflow: TextOverflow.ellipsis,),
                          ),
                            ],
                          ),
                          
                          SizedBox(width: 10,),
                           CircleAvatar(
                            child: CachedNetworkImage(
                                imageUrl: imageHost + user.avatar + ".webp"),
                          )
                           
                        ],
                      );
                    }
                  },
                ),
              ),
              
              )
            
          ),
          Container(
            height: 60,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    maxLines: 2,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(hintText: "请输入",border: OutlineInputBorder()),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.face),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
