import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  String? _headerTerm = "การจดลิขสิทธิ์";
  String? _headerTerm2 = "การถ่ายโอนลิขสิทธิ์";
  String? _headerTerm3 = "ประกาศสาธารณสมบัติ";
  String? _dataTerm =
      "ผู้นำส่งภาพมาให้คลังข้อมูลภาพถ่ายโรคสำคัญของมันสำปะหลังจำเป็นต้องถ่ายโอนลิขสิทธิ์หรือระบุว่าข้อมูลเป็นสาธารณสมบัติ กรุณาเลือกหนึ่งในข้อความจากข้างล่าง ข้อมูลและภาพที่ท่านส่งมาให้นั้นจะถูกนำไปใช้ในกลุ่มนักวิชาการโรคพืชและนักวิชาการเกษตรผ่านคลังข้อมูลภาพถ่ายโรคสำคัญของมันสำปะหลัง ทางคลังข้อมูลภาพถ่ายโรคสำคัญของมันสำปะหลังไม่แนะนำให้ผู้ส่งข้อมูลและภาพใช้งานข้อมูลและภาพภายใต้จุดประสงค์อื่นที่ไม่ตรงกับข้อตกลงการใช้งานของคลังข้อมูลภาพถ่ายโรคสำคัญของมันสำปะหลัง ข้อตกลงนี้จะเปลี่ยนไปตามนโยบายของคลังข้อมูลภาพถ่ายโรคสำคัญของมันสำปะหลัง";
  String? _dataTerm2 =
      "ข้าพเจ้าขอยืนยันว่าข้าพเจ้าเป็นเจ้าของลิขสิทธิ์ข้อมูลและภาพถ่ายและด้วยเหตุนี้ข้าพเจ้าขอถ่ายโอนลิขสิทธิ์ทั้งหมดของข้อมูลและภาพให้แก่คลังข้อมูลภาพถ่ายโรคสำคัญของมันสำปะหลัง การถ่ายโอนครั้งนี้จะทำให้คลังข้อมูลภาพถ่ายโรคสำคัญของมันสำปะหลังมีอำนาจเด็ดขาดในการให้ลิขสิทธิ์ของข้อมูลและภาพให้แก่ผู้อื่น ข้าพเจ้าในฐานะเจ้าของลิขสิทธิ์ยังสามารถใช้งานภาพนี้สำหรับงานตีพิมพ์ของข้าพเจ้าได้โดยที่ไม่ต้องขออนุญาตจากคลังข้อมูลภาพถ่ายโรคสำคัญของมันสำปะหลัง ข้าพเจ้ายังขอยืนยันอีกว่างานที่ตีพิมพ์จากข้อมูลและภาพของคลังข้อมูลภาพถ่ายโรคสำคัญของมันสำปะหลังจะไม่ละเมิดลิขสิทธิ์หรือสิทธิของผู้อื่น ข้าพเจ้าทราบดีว่าคลังข้อมูลภาพถ่ายโรคสำคัญของมันสำปะหลังจะใช้คำพูดข้างต้นนี้ในการอ้างลิขสิทธิ์ของผลงาน";
  String? _dataTerm3 =
      "ข้าพเจ้าขอยืนยันว่าข้อมูลและภาพที่ได้เห็นจากข้างในระบบทำขึ้นโดยคลังข้อมูลภาพถ่ายโรคสำคัญของมันสำปะหลังหรือมีเหตุผลอื่นที่ทำให้ไม่สามารถจดลิขสิทธิ์ได้และตกเป็นสาธารณสมบัติ ด้วยเหตุนี้ผลงานจึงสามารถตีพิมพ์ได้อย่างอิสระ ข้าพเจ้าทราบดีว่าคลังข้อมูลภาพถ่ายโรคสำคัญของมันสำปะหลังจะใช้คำพูดข้างต้นเพื่อพิจารณาว่าผลงานไร้ลิขสิทธิ์";
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
            'ข้อกำหนดและบริการ',
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
                          padding:
                              EdgeInsets.only(top: 15.0, right: 210, bottom: 5),
                          child: Text(
                            "$_headerTerm",
                            style: const TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
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
                          padding:
                              EdgeInsets.only(top: 15.0, right: 210, bottom: 5),
                          child: Text(
                            "$_headerTerm2",
                            style: const TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
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
                          padding:
                              EdgeInsets.only(top: 15.0, right: 210, bottom: 5),
                          child: Text(
                            "$_headerTerm3",
                            style: const TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
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
                            "เลือกข้อนี้เพื่อยอมรับกับการถ่ายโอนลิขสิทธิ์ข้างต้น",
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
                            "เลือกข้อนี้เพื่อยอมรับกับประกาศสาธารณสมบัติข้างต้น",
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
                            'เสร็จสิ้น',
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
