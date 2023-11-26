import 'dart:convert';
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/entities/objectlist.dart';
import 'package:mun_bot/entities/stp_value.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/entities/surveypoint.dart';
import 'package:mun_bot/env.dart';
import 'dart:developer';

class SurveyTargetPoint {
  Future<List<SurveyTargetPointValue>> surveyTargetPointDiseaseBySurveyId(
      String token, int surveyId, int pointNumber, int itemNumber) async {
    List<SurveyTargetPointValue> stps = [];
    Service surveyService = new Service();
    var response = await surveyService.doGet(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/surveyId/${surveyId}/disease/${pointNumber}/item/${itemNumber}",
        token);

    if (response.statusCode == 200) {
      stps = ObjectList<SurveyTargetPointValue>.fromJson(
          jsonDecode(response.data),
          (body) => SurveyTargetPointValue.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return stps;
  }

  Future<Map<String, dynamic>?> countDiseaseBySurveyId(
      int surveyId, String token) async {
    Map<String, dynamic>? bodyData;
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/surveyid/${surveyId}/countdisease",
        token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        bodyData = res["body"];
        print(bodyData);
      } catch (e) {
        print("error on service: $e");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return bodyData;
  }

  Future<Map<String, dynamic>?> countNaturalEnemy(
      int surveyId, String token) async {
    Map<String, dynamic>? bodyData;
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/surveyid/${surveyId}/countnaturalenemy",
        token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        bodyData = res["body"];
      } catch (e) {
        print("error on service: $e");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return bodyData;
  }

  Future<Map<String, dynamic>?> countPestPhaseSurvey(
      int surveyId, String token) async {
    Map<String, dynamic>? bodyData;
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/surveyid/${surveyId}/countpestphasesurvey",
        token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        bodyData = res["body"];
      } catch (e) {
        print("error on service: $e");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return bodyData;
  }

  Future<List<SurveyTargetPointValue>> surveyTargetPointNaturalBySurveyId(
      String token, int surveyId, int pointNumber, int itemNumber) async {
    List<SurveyTargetPointValue> stps = [];
    Service surveyService = new Service();
    var response = await surveyService.doGet(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/surveyId/${surveyId}/naturalenemy/${pointNumber}/item/${itemNumber}",
        token);

    if (response.statusCode == 200) {
      stps = ObjectList<SurveyTargetPointValue>.fromJson(
          jsonDecode(response.data),
          (body) => SurveyTargetPointValue.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return stps;
  }

  Future<List<SurveyTargetPointValue>> surveyTargetPointPestphaseBySurveyId(
      String token, int surveyId, int pointNumber, int itemNumber) async {
    List<SurveyTargetPointValue> stps = [];
    Service surveyService = new Service();
    var response = await surveyService.doGet(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/surveyId/${surveyId}/pestphase/${pointNumber}/item/${itemNumber}",
        token);

    if (response.statusCode == 200) {
      stps = ObjectList<SurveyTargetPointValue>.fromJson(
          jsonDecode(response.data),
          (body) => SurveyTargetPointValue.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return stps;
  }

  Future<int> updateSurveyTargetPointDisease(String token, int pointNumber,
      int itemNumber, var surveyTargetPoint) async {
    Service service = new Service();
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/disease/${pointNumber}/item/${itemNumber}",
        token,
        surveyTargetPoint);
    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return response.statusCode;
  }

  Future<int> updateSurveyTargetPointNatural(String token, int pointNumber,
      int itemNumber, var surveyTargetPoint) async {
    Service service = new Service();
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/naturalenemy/${pointNumber}/item/${itemNumber}",
        token,
        surveyTargetPoint);

    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return response.statusCode;
  }

  Future<int> updateSurveyTargetPointPestPhase(String token, int pointNumber,
      int itemNumber, var surveyTargetPoint) async {
    Service service = new Service();
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/pestphase/${pointNumber}/item/${itemNumber}",
        token,
        surveyTargetPoint);

    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return response.statusCode;
  }

  List<Map<String, dynamic>> surveyPointList = [];

  Future<bool> checkSurveyTargetBySurveyId(String token, int surveyId) async {
    Service service = Service();
    bool checkTarget = false;
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/surveyid/${surveyId}/checksurveytarget",
        token.toString());
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.data);
      if (responseBody['status'] == 200) {
        checkTarget = responseBody['body'];
      }
    }
    return checkTarget;
  }

