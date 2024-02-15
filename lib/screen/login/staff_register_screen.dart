import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/entities/token.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:mun_bot/screen/main_screen.dart';
import 'package:mun_bot/social_login/ui/auth-page.dart';
import '../../main.dart';
import 'app_styles.dart';
import 'dart:convert';
import 'package:http/http.dart' as Http;

class StaffRegisterScreen extends StatefulWidget {
  final String? token;
  final String? codeCompanyregister;
  final String? nameCompanyregister;
  StaffRegisterScreen({
    required this.token,
    required this.codeCompanyregister,
    required this.nameCompanyregister,
  });

  @override
  State<StatefulWidget> createState() => _StaffRegisterScreen();
}

class _StaffRegisterScreen extends State<StaffRegisterScreen> {
  late String _codeCompanyregister;
  late String _nameCompanyregister;

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  //String? token;
  @override
  void initState() {
    super.initState();
    _codeCompanyregister = widget.codeCompanyregister!;
    _nameCompanyregister = widget.nameCompanyregister!;
    //token = tokenFromLogin?.token;
    //print(widget.token);
    //print(name = loggedUser.firstName)
    // ;
    setState(() {
      if(loggedUser.firstName != null &&  loggedUser.firstName.length > 0 ){
        nameCheck = true ;
        name = loggedUser.firstName ;
      }
      if(loggedUser.lastName != null &&  loggedUser.lastName.length > 0 ){
        surnameCheck = true ;
        surname = loggedUser.lastName ;
      }
      nameController.text = loggedUser.firstName ;
      lastNameController.text = loggedUser.lastName ;
    });

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
        "$LOCAL_SERVER_IP_URL/register/staff",
        widget.token.toString(),
        staffBody);
    ////print(response);
    var responseBody = json.decode(response.data);
    if (responseBody['status'] == 200) {
      String messageCheck = responseBody['message'] as String;
      bool isRegis = true ;
      String showMS = "มีการใช้งาน E-mail นี้แล้ว";

      if (messageCheck == "Success") {
        String showMS = "ลงทะเบียนเจ้าหน้าที่สำเร็จ";
        isRegis = false ;
        //showAlert(context, showMS,false);


      }
      showAlert(context, showMS ,isRegis);
      ////print(responseBody['body']);
      return true;
    } else {
      return false;
    }
  }

  void showAlert(BuildContext context, String showMS, bool isRegis) {
   // Color backgroundColor =
    //     isRegis ? Colors.red : Colors.green;
    if (isRegis) {
      showMS = "emailalreadyinuse".i18n();
    } else  {
      showMS = "registerstaffdone".i18n();
    }



    showCupertinoDialog<void>(
      barrierDismissible: false,

      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          "notification-label".i18n(),
          style: const TextStyle(
            color: CupertinoColors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: Text(
          showMS,
          style: const TextStyle(
            color: CupertinoColors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text(
              "done".i18n(),
              style: const TextStyle(
                color: CupertinoColors.activeBlue,
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () async {

              Navigator.of(context).pop();

              if(isRegis){

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return LoginScreen();
                  }),
                      (r) {
                    return false;
                  },
                ) ;


              }else{

                Token token = Token(loggedUser.token /*, t.body.user*/);

                tokenFromLogin = token;

                await save("current_user", loggedUser);

                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MainScreen()));

              }

            },
          ),
        ],
      ),
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
                            "prefix".i18n(),
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
                            "firstname".i18n(),
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
                              controller: nameController,
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
                            "lastname".i18n(),
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
                              controller: lastNameController  ,
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
                            "phonenumber".i18n(),
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
                            "position".i18n(),
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
                            "division".i18n(),
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
                               minimumSize: Size(
            MediaQuery.of(context).size.width * 0.9, 
            55,
          ),
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
                                "done".i18n(),
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
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only( right: 55),              
                                alignment: Alignment.center,
                                child: Text(
                                  "registerforofficials".i18n(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
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
