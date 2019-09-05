import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/material.dart';

class ExchangeDetailPage extends StatelessWidget {
  Exchange exchange;
  ExchangeDetailPage(this.exchange);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("兑换详情"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Table(
            columnWidths: {0: FractionColumnWidth(0.2)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: <Widget>[
                  TableCell(child: Text("编号")),
                  TableCell(
                    child: Text(exchange.uuid),
                  ),
                ],
              ),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑入时间"),
                ),
                TableCell(
                  child: Text(exchange.createAt),
                ),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑入币种"),
                ),
                TableCell(
                  child: Text(exchange.fromCoin),
                ),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑入金额"),
                ),
                TableCell(
                  child: Text(exchange.fromAmount.toString()),
                ),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑入价格"),
                ),
                TableCell(
                  child: Text("￥" + exchange.fromPriceCny.toString()),
                ),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑入地址"),
                ),
                TableCell(
                  child: Text(exchange.fromAddress),
                ),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑入交易"),
                ),
                TableCell(
                  child: Text(exchange.sendTxs),
                ),
              ]),
              TableRow(children: <Widget>[
                Divider(),
                Divider(),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑出币种"),
                ),
                TableCell(
                  child: Text(exchange.toCoin),
                ),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑出地址"),
                ),
                TableCell(
                  child: Text(exchange.toAddress),
                ),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑出金额"),
                ),
                TableCell(
                  child: Text(exchange.toAmount.toString()),
                ),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑出价格"),
                ),
                TableCell(
                  child: Text("￥" + exchange.toPriceCny.toString()),
                ),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("手续费"),
                ),
                TableCell(
                  child: Text(exchange.free.toString()),
                ),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("费率"),
                ),
                TableCell(
                  child: Text(
                      (exchange.fromPriceCny / exchange.toPriceCny).toString()),
                ),
              ]),
              TableRow(children: <Widget>[
                Divider(),
                Divider(),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑换商地址"),
                ),
                TableCell(
                  child: Text(exchange.sendAddress),
                ),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑出交易"),
                ),
                TableCell(child: Text(exchange.sendTxs)),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("兑出时间"),
                ),
                TableCell(
                    child: Text(exchange.sendTxs == "" ? "" : exchange.sendAt)),
              ]),
              TableRow(children: <Widget>[
                Divider(),
                Divider(),
              ]),
              TableRow(children: <Widget>[
                TableCell(
                  child: Text("状态"),
                ),
                TableCell(
                  child: Text(
                    exchange.state == 1 ? "完成" : "兑换中...",
                    style: TextStyle(color: Colors.indigo),
                  ),
                ),
              ]),
            ]),
      ),
    );
  }
}
