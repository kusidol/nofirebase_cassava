import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/district_service.dart';
import 'package:mun_bot/controller/farmer_service.dart';
import 'package:mun_bot/controller/province_service.dart';
import 'package:mun_bot/controller/subdistrict_service.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/model/input_validator.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/screen/widget/loading.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/util/ui/input.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CreateUserScrenn extends StatefulWidget {
  const CreateUserScrenn({Key? key}) : super(key: key);

  @override
  State<CreateUserScrenn> createState() => _CreateUserScrennState();
}

class _CreateUserScrennState extends State<CreateUserScrenn> {
  //SET UP
  String? token = tokenFromLogin?.token;
  bool _isLoading = true;
  StepperType stepperType = StepperType.horizontal;
  int _currentStep = 0;
  final _formKeyPage1 = GlobalKey<FormState>();
  final _formKeyPage2 = GlobalKey<FormState>();
  AutovalidateMode autovidateDisable = AutovalidateMode.disabled;

  // VARIABLE for create Data
  String title = "",
      firstname = "",
      lastname = "",
      address = "",
      province = "",
      district = "",
      subdistrict = "",
      telphone = "";

  // Checking for Province, District & Subdistrict
  bool selectedProvince = false;
  bool selectedDistrict = false;

  // Dropdown for Province, District and Subdistrict
  List<String> provinces = [];
  int? selectedProvinceId;
  List<String> districts = [];
  int? selectedDistrictId;
  List<String> subdistricts = [];
  int? selectedSubistrictId;

  // TEMP FOR GET DATA FROM SERVICE
  List<Map<String, dynamic>> data_provinces = [];
  List<Map<String, dynamic>> data_districts = [];
  List<Map<String, dynamic>> data_subdistricts = [];

  // TEXT FOR DROPDOWN : Province, District and Subdistrict
  String selectedProvince_value = "";
  String selectedDistrict_value = "";
  String selectedSubdistrict_value = "";

  @override
  void initState() {
    // TODO: implement initState
    onLoadFirstFunction();
    super.initState();
  }

  onLoadFirstFunction() async {
    // get Province
    ProviceService provinceService = new ProviceService();
    data_provinces = await provinceService.getAllProvince(token.toString());

    provinces = createDropdown(data_provinces);

    setState(() {
      _isLoading = false;
    });
  }

  // Function get ID from province, district and subdistrict
  /*
  MODE :
  1 = getID of Province,
  2 = getID of District,
  3 = getID of Subdistrict
  */
  int getId(String value, List<Map<String, dynamic>> list, int mode) {
    int result = 0;
    String label = "";
    if (mode == 1) {
      label = "provinceId";
    } else if (mode == 2) {
      label = "districtId";
    } else if (mode == 3) {
      label = "subdistrictId";
    } else {
      return result;
    }

    for (int i = 0; i < list.length; i++) {
      String text = jsonEncode(list[i]['name']);
      int id = int.parse(jsonEncode(list[i][label]));
      text = text.replaceAll('"', '');
      if (text == value) {
        result = id;
        break;
      }
    }
    return result;
  }

  List<String> createDropdown(List<Map<String, dynamic>> list) {
    List<String> result = [];
    for (int i = 0; i < list.length; i++) {
      String value = jsonEncode(list[i]['name']);
      value = value.replaceAll('"', '');
      result.add(value);
    }
    return result;
  }

  createDistrictDropdown() async {
    DistrictService districtService = new DistrictService();

    data_districts = await districtService.getAllDistrictsByProvinceId(
        token.toString(), selectedProvinceId!);
    districts = createDropdown(data_districts);
    setState(() {
      districts = districts;
    });
  }

  createSubistrictDropdown() async {
    SubdistrictService subdistrictService = new SubdistrictService();

    data_subdistricts = await subdistrictService.getAllSubdistrictsByDistrictId(
        token.toString(), selectedDistrictId!);
    subdistricts = createDropdown(data_subdistricts);
    setState(() {
      subdistricts = subdistricts;
    });
  }

