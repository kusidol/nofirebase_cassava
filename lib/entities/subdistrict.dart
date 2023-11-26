import 'package:json_annotation/json_annotation.dart';

part 'subdistrict.g.dart';

@JsonSerializable()
class Subdistrict {
  int subdistrictId;
  String name;
  int districtID;

  Subdistrict(
    this.subdistrictId,
    this.name,
    this.districtID,
  );
  factory Subdistrict.fromJson(Map<String, dynamic> json) =>
      _$SubdistrictFromJson(json);

  Map<String, dynamic> toJson() => _$SubdistrictToJson(this);
}
