// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
Planting _$PlantingFromJson(Map<String, dynamic> json) => Planting(
      json['plantingId'] as int,
      json['code'] == null ? "" : json['code'] as String,
      json['name'] == null ? "" : json['name'] as String,
      (json['size'] == null ? 0 : json['size'] as num).toDouble(),
      //  json['surveyTargetPoints'] = (json['surveyTargetPoints'] as List<dynamic>).map((item) => Variety.fromJson(item)).toList(),
      json['previousPlant'] == null ? "" : json['previousPlant'] as String,
      json['previousPlantOther'] == null
          ? ""
          : json['previousPlantOther'] as String,
      json['besidePlant'] == null ? "" : json['besidePlant'] as String,
      json['besidePlantOther'] == null
          ? ""
          : json['besidePlantOther'] as String,
      json['primaryPlantType'] == null
          ? ""
          : json['primaryPlantType'] as String,
      json['primaryVarietyOther'] == null
          ? ""
          : json['primaryVarietyOther'] as String,
      json['primaryPlantPlantingDate'] == null
          ? 0
          : json['primaryPlantPlantingDate'] as int,
      json['primaryPlantHarvestDate'] == null
          ? 0
          : json['primaryPlantHarvestDate'] as int,
      json['secondaryPlantType'] == null
          ? ""
          : json['secondaryPlantType'] as String,
      json['secondaryPlantVariety'] == null
          ? ""
          : json['secondaryPlantVariety'] as String,
      json['secondaryPlantPlantingDate'] == null
          ? 0
          : json['secondaryPlantPlantingDate'] as int,
      json['secondaryPlantHarvestDate'] == null
          ? 0
          : json['secondaryPlantHarvestDate'] as int,
      json['stemSource'] == null ? "" : json['stemSource'] as String,
      json['soakingStemChemical'] == null
          ? ""
          : json['soakingStemChemical'] as String,
      json['numTillage'] == null ? "" : json['numTillage'] as String,
      json['soilAmendments'] == null ? "" : json['soilAmendments'] as String,
      json['soilAmendmentsOther'] == null
          ? ""
          : json['soilAmendmentsOther'] as String,
      json['fertilizerDate1'] == null ? 0 : json['fertilizerDate1'] as int,
      json['fertilizerFormular1'] == null
          ? ""
          : json['fertilizerFormular1'] as String,
      json['fertilizerDate2'] == null ? 0 : json['fertilizerDate2'] as int,
      json['fertilizerFormular2'] == null
          ? ""
          : json['fertilizerFormular2'] as String,
      json['fertilizerDate3'] == null ? 0 : json['fertilizerDate3'] as int,
      json['fertilizerFormular3'] == null
          ? ""
          : json['fertilizerFormular3'] as String,
      json['diseaseManagement'] == null
          ? ""
          : json['diseaseManagement'] as String,
      json['pestManagement'] == null ? "" : json['pestManagement'] as String,
      json['weedingMonth1'] == null ? 0 : json['weedingMonth1'] as int,
      json['weedingChemical1'] == null ? 0 : json['weedingChemical1'] as int,
      json['weedingChemicalOther1'] == null
          ? ""
          : json['weedingChemicalOther1'] as String,
      json['weedingMonth2'] == null ? 0 : json['weedingMonth2'] as int,
      json['weedingChemical2'] == null ? 0 : json['weedingChemical2'] as int,
      json['weedingChemicalOther2'] == null
          ? ""
          : json['weedingChemicalOther2'] as String,
      json['weedingMonth3'] == null ? 0 : json['weedingMonth3'] as int,
      json['weedingChemical3'] == null ? 0 : json['weedingChemical3'] as int,
      json['weedingChemicalOther3'] == null
          ? ""
          : json['weedingChemicalOther3'] as String,
      json['note'] == null ? "" : json['note'] as String,
      json['createDate'] == null ? 0 : json['createDate'] as int,
      json['lastUpdateBy'] == null ? 0 : json['lastUpdateBy'] as int,
      json['lastUpdateDate'] == null ? 0 : json['lastUpdateDate'] as int,
      json['herbicideByWeedingChemical1'] == null
          ? -1
          : json['herbicideByWeedingChemical1'] as int,
      json['herbicideByWeedingChemical2'] == null
          ? -1
          : json['herbicideByWeedingChemical2'] as int,
      json['herbicideByWeedingChemical3'] == null
          ? -1
          : json['herbicideByWeedingChemical3'] as int,
    );

