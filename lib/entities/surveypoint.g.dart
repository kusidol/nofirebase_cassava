// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surveypoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyPoint _$SurveyPointFromJson(Map<String, dynamic> json) => SurveyPoint(
      json['surveyTargetPointId'] as int,
      json['pointNumber'] == null ? 0 : json['pointNumber'] as int,
      json['itemNumber'] == null ? 0 : json['itemNumber'] as int,
      json['value'] == null ? 0 : json['value'] as int,
    );

Map<String, dynamic> _$SurveyPointToJson(SurveyPoint instance) =>
    <String, dynamic>{
      'surveyTargetPointId': instance.surveyTargetPointId,
      'surveyTargetID': instance.pointNumber,
      'pointNumber': instance.itemNumber,
      'amount': instance.value,
    };
