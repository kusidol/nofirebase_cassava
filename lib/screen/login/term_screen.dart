import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/screen/login/qrcode_scren.dart';

import 'farmer_register_screen.dart';
import 'staff_register_screen.dart';

class TermScreen extends StatefulWidget {
  final String? codeCompanyregister; //ใช้ส่งเข้าAPI
  final String? userType; //ใช้ระบุว่าเป็น Farmer หรือ Staff
  final String? nameCompanyregister;

  String token; //ใช้DISPLAY

  TermScreen({
    required this.token,
    required this.codeCompanyregister,
    required this.userType,
    required this.nameCompanyregister,
  });
  // TermScreen(result);

  @override
  State<StatefulWidget> createState() => _TermScreen();
}

class _TermScreen extends State<TermScreen>
    with SingleTickerProviderStateMixin {
  String? _codeCompanyregister;
  String? _userType;
  String? _nameCompanyregister;
    String? _headerTerm = "copyrightregistration".i18n();
  String? _headerTerm2 = "transferofcopyright".i18n();
  String? _headerTerm3 = "publicdomainannouncement".i18n();
  String? _dataTerm = "dataterm1".i18n();
  String? _dataTerm2 = "dataterm2".i18n();
  String? _dataTerm3 = "dataterm3".i18n();
  @override
  void initState() {
    super.initState();
    _userType = widget.userType;
    _codeCompanyregister = widget.codeCompanyregister;
    _nameCompanyregister = widget.nameCompanyregister;
  }

  bool isChecked = false;
  bool isChecked2 = false;
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Color(0xFF118E7D),
                size: 20,
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return QRCodeScannerScreen(widget.token);
                }));
              },
            ),
          ],
        ),
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(left: 24, right: 24),
          child: Text(
            "termandpolicy".i18n(),
            style: const TextStyle(
              color: Color(0xFF118E7D),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor:
            Color(0xFF66F6E2), // You can change the background color here
      ),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "$_headerTerm",
                              style: const TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0, right: 35, left: 35, bottom: 10),
                          child: Text(
                            "$_dataTerm",
                            style: const TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "$_headerTerm2",
                              style: const TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0, right: 35, left: 35, bottom: 10),
                          child: Text(
                            "$_dataTerm2",
                            style: const TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "$_headerTerm3",
                              style: const TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 5.0, right: 35, left: 35, bottom: 10),
                          child: Text(
                            "$_dataTerm3",
                            style: const TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            child: SvgPicture.asset(
                              isChecked
                                  ? 'assets/images/Check.svg'
                                  : 'assets/images/Nocheck.svg',
                              fit: BoxFit.contain,
                            ),
                            onTap: () {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            }),
                        const SizedBox(
                          width: 1,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          alignment: Alignment.center,
                          child: Text(
                              "approveterm1".i18n(),
                            style: const TextStyle(
                              color: Color(0xFF25282B),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            child: SvgPicture.asset(
                              isChecked2
                                  ? 'assets/images/Check.svg'
                                  : 'assets/images/Nocheck.svg',
                              fit: BoxFit.contain,
                            ),
                            onTap: () {
                              setState(() {
                                isChecked2 = !isChecked2;
                              });
                            }),
                        const SizedBox(
                          width: 1,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          alignment: Alignment.center,
                          child: Text(
                            "approveterm2".i18n(),
                            style: const TextStyle(
                              color: Color(0xFF25282B),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
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
                            shadowColor: Color(0x4D4897D7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            minimumSize: Size(341, 55),
                          ),
                          child: Text(
                             "done".i18n(),
                            style: const TextStyle(
                              color: Color(0xFFF9FAFB),
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onPressed: isChecked && isChecked2
                              ? () {
                                  switch (widget.userType) {
                                    case "Farmer":
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FarmerRegisterScreen(
                                                token: widget.token,
                                            codeCompanyregister:
                                                widget.codeCompanyregister,
                                          ),
                                        ),
                                      );
                                      break;
                                    case "Staff":
                                      print(widget.userType);
                                      print(widget.codeCompanyregister);
                                      print(widget.nameCompanyregister);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StaffRegisterScreen(
                                                token: widget.token,
                                            codeCompanyregister:
                                                _codeCompanyregister,
                                            nameCompanyregister:
                                                _nameCompanyregister,
                                          ),
                                        ),
                                      );
                                      break;
                                    default:
                                      break;
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),
                  )
                ], // align children to the bottom
              ),
            ],
          ),
        ],
      ),
    );
  }
}
