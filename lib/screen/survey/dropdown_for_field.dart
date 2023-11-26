import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
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
import 'package:provider/provider.dart';
import 'package:mun_bot/providers/field_dropdown_provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
// import 'package:fluttertoast/fluttertoast.dart';

//import 'package:month_year_picker/month_year_picker.dart';

import 'package:intl/intl.dart';

import 'package:mun_bot/env.dart';
import '../../entities/field.dart';
import '../../entities/planting.dart';
import '../../entities/survey.dart';
import '../../entities/targetofsurvey.dart';
import '../../entities/userinfield.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import '../../main.dart';

class DropdownForField extends StatefulWidget {
  // final void Function(String) myVoidCallback;
  final Function myVoidCallback;
  const DropdownForField(this.myVoidCallback, {Key? key}) : super(key: key);

  @override
  State<DropdownForField> createState() => _DropdownForFieldState();
}

class _DropdownForFieldState extends State<DropdownForField> {
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
  String selectedOwnerName = "เจ้าของแปลง";
  String selectedFieldName = "ชื่อแปลง";
  String selectedfieldSubdistrict = "ตำบล";
  String selectedAddress = "ที่อยู่แปลง";
  String selectedplantingItems = "ชื่อการเพาะปลูก";
  String selectedplantingCode = "รหัสการเพาะปลูก";
  String selectedplantingDate = "ปีที่เพาะปลูก";
  String selectedsurveyDate = "วันที่สำรวจ";
  bool checkField = false;
  bool checkPlanting = true;
  bool checkSubdistrict = true;
  bool checkSurvey = true;
  bool checkUser = false;

  // for search
  String addressValue = '';
  String fieldNameValue = '';
  String ownerNameValue = '';

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

  //date
  TextEditingController dateinputPlanting = TextEditingController();
  TextEditingController dateinputSurvey = TextEditingController();

  ScrollController? _scrollController;

  _scrollListener() {}
  int length = Random().nextInt(10);
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
    dateinputPlanting.text = "";
    dateinputSurvey.text = "";
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

  _onloadField() async {
    print("onload Fields");
  }

  //
  TextEditingController codeNameController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController cultivationController = TextEditingController();
  late DateTime startDate;
  late DateTime endDate;

  void _handleSearchButton(Dropdownfield dropdownfield) async {
    //call Service
    FieldService fieldService = new FieldService();
    String? token = tokenFromLogin?.token;

    List<Field> data = await fieldService.searchFieldByKey(
        addressValue, fieldNameValue, ownerNameValue, token.toString());
    dropdownfield.updateItemsWithSearch(data);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return Dropdownfield();
          },
        )
      ],
      child: Consumer<Dropdownfield>(
        builder: (context, dropdownfield, index) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'select-field'.i18n(),
              ),
              backgroundColor: theme_color2,
            ),
            body: Container(
              decoration: dropdownfield.isScroll
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
                      onExpansionChanged: (bool isExpanded) {
                        if (!isExpanded) {
                          print('Hello World');
                          // dropdownfield.resetItemsAfterSearch();
                        } else {
                          print('Save Value');
                        }
                      },
                      leading: Icon(Icons.perm_contact_calendar_outlined),
                      subtitle: Text(selectedAddress +
                          " " +
                          selectedFieldName +
                          " " +
                          selectedOwnerName),
                      children: [
                        Container(
                          color: Colors.tealAccent[50],
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              TextFormField(
                                // controller: codeNameController,
                                decoration: InputDecoration(
                                  labelText: 'ที่อยู่แปลง',
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
                                  labelText: 'ชื่อแปลง',
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
                                // controller: locationController,
                                decoration: InputDecoration(
                                  labelText: 'เจ้าของแปลง',
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
                              _handleSearchButton(dropdownfield);
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
                          print('เลื่อนสุดขอบหน้าจอแล้ว');
                          if (dropdownfield.scroll) {
                            dropdownfield.fetchData();
                            dropdownfield.isScroll = true;
                          }
                          if (dropdownfield.isAllItem) {
                            showToastMessage(
                                "ข้อมูลแสดงครบทั้งหมดเป็นที่เรียบร้อยแล้ว");
                          }
                        }
                        return true;
                      },
                      child: dropdownfield.dropdownSearch
                          ? ListView.builder(
                              itemCount: dropdownfield.fieldString.length,
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
                                        "ชื่อแปลง : ${dropdownfield.fieldString[index]}"),
                                    // subtitle:
                                    // Text('ID : ${dropdownfield.items[index].id}'),
                                    onTap: () {
                                      Map<String, dynamic> data = {
                                        'nameField':
                                            dropdownfield.fieldString[index],
                                        'id': dropdownfield.items[index].id,
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
    print(s);
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
        //print(subdistrict.name);
        if (subdistrict.name == value) {
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
