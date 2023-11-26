import 'package:json_annotation/json_annotation.dart';

part 'variety.g.dart';

@JsonSerializable()
class Variety {
  int varietyId;
  String name;
  String trichome;
  String apicalLeavesColor;
  String youngLeavesColor;
  String petioleColor;
  String centralLeafletShape;
  String branchingHabit;
  String heightToFirstBranching;
  String plantHeight;
  String stemColor;
  String starchContentRainySeason;
  String starchContentDrySeason;
  double rootYield;
  String mainCharacter;
  String limitationNote;
  String source;

  Variety(
      this.varietyId,
      this.name,
      this.trichome,
      this.apicalLeavesColor,
      this.youngLeavesColor,
      this.petioleColor,
      this.centralLeafletShape,
      this.branchingHabit,
      this.heightToFirstBranching,
      this.plantHeight,
      this.stemColor,
      this.starchContentRainySeason,
      this.starchContentDrySeason,
      this.rootYield,
      this.mainCharacter,
      this.limitationNote,
      this.source);
  factory Variety.fromJson(Map<String, dynamic> json) =>
      _$VarietyFromJson(json);

  Map<String, dynamic> toJson() => _$VarietyToJson(this);
}
