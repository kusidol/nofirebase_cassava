


import 'package:flutter/cupertino.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/main.dart';

class SurveyPointProvider with ChangeNotifier {

  bool isLoading = false;
  List<bool> pointStatus = [false, false, false, false, false];
  List<List<bool>> selectedStatus =
  [
    [true,  false],
    [true,  false],
    [true,  false],
    [true,  false],
    [true,  false],
  ];

  final List<String> _statusList = ["Editing","Complete"];

  Future<bool> updateSelectedStatus(int surveyID,int point,int status) async {
    try {
      String? token = tokenFromLogin?.token;
      SurveyService surveyPoint = SurveyService();
      final code = await surveyPoint.postSurveyPointStatus(
          surveyID, point, _statusList[status], token);

      if (code == 200) {
        // The update was successful, handle the response if necessary
        return true;
      }
    } catch (e) {


    }
    return false ;
  }

  void setSelectedStatus(int i,int j,bool status){

    selectedStatus[i][j] = status;
    pointStatus[i] = !pointStatus[i];
    notifyListeners();
  }

  bool getStatusPoint(int i){
    return pointStatus[i];
  }

  Future<void> fetchData(int surveyID) async {

    var surveyService = SurveyService();
    String? token = tokenFromLogin?.token;
    List<Map<String, dynamic>> surveyPoints =  await surveyService.getSurveyPoint(token!, surveyID);
    //surveyPointList = surveyPointListAdd;

    surveyPoints.forEach((item) {

        //print("${item['pointNo']}          ${item['status']}") ;
        int i = item['pointNo'] ;
        pointStatus[i] =
        item['status'] == "Complete" ? true : false;
        int k = pointStatus[i] == true ? 1 : 0 ;
        //_selectedStatus[item['pointNo']][i] = true ;

        for (int j = 0; j < selectedStatus[i].length; j++) {
          selectedStatus[i][j] = j  == k;

        }

      });

    isLoading = true;
    notifyListeners();
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

}