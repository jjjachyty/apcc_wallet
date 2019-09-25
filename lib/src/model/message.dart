import 'package:apcc_wallet/src/common/define.dart';

class Message {
  String id;
  String sender;
  String receiver;
  int type;
  String content;
  String sendTime;
  String cresateTime;
  Message({this.id,this.sender,this.receiver,this.type,this.content,this.sendTime,this.cresateTime});
}

Future<List<Message>> getMessages(String friendsID,int pageNumer) async {
  List<Message> msg = new List();
   msg.add(Message(id:"1",sender:"e89912b1-bbb1-4405-aad3-be4d43cc515e",receiver: "ae7d58f2-297a-46ba-ae5c-098d4a96411a",type: 0,content: "你来我办公室一下",sendTime: "2019-9-25 16:10:25")); 
    msg.add(Message(id:"1",sender:"ae7d58f2-297a-46ba-ae5c-098d4a96411a",receiver: "e89912b1-bbb1-4405-aad3-be4d43cc515e",type: 0,content: "马上来",sendTime: "2019-9-25 16:10:28")); 

    msg.add(Message(id:"1",sender:"ae7d58f2-297a-46ba-ae5c-098d4a96411a",receiver: "e89912b1-bbb1-4405-aad3-be4d43cc515e",type: 0,content: "马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来马上来",sendTime: "2019-9-25 16:10:28")); 
       msg.add(Message(id:"1",sender:"e89912b1-bbb1-4405-aad3-be4d43cc515e",receiver: "ae7d58f2-297a-46ba-ae5c-098d4a96411a",type: 0,content: "为撒还没有见你来",sendTime: "2019-9-25 16:10:28")); 
if (pageNumer>1){
      msg.insert(0,Message(id:"1",sender:"ae7d58f2-297a-46ba-ae5c-098d4a96411a",receiver: "e89912b1-bbb1-4405-aad3-be4d43cc515e",type: 0,content: "的",sendTime: "2019-9-25 16:10:28")); 
    msg.insert(0,Message(id:"1",sender:"ae7d58f2-297a-46ba-ae5c-098d4a96411a",receiver: "e89912b1-bbb1-4405-aad3-be4d43cc515e",type: 0,content: "好的",sendTime: "2019-9-25 16:10:28")); 
    msg.insert(0,Message(id:"1",sender:"ae7d58f2-297a-46ba-ae5c-098d4a96411a",receiver: "e89912b1-bbb1-4405-aad3-be4d43cc515e",type: 0,content: "我有事去不了了",sendTime: "2019-9-25 16:10:28")); 

}
  return msg;
}