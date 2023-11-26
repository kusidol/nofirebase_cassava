// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Survey _$SurveyFromJson(Map<String, dynamic> json) => Survey(
      json['surveyId'] as int,
      json['date'] == null ? 0 : json['date'] as int,
      json['plantingID'] == null ? 0 : json['plantingID'] as int,
      json['besidePlant'] == null ? "" : json['besidePlant'] as String,
      json['weed'] == null ? "" : json['weed'] as String,
      (json['temperature'] == null ? 0 : json['temperature'] as double),
      (json['humidity'] == null ? 0 : json['humidity'] as double),
      json['rainType'] == null ? "" : json['rainType'] as String,
      json['sunlightType'] == null ? "" : json['sunlightType'] as String,
      json['dewType'] == null ? "" : json['dewType'] as String,
      json['soilType'] == null ? "" : json['soilType'] as String,
      json['percentDamageFromHerbicide'] == null
          ? ""
          : json['percentDamageFromHerbicide'] as String,
      json['surveyPatternDisease'] == null
          ? ""
          : json['surveyPatternDisease'] as String,
      json['surveyPatternPest'] == null
          ? ""
          : json['surveyPatternPest'] as String,
      json['surveyPatternNaturalEnemy'] == null
          ? ""
          : json['surveyPatternNaturalEnemy'] as String,
      json['numPointSurvey'] == null ? 0 : json['numPointSurvey'] as int,
      json['numPlantInPoint'] == null ? 0 : json['numPlantInPoint'] as int,
      json['imgOwner'] == null ? 0 : json['imgOwner'] as int,
      json['imgOwnerOther'] == null ? "" : json['imgOwnerOther'] as String,
      json['imgPhotographer'] == null ? 0 : json['imgPhotographer'] as int,
      json['imgPhotographerOther'] == null
          ? ""
          : json['imgPhotographerOther'] as String,
      json['note'] == null ? "" : json['note'] as String,
      json['createBy'] == null ? 0 : json['createBy'] as int,
      json['createDate'] == null ? 0 : json['createDate'] as int,
      json['lastUpdateBy'] == null ? 0 : json['lastUpdateBy'] as int,
      json['lastUpdateDate'] == null ? 0 : json['lastUpdateDate'] as int,
      json['status'] == null ? "" : json['status'] as String,
      json['firstName'] == null ? "" : json['firstName'] as String,
      json['lastName'] == null ? "" : json['firstName'] as String,
    );

Map<String, dynamic> _$SurveyToJson(Survey instance) => <String, dynamic>{
      'surveyId': instance.surveyID,
      'date': instance.date,
      'plantingID': instance.plantingID,
      'besidePlant': instance.besidePlant,
      'weed': instance.weed,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'rainType': instance.rainType,
      'sunlightType': instance.sunlightType,
      'dewType': instance.dewType,
      'soilType': instance.soilType,
      'percentDamageFromHerbicide': instance.percentDamageFromHerbicide,
      'surveyPatternDisease': instance.surveyPatternDisease,
      'surveyPatternPest': instance.surveyPatternPest,
      'surveyPatternNaturalEnemy': instance.surveyPatternNaturalEnemy,
      'numPointSurvey': instance.numPointSurvey,
      'numPlantInPoint': instance.numPlantInPoint,
      'imgOwner': instance.imgOwner,
      'imgOwnerOther': instance.imgOwnerOther,
      'imgPhotographer': instance.imgPhotographer,
      'imgPhotographerOther': instance.imgPhotographerOther,
      'note': instance.note,
      'createBy': instance.createBy,
      'createDate': instance.createDate,
      'lastUpdateBy': instance.lastUpdateBy,
      'lastUpdateDate': instance.lastUpdateDate,
      'status': instance.status,
      'firstName': instance.firstName,
      'lastname': instance.lastName,
    };

// const _$RainTypeEnumMap = {
//   RainType.no_rain: 'ไม่มีฝน',
//   RainType.intermittent_rain: 'ฝนทิ้งช่วง',
//   RainType.drizzle: 'ฝนปรอย',
//   RainType.heavy_rain: 'ฝนตกชุก',
// };

// const _$SunlightTypeEnumMap = {
//   SunlightType.sunny: 'แดดจัด',
//   SunlightType.little_sun: 'แดดน้อยฟ้าครึ้ม',
// };

// const _$DewTypeEnumMap = {
//   DewType.no_dew: 'ไม่มีน้ำค้าง',
//   DewType.little_dew: 'น้ำค้างเล็กน้อย',
//   DewType.strong_dew: 'น้ำค้างแรง',
// };

// const _$SurveyPatternDiseaseEnumMap = {
//   SurveyPatternDisease.count_trees: 'นับจำนวนต้น',
//   SurveyPatternDisease.count_surveys: 'นับจำนวนสิ่งสำรวจ',
//   SurveyPatternDisease.found_or_not_found: 'พบ/ไม่พบ',
//   SurveyPatternDisease.Level_0to5: 'ระดับ 0-5',
// };

const _$PercentDamageFromHerbicide = {
  PercentDamageFromHerbicide.one: '0',
  PercentDamageFromHerbicide.ten: '10',
  PercentDamageFromHerbicide.twenty: '20',
  PercentDamageFromHerbicide.thirty: '30',
  PercentDamageFromHerbicide.forty: '40',
  PercentDamageFromHerbicide.fifty: '50',
  PercentDamageFromHerbicide.sixty: '60',
  PercentDamageFromHerbicide.seventy: '70',
  PercentDamageFromHerbicide.eighty: '80',
  PercentDamageFromHerbicide.ninety: '90',
  PercentDamageFromHerbicide.one_hundred: '100',
};

// const _$SurveyPatternPestEnumMap = {
//   SurveyPatternPest.count_trees: 'นับจำนวนต้น',
//   SurveyPatternPest.count_surveys: 'นับจำนวนสิ่งสำรวจ',
//   SurveyPatternPest.found_or_not_found: 'พบ/ไม่พบ',
//   SurveyPatternPest.Level_0to5: 'ระดับ 0-5',
//   SurveyPatternPest.percent: 'เปอร์เซ็นต์',
// };

// const _$SurveyPatternNaturalEnemyEnumMap = {
//   SurveyPatternNaturalEnemy.count_trees: 'นับจำนวนต้น',
//   SurveyPatternNaturalEnemy.count_surveys: 'นับจำนวนสิ่งสำรวจ',
//   SurveyPatternNaturalEnemy.found_or_not_found: 'พบ/ไม่พบ',
//   SurveyPatternNaturalEnemy.percent: 'เปอร์เซ็นต์',
// };
