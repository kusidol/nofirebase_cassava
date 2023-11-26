import 'package:json_annotation/json_annotation.dart';

part 'natural_enermy.g.dart';

@JsonSerializable()
class NaturalEnermy {
  int naturalEnemyId;

  // String scientificName;
  // String type;
  // String controlMethod;
  // String releaseRate;
  // String source;

  NaturalEnermy(
    this.naturalEnemyId,

    // this.scientificName,
    // this.type,
    // this.controlMethod,
    // this.releaseRate,
    // this.source
  );
  factory NaturalEnermy.fromJson(Map<String, dynamic> json) =>
      _$NaturalEnermyFromJson(json);

  Map<String, dynamic> toJson() => _$NaturalEnermyToJson(this);
}
