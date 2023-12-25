



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mun_bot/controller/survey_target_point.dart';
import 'package:mun_bot/entities/stp_value.dart';
import 'package:mun_bot/main.dart';

class SurverTargetpoint{

  SurveyTargetPointValue stp;

  int index ;

  bool isUpdate ;

  SurverTargetpoint(this.stp,this.index,this.isUpdate);
}

class UpdatedSurveyTarget{

  int surveyTargetId;
  int value ;

  UpdatedSurveyTarget(this.surveyTargetId,this.value);

  UpdatedSurveyTarget.fromJson(Map<String, dynamic> json)
      : surveyTargetId = json['surveyTargetId'] as int,
       // targetOfSurveyName = json['targetOfSurveyName'] as String,
        value = json['value'] as int;

  Map<String, dynamic> toJson() => {
    'surveyTargetId': surveyTargetId,
   // 'targetOfSurveyName': targetOfSurveyName,
    'value' : value
  };

}

class SurveyTargetPointProvider with ChangeNotifier {

  SurveyTargetPointService surveyTargetPoint = SurveyTargetPointService();



  List<SurverTargetpoint> diseases = [] ;

  List<SurverTargetpoint> naturalEmemy = [] ;

  List<SurverTargetpoint> pest = [] ;

  Future<void> fetchData(int surveyID,int point,int item) async {

    String? token = tokenFromLogin?.token;
    surveyTargetPoint.surveyTargetPointDiseaseBySurveyId(
        token.toString(), surveyID,  point, item).then((value) {

          for(int i = 0 ; i < value.length ; i++){
            diseases.add(SurverTargetpoint(value[i],i,false));
            //print("${value[i].surveyTargetName} ${value[i].surveyTargetId} ${value[i].surveyTargetPoint.value}") ;
          }
    });

    surveyTargetPoint.surveyTargetPointNaturalBySurveyId(
        token.toString(), surveyID,  point, item).then((value) {

      for(int i = 0 ; i < value.length ; i++){
        naturalEmemy.add(SurverTargetpoint(value[i],i,false));
        notifyListeners();
        //print("${value[i].surveyTargetName} ${value[i].surveyTargetId} ${value[i].surveyTargetPoint.value}") ;
      }
    });

    surveyTargetPoint.surveyTargetPointPestphaseBySurveyId(
        token.toString(), surveyID,  point, item).then((value) {

      for(int i = 0 ; i < value.length ; i++){
        pest.add(SurverTargetpoint(value[i],i,false));
        notifyListeners();
        //print("${value[i].surveyTargetName} ${value[i].surveyTargetId} ${value[i].surveyTargetPoint.value}") ;
      }
    });


  }

  Future<bool> upDatesurveyTargetPoints(int point,int number,) async {
    String? token = tokenFromLogin?.token;
    List surveyTargetPoints = [] ;



    for(int i = 0 ; i < diseases.length ; i++){
      if(diseases[i].isUpdate){
        surveyTargetPoints.add(UpdatedSurveyTarget(diseases[i].stp.surveyTargetId,diseases[i].stp.surveyTargetPoint.value));
      }
    }
    for(int i = 0 ; i < naturalEmemy.length ; i++){
      if(naturalEmemy[i].isUpdate){
        surveyTargetPoints.add(UpdatedSurveyTarget(naturalEmemy[i].stp.surveyTargetId,naturalEmemy[i].stp.surveyTargetPoint.value));
      }
    }
    for(int i = 0 ; i < pest.length ; i++){
      if(pest[i].isUpdate){
        surveyTargetPoints.add(UpdatedSurveyTarget(pest[i].stp.surveyTargetId,pest[i].stp.surveyTargetPoint.value));
      }
    }



    bool isCompleted = await surveyTargetPoint.updateSurveyTargetPointDisease(
        token.toString(), point, number, jsonEncode(surveyTargetPoints));

    return isCompleted ;

  }

  void upDateDisease(int i,int value){
    diseases[i].stp.surveyTargetPoint.value = value;
    diseases[i].isUpdate = true ;
    notifyListeners();
  }

  void upDatesurveyTargetPointAt(int i,int value,bool isPest){

    if(isPest){
      pest[i].stp.surveyTargetPoint.value = value;
      pest[i].isUpdate = true ;
    }else{
      naturalEmemy[i].stp.surveyTargetPoint.value = value;
      naturalEmemy[i].isUpdate = true ;
    }


    notifyListeners();
  }

}