// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'objectlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectList<T> _$ObjectListFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ObjectList<T>(
      (json['body']==null? [""]:  json['body'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$ObjectListToJson<T>(
  ObjectList<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'body': instance.list.map(toJsonT).toList(),
    };
