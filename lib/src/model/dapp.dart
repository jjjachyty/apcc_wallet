import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';

class Dapp {
  String uuid;
  String name;
  String subtitle;
  String category;
  String permission;
  String synopsis;
  String score;
  String logo;
  String banner;
  String snapshot;
  String video;
  String owner;
  String used;
  int state;
  String submitAt;
  String upperAt;
  String lowerAt;
  String auditor;
  String auditOpinions;
  String homePage;
  Dapp({this.uuid,this.name,this.subtitle,this.category,this.permission,this.synopsis,this.score,this.logo,this.banner,this.snapshot,this.video,this.owner,this.used,this.state,this.submitAt,
  this.upperAt,this.lowerAt,this.auditor,this.auditOpinions,this.homePage});
}

Future<PageData> all(Map<String,dynamic> params) async {
  List<Dapp> _list = new List();
  var _data = await get("/dapp/all",
      parameters: params);
        var _pageData = PageData.fromJson(_data.data);

  if (_data.state){
  var _rows = _pageData.rows as List;
  _rows.forEach((item) {
    _list.add(Dapp(uuid: item["UUID"],name: item["Name"],subtitle: item["Subtitle"],category: item["Category"],permission: item["Permission"],synopsis: item["Synopsis"],score: item["Score"].toString(),logo: item["Logo"],
    banner: item["Banner"],snapshot: item["Snapshot"],video: item["Video"],owner: item["Owner"],used: item["Used"],state: item["State"],submitAt: item["SubmitAt"],upperAt: item["UpperAt"],lowerAt: item["LowerAt"],
    auditor: item["Auditor"],auditOpinions: item["AuditOpinions"],homePage: item["HomePage"]
    ));
  });
  _pageData.rows = _list;
  }
  return _pageData;
}
