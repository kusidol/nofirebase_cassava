import 'package:json_annotation/json_annotation.dart';

part 'disease.g.dart';

@JsonSerializable()
class Disease {
  int diseaseId;

  // String symptom;
  // String controlDisease;
  // String controlPest;
  // String source;

  Disease(
    this.diseaseId,

    // this.symptom,
    // this.controlDisease,
    // this.controlPest,
    // this.source
  );
  factory Disease.fromJson(Map<String, dynamic> json) =>
      _$DiseaseFromJson(json);

  Map<String, dynamic> toJson() => _$DiseaseToJson(this);
}
