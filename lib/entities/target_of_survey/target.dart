import 'package:json_annotation/json_annotation.dart';

part 'target.g.dart';

@JsonSerializable()
class Target {
  int targetOfSurveyId;
  String name;

  // String symptom;
  // String controlDisease;
  // String controlPest;
  // String source;

  Target(
    this.targetOfSurveyId,
    this.name
    // this.symptom,
    // this.controlDisease,
    // this.controlPest,
    // this.source
  );
  factory Target.fromJson(Map<String, dynamic> json) =>
      _$TargetFromJson(json);

  Map<String, dynamic> toJson() => _$TargetToJson(this);
}
