import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class TransferListPage extends StatefulWidget {
  String coin,payType;
 
  TransferListPage(this.coin,this.payType);
  @override
  _TransferListPageState createState() => _TransferListPageState(this.coin,this.payType);
}

class _TransferListPageState extends State<TransferListPage> {
  var coin,payType;
  _TransferListPageState(this.coin,this.payType);
  List<AssetLog> _orders = new List();
  ScrollController _scrollController = new ScrollController();
  int currentPage = 1;
  bool isPerformingRequest = false;
  @override
  void initState() {
    super.initState();
    orders(coin,payType, currentPage).then((_pageData) {
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
      var _pageData = await orders(coin,payType, currentPage);
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
        title: Text("转账记录"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _orders.length,
          itemBuilder: (buildContext, index) {
            return ListTile(
              leading: Text(formatDate(
                  DateTime.parse(_orders[index].createAt).toLocal(),
                  [mm, "/", dd, " ", HH, ":", nn, ":", ss]),style: TextStyle(fontSize: 15),),
              trailing: Text("-" +
                  (toDouble(_orders[index].fromPreblance) -
                          toDouble(_orders[index].fromBlance))
                      .toString()),
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
