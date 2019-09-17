import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class TransferDetailMHCPage extends StatelessWidget {
  MHCTransferLog log;
  TransferDetailMHCPage(this.log);
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
              leading: Text("交易编号"),
              title: Text(log.txHash),
            ),
            ListTile(
              leading: Text("区块编号"),
              title: Text(log.blockNumber.toString()),
            ),
            ListTile(
              leading: Text("区块Hash"),
              title: Text(log.blockHash),
            ),
            ListTile(
              leading: Text("转出地址"),
              title: Text(log.from),
            ),
            ListTile(
              leading: Text("转入地址"),
              title: Text(log.to),
            ),
            ListTile(
              leading: Text("Gas限制"),
              title: Text((log.gas/1000000000000000000).toStringAsFixed(18)),
            ),
            ListTile(
              leading: Text("Gas价格"),
              title: Text((log.gasPrice/1000000000000000000).toStringAsFixed(18)),
            ),
            ListTile(
              leading: Text("Gas花费"),
              title: Text((log.gasUsed/1000000000000000000).toStringAsFixed(18)),
            ),
            ListTile(
              leading: Text("转账金额"),
              title: Text(log.value.toString()),
            ),
                        ListTile(
              leading: Text("状      态"),
              title: Text(log.status==1?"完成":"转账中"),
            ),
            ListTile(
              leading: Text("Nonce  "),
              title: Text(log.nonce.toString()),
            ),
            ListTile(
              leading: Text("手续费  "),
              title: Text(log.free.toString()),
            ),

            ListTile(
              leading: Text("创建时间"),
              title: Text(formatDate(DateTime.parse(log.createAt).toLocal(),
                    [yyyy,"/",mm, "/", dd, " ", HH, ":", nn, ":", ss]),
                style: TextStyle(fontSize: 15),),
            ),
            ListTile(
              leading: Text("InputData"),
              title: Text(log.inputData),
            ),
            ListTile(
              leading: Text("TokenTo"),
              title: Text(log.tokenTo),
            ),
            ListTile(
              leading: Text("TokenValue"),
              title: Text(log.tokenValue.toString()),
            )
          ],
        ),
      ),
    );
  }
}
