import 'package:json_annotation/json_annotation.dart';

part 'survey.g.dart';

List<String> percentDamage = [
  "0",
  "10",
  "20",
  "30",
  "40",
  "50",
  "60",
  "70",
  "80",
  "90",
  "100"
];

// enum RainType { no_rain, intermittent_rain, drizzle, heavy_rain }
List<String> RainType = ["ไม่มีฝน", "ฝนทิ้งช่วง", "ฝนปรอย", "ฝนตกชุก"];

// enum SunlightType { sunny, little_sun }
List<String> SunlightType = ["แดดจัด", "แดดน้อยฟ้าครึ้ม"];

// enum DewType { no_dew, little_dew, strong_dew }
List<String> DewType = ["ไม่มีน้ำค้าง", "น้ำค้างเล็กน้อย", "น้ำค้างแรง"];

enum PercentDamageFromHerbicide {
  one,
  ten,
  twenty,
  thirty,
  forty,
  fifty,
  sixty,
  seventy,
  eighty,
  ninety,
  one_hundred
}

// enum SurveyPatternDisease {
//   count_trees,
//   count_surveys,
//   found_or_not_found,
//   Level_0to5
// }
List<String> SurveyPatternDisease = [
  "นับจำนวนต้น",
  "นับจำนวนสิ่งสำรวจ",
  "พบ/ไม่พบ",
  "ระดับ 0-5"
];

// enum SurveyPatternPest {
//   count_trees,
//   count_surveys,
//   found_or_not_found,
//   Level_0to5,
//   percent
// }
List<String> SurveyPatternPest = [
  "นับจำนวนต้น",
  "นับจำนวนสิ่งสำรวจ",
  "พบ/ไม่พบ",
  "ระดับ 0-5",
  "เปอร์เซ็นต์"
];

// enum SurveyPatternNaturalEnemy {
//   count_trees,
//   count_surveys,
//   found_or_not_found,
//   percent
// }
List<String> SurveyPatternNaturalEnemy = [
  "นับจำนวนต้น",
  "นับจำนวนสิ่งสำรวจ",
  "พบ/ไม่พบ",
  "เปอร์เซ็นต์"
];

@JsonSerializable()
class Survey {
  int surveyID;
  int date;
  int plantingID;
  String besidePlant;
  String weed;

  double temperature;
  double humidity;
  String rainType;
  String sunlightType;
  String dewType;
  String soilType;
  String percentDamageFromHerbicide;
  String surveyPatternDisease;
  String surveyPatternPest;
  String surveyPatternNaturalEnemy;
  int numPointSurvey;
  int numPlantInPoint;
  int imgOwner;
  String imgOwnerOther;
  int imgPhotographer;
  String imgPhotographerOther;
  String note;
  int createBy;
  int createDate;
  int lastUpdateBy;
  int lastUpdateDate;
  String status;
  String firstName;
  String lastName;

  Survey(
    this.surveyID,
    this.date,
    this.plantingID,
    this.besidePlant,
    this.weed,
    this.temperature,
    this.humidity,
    this.rainType,
    this.sunlightType,
    this.dewType,
    this.soilType,
    this.percentDamageFromHerbicide,
    this.surveyPatternDisease,
    this.surveyPatternPest,
    this.surveyPatternNaturalEnemy,
    this.numPointSurvey,
    this.numPlantInPoint,
    this.imgOwner,
    this.imgOwnerOther,
    this.imgPhotographer,
    this.imgPhotographerOther,
    this.note,
    this.createBy,
    this.createDate,
    this.lastUpdateBy,
    this.lastUpdateDate,
    this.status,
    this.firstName,
    this.lastName,
  );
  factory Survey.fromJson(Map<String, dynamic> json) => _$SurveyFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyToJson(this);
}
