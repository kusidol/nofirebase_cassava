// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************



Disease _$DiseaseFromJson(Map<String, dynamic> json) => Disease(
      json['diseaseId'] as int,
    
      // json['symptom'] == null ? "" : json['symptom'] as String,
      // json['controlDisease'] == null ? "" : json['controlDisease'] as String,
      // json['controlPest'] == null ? "" : json['controlPest'] as String,
      // json['source'] == null ? "" : json['source'] as String,
    );

Map<String, dynamic> _$DiseaseToJson(Disease instance) =>
    <String, dynamic>{
      'diseaseId': instance.diseaseId,

      // 'symptom': instance.symptom,
      // 'controlDisease': instance.controlDisease,
      // 'controlPest': instance.controlPest,
      // 'source': instance.source,

    };
