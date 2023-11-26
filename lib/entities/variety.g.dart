// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variety.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Variety _$VarietyFromJson(Map<String, dynamic> json) => Variety(
    json['varietyId'] == null ? 0 : json['varietyId'] as int,
    json['name'] == null ? "" : json['name'] as String,
    json['trichome'] == null ? "" : json['trichome'] as String,
    json['apicalLeavesColor'] == null
        ? ""
        : json['apicalLeavesColor'] as String,
    json['youngLeavesColor'] == null ? "" : json['youngLeavesColor'] as String,
    json['petioleColor'] == null ? "" : json['petioleColor'] as String,
    json['centralLeafletShape'] == null
        ? ""
        : json['centralLeafletShape'] as String,
    json['branchingHabit'] == null ? "" : json['branchingHabit'] as String,
    json['heightToFirstBranching'] == null
        ? ""
        : json['heightToFirstBranching'] as String,
    json['plantHeight'] == null ? "" : json['plantHeight'] as String,
    json['stemColor'] == null ? "" : json['stemColor'] as String,
    json['starchContentRainySeason'] == null
        ? ""
        : json['starchContentRainySeason'] as String,
    json['starchContentDrySeason'] == null
        ? ""
        : json['starchContentDrySeason'] as String,
    (json['rootYield'] == null ? 0 : json['rootYield'] as num).toDouble(),
    json['mainCharacter'] == null ? "" : json['mainCharacter'] as String,
    json['limitationNote'] == null ? "" : json['limitationNote'] as String,
    json['source'] == null ? "" : json['source'] as String);

Map<String, dynamic> _$VarietyToJson(Variety instance) => <String, dynamic>{
      'varietyId': instance.varietyId,
      'name': instance.name,
      'trichome': instance.trichome,
      'apicalLeavesColor': instance.apicalLeavesColor,
      'youngLeavesColor': instance.youngLeavesColor,
      'petioleColor': instance.petioleColor,
      'centralLeafletShape': instance.centralLeafletShape,
      'branchingHabit': instance.branchingHabit,
      'heightToFirstBranching': instance.heightToFirstBranching,
      'plantHeight': instance.plantHeight,
      'stemColor': instance.stemColor,
      'starchContentRainySeason': instance.starchContentRainySeason,
      'starchContentDrySeason': instance.starchContentDrySeason,
      'rootYield': instance.rootYield,
      'mainCharacter': instance.mainCharacter,
      'limitationNote': instance.limitationNote,
      'source': instance.source,
    };
