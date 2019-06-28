import 'dart:convert';

import 'package:apcc_wallet/src/common/http.dart';

class Version {
  String versionCode;
  String releaseTime;
  String releaseNote;
  String androidDownloadUrl;
  String iosDownloadUrl;
  Version(
      {this.versionCode,
      this.releaseTime,
      this.releaseNote,
      this.androidDownloadUrl,
      this.iosDownloadUrl});

  Version.fromJson(Map<String, dynamic> json)
      : versionCode = json["VersionCode"],
        releaseTime = json["ReleaseTime"],
        releaseNote = json["ReleaseNote"],
        androidDownloadUrl = json["AndroidDownloadUrl"],
        iosDownloadUrl = json["IosDownloadUrl"];
}

Future<Version> getVersion() async {
  var _data = await get("/com/version");
  print("veriosn=${_data.data}");
  if (_data.state) {
    return Version.fromJson(_data.data);
  }
  return Version(versionCode: "");
}
