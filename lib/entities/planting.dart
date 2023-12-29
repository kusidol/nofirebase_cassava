import 'dart:core';

import 'package:json_annotation/json_annotation.dart';
import 'package:mun_bot/entities/plantingCassavaVarieties.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/entities/variety.dart';

part 'planting.g.dart';

// enum PreviousPlant { cassava, pineapple, sugar_cane, other, noData }
List<String> previousPlantName = ["มันสำปะหลัง", "สับปะรด", "อ้อย", "อื่นๆ"];

// enum BesidePlant { cassava, rubber, pineapple, sugar_cane, other, noData }
List<String> besidePlantName = [
  "มันสำปะหลัง",
  "ยางพารา",
  "สับปะรด",
  "อ้อย",
  "อื่นๆ"
];

// enum StemSource { buy, keepYourOwnSaplings, noData }
List<String> stemSourceName = ["ซื้อ", "เก็บท่อนพันธุ์เอง"];

List<String> soakingStemChemicalName = [
  "ไทอะมีโทแซม",
  "อิมิดราคลอพริด",
  "มาลาไทออน",
  "ไม่แช่"
];

// enum NumTillage { one, two, three, four, noData }
List<String> numTillageName = ["1", "2", "3", "4", ""];

// enum SoilAmendments { cassavaPulp, chickenDroppings, lime, other, noData }
List<String> soilAmendmentsName = [
  "กากมันสำปะหลัง",
  "มูลไก่แกลบ",
  "ปูนขาว",
  "อื่นๆ"
];

List<String> diseaseManagement = [
  "ใช้สารเคมี",
  "ชีววิธี",
  "วิธีกล",
  "ไม่จัดการ"
];

List<String> pestManagementName = [
  "ใช้สารเคมี",
  "ชีววิธี",
  "วิธีกล",
  "ไม่จัดการ"
];

List<String> weedingMonthName = [
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "11",
  "12"
];
List<String> weedingChemicalName = [
  "อะเซโทคลอร์",
  "อะลาคลอร์",
  "ฟลูมืออกชาซิน",
  "เฮสเมโทลาคลอร์",
  "ไคลโฟเสท",
  "กลูโฟซิเนตแอมโมเนิยม",
  "ไตยูรอน",
  "ใช้แรงงาน",
  "อื่นๆ",
];

@JsonSerializable()
class Planting {
  int plantingId;
  String code;
  String name;
  double size;
  // List<Variety> varietys;

  String previousPlant; //enum
  String previousPlantOther;
  String besidePlant; //enum
  String besidePlantOther;
  String primaryPlantType;
  String primaryVarietyOther;
  int primaryPlantPlantingDate; //date
  int primaryPlantHarvestDate; //date
  String secondaryPlantType;
  String secondaryPlantVariety;
  int secondaryPlantPlantingDate;
  int secondaryPlantHarvestDate;
  String stemSource; //enum
  String soakingStemChemical; //enum
  String numTillage; //enum
  String soilAmendments; //enum
  String soilAmendmentsOther;
  int fertilizerDate1;
  String fertilizerFormular1;
  int fertilizerDate2;
  String fertilizerFormular2;
  int fertilizerDate3;
  String fertilizerFormular3;
  String diseaseManagement; //enum
  String pestManagement; //enum
  int weedingMonth1;
  int weedingChemical1;
  String weedingChemicalOther1;
  int weedingMonth2;
  int weedingChemical2;
  String weedingChemicalOther2;
  int weedingMonth3;
  int weedingChemical3;
  String weedingChemicalOther3;
  String note;
  int createDate;
  int lastUpdateBy;
  int lastUpdateDate;
  int herbicideByWeedingChemical1;
  int herbicideByWeedingChemical2;
  int herbicideByWeedingChemical3;

  Planting(
    this.plantingId,
    this.code,
    this.name,
    this.size,
    // this.varietys,
    this.previousPlant,
    this.previousPlantOther,
    this.besidePlant,
    this.besidePlantOther,
    this.primaryPlantType,
    this.primaryVarietyOther,
    this.primaryPlantPlantingDate,
    this.primaryPlantHarvestDate,
    this.secondaryPlantType,
    this.secondaryPlantVariety,
    this.secondaryPlantPlantingDate,
    this.secondaryPlantHarvestDate,
    this.stemSource,
    this.soakingStemChemical,
    this.numTillage,
    this.soilAmendments,
    this.soilAmendmentsOther,
    this.fertilizerDate1,
    this.fertilizerFormular1,
    this.fertilizerDate2,
    this.fertilizerFormular2,
    this.fertilizerDate3,
    this.fertilizerFormular3,
    this.diseaseManagement,
    this.pestManagement,
    this.weedingMonth1,
    this.weedingChemical1,
    this.weedingChemicalOther1,
    this.weedingMonth2,
    this.weedingChemical2,
    this.weedingChemicalOther2,
    this.weedingMonth3,
    this.weedingChemical3,
    this.weedingChemicalOther3,
    this.note,
    this.createDate,
    this.lastUpdateBy,
    this.lastUpdateDate,
    this.herbicideByWeedingChemical1,
    this.herbicideByWeedingChemical2,
    this.herbicideByWeedingChemical3,
  );
  factory Planting.fromJson(Map<String, dynamic> json) =>
      _$PlantingFromJson(json);

  Map<String, dynamic> toJson() => _$PlantingToJson(this);
}
