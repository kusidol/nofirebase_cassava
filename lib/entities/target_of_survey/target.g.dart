part of 'target.dart';

Target _$TargetFromJson(Map<String, dynamic> json) => Target(
       json['targetOfSurveyId'] as int,
      json['name'] == null ? "" : json['name'] as String,
    );

Map<String, dynamic> _$TargetToJson(Target instance) =>
    <String, dynamic>{
      'targetOfSurveyId': instance.targetOfSurveyId,
      'name': instance.name,

    };
