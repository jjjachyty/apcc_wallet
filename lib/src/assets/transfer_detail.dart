import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/material.dart';

class TransferDetailPage extends StatelessWidget {
  TransferLog log;
  TransferDetailPage(this.log);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("转账详情"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Text("编号"),
              title: Text(log.uuid),
            ),
            ListTile(
              leading: Text("类型"),
              title: Text(payTypes[log.payType]),
            ),
            ListTile(
              leading: Text("币种"),
              title: Text(log.coin),
            ),
            ListTile(
              leading: Text("转出金额"),
              title: Text(log.amount.toString()),
            ),
            ListTile(
              leading: Text("手续费"),
              title: Text(log.free.toString()),
            ),
            ListTile(
              leading: Text("到账金额"),
              title: Text((log.amount - log.free).toString()),
            ),
            ListTile(
              leading: Text("地址"),
              title: Text(log.fromAddress),
            ),
            Icon(
              Icons.arrow_downward,
              color: Colors.indigo,
            ),
            ListTile(
              leading: Text("地址"),
              title: Text(log.toAddress),
            ),
            ListTile(
              leading: Text("币种"),
              title: Text(log.coin),
            ),
            Divider(),
            ListTile(
              leading: Text("状态"),
              title: Text(
                log.state == 1 ? "完成" : "转账中...",
                style: TextStyle(color: Colors.indigo),
              ),
            )
          ],
        ),
      ),
    );
  }
}
