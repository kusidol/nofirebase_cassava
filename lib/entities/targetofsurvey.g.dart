// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'targetofsurvey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetOfSurvey _$TargetOfSurveyFromJson(Map<String, dynamic> json) =>
    TargetOfSurvey(
      json['targetOfSurveyID'] as int,
      json['name'] == null ? "" : json['name'] as String,
    );

Map<String, dynamic> _$TargetOfSurveyToJson(TargetOfSurvey instance) =>
    <String, dynamic>{
      'targetOfSurveyID': instance.targetOfSurveyID,
      'name': instance.name,
    };
