// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_occupation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOccupation _$UserOccupationFromJson(Map<String, dynamic> json) {
  return UserOccupation(
    uuid: json['Uuid'] as String,
    userID: json['UserID'] as String,
    jobType: json['JobType'] as int,
    certificateCode: json['CertificateCode'] as String,
    certificateOrganization: json['CertificateOrganization'] as String,
    workingOrganization: json['WorkingOrganization'] as String,
    city: json['City'] as String,
    address: json['Address'] as String,
    county: json['County'] as String,
    title: json['Title'] as String,
    createAt: json['CreateAt'] as String,
    department: json['Department'] as String,
    introduction: json['Introduction'] as String,
    jobSubject: json['JobSubject'] as String,
    province: json['Province'] as String,
    reviewComments: json['ReviewComments'] as String,
    reviewer: json['Reviewer'] as String,
    reviewTime: json['ReviewTime'] as String,
    seniority: json['Seniority'] as int,
    status: json['Status'] as int,
  );
}

Map<String, dynamic> _$UserOccupationToJson(UserOccupation instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'userID': instance.userID,
      'jobType': instance.jobType,
      'certificateCode': instance.certificateCode,
      'certificateOrganization': instance.certificateOrganization,
      'workingOrganization': instance.workingOrganization,
      'department': instance.department,
      'seniority': instance.seniority,
      'title': instance.title,
      'province': instance.province,
      'city': instance.city,
      'county': instance.county,
      'address': instance.address,
      'introduction': instance.introduction,
      'status': instance.status,
      'createAt': instance.createAt,
      'reviewTime': instance.reviewTime,
      'reviewer': instance.reviewer,
      'reviewComments': instance.reviewComments,
      'jobSubject': instance.jobSubject,
    };