  // Function for Stepper in Page
  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep == 1) {
      Navigator.of(context).pop();
    } else if (_currentStep == 0) {
      if (_formKeyPage1.currentState!.validate()) {
        setState(() => _currentStep += 1);
      } else {
        ////print("in valid");
      }
    } else if (_currentStep == 1) {
      if (_formKeyPage2.currentState!.validate()) {
        setState(() => _currentStep += 1);
      } else {
        ////print("in valid");
      }
    } else {
      setState(() => _currentStep += 1);
    }
  }

  cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    } else {
      // resetValueEditNotFinish();
      Navigator.of(context).pop();
    }
  }

  bool isFinal() {
    if (_currentStep == 1) return true;

    return false;
  }

  // Submitfunction
  submitFunction() async {
    ////print("SUBMIT FUNCTION FOR CREATE");
    // FOR CREATE DATA
    var createData = {
      "title": title,
      "firstName": firstname,
      "lastName": lastname,
      "address": address,
      "subdistrict": selectedSubistrictId,
      "phoneNo": telphone
    };
    FarmerService farmerService = new FarmerService();
    int statusCode =
        await farmerService.createFarmer(token.toString(), createData);
    if (statusCode == 200) {
      // Navigator.pushReplacement(context, MaterialPageRoute(
      //   builder: (BuildContext context) {
      //     return MainScreen();
      //   },
      // ));
      Navigator.pop(context);
      CustomLoading.showSuccess();
    } else {
      CustomLoading.showError(
          context, 'Something went wrong. Please try again later.');
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
              blurRadius: sizeWidth(8, context)),
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
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    // resetValueEditNotFinish();
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(sizeWidth(8, context)),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "create-farmerUser-label".i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeHeight(22, context),
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
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
                        padding: EdgeInsets.all(sizeHeight(8, context)),
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
                        padding: EdgeInsets.all(sizeHeight(8, context)),
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

  Widget _buildCreateUserFirstPage() {
    return Container(
      height: SizeConfig.screenHeight! * 0.57,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          // Container(
          //   width: SizeConfig.screenWidth,
          //   alignment: Alignment.center,
          //   child: Text("first-page".i18n(),
          //       style: TextStyle(
          //           fontSize: sizeHeight(20, context),
          //           fontWeight: FontWeight.bold)),
          // ),
          Form(
              key: _formKeyPage1,
              autovalidateMode: autovidateDisable,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "prefix".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        title = text;
                      }),
                      // if (text.isEmpty || (text == null) || (text == ""))
                      //   {planting.name = save_plantingName}
                    },
                    validator1: (value) =>
                        InputCodeValidator.validateNotSpecialCharacter(
                            value, title),
                    labelText: title == "" ? "insert-prefix".i18n() : title,
                    successText: "",
                    inputIcon: Icon(Icons.eco_sharp),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Name".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        firstname = text;
                      }),
                      // if (text.isEmpty || (text == null) || (text == ""))
                      //   {planting.name = save_plantingName}
                    },
                    validator1: (value) =>
                        InputCodeValidator.validateNotSpecialCharacter(
                            value, firstname),
                    labelText:
                        firstname == "" ? "insert-name".i18n() : firstname,
                    successText: "",
                    inputIcon: Icon(Icons.eco_sharp),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "last-name".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        lastname = text;
                      }),
                      // if (text.isEmpty || (text == null) || (text == ""))
                      //   {planting.name = save_plantingName}
                    },
                    validator1: (value) =>
                        InputCodeValidator.validateNotSpecialCharacter(
                            value, lastname),
                    labelText:
                        lastname == "" ? "insert-last-name".i18n() : lastname,
                    successText: "",
                    inputIcon: Icon(Icons.eco_sharp),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "address".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        address = text;
                      }),
                      // if (text.isEmpty || (text == null) || (text == ""))
                      //   {planting.name = save_plantingName}
                    },
                    validator1: (value) =>
                        InputCodeValidator.validateNotSpecialCharacter(
                            value, address),
                    labelText:
                        address == "" ? "insert-address".i18n() : address,
                    successText: "",
                    inputIcon: Icon(Icons.eco_sharp),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildCreateUserSecondPage() {
    return Container(
      height: SizeConfig.screenHeight! * 0.57,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          // Container(
          //   width: SizeConfig.screenWidth,
          //   alignment: Alignment.center,
          //   child: Text("second-page".i18n(),
          //       style: TextStyle(
          //           fontSize: sizeHeight(20, context),
          //           fontWeight: FontWeight.bold)),
          // ),
          Form(
              key: _formKeyPage2,
              autovalidateMode: autovidateDisable,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "province".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  DropdownSearch<String>(
                    mode: Mode.DIALOG,
                    showSelectedItems: true,
                    items: provinces,
                    dropdownSearchDecoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(sizeWidth(20, context)),
                        borderSide: const BorderSide(
                          color: theme_color,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(sizeWidth(20, context)),
                        borderSide: BorderSide(
                          color: theme_color,
                          width: sizeWidth(2, context),
                        ),
                      ),
                      hintText: "พืชที่ปลูกก่อนหน้า",
                    ),
                    onChanged: (value) async {
                      setState(() {
                        // _selectPreviousPlant = value;
                        // planting.previousPlant = value.toString();
                        // ////print(planting.previousPlant);
                        selectedProvince_value = value.toString();
                        selectedProvinceId =
                            getId(selectedProvince_value, data_provinces, 1);
                        selectedProvince = true;
                      });
                      await createDistrictDropdown();
                    },
                    // selectedItem: planting.previousPlant == ""
                    //     ? _selectPreviousPlant
                    //     : planting.previousPlant,
                    selectedItem: selectedProvince_value == ""
                        ? "select-province-info".i18n()
                        : selectedProvince_value,
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      cursorColor: Colors.blue,
                      autofillHints: [AutofillHints.name],
                      decoration: InputDecoration(
                        hintText: 'search'.i18n(),
                      ),
                    ),
                    validator: (value) => InputCodeValidator.validateDropDown(
                        value, "select-province-info".i18n()),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "district".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  selectedProvince
                      ? DropdownSearch<String>(
                          mode: Mode.DIALOG,
                          showSelectedItems: true,
                          items: districts,
                          dropdownSearchDecoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(sizeWidth(20, context)),
                              borderSide: const BorderSide(
                                color: theme_color,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(sizeWidth(20, context)),
                              borderSide: BorderSide(
                                color: theme_color,
                                width: sizeWidth(2, context),
                              ),
                            ),
                            hintText: "พืชที่ปลูกก่อนหน้า",
                          ),
                          onChanged: (value) async {
                            setState(() {
                              // _selectPreviousPlant = value;
                              // planting.previousPlant = value.toString();
                              // ////print(planting.previousPlant);
                              selectedDistrict_value = value.toString();
                              selectedDistrictId = getId(
                                  selectedDistrict_value, data_districts, 2);
                              selectedDistrict = true;
                            });
                            await createSubistrictDropdown();
                          },
                          // selectedItem: planting.previousPlant == ""
                          //     ? _selectPreviousPlant
                          //     : planting.previousPlant,
                          selectedItem: selectedDistrict_value == ""
                              ? "select-district-info".i18n()
                              : selectedDistrict_value,
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            cursorColor: Colors.blue,
                            autofillHints: [AutofillHints.name],
                            decoration: InputDecoration(
                              hintText: 'search'.i18n(),
                            ),
                          ),
                          validator: (value) =>
                              InputCodeValidator.validateDropDown(
                                  value, "select-district-info".i18n()),
                        )
                      : Container(
                          child: Center(
                            child: Text("must-select-province-first".i18n()),
                          ),
                        ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "sub-district".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  selectedDistrict
                      ? DropdownSearch<String>(
                          mode: Mode.DIALOG,
                          showSelectedItems: true,
                          items: subdistricts,
                          dropdownSearchDecoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(sizeWidth(20, context)),
                              borderSide: const BorderSide(
                                color: theme_color,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(sizeWidth(20, context)),
                              borderSide: BorderSide(
                                color: theme_color,
                                width: sizeWidth(2, context),
                              ),
                            ),
                            hintText: "พืชที่ปลูกก่อนหน้า",
                          ),
                          onChanged: (value) {
                            setState(() {
                              // _selectPreviousPlant = value;
                              // planting.previousPlant = value.toString();
                              // ////print(planting.previousPlant);
                              selectedSubdistrict_value = value.toString();
                              selectedSubistrictId = getId(
                                  selectedSubdistrict_value,
                                  data_subdistricts,
                                  3);
                            });
                          },
                          // selectedItem: planting.previousPlant == ""
                          //     ? _selectPreviousPlant
                          //     : planting.previousPlant,
                          selectedItem: selectedSubdistrict_value == ""
                              ? "select-sub-district-info".i18n()
                              : selectedSubdistrict_value,
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            cursorColor: Colors.blue,
                            autofillHints: [AutofillHints.name],
                            decoration: InputDecoration(
                              hintText: 'search'.i18n(),
                            ),
                          ),
                          validator: (value) =>
                              InputCodeValidator.validateDropDown(
                                  value, "select-sub-district-info".i18n()),
                        )
                      : Container(
                          child: Center(
                            child: Text("must-select-district-first".i18n()),
                          ),
                        ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "telphone-number".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        telphone = text;
                      }),
                      // if (text.isEmpty || (text == null) || (text == ""))
                      //   {planting.name = save_plantingName}
                    },
                    validator1: (value) =>
                        InputCodeValidator.validateNotSpecialCharacter(
                            value, telphone),
                    labelText: telphone == ""
                        ? "insert-telphone-number".i18n()
                        : telphone,
                    successText: "",
                    inputIcon: Icon(Icons.eco_sharp),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(sizeHeight(67, context)),
        child: getAppBarUI(),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme_color2),
              ),
            )
          : Container(
              padding: EdgeInsets.all(sizeHeight(12, context)),
              child: Container(
                height: SizeConfig.screenHeight,
                child: Theme(
                  data: ThemeData(
                    canvasColor: Color.fromARGB(255, 255, 255, 255),
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: theme_color4,
                          background: Colors.red,
                          secondary: Colors.green,
                        ),
                  ),
                  child: Stepper(
                    physics: ScrollPhysics(),
                    type: stepperType,
                    currentStep: _currentStep,
                    onStepTapped: (step) => tapped(step),
                    onStepContinue: continued,
                    onStepCancel: cancel,
                    controlsBuilder: (context, {onStepCancel, onStepContinue}) {
                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text('previous-label'.i18n()),
                              onPressed: cancel,
                            ),
                          ),
                          SizedBox(
                            width: sizeWidth(12, context),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              child: isFinal()
                                  ? Text('create-new-field-label'.i18n())
                                  : Text('next-label'.i18n()),
                              onPressed: isFinal() ? submitFunction : continued,
                            ),
                          ),
                        ],
                      );
                    },
                    steps: [
                      Step(
                        title: GestureDetector(
                          child: new Text(''),
                          onTap: () {
                            setState(() {
                              _currentStep = 0;
                            });
                          },
                        ),
                        content: Column(
                          children: <Widget>[
                            _buildCreateUserFirstPage(),
                            SizedBox(height: SizeConfig.screenHeight! * 0.025),
                          ],
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 0
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                      Step(
                        title: GestureDetector(
                          child: new Text(''),
                          onTap: () {
                            setState(() {
                              _currentStep = 1;
                            });
                          },
                        ),
                        content: Column(
                          children: <Widget>[
                            _buildCreateUserSecondPage(),
                            SizedBox(height: SizeConfig.screenHeight! * 0.025),
                          ],
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep >= 1
                            ? StepState.complete
                            : StepState.disabled,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
