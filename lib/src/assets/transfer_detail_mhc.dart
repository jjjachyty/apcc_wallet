import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/assets.dart';
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
              leading: Text("编号"),
              title: Text(log.txHash),
            )
          ],
        ),
      ),
    );
  }
}
