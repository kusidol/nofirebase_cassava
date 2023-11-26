import 'package:json_annotation/json_annotation.dart';

part 'surveytarget.g.dart';

enum Tpe { byPoint, overall }

@JsonSerializable()
class SurveyTarget {
  int surveyTargetID;
  int surveyID;
  int targetOfSurveyID;
  Tpe tpe;
  int levelDamage;
  int percentDamage;
  // int countDiseaseBySurveyId;
  // int countPestPhaseSurveyBySurveyId;
  // int countNaturalEnemyBySurveyId;
  SurveyTarget(
    this.surveyTargetID,
    this.surveyID,
    this.targetOfSurveyID,
    this.tpe,
    this.levelDamage,
    this.percentDamage,
    // this.countDiseaseBySurveyId,
    // this.countPestPhaseSurveyBySurveyId,
    // this.countNaturalEnemyBySurveyId,
  );
  factory SurveyTarget.fromJson(Map<String, dynamic> json) =>
      _$SurveyTargetFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyTargetToJson(this);
}
