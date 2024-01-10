import 'dart:convert';
import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/farmer_service.dart';
import 'package:mun_bot/controller/staff_service.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/screen/widget/no_data.dart';
import 'package:mun_bot/util/change_date_time.dart';
import 'package:mun_bot/util/size_config.dart';

class UpdateSurveyorScreen extends StatefulWidget {
  final int fieldId;
  const UpdateSurveyorScreen(this.fieldId, {Key? key}) : super(key: key);

  @override
  State<UpdateSurveyorScreen> createState() => _UpdateSurveyorScreenState();
}

class StaffSurvey {
  int id;
  String firstName;
  String lastName;
  bool status;
  bool owner;

  StaffSurvey(this.id, this.firstName, this.lastName, this.status, this.owner);
}

class _UpdateSurveyorScreenState extends State<UpdateSurveyorScreen> {
  // SET UP FOR PAGE
  String? token = tokenFromLogin?.token;
  bool updateStatus = true;
  String selectedFirstName = "first-name".i18n();
  String selectedLastName = "last-name".i18n();

  // Staff Data
  bool isLoadingStaff = false;
  bool isLoadMoreStaff = false;
  final scrollControllerStaff = ScrollController();
  int pageStaff = 1;
  int valueStaff = 10;
  List<StaffSurvey> staffs = [];
  List<StaffSurvey> fetchData_staffs = [];
  String firstNameValue_Staff = '';
  String lastNameValue_Staff = '';
  TextEditingController firstnameStaffController = TextEditingController();
  TextEditingController lastnameStaffController = TextEditingController();
  List<StaffSurvey> saveStaffsWhenSearch = [];
  bool isSearchStaff = false;
  bool searchStaffEmpty = false;

  // Farmer Data
  bool isLoadingFarmer = false;
  bool isLoadMoreFarmer = false;
  final scrollControllerFarmer = ScrollController();
  int pageFarmer = 1;
  int valueFarmer = 10;
  List<StaffSurvey> farmers = [];
  List<StaffSurvey> fetchData_farmers = [];
  String firstNameValue_Farmer = '';
  String lastNameValue_Farmer = '';
  TextEditingController firstnameFarmerController = TextEditingController();
  TextEditingController lastnameFarmerController = TextEditingController();
  List<StaffSurvey> saveFarmersWhenSearch = [];
  bool isSearchFarmer = false;
  bool searchFarmerEmpty = false;

  void initState() {
    super.initState();
    // SET UP SCROLL
    scrollControllerStaff.addListener(_scrollListenerStaff);
    scrollControllerFarmer.addListener(_scrollListenerFarmer);
    fetchMoreStaff();
    setState(() {
      isLoadingStaff = true;
    });
    fetchMoreFarmer();
    setState(() {
      isLoadingFarmer = true;
    });
  }

  Future<void> fetchMoreStaff() async {
    StaffService staffService = new StaffService();
    List<Map<String, dynamic>> data = await staffService.getAllStaffByFieldId(
        token.toString(), widget.fieldId, pageStaff, valueStaff);
    List<StaffSurvey> moreData = [];
    for (int i = 0; i < data.length; i++) {
      int id = int.parse((data[i]["staffId"]).toString());
      int status_int = int.parse((data[i]["status"]).toString());
      bool status = status_int == 0 ? false : true;
      String firstName = data[i]["firstName"].toString();
      String lastName = data[i]["lastName"].toString();
      bool owner = data[i]["Respon"];
      moreData.add(new StaffSurvey(id, firstName, lastName, status, owner));
    }
    moreData.forEach((e) {
      fetchData_staffs.add(e);
    });
    setState(() {
      if (staffs.length % valueStaff != 0) {
        int x = staffs.length % valueStaff;
        for (int i = 0; i < x; i++) {
          staffs.removeLast();
        }
        staffs = [...staffs, ...fetchData_staffs];
      } else {
        staffs = [...staffs, ...fetchData_staffs];
      }
      pageStaff = (staffs.length ~/ valueStaff) + 1;
      fetchData_staffs.clear();
    });
  }

