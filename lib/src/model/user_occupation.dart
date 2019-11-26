import 'package:apcc_wallet/src/common/define.dart';
import 'package:apcc_wallet/src/common/http.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_occupation.g.dart';
@JsonSerializable(nullable: false)
class UserOccupation {
  String uuid;
  String userID;
  int jobType;
  String certificateCode;
  String certificateOrganization;
  String workingOrganization;
  String department;
  int seniority;
  String title;
  String province;
  String city;
  String county;
  String address;
  String introduction;
  int status;
  String createAt;
  String reviewTime;
  String reviewer;
  String reviewComments;
  String jobSubject;
  UserOccupation({this.uuid,this.userID,this.jobType,this.certificateCode,this.certificateOrganization,this.workingOrganization,this.city,this.address,this.county,this.title,this.createAt,this.department,this.introduction,this.jobSubject,this.province,this.reviewComments,this.reviewer,this.reviewTime,this.seniority,this.status});
  factory UserOccupation.fromJson(Map<String, dynamic> json) => _$UserOccupationFromJson(json);

Map<String,dynamic> toJson() => _$UserOccupationToJson(this);
}


  Future<Data> applyOccupation(UserOccupation occupation ) async {
    return await post("/user/occupation/apply",data:occupation.toJson());
  }