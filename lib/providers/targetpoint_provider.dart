


import 'package:flutter/cupertino.dart';
import 'package:mun_bot/controller/survey_target_point.dart';
import 'package:mun_bot/controller/tagerpoint_image_service.dart';
import 'package:mun_bot/entities/surveypoint.dart';
import 'package:mun_bot/main.dart';


class SurveyPointData{

  List<TargetPoint> targetPoints  = [] ;

  SurveyPointData();

}

class SurveyTargetPoint{
  int surveyTargetPointID ;
  int value ;

  SurveyTargetPoint(this.surveyTargetPointID,this.value);

}

class TargetPoint{

  int pests = 0 ;
  int enemies = 0 ;
  int diseases = 0 ;
  int amountOfImage = 0 ;
  int surveyID ;
  int point ;

  List<bool> points = [ true ] ;
  List<SurveyTargetPoint>? surveyTargetPoints;
  TargetPoint(this.surveyID,this.point);

}

class TargetPointProvider with ChangeNotifier {

  List<List<bool>> spots =
  [
    [true],
    [true],
    [true],
    [true],
  ];

  void deleteSpotAt(int surveyPoint,int spotIndex,int index){

    for(int i = 0 ; i < 5 ; i++){
      if(!isPointComplete(spotIndex*5+i)){
        deletePointAt(surveyPoint,spotIndex,i,0);
      }
    }
  }

  void deletePointAt(int surveyPoint,int spotIndex,int pointIndex,int index){
   // surveyPointData.targetPoints[pointIndex].points[0] = !surveyPointData.targetPoints[pointIndex].points[0];
    String? token = tokenFromLogin?.token;
    TargetPoint tp = surveyPointData.targetPoints[spotIndex*5+pointIndex];
    //print("${spotIndex}  ${pointIndex}");
    ImageTagetpointService imageService = ImageTagetpointService();
    tp.surveyTargetPoints!.forEach((e) async {
      SurveyPoint sp = SurveyPoint(e.surveyTargetPointID,surveyPoint,spotIndex*5+pointIndex,0 );
      await surveyTargetPointService.updateSurveyTargetPoint( e.surveyTargetPointID, sp, token.toString()).then((value) {

        if(value){
          imageService.deleteImageByTargetpointId(e.surveyTargetPointID, token.toString());
        }

      });

    }) ;

    surveyPointData.targetPoints[spotIndex*5+pointIndex].points[0] = !surveyPointData.targetPoints[spotIndex*5+pointIndex].points[0];
    surveyPointData.targetPoints[spotIndex*5+pointIndex] = TargetPoint(tp.surveyID,tp.point) ;

    bool isEmptySpot = true ;

    for(int i = spotIndex*5 ; i < spotIndex*5 + 5 ; i++){

      tp = surveyPointData.targetPoints[i] ;

      if(tp.diseases + tp.enemies + tp.pests > 0){
        isEmptySpot = false ;
        break ;
      }
    }

    spots[spotIndex][0] = isEmptySpot ;
    notifyListeners();
  }

  bool isSpotComplete(int spotIndex){
    return spots[spotIndex][0];
  }
  bool isPointComplete(int pointIndex){
    return surveyPointData.targetPoints[pointIndex].points[0];
  }

  SurveyTargetPointService  surveyTargetPointService = SurveyTargetPointService();

  SurveyPointData surveyPointData  = SurveyPointData();

  int pestSize = 0;
  int enemySize = 0 ;
  int diseaseSize = 0 ;

  bool _disposed = false ;

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> resetDataAt(int pointIndex) async {
    //TargetPoint tp = surveyPointData.targetPoints[pointIndex];
    //surveyPointData.targetPoints[pointIndex] = TargetPoint(tp.surveyID,tp.point) ;

    //for(int i = 0 ; i < 20 ; i++){
    //  print("index ${i} pointIndex- ${pointIndex}    ${surveyPointData.targetPoints[i].surveyTargetPoints}");
   // }


   // notifyListeners();
  }