Map<String, dynamic> _$PlantingToJson(Planting instance) => <String, dynamic>{
      'plantingId': instance.plantingId,
      'code': instance.code,
      'name': instance.name,
      'size': instance.size,
      'previousPlant': instance.previousPlant,
      'previousPlantOther': instance.previousPlantOther,
      'besidePlant': instance.besidePlant,
      'besidePlantOther': instance.besidePlantOther,
      'primaryPlantType': instance.primaryPlantType,
      'primaryVarietyOther': instance.primaryVarietyOther,
      'primaryPlantPlantingDate': instance.primaryPlantPlantingDate,
      'primaryPlantHarvestDate': instance.primaryPlantHarvestDate,
      'secondaryPlantType': instance.secondaryPlantType,
      'secondaryPlantVariety': instance.secondaryPlantVariety,
      'secondaryPlantPlantingDate': instance.secondaryPlantPlantingDate,
      'secondaryPlantHarvestDate': instance.secondaryPlantHarvestDate,
      'stemSource': instance.stemSource,
      'soakingStemChemical': instance.soakingStemChemical,
      'numTillage': instance.numTillage,
      'soilAmendments': instance.soilAmendments,
      'soilAmendmentsOther': instance.soilAmendmentsOther,
      'fertilizerDate1': instance.fertilizerDate1,
      'fertilizerFormular1': instance.fertilizerFormular1,
      'fertilizerDate2': instance.fertilizerDate2,
      'fertilizerFormular2': instance.fertilizerFormular2,
      'fertilizerDate3': instance.fertilizerDate3,
      'fertilizerFormular3': instance.fertilizerFormular3,
      'diseaseManagement': instance.diseaseManagement,
      'pestManagement': instance.pestManagement,
      'weedingMonth1': instance.weedingMonth1,
      'weedingChemical1': instance.weedingChemical1,
      'weedingChemicalOther1': instance.weedingChemicalOther1,
      'weedingMonth2': instance.weedingMonth2,
      'weedingChemical2': instance.weedingChemical2,
      'weedingChemicalOther2': instance.weedingChemicalOther2,
      'weedingMonth3': instance.weedingMonth3,
      'weedingChemical3': instance.weedingChemical3,
      'weedingChemicalOther3': instance.weedingChemicalOther3,
      'note': instance.note,
      'createDate': instance.createDate,
      'lastUpdateBy': instance.lastUpdateBy,
      'lastUpdateDate': instance.lastUpdateDate,
      'herbicideByWeedingChemical1': instance.herbicideByWeedingChemical1,
      'herbicideByWeedingChemical2': instance.herbicideByWeedingChemical2,
      'herbicideByWeedingChemical3': instance.herbicideByWeedingChemical3,
    };

// const _$PreviousPlantEnumMap = {
//   PreviousPlant.cassava: 'มันสำปะหลัง',
//   PreviousPlant.pineapple: 'สับปะรด',
//   PreviousPlant.sugar_cane: 'อ้อย',
//   PreviousPlant.other: 'อื่นๆ',
//   PreviousPlant.noData: ""
// };

// const _$BesidePlantEnumMap = {
//   BesidePlant.cassava: 'มันสำปะหลัง',
//   BesidePlant.rubber: 'ยางพารา',
//   BesidePlant.pineapple: 'สับปะรด',
//   BesidePlant.sugar_cane: 'อ้อย',
//   BesidePlant.other: 'อื่นๆ',
//   BesidePlant.noData: ""
// };

// const _$StemSourceEnumMap = {
//   StemSource.buy: 'ซื้อ',
//   StemSource.keepYourOwnSaplings: 'เก็บท่อนพันธุ์เอง',
//   StemSource.noData: ""
// };

// const _$SoakingStemChemicalEnumMap = {
//   SoakingStemChemical.thiamitosam: 'ไทอะมีโทแซม',
//   SoakingStemChemical.imidaCloprid: 'อิมิดราคลอพริด',
//   SoakingStemChemical.malathion: 'มาลาไทออน',
//   SoakingStemChemical.notSoaked: 'ไม่แช่',
//   SoakingStemChemical.noData: ""
// };

// const _$NumTillageEnumMap = {
//   NumTillage.one: '1',
//   NumTillage.two: '2',
//   NumTillage.three: '3',
//   NumTillage.four: '4',
//   NumTillage.noData: ""
// };

// const _$SoilAmendmentsEnumMap = {
//   SoilAmendments.cassavaPulp: 'กากมันสำปะหลัง',
//   SoilAmendments.chickenDroppings: 'มูลไก่แกลบ',
//   SoilAmendments.lime: 'ปูนขาว',
//   SoilAmendments.other: 'อื่นๆ',
//   SoilAmendments.noData: ""
// };

// const _$DiseaseManagementEnumMap = {
//   DiseaseManagement.useChemicals: 'ใช้สารเคมี',
//   DiseaseManagement.biologicalMethod: 'ชีววิธี',
//   DiseaseManagement.mechanicalMethod: 'วิธีกล',
//   DiseaseManagement.dontDeal: 'ไม่จัดการ',
//   DiseaseManagement.noDate: ""
// };

// const _$PestManagementEnumMap = {
//   PestManagement.useChemicals: 'ใช้สารเคมี',
//   PestManagement.biologicalMethod: 'ชีววิธี',
//   PestManagement.mechanicalMethod: 'วิธีกล',
//   PestManagement.dontDeal: 'ไม่จัดการ',
//   PestManagement.noDate: ""
// };
