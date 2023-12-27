import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/subdistrict_service.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/subdistrict.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/entities/targetofsurvey.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/entities/userinfield.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/widget/no_data.dart';
import 'package:mun_bot/util/const.dart';
import 'package:provider/provider.dart';
import 'package:mun_bot/providers/planting_dropdown_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

//import 'package:month_year_picker/month_year_picker.dart';

import 'package:intl/intl.dart';

import 'package:mun_bot/env.dart';
import '../../entities/field.dart';
import '../../entities/planting.dart';
import '../../entities/survey.dart';
import '../../entities/targetofsurvey.dart';
import '../../entities/userinfield.dart';

import '../../main.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class DropdownForPlanting extends StatefulWidget {
  // final void Function(String) myVoidCallback;
  final Function myVoidCallback;
  const DropdownForPlanting(this.myVoidCallback, {Key? key}) : super(key: key);

  @override
  State<DropdownForPlanting> createState() => _DropdownForPlantingState();
}

class _DropdownForPlantingState extends State<DropdownForPlanting> {
  late List<Field> _fields = [];
  late List<Planting> _plants = [];
  late List<Survey> _survey = [];
  late List<User> _user = [];
  late List<Subdistrict> _subdistrict = [];
  final List<String> plantingItems = [];
  final List<String> plantingCode = [];
  final List<String> plantingDate = [];
  final List<String> fieldItems = [];
  final List<String> fieldCode = [];
  final List<String> surveyItems = [
    'แปลงที่ 1',
    'แปลงที่ 2',
    'แปลงที่ 3',
  ];
  final List<String> surveyDateItems = [];
  final List<String> farmerItems = [];
  final List<String> subdistrictItems = [];

  String? selectedValue;
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();
  late Field field;
  late Planting planting;
  late Survey survey;
  late TargetOfSurvey targetOfsurvey;
  late UserInField typeOwner;
  String selectedPlantingName = "ชื่อการเพาะปลูก";
  String selectedfieldName = "name-field-label".i18n();
  String selectedAddress = "ที่อยู่การเพาะปลูก";
  String selectedOwnerName = "เจ้าของการเพาะปลูก";
  String selectedplantingItems = "ชื่อการเพาะปลูก";
  String selectedplantingCode = "รหัสการเพาะปลูก";
  String selectedplantingDate = "ปีที่เพาะปลูก";
  String selectedsurveyDate = "วันที่สำรวจ";
  bool checkField = false;
  bool checkPlanting = true;
  bool checkSubdistrict = true;
  bool checkSurvey = true;
  bool checkUser = false;

  @override
  void dispose() {
    textEditingController.dispose();
    // Clean up the controller when the widget is disposed.
    codeNameController.dispose();
    ownerController.dispose();
    locationController.dispose();
    cultivationController.dispose();
    super.dispose();
  }

  //final bool _pinned = true;
  //final bool _snap = false;
  //final bool _floating = true;

  //date
  TextEditingController dateinputPlanting = TextEditingController();
  TextEditingController dateinputSurvey = TextEditingController();
  //text editing controller for text field
  ScrollController? _scrollController;

  _scrollListener() {}
  int length = Random().nextInt(10);
  bool isLoading = true;

  // for search
  String addressValue = '';
  String fieldNameValue = '';
  String ownerNameValue = '';
  String plantingNameValue = '';

  var _startDateUserNameColor = Colors.black;
  var _startDateTimeText = " Start Date";
  TextEditingController startDateController = TextEditingController();

