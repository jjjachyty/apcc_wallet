import 'package:apcc_wallet/src/assets/transfer_detail.dart';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class TransferListPage extends StatefulWidget {
  String coin, payType;

  TransferListPage(this.coin, this.payType);
  @override
  _TransferListPageState createState() =>
      _TransferListPageState(this.coin, this.payType);
}

class _TransferListPageState extends State<TransferListPage> {
  var coin, payType;
  _TransferListPageState(this.coin, this.payType);
  List<AssetLog> _orders = new List();
  ScrollController _scrollController = new ScrollController();
  int currentPage = 1;
  bool isPerformingRequest = false;
  @override
  void initState() {
    super.initState();
    orders(coin, payType, currentPage).then((_pageData) {
      setState(() {
        _orders = _pageData.rows;
        print(_pageData.currentPage);
        currentPage = _pageData.currentPage;
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
        currentPage++;
      });
      var _pageData = await orders(coin, payType, currentPage);
      setState(() {
        _orders.addAll(_pageData.rows);
        isPerformingRequest = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("记录"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _orders.length,
          itemBuilder: (buildContext, index) {
            var _state = _orders[index].state == 1 ? "完成" : "转账中";
            var _log = _orders[index];

            return ListTile(
              leading: Text(
                formatDate(DateTime.parse(_log.createAt).toLocal(),
                    [mm, "/", dd, " ", HH, ":", nn, ":", ss]),
                style: TextStyle(fontSize: 15),
              ),
              title: Text(payTypes[_log.payType]),
              trailing: Text("-" + (_log.fromAmount).toString(),
                  style: TextStyle(color: Colors.green)),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (buildContext) {
                  return TransferDetailPage(_log);
                }));
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
