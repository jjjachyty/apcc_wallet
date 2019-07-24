import 'package:apcc_wallet/src/assets/exchange_detail.dart';
import 'package:apcc_wallet/src/assets/transfer_detail.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class ExchangeListPage extends StatefulWidget {
  String mainCoin, exchangeCoin;

  ExchangeListPage(this.mainCoin, this.exchangeCoin);
  @override
  _ExchangeListPageState createState() =>
      _ExchangeListPageState(this.mainCoin, this.exchangeCoin);
}

class _ExchangeListPageState extends State<ExchangeListPage> {
  String mainCoin, exchangeCoin;
  _ExchangeListPageState(this.mainCoin, this.exchangeCoin);
  List<Exchange> _orders = new List();
  ScrollController _scrollController = new ScrollController();
  int currentPage = 1;
  bool isPerformingRequest = false;
  @override
  void initState() {
    super.initState();
    exchangeList(mainCoin, exchangeCoin, currentPage).then((_pageData) {
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
      var _pageData = await exchangeList(mainCoin, exchangeCoin, currentPage);
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
        title: Text("兑换记录"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _orders.length,
          itemBuilder: (buildContext, index) {
            var _state = _orders[index].state == 1 ? "完成" : "兑换中";
             var _log = _orders[index];
        
            return ListTile(
                leading: Text(
                  formatDate(DateTime.parse(_log.createAt).toLocal(),
                      [mm, "/", dd, " ", HH, ":", nn, ":", ss]),
                  style: TextStyle(fontSize: 15),
                ),
                
                trailing: Text.rich(TextSpan(
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    text: _log.amount.toStringAsFixed(6),children: <TextSpan>[
                              TextSpan(text: _state,style: TextStyle(color: Colors.green,fontSize: 12))
                            ])),
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (buildContext){
                              
                                 return ExchangeDetailPage(_log);
                              }));
                            },);
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
