import 'package:json_annotation/json_annotation.dart';

part 'targetofsurvey.g.dart';

@JsonSerializable()
class TargetOfSurvey {
  int targetOfSurveyID;
  String name;

  TargetOfSurvey(
    this.targetOfSurveyID,
    this.name,
  );
  factory TargetOfSurvey.fromJson(Map<String, dynamic> json) =>
      _$TargetOfSurveyFromJson(json);

  Map<String, dynamic> toJson() => _$TargetOfSurveyToJson(this);
}