  var _endDateUserNameColor = Colors.black;
  var _endDateTimeText = " Start Date";
  TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
    dateinputPlanting.text = "";
    dateinputSurvey.text = ""; //set the initial value of text field
    super.initState();
    asyncFunction();
  }

  asyncFunction() async {
    await _onloadField();
    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  void _startDateTFToggle(e) {
    setState(() {
      //_rqVisible = !_rqVisible;
      _startDateTimeText = "Start Date";
      _startDateUserNameColor = Colors.black;
    });
  }

  void _endDateTFToggle(e) {
    setState(() {
      //_rqVisible = !_rqVisible;
      _endDateTimeText = "End Date";
      _endDateUserNameColor = Colors.black;
    });
  }

  _onloadField() async {
    //print("onload Fields");
  }

  _callUserBySubdistrict(int value) async {
    //print("onload Fields");
    UserService userService = new UserService();
    String? token = tokenFromLogin?.token;
    _user = await userService.getUserBySubdistrict(value, token.toString());
  }

  _callFieldsByUserID(int value) async {
    //print("onload Fields");
    FieldService fieldService = new FieldService();
    String? token = tokenFromLogin?.token;
    _fields = await fieldService.getFieldsByUserID(value, token.toString());
  }

  _callPlantingInField(int value) async {
    //print("onload Fields");
    PlantingService plantingService = new PlantingService();
    String? token = tokenFromLogin?.token;
    _plants = await plantingService.getPlantingInfield(value, token.toString());
  }

  bool isVisible = true;

  _onEndScroller(ScrollMetrics metrics) {
    Future.delayed(const Duration(milliseconds: 10), () {
      if (mounted) {
        setState(() {
          isVisible = true;
        });
      }
    });
  }

  _onElseScroller(ScrollMetrics metrics) {
    setState(() {
      //if(isVisible)
      isVisible = false;
    });
  }

  //
  TextEditingController codeNameController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController cultivationController = TextEditingController();
  // late DateTime startDate = DateTime.now();
  // late DateTime endDate = DateTime.now();
  int startDate = 0;
  int endDate = 0;

  void _handleSearchButton(Dropdownplanting dropdownplanting) async {
    Map<String, dynamic> jsonData = {
      "address": addressValue,
      "endDate": endDate,
      "fieldName": fieldNameValue,
      "ownerName": ownerNameValue,
      "plantingName": plantingNameValue,
      "startDate": startDate
    };

    String jsonString = jsonEncode(jsonData);
    //print(jsonString);

    PlantingService plantingService = new PlantingService();
    String? token = tokenFromLogin?.token;

    List<Planting> data = await plantingService.searchPlantingByKey(
        addressValue,
        endDate,
        fieldNameValue,
        ownerNameValue,
        plantingNameValue,
        startDate,
        token.toString());
    dropdownplanting.updateItemsWithSearch(data);
  }

  @override
  Widget build(BuildContext context) {
    TextField _startDateTextField = TextField(
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());

        // date = (await showDatePicker(
        //     context: context,
        //     initialDate: DateTime.now(),
        //     firstDate: DateTime(1900),
        //     lastDate: DateTime(2100)))!;
        DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100));
        if (newDate == null) return;
        setState(() {
          date = newDate;
        });
        startDateController.text = date.toIso8601String();

        startDate = date.millisecondsSinceEpoch;
        startDateController.text = DateFormat("dd-MM-yyyy").format(newDate);
      },
      controller: startDateController,
      onChanged: (e) => _startDateTFToggle(e),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: Colors.deepPurple, fontFamily: 'OpenSans', fontSize: 16),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: 14.0),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: _startDateUserNameColor,
        ),
        hintText: 'Pick Start Date',
        hintStyle: kHintTextStyle,
      ),
    );

    TextField _endDateTextField = TextField(
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());

        // date = (await showDatePicker(
        //     context: context,
        //     initialDate: DateTime.now(),
        //     firstDate: DateTime(1900),
        //     lastDate: DateTime(2100)))!;
        DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100));
        if (newDate == null) return;
        setState(() {
          date = newDate;
        });
        endDateController.text = date.toIso8601String();

        endDate = date.millisecondsSinceEpoch;
        endDateController.text = DateFormat("dd-MM-yyyy").format(newDate);
      },
      controller: endDateController,
      onChanged: (e) => _startDateTFToggle(e),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: Colors.deepPurple, fontFamily: 'OpenSans', fontSize: 16),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: 14.0),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: _startDateUserNameColor,
        ),
        hintText: 'Pick End Date',
        hintStyle: kHintTextStyle,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return Dropdownplanting();
          },
        )
      ],
      child: Consumer<Dropdownplanting>(
        builder: (context, dropdownplanting, index) {
          return Scaffold(
            appBar: AppBar(
              title: Text('เลือกเพาะปลูก'),
              backgroundColor: theme_color2,
            ),
            body: Container(
              decoration: dropdownplanting.isScroll
                  ? BoxDecoration()
                  : BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/newScroll.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
              child: Column(
                children: [
                  ExpansionTile(
                      textColor: Colors.black,
                      iconColor: theme_color2,
                      title: Text('ค้นหาเพิ่มเติม',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      leading: Icon(Icons.perm_contact_calendar_outlined),
                      subtitle: Text(selectedAddress +
                          " " +
                          selectedfieldName +
                          " " +
                          selectedOwnerName +
                          " " +
                          selectedPlantingName),
                      children: [
                        Container(
                          color: Colors.tealAccent[50],
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: codeNameController,
                                decoration: InputDecoration(
                                  labelText: 'ที่อยู่การเพาะปลูก',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    addressValue = value;
                                  });
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: ownerController,
                                decoration: InputDecoration(
                                  labelText: 'name-field-label'.i18n(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    fieldNameValue = value;
                                  });
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: locationController,
                                decoration: InputDecoration(
                                  labelText: 'เจ้าของการเพาะปลูก',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    ownerNameValue = value;
                                  });
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: cultivationController,
                                decoration: InputDecoration(
                                  labelText: 'ชื่อการเพาะปลูก',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    plantingNameValue = value;
                                  });
                                },
                              ),
                              SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "วันที่เริ่มต้น",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans',
                                              fontSize: 15),
                                        ),
                                        SizedBox(height: 20.0),
                                        Container(
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: kBoxDecorationStyle,
                                            height: 60.0,
                                            child: _startDateTextField,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "วันที่สิ้นสุด",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans',
                                              fontSize: 15),
                                        ),
                                        SizedBox(height: 20.0),
                                        Container(
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: kBoxDecorationStyle,
                                            height: 60.0,
                                            child: _endDateTextField,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Text('วันที่เริ่ม'),
                              // RaisedButton(
                              //   child: Text('เลือกวันที่'),
                              //   onPressed: () {
                              //     showDatePicker(
                              //       context: context,
                              //       initialDate: DateTime.now(),
                              //       firstDate: DateTime(2000),
                              //       lastDate: DateTime(2025),
                              //     ).then((selectedDate) {
                              //       setState(() {
                              //         startDate = selectedDate!;
                              //       });
                              //     });
                              //   },
                              // ),
                              // SizedBox(height: 16.0),
                              // Text('ถึงวันสุดท้าย'),
                              // RaisedButton(
                              //   child: Text('เลือกวันที่'),
                              //   onPressed: () {
                              //     showDatePicker(
                              //       context: context,
                              //       initialDate: DateTime.now(),
                              //       firstDate: DateTime(2000),
                              //       lastDate: DateTime(2025),
                              //     ).then((selectedDate) {
                              //       setState(() {
                              //         endDate = selectedDate!;
                              //       });
                              //     });
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2, left: 20, right: 20, bottom: 20),
                          height: 50.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              //side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))
                            ),
                            onPressed: () {
                              _handleSearchButton(dropdownplanting);
                            },
                            padding: EdgeInsets.all(10.0),
                            color: theme_color2,
                            textColor: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "ค้นหา",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(width: 5.0),
                                Icon(Icons.search),
                              ],
                            ),
                          ),
                        )
                      ]),
                  Expanded(
                    child: NotificationListener<ScrollEndNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          //print('เลื่อนสุดขอบหน้าจอแล้ว');
                          if (dropdownplanting.scroll) {
                            dropdownplanting.fetchData();
                            dropdownplanting.isScroll = true;
                          }
                          if (dropdownplanting.isAllItem) {
                            showToastMessage(
                                "ข้อมูลแสดงครบทั้งหมดเป็นที่เรียบร้อยแล้ว");
                          }
                        }
                        return true;
                      },
                      child: dropdownplanting.dropdownSearch
                          ? ListView.builder(
                              itemCount: dropdownplanting.plantingString.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Text(
                                        dropdownplanting.plantingString[index]),
                                    // subtitle: Text(
                                    // 'ID : ${dropdownplanting.items[index].id}'),
                                    onTap: () {
                                      Map<String, dynamic> data = {
                                        'nameField': dropdownplanting
                                            .plantingString[index],
                                        'id': dropdownplanting.items[index].id,
                                      };
                                      widget.myVoidCallback(data);

                                      Navigator.pop(context, false);
                                    },
                                  ),
                                );
                              },
                            )
                          : NoData().showNoData(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showToastMessage(String msg) {
    FlutterToastr.show(msg, context,
        duration: 3,
        position: FlutterToastr.bottom,
        backgroundColor: theme_color,
        textStyle: TextStyle(fontSize: 15, color: Colors.black));
  }

  bool isItemDisabled(String s) {
    //return s.startsWith('I');

    if (s.startsWith('I')) {
      return true;
    } else {
      return false;
    }
  }

  void itemSelectionChanged(String? s) {
    //print(s);
  }

  void getAll() {
    plantingItems.clear();
    plantingCode.clear();
    plantingDate.clear();
    fieldItems.clear();
    fieldCode.clear();
    subdistrictItems.clear();
    surveyDateItems.clear();
    farmerItems.clear();
    int count = 0;
    if (checkPlanting)
      for (Planting plant in _plants) {
        plantingItems.add(plant.name);
        plantingCode.add(plant.code);
        String date = DateFormat("dd-MM-yyyy")
            .format(new DateTime.fromMillisecondsSinceEpoch(plant.createDate));
        plantingDate.add(date);
      }
    if (checkField)
      for (Field field in _fields) {
        fieldItems.add(field.name);
        fieldCode.add(field.code);
      }
    if (checkSubdistrict)
      for (Subdistrict subdistrict in _subdistrict) {
        subdistrictItems.add(subdistrict.name);
      }
    if (checkSurvey)
      for (Survey survey in _survey) {
        count = count + 1;
        String date = DateFormat("dd-MM-yyyy").format(
            new DateTime.fromMillisecondsSinceEpoch(survey.createDate as int));
        surveyDateItems.add(date + " ครั้งที่ " + count.toString());
      }
    if (checkUser)
      for (User user in _user) {
        farmerItems.add(user.firstName + user.lastName);
      }
  }

  int getID(String value, String Option) {
    if (Option == "Sub") {
      for (Subdistrict subdistrict in _subdistrict) {
        ////print(subdistrict.name);
        if (subdistrict.name == value) {
          ////print(subdistrict.subdistrictId);
          return subdistrict.subdistrictId;
        }
      }
    } else if (Option == "User") {
      for (User user in _user) {
        if (user.firstName + user.lastName == value) {
          return user.userID;
        }
      }
    } else if (Option == "Field") {
      for (Field field in _fields) {
        if (field.name == value) {
          ////print(field.name);
          return field.fieldID;
        }
      }
    } else if (Option == "Planting") {
      for (Planting planting in _plants) {
        if (planting.name == value) {
          return planting.plantingId;
        }
      }
    }
    return 0;
  }

  String getFieldCode(String value) {
    for (Field field in _fields) {
      if (field.code == value) {
        return field.name;
      }
    }
    return "";
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
