part of 'pest_phase_survey.dart';

PestPhaseSurvey _$PestPhaseSurveyFromJson(Map<String, dynamic> json) => PestPhaseSurvey(
       json['pestPhaseSurveyId'] as int,
      json['pestName'] == "" ? "" : json['pestName'] as String,
 
    );

Map<String, dynamic> _$PestPhaseSurveyToJson(PestPhaseSurvey instance) =>
    <String, dynamic>{
      'pestPhaseSurveyId': instance.pestPhaseSurveyId,
      'pestName': instance.pestName,
  


    };