  Future<void> fetchData(int surveyID,int point) async {

    String? token = tokenFromLogin?.token;

    //SurveyPointData surveyPointData = SurveyPointData();

    for(int i = 0 ; i < 20 ; i++){
      surveyPointData.targetPoints.add(TargetPoint(surveyID,point));
    }

    surveyTargetPointService.surveyPointPestphaseBySurveyId(token.toString(), surveyID, point).then((value) {

      if(value != null){
       // print(value.length);

        pestSize =  value.length;

        for(int i = 0 ; i < pestSize ; i++){

        //  if(surveyPointData.targetPoints[i%20].targetPointID == -1){
          //  surveyPointData.targetPoints[i%20].targetPointID = value[i].surveyTargetPointId ;
        //  }

          if(value[i].value > 0){
            surveyPointData.targetPoints[i%20].pests++;

            if(surveyPointData.targetPoints[i%20].surveyTargetPoints==null){
              surveyPointData.targetPoints[i%20].surveyTargetPoints = [];
            }
            surveyPointData.targetPoints[i%20].surveyTargetPoints!.add(SurveyTargetPoint(value[i].surveyTargetPointId, value[i].value)) ;
            //surveyPointData.targetPoints[i%20].targetPointID = value[i].surveyTargetPointId ;
            if(surveyPointData.targetPoints[i % 20].points[0]){
               surveyPointData.targetPoints[i % 20].points[0] = false ;
               spots[ ((i %20)/ 5).floor() ][0] = false ;
            }
          }
        }
        pestSize = (pestSize / 20).round() ;
        notifyListeners();
      }
    }) ;

    //print("> ${ surveyPointData.targetPoints.length}");
   //print(">- ${ surveyPointData.targetPoints[0].pests}");
    /*for(int i = 0 ; i < surveyPointData.targetPoints.length ; i++){
      print(surveyPointData.targetPoints[i].pests);
    }*/

    surveyTargetPointService.surveyPointDiseaseBySurveyId(token.toString(), surveyID, point).then((value) {
      if(value != null){
        diseaseSize =  value.length;



        for(int i = 0 ; i < diseaseSize ; i++){

        //  if(surveyPointData.targetPoints[i%20].targetPointID == -1){
         //   surveyPointData.targetPoints[i%20].targetPointID = value[i].surveyTargetPointId ;
        //  }

          if(value[i].value > 0) {
            if(surveyPointData.targetPoints[i%20].surveyTargetPoints==null){
              surveyPointData.targetPoints[i%20].surveyTargetPoints = [];
            }
            surveyPointData.targetPoints[i%20].surveyTargetPoints!.add(SurveyTargetPoint(value[i].surveyTargetPointId, value[i].value)) ;
            surveyPointData.targetPoints[i % 20].diseases++;
            if(surveyPointData.targetPoints[i % 20].points[0]){
              surveyPointData.targetPoints[i % 20].points[0] = false ;
              spots[ ((i %20)/ 5).floor()  ][0] = false ;
            }

          }
        }
        diseaseSize = (diseaseSize / 20).round() ;
        notifyListeners();
      }
    }) ;
    surveyTargetPointService.surveyPointNaturalBySurveyId(token.toString(), surveyID, point).then((value) {

      if(value != null){
        enemySize = value.length;

        for(int i = 0 ; i < enemySize ; i++){

          if(value[i].value > 0) {
            if(surveyPointData.targetPoints[i%20].surveyTargetPoints==null){
              surveyPointData.targetPoints[i%20].surveyTargetPoints = [];
            }
            //print("${i}");
            surveyPointData.targetPoints[i%20].surveyTargetPoints!.add(SurveyTargetPoint(value[i].surveyTargetPointId, value[i].value)) ;
            surveyPointData.targetPoints[i % 20].enemies++;
            if(surveyPointData.targetPoints[i % 20].points[0]){
              surveyPointData.targetPoints[i % 20].points[0] = false ;
              spots[ ((i %20)/ 5).floor()  ][0] = false ;
            }
          }

        }
        enemySize = (enemySize / 20).round() ;
        notifyListeners();
      }
    }) ;

    for(int i = 0 ; i < 20 ; i++){

      TargetPoint tp = surveyPointData.targetPoints[i];
      surveyTargetPointService.countImages(token.toString(), tp.surveyID, tp.point, i).then((value) {
        surveyPointData.targetPoints[i].amountOfImage = value ;
      });


    }
 //   print("${surveyPointData.targetPoints.length}   ") ;
  /*  for(int k = 0 ; k < 20; k++){
      TargetPoint tp = surveyPointData.targetPoints[k];
      int total = surveyPointData.targetPoints[k].pests + surveyPointData.targetPoints[k].enemies + surveyPointData.targetPoints[k].diseases ;
      print("${surveyPointData.targetPoints[k].diseases}   ${total}") ;
      surveyPointData.targetPoints[k].points[0] = total > 0 ? false : true ;
    }*/
   // notifyListeners();
  }

}