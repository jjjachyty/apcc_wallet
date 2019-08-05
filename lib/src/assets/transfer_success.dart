import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransferSuccessPage extends StatelessWidget {
  String title;
  TransferSuccessPage(this.title);

  GlobalKey<ScaffoldState> _key = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.close,color: Colors.green,),onPressed: (){
        Navigator.of(context).pop();
      },),backgroundColor: Colors.transparent,elevation: 0,),
        body: Container(
      padding: EdgeInsets.all(9),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: <Widget>[
          //     IconButton(
          //       icon: Icon(
          //         Icons.close,
          //         color: Colors.green,
          //       ),
          //       onPressed: () {
          //         Navigator.of(context).pop();
          //       },
          //     )
          //   ],
          // ),
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Text("因网络原因到账时间不准,还请耐心等待"),
          Divider(),
        //  txHash!=null? Table(
        //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        //   columnWidths: {0:FractionColumnWidth(0.2),2:FractionColumnWidth(0.2)},
        //     children: <TableRow>[
        //       TableRow(children: <Widget>[
        //         Text("交易Hash"),
        //         Text(txHash),
        //         FlatButton(child: Text("复制",style: TextStyle(color: Colors.green),),onPressed: (){
        //            Clipboard.setData(ClipboardData(text: txHash));
        //           _key.currentState.showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text("已复制"),));
        //         },)
        //       ]),
              
        //     ],
        //   ):Text("可在转账记录中查询详情"),
  
        ],
      ),
    ));
  }
}
