import 'package:flutter/material.dart';

class TransferSuccessPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5),(){
      Navigator.of(context).pushNamedAndRemoveUntil("/assets",(router)=>false);
    });
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close,color: Colors.green,),
          onPressed: (){
Navigator.of(context).pop();
          },
        )
      ],),
      body:   Container(
       alignment: Alignment.center,
       child: Column(
        
         children: <Widget>[
           Row(
              mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               Icon(Icons.done_all),
               Text("转账成功")
             ],
           )
         ],
       ),
    )
    ); 
    
    
  
  }
}