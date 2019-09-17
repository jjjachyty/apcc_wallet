import 'package:apcc_wallet/src/assets/transfer_detail.dart';
import 'package:apcc_wallet/src/assets/transfer_detail_mhc.dart';
import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/utils.dart';
import 'package:apcc_wallet/src/model/assets.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class TransferListMHCPage extends StatefulWidget {
  String address;
  TransferListMHCPage(this.address);
  @override
  _TransferListMHCPageState createState() =>
      _TransferListMHCPageState(this.address);
}

class _TransferListMHCPageState extends State<TransferListMHCPage> {
  var address;
  _TransferListMHCPageState(this.address);
  List<MHCTransferLog> _orders = new List();
  ScrollController _scrollController = new ScrollController();
  int currentPage = 1;
  bool isPerformingRequest = false;
  @override
  void initState() {
    super.initState();
    mhctransferList(address, currentPage).then((_pageData) {
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
      var _pageData = await mhctransferList(address, currentPage);
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
            var _state = _orders[index].status == 1 ? "完成" : "转账中";
            var _log = _orders[index];
            var _dict = _log.from==address?"转出":"转入";
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(
                formatDate(DateTime.parse(_log.createAt).toLocal(),
<<<<<<< HEAD
                    [mm, "/", dd, " ", HH, ":", nn, ":", ss]),
                textAlign: TextAlign.end,
              ),
              title: Text(_log.from == address ? "转入" : "转出"),
              trailing: Text((_log.value).toString(), style: TextStyle()),
=======
                    [yyyy,"/",mm, "/", dd, " ", HH, ":", nn, ":", ss]),
                style: TextStyle(fontSize: 15),
              ),
              title: Text(_dict),
              trailing: Text((_dict=="转入"?"+ ":"- ")+(_log.value).toString(),
                  style: TextStyle(color: Colors.indigo)),
>>>>>>> c3d441f0b2228c355464e2c9a93751b60a7a0d0d
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (buildContext) {
                  return TransferDetailMHCPage(_log);
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
