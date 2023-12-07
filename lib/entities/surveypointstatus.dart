import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'surveypointstatus.g.dart';

class SurveyPointStatus {
  final int surveyPointId;
  final int pointNo;
  final String status;

  SurveyPointStatus(
    this.surveyPointId,
    this.pointNo,
    this.status,
  );
  factory SurveyPointStatus.fromJson(Map<String, dynamic> json) =>
      _$SurveyPointStatusFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyPointStatusToJson(this);
}
