// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surveypointstatus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
SurveyPointStatus _$SurveyPointStatusFromJson(Map<String, dynamic> json) =>
    SurveyPointStatus(
      json['surveyPointId'] as int,
      json['pointNo'] == null ? 0 : json['pointNo'] as int,
      json['status'] == "" ? "" : json['status'] as String,
    );

Map<String, dynamic> _$SurveyPointStatusToJson(SurveyPointStatus instance) =>
    <String, dynamic>{
      'surveyPointId': instance.surveyPointId,
      'pointNo': instance.pointNo,
      'status': instance.status,
    };