  Future<Map<String, dynamic>>
      findBySurveyIdAndPointNumberAndItemNumberAndApprovedStatus(
          String token, int surveyId, int itemNumber, int pointNumber) async {
    Service service = Service();

    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/surveyid/${surveyId}/pointnumber/${pointNumber}/itemnumber/${itemNumber}",
        token.toString());
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.data);
      if (responseBody['status'] == 200) {
        List<dynamic> surveyPoints = responseBody['body'];
        for (var surveyPoint in surveyPoints) {
          Map<String, dynamic> surveyPointPull = {
            'total': surveyPoint['total'],
            'found': surveyPoint['found'],
            'amountOfImage': surveyPoint['amountOfImage'],
          };

          surveyPointList.add(surveyPointPull);
        }
      }
    }

    return surveyPointList[itemNumber];
  }

  Future<List<SurveyPoint>> surveyPointDiseaseBySurveyId(
      String token, int surveyId, int pointNumber) async {
    List<SurveyPoint> stps = [];
    Service surveyService = new Service();
    var response = await surveyService.doGet(
      "${LOCAL_SERVER_IP_URL}/surveytargetpoint/surveyId/${surveyId}/disease/${pointNumber}",
      token,
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> responseBody = jsonDecode(response.data);

      // Check if the 'body' key exists and is a list
      if (responseBody.containsKey('body') && responseBody['body'] is List) {
        // Extract the list of surveyTargetPoints for each object in 'body'
        final List<dynamic> bodyList = responseBody['body'];

        // Initialize a list to store all surveyTargetPoints
        final List<SurveyPoint> allSurveyTargetPoints = [];

        // Iterate through each object in 'body'
        for (final surveyTarget in bodyList) {
          // Check if 'surveyTargetPoints' is a list in the current object
          if (surveyTarget.containsKey('surveyTargetPoints') &&
              surveyTarget['surveyTargetPoints'] is List) {
            // Extract the list of surveyTargetPoints for the current object
            final List<dynamic> surveyTargetPoints =
                surveyTarget['surveyTargetPoints'];

            // Parse the list of SurveyPoint objects and add them to the result list
            final List<SurveyPoint> surveyTargetPointList = surveyTargetPoints
                .map((point) => SurveyPoint.fromJson(point))
                .toList();

            allSurveyTargetPoints.addAll(surveyTargetPointList);
          }
        }

        // Now, allSurveyTargetPoints contains the combined list of surveyTargetPoints
        stps = allSurveyTargetPoints;
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }

    return stps;
  }

  Future<List<SurveyPoint>> surveyPointNaturalBySurveyId(
      String token, int surveyId, int pointNumber) async {
    List<SurveyPoint> stps = [];
    Service surveyService = new Service();
    var response = await surveyService.doGet(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/surveyId/${surveyId}/naturalenemy/${pointNumber}",
        token);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> responseBody = jsonDecode(response.data);

      // Check if the 'body' key exists and is a list
      if (responseBody.containsKey('body') && responseBody['body'] is List) {
        // Extract the list of surveyTargetPoints for each object in 'body'
        final List<dynamic> bodyList = responseBody['body'];

        // Initialize a list to store all surveyTargetPoints
        final List<SurveyPoint> allSurveyTargetPoints = [];

        // Iterate through each object in 'body'
        for (final surveyTarget in bodyList) {
          // Check if 'surveyTargetPoints' is a list in the current object
          if (surveyTarget.containsKey('surveyTargetPoints') &&
              surveyTarget['surveyTargetPoints'] is List) {
            // Extract the list of surveyTargetPoints for the current object
            final List<dynamic> surveyTargetPoints =
                surveyTarget['surveyTargetPoints'];
            //print(surveyTargetPoints);

            // Parse the list of SurveyPoint objects and add them to the result list
            final List<SurveyPoint> surveyTargetPointList = surveyTargetPoints
                .map((point) => SurveyPoint.fromJson(point))
                .toList();

            allSurveyTargetPoints.addAll(surveyTargetPointList);
          }
        }

        // Now, allSurveyTargetPoints contains the combined list of surveyTargetPoints
        stps = allSurveyTargetPoints;
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }

    return stps;
  }

  Future<List<SurveyPoint>> surveyPointPestphaseBySurveyId(
      String token, int surveyId, int pointNumber) async {
    List<SurveyPoint> stps = [];
    Service surveyService = new Service();
    var response = await surveyService.doGet(
        "${LOCAL_SERVER_IP_URL}/surveytargetpoint/surveyId/${surveyId}/pestphase/${pointNumber}",
        token);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> responseBody = jsonDecode(response.data);

      // Check if the 'body' key exists and is a list
      if (responseBody.containsKey('body') && responseBody['body'] is List) {
        // Extract the list of surveyTargetPoints for each object in 'body'
        final List<dynamic> bodyList = responseBody['body'];

        // Initialize a list to store all surveyTargetPoints
        final List<SurveyPoint> allSurveyTargetPoints = [];

        // Iterate through each object in 'body'
        for (final surveyTarget in bodyList) {
          // Check if 'surveyTargetPoints' is a list in the current object
          if (surveyTarget.containsKey('surveyTargetPoints') &&
              surveyTarget['surveyTargetPoints'] is List) {
            // Extract the list of surveyTargetPoints for the current object
            final List<dynamic> surveyTargetPoints =
                surveyTarget['surveyTargetPoints'];
            // Parse the list of SurveyPoint objects and add them to the result list
            final List<SurveyPoint> surveyTargetPointList = surveyTargetPoints
                .map((point) => SurveyPoint.fromJson(point))
                .toList();

            allSurveyTargetPoints.addAll(surveyTargetPointList);
          }
        }

        // Now, allSurveyTargetPoints contains the combined list of surveyTargetPoints
        stps = allSurveyTargetPoints;
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }

    return stps;
  }
}