  Future<void> fetchMoreFarmer() async {
    FarmerService farmerService = new FarmerService();
    List<Map<String, dynamic>> data = await farmerService.getAllFarmerByFieldId(
        token.toString(), widget.fieldId, pageFarmer, valueFarmer);
    List<StaffSurvey> moreData = [];
    for (int i = 0; i < data.length; i++) {
      int id = int.parse((data[i]["farmerId"]).toString());
      int status_int = int.parse((data[i]["status"]).toString());
      bool status = status_int == 0 ? false : true;
      String firstName = data[i]["firstName"].toString();
      String lastName = data[i]["lastName"].toString();
      bool owner = data[i]["Respon"];
      moreData.add(new StaffSurvey(id, firstName, lastName, status, owner));
    }
    moreData.forEach((e) {
      fetchData_farmers.add(e);
    });
    setState(() {
      if (farmers.length % valueFarmer != 0) {
        int x = farmers.length % valueFarmer;
        for (int i = 0; i < x; i++) {
          farmers.removeLast();
        }
        farmers = [...farmers, ...fetchData_farmers];
      } else {
        farmers = [...farmers, ...fetchData_farmers];
      }
      pageFarmer = (farmers.length ~/ valueFarmer) + 1;
      fetchData_farmers.clear();
    });
  }

  Future<void> _scrollListenerFarmer() async {
    if (scrollControllerFarmer.position.pixels ==
            scrollControllerFarmer.position.maxScrollExtent &&
        !isSearchFarmer) {
      setState(() {
        isLoadMoreFarmer = true;
      });
      await fetchMoreFarmer();
      setState(() {
        isLoadMoreFarmer = false;
      });
    }
  }

  Future<void> _scrollListenerStaff() async {
    if (scrollControllerStaff.position.pixels ==
            scrollControllerStaff.position.maxScrollExtent &&
        !isSearchStaff) {
      setState(() {
        isLoadMoreStaff = true;
      });
      await fetchMoreStaff();
      setState(() {
        isLoadMoreStaff = false;
      });
    }
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: sizeWidth(8, context),
            right: sizeWidth(8, context)),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + sizeHeight(40, context),
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(sizeWidth(32, context)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(sizeWidth(8, context)),
                    child: Icon(
                      Icons.arrow_back,
                      size: sizeHeight(25, context),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'update-userSurvey-field-label'.i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeHeight(18, context),
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 0,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeHeight(32, context)),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(sizeWidth(8, context)),
                        // child: Icon(Icons.map),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeHeight(32, context)),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(sizeWidth(8, context)),
                        // child: Icon(FontAwesomeIcons.per,color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> removeFarmer(int farmerId) async {
    try {
      FarmerService farmerService = FarmerService();
      int response = await farmerService.removeFarmer(
          token.toString(), farmerId, widget.fieldId);
      if (response == 200) {
        setState(() {
          updateStatus = true;
        });
        //print('Resource updated successfully.');
      } else {
        setState(() {
          updateStatus = false;
        });
        //print('Resource updated not successfully.');
      }
    } catch (e) {
      //print('Error during update: $e');
    }
  }

  Future<void> removeSurveyor(int staffId) async {
    try {
      StaffService staffService = StaffService();
      int response = await staffService.removeStaff(
          token.toString(), staffId, widget.fieldId);
      if (response == 200) {
        setState(() {
          updateStatus = true;
        });
        //print('Resource updated successfully.');
      } else {
        setState(() {
          updateStatus = false;
        });
        //print('Resource updated not successfully.');
      }
    } catch (e) {
      //print('Error during update: $e');
    }
  }

  Future<void> addFarmer(int farmerId) async {
    try {
      FarmerService farmerService = FarmerService();
      int response = await farmerService.addFarmer(
          token.toString(), farmerId, widget.fieldId);
      if (response == 200) {
        setState(() {
          updateStatus = true;
        });
        //print('Resource updated successfully.');
      } else {
        setState(() {
          updateStatus = false;
        });
        //print('Resource updated not successfully.');
      }
    } catch (e) {
      //print('Error during update: $e');
    }
  }

