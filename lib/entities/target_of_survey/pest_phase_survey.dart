import 'package:json_annotation/json_annotation.dart';

part 'pest_phase_survey.g.dart';

@JsonSerializable()
class PestPhaseSurvey {
  int pestPhaseSurveyId;
  String pestName;

  PestPhaseSurvey(
    this.pestPhaseSurveyId,
    this.pestName,

  
  );
  factory PestPhaseSurvey.fromJson(Map<String, dynamic> json) =>
      _$PestPhaseSurveyFromJson(json);

  Map<String, dynamic> toJson() => _$PestPhaseSurveyToJson(this);
}
