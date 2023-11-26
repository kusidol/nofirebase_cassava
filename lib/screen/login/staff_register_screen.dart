import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/entities/token.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:mun_bot/screen/main_screen.dart';
import '../../main.dart';
import 'app_styles.dart';
import 'dart:convert';
import 'package:http/http.dart' as Http;

class StaffRegisterScreen extends StatefulWidget {
  final String? codeCompanyregister;
  final String? nameCompanyregister;
  StaffRegisterScreen({
    required this.codeCompanyregister,
    required this.nameCompanyregister,
  });

  @override
  State<StatefulWidget> createState() => _StaffRegisterScreen();
}

class _StaffRegisterScreen extends State<StaffRegisterScreen> {
  late String _codeCompanyregister;
  late String _nameCompanyregister;
  String? token;
  @override
  void initState() {
    super.initState();
    _codeCompanyregister = widget.codeCompanyregister!;
    _nameCompanyregister = widget.nameCompanyregister!;
    token = tokenFromLogin?.token;
    print(token);
  }

  String prefix = "";
  bool prefixCheck = false;
  String name = "";
  bool nameCheck = false;
  String surname = "";
  bool surnameCheck = false;
  String phone = "";
  String phoneCheck = "false";
  String position = "";
  bool positionCheck = false;
  String positionCompany = "";
  bool positionCompanyCheck = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorMessage = '';

  Future<bool> createStaff(var staffBody) async {
    Service service = Service();
    var response = await service.doPostWithFormData(
        "$LOCAL_SERVER_IP_URL/register/staff", token.toString(), staffBody);
    print(response);
    var responseBody = json.decode(response.data);
    if (responseBody['status'] == 200) {
      String messageCheck = responseBody['message'] as String;
      if (messageCheck == "Success") {
        String showMS = "ลงทะเบียนเจ้าหน้าที่สำเร็จ";
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

  Widget createStaffform() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.23,
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
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16, top: 16),
                          child: Text(
                            'ตำแหน่ง',
                            style: const TextStyle(
                              color: Color(0xFFB8B6B6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        positionCheck == false
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
                                  position = text;
                                  if (position != "") {
                                    positionCheck = true;
                                  } else if (position == "") {
                                    positionCheck = false;
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
                            'ส่วนงาน',
                            style: const TextStyle(
                              color: Color(0xFFB8B6B6),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        positionCompanyCheck == false
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
                                  positionCompany = text;
                                  if (positionCompany != "") {
                                    positionCompanyCheck = true;
                                  } else if (positionCompany == "") {
                                    positionCompanyCheck = false;
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
                                      position != "" &&
                                      phone != "" &&
                                      positionCompany != "" &&
                                      phone.length == 10 &&
                                      prefix.length >= 2 &&
                                      surname.length >= 2 &&
                                      name.length >= 2
                                  ? () {
                                      var jsonBody = {
                                        "code": _codeCompanyregister,
                                        "division": positionCompany,
                                        "firstName": name,
                                        "lastName": surname,
                                        "phoneNo": phone,
                                        "position": position,
                                        "title": prefix,
                                      };
                                      createStaff(jsonBody);
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFB9B9D),
                      Color(0xFFFB9B9D),
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
                                'ลงทะเบียนสำหรับเจ้าหน้าที่',
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
                          margin: EdgeInsets.only(left: 50, right: 50),
                          child: Text(
                            _nameCompanyregister,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                          child: createStaffform(),
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
