import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:mun_bot/screen/main_screen.dart';
import '../../main.dart';
import 'app_styles.dart';

class FarmerRegisterScreen extends StatefulWidget {
  final String? codeCompanyregister;
  FarmerRegisterScreen({
    required this.codeCompanyregister,
  });
  @override
  State<StatefulWidget> createState() => _FarmerRegisterScreen();
}

class _FarmerRegisterScreen extends State<FarmerRegisterScreen> {
  late String _codeCompanyregister;
  String? token;
  List<Map<String, dynamic>> provinceItems = [];
  List<Map<String, dynamic>> districtItems = [];
  List<Map<String, dynamic>> subdistrictItems = [];

  String? provinceSelectedShow = '';
  String? districtSelectedShow = '';
  String? subdistrictSelectedShow = '';
  @override
  void initState() {
    super.initState();
    _codeCompanyregister = widget.codeCompanyregister!;
    print(_codeCompanyregister);
    token = tokenFromLogin?.token;
    print(token);
    getAllprovic();
  }

  Future<void> getAllprovic() async {
    var bodyValue;

    Service service = Service();
    var response = await service.doGet(
        "$LOCAL_SERVER_IP_URL/provinces/", token.toString());
    // print(response);
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.data);
      if (responseBody['status'] == 200) {
        List<dynamic> provinces = responseBody['body'];
        for (var province in provinces) {
          Map<String, dynamic> saveProvince = {
            'provinceId': province['provinceId'],
            'name': province['name'],
            'nameEng': province['nameEng'],
            'code': province['code']
          };
          provinceItems.add(saveProvince);
        }
        provinceSelectedShow =
            provinceItems.isNotEmpty ? provinceItems[0]['name'] : null;

        provinceItems.forEach((item) => print(item));
      }
    }
  }

  Future<void> getAlldistrict() async {
    setState(() {
      districtItems.clear(); // Reset the districtItems
      districtSelectedShow = null; // Reset the selected district value
      district = "";
      districtCheck = false;
    });

    var bodyValue;
    print(province);
    Service service = Service();
    var response = await service.doGet(
        "$LOCAL_SERVER_IP_URL/provinces/$province/districts", token.toString());
    // print(response);
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.data);
      if (responseBody['status'] == 200) {
        List<dynamic> districts = responseBody['body'];
        for (var district in districts) {
          Map<String, dynamic> saveDistrict = {
            'districtId': district['districtId'],
            'name': district['name'],
            'code': district['code']
          };
          setState(() {
            districtItems.add(saveDistrict); // Update districtItems list
          });
        }
        setState(() {
          districtSelectedShow = districtItems.isNotEmpty
              ? districtItems[0]['name']
              : null; // Set the selected district value
        });

        districtItems.forEach((item) => print(item));
      }
    }
  }

  Future<void> getAllsubdistrict() async {
    setState(() {
      subdistrictItems.clear(); // Reset the districtItems
      subdistrictSelectedShow = null; // Reset the selected district value
      subdistrict = "";
      subdistrictCheck = false;
    });

    var bodyValue;
    print(district);
    Service service = Service();
    var response = await service.doGet(
        "$LOCAL_SERVER_IP_URL/districts/$district/subdistricts",
        token.toString());
    // print(response);
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.data);
      if (responseBody['status'] == 200) {
        List<dynamic> subdistricts = responseBody['body'];
        for (var subdistrict in subdistricts) {
          Map<String, dynamic> saveSubdistrict = {
            'subdistrictId': subdistrict['subdistrictId'],
            'name': subdistrict['name'],
          };
          setState(() {
            subdistrictItems.add(saveSubdistrict); // Update districtItems list
          });
        }
        setState(() {
          subdistrictSelectedShow = subdistrictItems.isNotEmpty
              ? subdistrictItems[0]['name']
              : null; // Set the selected district value
        });

        subdistrictItems.forEach((item) => print(item));
      }
    }
  }

  Future<bool> createFarmer(var farmerBody) async {
    Service service = Service();
    var response = await service.doPostWithFormData(
        "$LOCAL_SERVER_IP_URL/register/farmer", token.toString(), farmerBody);
    print(response);
    var responseBody = json.decode(response.data);
    if (responseBody['status'] == 200) {
      String messageCheck = responseBody['message'] as String;
      if (messageCheck == "Success") {
        String showMS = "ลงทะเบียนเกษตรกรสำเร็จ";
        showAlert(context, showMS);
      } else {
        String showMS = "มีการใช้งาน E-mail นี้แล้ว";
        showAlert(context, showMS);
      }
      print(responseBody['body']);
      return true;
    } else {
      return false;
    }
  }

  void showAlert(BuildContext context, String showMS) {
    Color backgroundColor = showMS == "มีการใช้งาน E-mail นี้แล้ว"
        ? Colors.red
        : Colors.green; // Change the background color based on the condition

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            'แจ้งเตือน',
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Text(
            showMS,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ตกลง',
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return LoginScreen();
                  }),
                  (r) {
                    return false;
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  String prefix = "";
  bool prefixCheck = false;
  String name = "";
  bool nameCheck = false;
  String surname = "";
  bool surnameCheck = false;
  String addressFarmer = "";
  bool addressFarmerCheck = false;
  String phone = "";
  String phoneCheck = "false";
  String? province = "";
  bool provinceCheck = false;
  String? district = "";
  bool districtCheck = false;
  String? subdistrict = "";
  bool subdistrictCheck = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorMessage = '';

  Widget createFarmerform() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.18,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            'คำนำหน้า',
                            style: const TextStyle(
                              color: Color(0xFFB8B6B6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        prefixCheck == false
                            ? Container(
                                margin: EdgeInsets.only(left: 5, top: 16),
                                child: Text(
                                  '*',
                                  style: const TextStyle(
                                    color: Color(0xFFFD0000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            : SizedBox(), // Replace SizedBox with an appropriate widget if needed
                      ],
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFDDEBF9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFFFFF)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors
                                        .green, // Set your desired enabled border color here
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onChanged: (text) {
                                setState(() {
                                  prefix = text;
                                  if (prefix != "" && prefix.length > 1) {
                                    prefixCheck = true;
                                  } else if (prefix == "" ||
                                      prefix.length < 2) {
                                    prefixCheck = false;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            'ชื่อ',
                            style: const TextStyle(
                              color: Color(0xFFB8B6B6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        nameCheck == false
                            ? Container(
                                margin: EdgeInsets.only(left: 5, top: 16),
                                child: Text(
                                  '*',
                                  style: const TextStyle(
                                    color: Color(0xFFFD0000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFDDEBF9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20),
                              ],
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFFFFF)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors
                                        .green, // Set your desired enabled border color here
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onChanged: (text) {
                                setState(() {
                                  name = text;
                                  if (name != "" && name.length > 1) {
                                    nameCheck = true;
                                  } else if (name == "" || name.length < 2) {
                                    nameCheck = false;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            'นามสกุล',
                            style: const TextStyle(
                              color: Color(0xFFB8B6B6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        surnameCheck == false
                            ? Container(
                                margin: EdgeInsets.only(left: 5, top: 16),
                                child: Text(
                                  '*',
                                  style: const TextStyle(
                                    color: Color(0xFFFD0000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFDDEBF9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFFFFF)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors
                                        .green, // Set your desired enabled border color here
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onChanged: (text) {
                                setState(() {
                                  surname = text;
                                  if (surname != "" && surname.length > 1) {
                                    surnameCheck = true;
                                  } else if (surname == "" ||
                                      surname.length < 2) {
                                    surnameCheck = false;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            'ที่อยู่',
                            style: const TextStyle(
                              color: Color(0xFFB8B6B6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        addressFarmerCheck == false
                            ? Container(
                                margin: EdgeInsets.only(left: 5, top: 16),
                                child: Text(
                                  '*',
                                  style: const TextStyle(
                                    color: Color(0xFFFD0000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFDDEBF9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFFFFF)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors
                                        .green, // Set your desired enabled border color here
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onChanged: (text) {
                                setState(() {
                                  addressFarmer = text;
                                  if (addressFarmer != "") {
                                    addressFarmerCheck = true;
                                  } else if (addressFarmer == "") {
                                    addressFarmerCheck = false;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            'จังหวัด',
                            style: const TextStyle(
                              color: Color(0xFFB8B6B6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        provinceCheck == false
                            ? Container(
                                margin: EdgeInsets.only(left: 5, top: 16),
                                child: Text(
                                  '*',
                                  style: const TextStyle(
                                    color: Color(0xFFFD0000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(
                                  FocusNode()); // Close any open keyboard
                              // setState(() {
                              //   if (provinceSelectedShow != null &&
                              //       provinceSelectedShow!.isNotEmpty) {
                              //     // Close the dropdown if it's already open
                              //     provinceSelectedShow = null;
                              //   } else {
                              //     // Open the dropdown if it's closed
                              //     provinceSelectedShow =
                              //         provinceItems.first['name'];
                              //   }
                              // });
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFFDDEBF9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: SingleChildScrollView(
                                child: DropdownButton<String>(
                                  value: provinceSelectedShow,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      provinceSelectedShow = newValue;
                                      province = provinceItems
                                          .firstWhere((province) =>
                                              province['name'] ==
                                              newValue)['provinceId']
                                          .toString();
                                      print(
                                          "ProvinceIdSelected : " + province!);
                                      if (province != null) {
                                        provinceCheck = true;
                                        getAlldistrict();
                                      } else {
                                        provinceCheck = false;
                                      }
                                    });
                                  },
                                  items: provinceItems
                                      .map<DropdownMenuItem<String>>(
                                    (Map<String, dynamic> province) {
                                      return DropdownMenuItem<String>(
                                        value: province['name'],
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            province['name'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF060606),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  hint: Text(
                                    '  เลือกจังหวัด',
                                    style: const TextStyle(
                                      color: Color(0xFF7696FE),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  underline: SizedBox(),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF7696FE),
                                  ),
                                  isExpanded: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            'อำเภอ',
                            style: const TextStyle(
                              color: Color(0xFFB8B6B6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        districtCheck == false
                            ? Container(
                                margin: EdgeInsets.only(left: 5, top: 16),
                                child: Text(
                                  '*',
                                  style: const TextStyle(
                                    color: Color(0xFFFD0000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            child: AbsorbPointer(
                              absorbing: province == "",
                              child: Opacity(
                                opacity: province == "" ? 0.5 : 1.0,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFDDEBF9),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: SingleChildScrollView(
                                    child: DropdownButton<String>(
                                      value: districtSelectedShow,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          districtSelectedShow = newValue;
                                          district = districtItems
                                              .firstWhere((district) =>
                                                  district['name'] ==
                                                  newValue)['districtId']
                                              .toString();
                                          print("DistrictIdSelected : " +
                                              district!);
                                          if (district != null) {
                                            districtCheck = true;
                                            getAllsubdistrict();
                                          } else {
                                            districtCheck = false;
                                          }
                                        });
                                      },
                                      items: districtItems
                                          .map<DropdownMenuItem<String>>(
                                        (Map<String, dynamic> district) {
                                          return DropdownMenuItem<String>(
                                            value: district['name'],
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                district['name'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF060606),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      hint: Text(
                                        '  เลือกอำเภอ',
                                        style: const TextStyle(
                                          color: Color(0xFF7696FE),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      underline: SizedBox(),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Color(0xFF7696FE),
                                      ),
                                      isExpanded: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            'ตำบล',
                            style: const TextStyle(
                              color: Color(0xFFB8B6B6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        subdistrictCheck == false
                            ? Container(
                                margin: EdgeInsets.only(left: 5, top: 16),
                                child: Text(
                                  '*',
                                  style: const TextStyle(
                                    color: Color(0xFFFD0000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            child: AbsorbPointer(
                              absorbing: province == "" || district == "",
                              child: Opacity(
                                opacity: province == "" || district == ""
                                    ? 0.5
                                    : 1.0,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFDDEBF9),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: SingleChildScrollView(
                                    child: DropdownButton<String>(
                                      value: subdistrictSelectedShow,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          subdistrictSelectedShow = newValue;
                                          subdistrict = subdistrictItems
                                              .firstWhere((subdistrict) =>
                                                  subdistrict['name'] ==
                                                  newValue)['subdistrictId']
                                              .toString();
                                          print("SubDistrictIdSelected : " +
                                              subdistrict!);
                                          if (subdistrict != null) {
                                            subdistrictCheck = true;
                                          } else {
                                            subdistrictCheck = false;
                                          }
                                        });
                                      },
                                      items: subdistrictItems
                                          .map<DropdownMenuItem<String>>(
                                        (Map<String, dynamic> subdistrict) {
                                          return DropdownMenuItem<String>(
                                            value: subdistrict['name'],
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                subdistrict['name'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF060606),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      hint: Text(
                                        '  เลือกตำบล',
                                        style: const TextStyle(
                                          color: Color(0xFF7696FE),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      underline: SizedBox(),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: Color(0xFF7696FE),
                                      ),
                                      isExpanded: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            'เบอร์โทรศัพท์',
                            style: const TextStyle(
                              color: Color(0xFFB8B6B6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        phoneCheck == "false"
                            ? Container(
                                margin: EdgeInsets.only(left: 5, top: 16),
                                child: Text(
                                  '*',
                                  style: const TextStyle(
                                    color: Color(0xFFFD0000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            : phoneCheck == "phonevalidate"
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, top: 20),
                                    child: Text(
                                      '(กรุณากรอกเบอร์ให้ครบสิบหลัก)',
                                      style: const TextStyle(
                                        color: Color(0xFFFD0000),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFDDEBF9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFFFFF)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors
                                        .green, // Set your desired enabled border color here
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                counterText: '',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              onChanged: (text) {
                                setState(() {
                                  phone = text;
                                  if (phone.length != 10) {
                                    phoneCheck = "phonevalidate";
                                  }
                                  if (phone.length == 10) {
                                    phoneCheck = "true";
                                  } else if (phone == "") {
                                    phoneCheck = "false";
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
                        child: Container(
                          margin: EdgeInsets.all(1),
                          width: 500,
                          color: Colors.white,
                          child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF00A824),
                                elevation: 8,
                                shadowColor: Color(0x4D005DA8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                minimumSize: Size(355, 55),
                              ),
                              onPressed: prefix != "" &&
                                      name != "" &&
                                      surname != "" &&
                                      phone != "" &&
                                      addressFarmer != "" &&
                                      phone.length == 10 &&
                                      province != "" &&
                                      subdistrict != "" &&
                                      district != "" &&
                                      prefix.length >= 2 &&
                                      surname.length >= 2 &&
                                      name.length >= 2
                                  ? () {
                                      int subDistrictId =
                                          int.parse(subdistrict!);
                                      var jsonBody = {
                                        "address": addressFarmer,
                                        "code": _codeCompanyregister,
                                        "firstName": name,
                                        "lastName": surname,
                                        "phoneNo": phone,
                                        "subDistrictId": subDistrictId,
                                        "title": prefix,
                                      };
                                      createFarmer(jsonBody);
                                      // Navigator.pushAndRemoveUntil(context,
                                      //     MaterialPageRoute(
                                      //         builder: (BuildContext context) {
                                      //   return LoginScreen();
                                      // }), (r) {
                                      //   return false;
                                      // });
                                    }
                                  : null,
                              child: Text(
                                'เสร็จสิ้น',
                                style: const TextStyle(
                                  color: Color(0xFFF9FAFB),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF7696FE),
                      Color(0xFFC1C4E6),
                      Color(0xFFFFFFFF),
                      Color(0xFFFBFBFB),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 0.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                print("back");
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return LoginScreen();
                                }), (r) {
                                  return false;
                                });
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 50, right: 50),
                              child: Text(
                                'ลงทะเบียนสำหรับเกษตรกร',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 13),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          child: createFarmerform(),
                        ),
                      ],
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
}
