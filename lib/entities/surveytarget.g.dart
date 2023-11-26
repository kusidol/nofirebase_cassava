// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surveytarget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyTarget _$SurveyTargetFromJson(Map<String, dynamic> json) => SurveyTarget(
      json['surveyTargetID'] as int,
      json['surveyID'] == null ? 0 : json['surveyID'] as int,
      json['targetOfSurveyID'] == null ? 0 : json['targetOfSurveyID'] as int,
      $enumDecode(_$TpeEnumMap, json['tpe']),
      json['levelDamage'] == null ? 0 : json['levelDamage'] as int,
      json['percentDamage'] == null ? 0 : json['percentDamage'] as int,
      // json['countDiseaseBySurveyId'] == null
      //     ? 0
      //     : json['countDiseaseBySurveyId'] as int,
      // json['countPestPhaseSurveyBySurveyId'] == null
      //     ? 0
      //     : json['countPestPhaseSurveyBySurveyId'] as int,
      // json['countNaturalEnemyBySurveyId'] == null
      //     ? 0
      //     : json['countNaturalEnemyBySurveyId'] as int,
    );

Map<String, dynamic> _$SurveyTargetToJson(SurveyTarget instance) =>
    <String, dynamic>{
      'surveyTargetID': instance.surveyTargetID,
      'surveyID': instance.surveyID,
      'targetOfSurveyID': instance.targetOfSurveyID,
      'tpe': _$TpeEnumMap[instance.tpe]!,
      'levelDamage': instance.levelDamage,
      'percentDamage': instance.percentDamage,
      // 'countDiseaseBySurveyId': instance.countDiseaseBySurveyId,
      // 'countPestPhaseSurveyBySurveyId': instance.countPestPhaseSurveyBySurveyId,
      // 'countNaturalEnemyBySurveyId': instance.countNaturalEnemyBySurveyId,
    };

const _$TpeEnumMap = {
  Tpe.byPoint: 'byPoint',
  Tpe.overall: 'overall',
};
