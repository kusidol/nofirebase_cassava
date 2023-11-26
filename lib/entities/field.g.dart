// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Field _$FieldFromJson(Map<String, dynamic> json) => Field(
      json['fieldId'] as int,
      json['organization'] == null ? 0 : json['organization'] as int,
      json['code'] == null ? "" : json['code'] as String,
      json['name'] == null ? "" : json['name'] as String,
      json['address'] == null ? "" : json['address'] as String,
      json['road'] == null ? "" : json['road'] as String,
      json['moo'] == null ? "" : json['moo'] as String,
      json['imgPath'] == null ? "" : json['imgPath'] as String,
      json['subdistrictID'] == null ? 0 : json['subdistrictID'] as int,
      json['landmark'] == null ? "" : json['landmark'] as String,
      (json['latitude'] == null ? 0 : json['latitude'] as num).toDouble(),
      (json['longitude'] == null ? 0 : json['longitude'] as num).toDouble(),
      (json['metresAboveSeaLv'] == null ? 0 : json['metresAboveSeaLv'] as num)
          .toDouble(),
      (json['size'] == null ? 0 : json['size'] as num).toDouble(),
      // $enumDecode(_$StatusEnumMap, json['status']),
      json['status'] == null ? "" : json['status'] as String,
      json['createBy'] == null ? 0 : json['createBy'] as int,
      json['createDate'] == null ? 0 : json['createDate'] as int,
      json['lastUpdateBy'] == null ? 0 : json['lastUpdateBy'] as int,
      json['lastUpdateDate'] == null ? 0 : json['lastUpdateDate'] as int,
      json['editable'] == null ? false : json['editable'] as bool,
    );

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
      'fieldId': instance.fieldID,
      'organization': instance.organization,
      'code': instance.code,
      'name': instance.name,
      'address': instance.address,
      'road': instance.road,
      'moo': instance.moo,
      'imgPath': instance.imgPath,
      'subdistrictID': instance.subdistrictID,
      'landmark': instance.landmark,
      'latitude': instance.latitude,
      'longitude': instance.longtitude,
      'metresAboveSeaLv': instance.metresAboveSeaLv,
      'size': instance.size,
      // 'status': _$StatusEnumMap[instance.status]!,
      'status': instance.status,
      'createBy': instance.createBy,
      'createDate': instance.createDate,
      'lastUpdateBy': instance.lastUpdateBy,
      'lastUpdateDate': instance.lastUpdateDate,
      'editable': instance.editable
    };

const _$StatusEnumMap = {
  Status.use: 'ใช้งาน',
  Status.cancel: 'ยกเลิก',
};
