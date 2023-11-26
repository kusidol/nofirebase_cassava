import 'package:json_annotation/json_annotation.dart';

part 'surveypoint.g.dart';

@JsonSerializable()
class SurveyPoint {
  int surveyTargetPointId;
  int pointNumber;
  int itemNumber;
  int value;
 

  SurveyPoint(
    this.surveyTargetPointId,
    this.pointNumber,
    this.itemNumber,
    this.value,
  );
  factory SurveyPoint.fromJson(Map<String, dynamic> json) =>
      _$SurveyPointFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyPointToJson(this);
}