  Future<void> addSurveyor(int staffId) async {
    try {
      StaffService staffService = StaffService();
      int response = await staffService.addStaff(
          token.toString(), staffId, widget.fieldId);
      if (response == 200) {
        setState(() {
          updateStatus = true;
        });
        //print('Resource updated successfully.');
      } else {
        setState(() {
          updateStatus = false;
        });
        //print('Resource updated not successfully.');
      }
    } catch (e) {
      //print('Error during update: $e');
    }
  }

  List<Widget> getListFarmer() {
    List<Widget> completeBoxes = [];
    for (int i = 0; i < farmers.length; i++) {
      completeBoxes.add(
        SizedBox(
          width: SizeConfig.screenWidth,
          height: sizeHeight(70, context),
          child: Card(
            child: Row(
              children: [
                SizedBox(
                  width: sizeWidth(8, context),
                ),
                Icon(
                  Icons.person,
                  size: sizeHeight(25, context),
                ),
                SizedBox(
                  width: sizeWidth(8, context),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${farmers[i].firstName}",
                      style: TextStyle(fontSize: sizeHeight(16, context)),
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Text("${farmers[i].lastName}",
                        style: TextStyle(fontSize: sizeHeight(16, context))),
                  ],
                ),
                Spacer(),
                !farmers[i].owner
                    ? AnimatedToggleSwitch<bool>.dual(
                        current: farmers[i].status,
                        first: false,
                        second: true,
                        dif: sizeWidth(80, context),
                        borderColor: Colors.transparent,
                        borderWidth: sizeWidth(7, context),
                        height: sizeHeight(55, context),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 0),
                          ),
                        ],
                        onChanged: (value) {
                          setState(
                            () {
                              if (value) {
                                // add surveyor
                                addFarmer(farmers[i].id).then((value) => {
                                      if (updateStatus)
                                        {
                                          // move the button
                                          farmers[i].status = !farmers[i].status
                                        }
                                    });
                              } else {
                                // remove surveyor
                                removeFarmer(farmers[i].id).then((value) => {
                                      if (updateStatus)
                                        {
                                          // move the button
                                          farmers[i].status = !farmers[i].status
                                        }
                                    });
                              }
                            },
                          );
                        },
                        colorBuilder: (value) =>
                            value == false ? Colors.red : Colors.green,
                        iconBuilder: (value) => value == false
                            ? Icon(
                                Icons.cancel,
                                color: Colors.white,
                                size: sizeHeight(25, context),
                              )
                            : Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: sizeHeight(25, context),
                              ),
                        textBuilder: (value) => value == false
                            ? Center(
                                child: Text(
                                'not-surveyor-label'.i18n(),
                                style: TextStyle(
                                    fontSize: sizeHeight(16, context)),
                              ))
                            : Center(
                                child: Text(
                                'surveyor-label'.i18n(),
                                style: TextStyle(
                                    fontSize: sizeHeight(16, context)),
                              )),
                      )
                    : Container(
                        child: Padding(
                          padding:
                              EdgeInsets.only(right: sizeWidth(20, context)),
                          child: Text(
                            'person-field-owner'.i18n(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: sizeHeight(16, context)),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      );
    }
    return completeBoxes;
  }

  List<Widget> getListStaff() {
    List<Widget> completeBoxes = [];
    for (int i = 0; i < staffs.length; i++) {
      completeBoxes.add(
        SizedBox(
          width: SizeConfig.screenWidth,
          height: sizeHeight(70, context),
          child: Card(
            child: Row(
              children: [
                SizedBox(
                  width: sizeWidth(8, context),
                ),
                Icon(
                  Icons.person,
                  size: sizeHeight(25, context),
                ),
                SizedBox(
                  width: sizeWidth(8, context),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${staffs[i].firstName}",
                      style: TextStyle(fontSize: sizeHeight(16, context)),
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Text(
                      "${staffs[i].lastName}",
                      style: TextStyle(fontSize: sizeHeight(16, context)),
                    ),
                  ],
                ),
                Spacer(),
                !staffs[i].owner
                    ? AnimatedToggleSwitch<bool>.dual(
                        current: staffs[i].status,
                        first: false,
                        second: true,
                        dif: sizeWidth(80, context),
                        borderColor: Colors.transparent,
                        borderWidth: sizeWidth(7, context),
                        height: sizeHeight(55, context),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 0),
                          ),
                        ],
                        onChanged: (value) {
                          setState(
                            () {
                              if (value) {
                                // add surveyor
                                addSurveyor(staffs[i].id).then((value) => {
                                      if (updateStatus)
                                        {
                                          // move the button
                                          staffs[i].status = !staffs[i].status
                                        }
                                    });
                              } else {
                                // remove surveyor
                                removeSurveyor(staffs[i].id).then((value) => {
                                      if (updateStatus)
                                        {
                                          // move the button
                                          staffs[i].status = !staffs[i].status
                                        }
                                    });
                              }
                            },
                          );
                        },
                        colorBuilder: (value) =>
                            value == false ? Colors.red : Colors.green,
                        iconBuilder: (value) => value == false
                            ? Icon(
                                Icons.cancel,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.check_circle,
                                color: Colors.white,
                              ),
                        textBuilder: (value) => value == false
                            ? Center(
                                child: Text(
                                'not-surveyor-label'.i18n(),
                                style: TextStyle(
                                    fontSize: sizeHeight(16, context)),
                              ))
                            : Center(
                                child: Text(
                                'surveyor-label'.i18n(),
                                style: TextStyle(
                                    fontSize: sizeHeight(16, context)),
                              )),
                      )
                    : Container(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text(
                            'person-responsible-field'.i18n(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: sizeHeight(16, context),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      );
    }
    return completeBoxes;
  }

  Widget boxDisplay(String type) {
    return type == "staff"
        ? Column(children: getListStaff())
        : Column(children: getListFarmer());
  }

  Widget staff() {
    return Column(
      children: [
        searchStaff(),
        Expanded(
          child: ListView(
            controller: scrollControllerStaff,
            children: [
              Column(
                children: [
                  isLoadingStaff
                      ? Column(
                          children: [
                            searchStaffEmpty
                                ? NoData().showNoData(context)
                                : boxDisplay("staff"),
                            isLoadMoreStaff
                                ? Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Container()
                          ],
                        )
                      : Container(
                          height: SizeConfig.screenHeight! * 0.92,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleSearchButton_Staff() async {
    //call Service
    StaffService staffService = new StaffService();
    String? token = tokenFromLogin?.token;
    saveStaffsWhenSearch = staffs;
    List<Map<String, dynamic>> data =
        await staffService.searchStaffByFirstnameLastName(
            widget.fieldId,
            firstNameValue_Staff,
            lastNameValue_Staff,
            token.toString(),
            1,
            100);
    List<StaffSurvey> moreData = [];
    for (int i = 0; i < data.length; i++) {
      int id = int.parse((data[i]["staffId"]).toString());
      int status_int = int.parse((data[i]["status"]).toString());
      bool status = status_int == 0 ? false : true;
      String firstName = data[i]["firstName"].toString();
      String lastName = data[i]["lastName"].toString();
      bool owner = data[i]["Respon"];
      moreData.add(new StaffSurvey(id, firstName, lastName, status, owner));
    }
    setState(() {
      isSearchStaff = true;
      if (moreData.length == 0) {
        searchStaffEmpty = true;
      } else {
        searchStaffEmpty = false;
      }
      staffs = moreData;
      firstNameValue_Staff = "";
      lastNameValue_Staff = "";
      isLoadingStaff = true;
    });
  }

  Widget searchStaff() {
    return ExpansionTile(
        textColor: Colors.black,
        iconColor: theme_color2,
        title: Text('search-more'.i18n(),
            style: TextStyle(
                fontSize: sizeHeight(20, context),
                fontWeight: FontWeight.bold)),
        onExpansionChanged: (bool isExpanded) {
          if (!isExpanded) {
            //print('Hello World');
          } else {
            //print('Save Value');
          }
        },
        leading: Icon(
          Icons.perm_contact_calendar_outlined,
          size: sizeHeight(25, context),
        ),
        subtitle: Text(
          selectedFirstName + " " + selectedLastName,
          style: TextStyle(fontSize: sizeHeight(16, context)),
        ),
        children: [
          Container(
            color: Colors.tealAccent[50],
            padding: EdgeInsets.all(sizeHeight(20, context)),
            child: Column(
              children: [
                TextFormField(
                  controller: firstnameStaffController,
                  decoration: InputDecoration(
                    labelText: selectedFirstName,
                    labelStyle: TextStyle(fontSize: sizeHeight(14, context)),
                    contentPadding: EdgeInsets.all(sizeHeight(16, context)),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeHeight(10, context)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      firstNameValue_Staff = value;
                    });
                  },
                ),
                SizedBox(height: sizeHeight(16, context)),
                TextFormField(
                  controller: lastnameStaffController,
                  decoration: InputDecoration(
                    labelText: selectedLastName,
                    labelStyle: TextStyle(fontSize: sizeHeight(14, context)),
                    contentPadding: EdgeInsets.all(sizeHeight(16, context)),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeHeight(10, context)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      lastNameValue_Staff = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: sizeHeight(2, context),
                left: sizeWidth(20, context),
                right: sizeWidth(20, context),
                bottom: sizeHeight(20, context)),
            height: sizeHeight(50, context),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                //side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))
              ),
              onPressed: () {
                setState(() {
                  isLoadingStaff = false;
                });
                _handleSearchButton_Staff();
              },
              padding: EdgeInsets.all(sizeHeight(10, context)),
              color: theme_color2,
              textColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "search".i18n(),
                    style: TextStyle(fontSize: sizeHeight(16, context)),
                  ),
                  SizedBox(width: sizeWidth(5, context)),
                  Icon(
                    Icons.search,
                    size: sizeHeight(20, context),
                  ),
                ],
              ),
            ),
          )
        ]);
  }

  Widget farmer() {
    return Column(
      children: [
        searchFarmer(),
        Expanded(
          child: ListView(
            controller: scrollControllerFarmer,
            children: [
              Column(
                children: [
                  isLoadingFarmer
                      ? Column(
                          children: [
                            searchFarmerEmpty
                                ? NoData().showNoData(context)
                                : boxDisplay("farmer"),
                            isLoadMoreFarmer
                                ? Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Container()
                          ],
                        )
                      : Container(
                          height: SizeConfig.screenHeight! * 0.92,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget searchFarmer() {
    return ExpansionTile(
        textColor: Colors.black,
        iconColor: theme_color2,
        title: Text('search-more'.i18n(),
            style: TextStyle(
                fontSize: sizeHeight(20, context),
                fontWeight: FontWeight.bold)),
        onExpansionChanged: (bool isExpanded) {
          if (!isExpanded) {
            //print('Hello World');
          } else {
            //print('Save Value');
          }
        },
        leading: Icon(
          Icons.perm_contact_calendar_outlined,
          size: sizeHeight(25, context),
        ),
        subtitle: Text(
          selectedFirstName + " " + selectedLastName,
          style: TextStyle(fontSize: sizeHeight(16, context)),
        ),
        children: [
          Container(
            color: Colors.tealAccent[50],
            padding: EdgeInsets.all(sizeWidth(20, context)),
            child: Column(
              children: [
                TextFormField(
                  controller: firstnameFarmerController,
                  decoration: InputDecoration(
                    labelText: selectedFirstName,
                    labelStyle: TextStyle(fontSize: sizeHeight(14, context)),
                    contentPadding: EdgeInsets.all(sizeHeight(16, context)),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeHeight(10, context)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      firstNameValue_Farmer = value;
                    });
                  },
                ),
                SizedBox(height: sizeHeight(16, context)),
                TextFormField(
                  controller: lastnameFarmerController,
                  decoration: InputDecoration(
                    labelText: selectedLastName,
                    labelStyle: TextStyle(fontSize: sizeHeight(14, context)),
                    contentPadding: EdgeInsets.all(sizeHeight(16, context)),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(10, context)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      lastNameValue_Farmer = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: sizeHeight(2, context),
                left: sizeWidth(20, context),
                right: sizeWidth(20, context),
                bottom: sizeHeight(20, context)),
            height: sizeHeight(50, context),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(sizeWidth(18, context)),
                //side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))
              ),
              onPressed: () {
                _handleSearchButton_Farmer();
              },
              padding: EdgeInsets.all(sizeHeight(10, context)),
              color: theme_color2,
              textColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "search".i18n(),
                    style: TextStyle(fontSize: sizeHeight(16, context)),
                  ),
                  SizedBox(width: sizeWidth(5, context)),
                  Icon(
                    Icons.search,
                    size: sizeHeight(20, context),
                  ),
                ],
              ),
            ),
          )
        ]);
  }

  void _handleSearchButton_Farmer() async {
    //call Service
    FarmerService farmerService = new FarmerService();
    String? token = tokenFromLogin?.token;
    saveFarmersWhenSearch = farmers;

    List<Map<String, dynamic>> data =
        await farmerService.searchFarmerByFirstnameLastName(
            widget.fieldId,
            firstNameValue_Farmer,
            lastNameValue_Farmer,
            token.toString(),
            1,
            100);
    List<StaffSurvey> moreData = [];
    for (int i = 0; i < data.length; i++) {
      int id = int.parse((data[i]["farmerId"]).toString());
      int status_int = int.parse((data[i]["status"]).toString());
      bool status = status_int == 0 ? false : true;
      String firstName = data[i]["firstName"].toString();
      String lastName = data[i]["lastName"].toString();
      bool owner = data[i]["Respon"];
      moreData.add(new StaffSurvey(id, firstName, lastName, status, owner));
    }
    setState(() {
      isSearchFarmer = true;
      if (moreData.length == 0) {
        searchFarmerEmpty = true;
      } else {
        searchFarmerEmpty = false;
      }
      farmers = moreData;
      firstNameValue_Farmer = "";
      lastNameValue_Farmer = "";
      isLoadingFarmer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
          child: getAppBarUI(),
        ),
        body: Column(
          children: [
            Container(
              height: SizeConfig.screenHeight! * 0.92,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: sizeHeight(0, context)),
                      child: PreferredSize(
                          preferredSize:
                              Size.fromHeight(AppBar().preferredSize.height),
                          child: Container(
                            height: sizeHeight(50, context),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  sizeHeight(8, context),
                                ),
                                border: Border.all(
                                  color: theme_color,
                                  width: sizeWidth(1, context),
                                ),
                                color: Colors.white,
                              ),
                              child: TabBar(
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      sizeHeight(8, context)),
                                  color: theme_color2,
                                ),
                                tabs: [
                                  Tab(
                                    child: Text(
                                      'officer-label'.i18n(),
                                      style: TextStyle(
                                          fontSize: sizeHeight(16,
                                              context)), // Set your desired font size
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'farmer-label'.i18n(),
                                      style: TextStyle(
                                          fontSize: sizeHeight(16,
                                              context)), // Set your desired font size
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))),
                  // create widgets for each tab bar here
                  Container(
                    height: SizeConfig.screenHeight! * 0.92,
                    child: TabBarView(
                      children: [
                        // first tab bar view widget
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(1),
                                theme_color3.withOpacity(.4),
                                theme_color4.withOpacity(1),
                                //Colors.white.withOpacity(1),
                                //Colors.white.withOpacity(1),
                              ],
                            ),
                          ),
                          child: Center(child: staff()),
                        ),
                        // second tab bar viiew widget
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(1),
                                theme_color3.withOpacity(.4),
                                theme_color4.withOpacity(1),
                                //Colors.white.withOpacity(1),
                                //Colors.white.withOpacity(1),
                              ],
                            ),
                          ),
                          child: Center(
                            child: farmer(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
