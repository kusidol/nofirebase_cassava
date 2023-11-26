// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subdistrict.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subdistrict _$SubdistrictFromJson(Map<String, dynamic> json) => Subdistrict(
      json['subdistrictId'] as int,
      json['name'] == null ? "" : json['name'] as String,
      json['districtID'] == null ? 0 : json['districtID'] as int,
    );

Map<String, dynamic> _$SubdistrictToJson(Subdistrict instance) =>
    <String, dynamic>{
      'subdistrictId': instance.subdistrictId,
      'name': instance.name,
      'districtID': instance.districtID,
    };
