import 'package:json_annotation/json_annotation.dart';

part 'plantingCassavaVarieties.g.dart';

@JsonSerializable()
class PlantingCassavaVarieties {
  int plantingId;
  int varietyId;

  PlantingCassavaVarieties(
    this.plantingId,
    this.varietyId,
  );
  factory PlantingCassavaVarieties.fromJson(Map<String, dynamic> json) =>
      _$PlantingCassavaVarietiesFromJson(json);

  Map<String, dynamic> toJson() => _$PlantingCassavaVarietiesToJson(this);
}
