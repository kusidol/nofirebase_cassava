// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stp_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyTargetPointValue _$SurveyTargetPointValueFromJson(
        Map<String, dynamic> json) =>
    SurveyTargetPointValue(
      json['surveyTargetId'] as int,
      json['surveyTargetName'] == "" ? "" : json['surveyTargetName'] as String,
      json['surveyTargetPoint'] =
          SurveyPoint.fromJson(json['surveyTargetPoints']),
    );

Map<String, dynamic> _$SurveyTargetPointValueToJson(
        SurveyTargetPointValue instance) =>
    <String, dynamic>{
      'surveyTargetId': instance.surveyTargetId,
      'surveyTargetName': instance.surveyTargetName,
      'surveyTargetPoint': instance.surveyTargetPoint,
    };
