// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surveypointstatus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
SurveyPointStatus _$SurveyPointStatusFromJson(Map<String, dynamic> json) =>
    SurveyPointStatus(
      json['surveyId'] as int,
      json['pointNumber'] == null ? 0 : json['pointNumber'] as int,
      json['status'] == "" ? "" : json['status'] as String,
    );

Map<String, dynamic> _$SurveyPointStatusToJson(SurveyPointStatus instance) =>
    <String, dynamic>{
      'surveyId': instance.surveyId,
      'pointNumber': instance.pointNumber,
      'status': instance.status,
    };
