import 'dart:io';

import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:dio/dio.dart';

class IDCard {
  String name;
  String number;
  String gender;
  String birthday;
  String race;
  String address;
  String issuedBy;
  String validDate;
  IDCard.fromJSON(Map<String, dynamic> json)
      : name = json["Name"],
        number = json["id_card_number"],
        gender = json["Gender"],
        birthday = json["Birthday"],
        race = json["Race"],
        address = json["Address"],
        issuedBy = json["issued_by"],
        validDate = json["valid_date"];
  Map<String, dynamic> toJson() {
    return {
      'Name': this.name,
      'id_card_number': this.number,
      'Gender': this.gender,
      'Birthday': this.birthday,
      'Race': this.race,
      'Address': this.address,
      'issued_by': this.issuedBy,
      'valid_date': this.validDate
    };
  }
}

Future<Data> recognition(File card1, File card2) async {
  var _data = await post("/com/idcardrecognition",
      data: new FormData.from({
        "card1": new UploadFileInfo(card1, "card1"),
        "card2": new UploadFileInfo(card2, "card2")
      }));
  return _data;
}
