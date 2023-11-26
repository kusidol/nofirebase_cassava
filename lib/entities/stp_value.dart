import 'package:json_annotation/json_annotation.dart';
import 'package:mun_bot/entities/surveypoint.dart';

part 'stp_value.g.dart';

@JsonSerializable()
class SurveyTargetPointValue {
  int surveyTargetId;
  String surveyTargetName;
  SurveyPoint surveyTargetPoints;


  SurveyTargetPointValue(
    this.surveyTargetId,
    this.surveyTargetName,
    this.surveyTargetPoints,

  );
  factory SurveyTargetPointValue.fromJson(Map<String, dynamic> json) =>
      _$SurveyTargetPointValueFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyTargetPointValueToJson(this);
}
