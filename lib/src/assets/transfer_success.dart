import 'package:flutter/material.dart';

class TransferSuccessPage extends StatelessWidget {
  String payType;
  TransferSuccessPage(this.payType);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(9),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
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
                "转账成功",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Text(payType == "out" ? "转出外部因网络原因到账时间不准,请耐心等待" : "")
        ],
      ),
    ));
  }
}
