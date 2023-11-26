import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'surveypointstatus.g.dart';

class SurveyPointStatus {
  final int surveyId;
  final int pointNumber;
  final String status;

  SurveyPointStatus(
    this.surveyId,
    this.pointNumber,
    this.status,
  );
  factory SurveyPointStatus.fromJson(Map<String, dynamic> json) =>
      _$SurveyPointStatusFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyPointStatusToJson(this);
}
