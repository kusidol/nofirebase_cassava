import 'package:json_annotation/json_annotation.dart';

part 'field.g.dart';

enum Status { use, cancel }

@JsonSerializable()
class Field {
  int fieldID;
  int organization;
  String code;
  String name;
  String address;
  String road;
  String moo;
  String imgPath;
  int subdistrictID;
  String landmark;
  double latitude;
  double longtitude;
  double metresAboveSeaLv;
  double size;
  String status;
  int createBy;
  int createDate;
  int lastUpdateBy;
  int lastUpdateDate;
  bool editable;

  Field(
      this.fieldID,
      this.organization,
      this.code,
      this.name,
      this.address,
      this.road,
      this.moo,
      this.imgPath,
      this.subdistrictID,
      this.landmark,
      this.latitude,
      this.longtitude,
      this.metresAboveSeaLv,
      this.size,
      this.status,
      this.createBy,
      this.createDate,
      this.lastUpdateBy,
      this.lastUpdateDate,
      this.editable);
  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  Map<String, dynamic> toJson() => _$FieldToJson(this);
}
