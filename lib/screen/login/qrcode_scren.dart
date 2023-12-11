import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as Http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/entities/token.dart';
import 'package:mun_bot/screen/login/farmer_register_screen.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/screen/login/term_screen.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:scan/scan.dart';
import 'package:mun_bot/screen/login/staff_register_screen.dart';
import 'package:mun_bot/screen/main_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';
import '../../env.dart';
import '../../main.dart';
import 'app_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class QRCodeScannerScreen extends StatefulWidget {
  String token;

  @override
  QRCodeScannerScreen(this.token);

  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

//CameraScanner
class _QRCodeScannerScreenState extends State<QRCodeScannerScreen>
    with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _permission = false;
  bool arkPermission = false;
  String? registerCode;
  String message = "";
  String userType = "";
  String nameCompany = "";
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getPermission();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    // Clear the token here
    tokenFromLogin = null;
  }

  void _getPermission() async {
    final grant = await Permission.camera.request().isGranted;
    setState(() {
      _permission = grant;
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final granted = await Permission.camera.isGranted;
      if (granted && !_permission) {
        _permission = granted;
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> doQR(String regisCode) async {
    final String? token = widget.token;
    final Service service = Service();

    try {
      final response = await service.doGet(
          '$LOCAL_SERVER_IP_URL/register/$regisCode', token.toString());
      final responseBody = json.decode(response.data) as Map<String, dynamic>;
      ////print(responseBody);

      if (response.statusCode == 200) {
        final body = responseBody['body'] as Map<String, dynamic>;
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('qrcode-verification'.i18n()),
            content: Text('qrcode-valid'.i18n()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // //print("--"+Navigator.);
                },
                child:
                    Text('cancle'.i18n(), style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () async {
                  // Show a loading dialog

                  await Future.delayed(Duration(seconds: 2));
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermScreen(
                        token: widget.token,
                        codeCompanyregister: regisCode,
                        userType: body['userType'] as String,
                        nameCompanyregister: body['organizationName'] as String,
                      ),
                    ),
                  );
                },
                child: Text(
                  'confirm'.i18n(),
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        );
      } else if (response.statusCode == 400) {
        _showAlertDialog(context, "qrcode-invalid".i18n());
      }

      //registerCode = rest;
      //final body = responseBody['body'] as Map<String, dynamic>;
      //message = "รหัสถูกต้อง";
      //userType = body['userType'] as String;
      //nameCompany = body['organizationName'] as String;

    } catch (error) {
      //showAlert(context);
      //return error;
    }
  }

  Future<dynamic> _getRole() async {
    final String? token = widget.token;
    final Service service = Service();
    try {
      final response = await service.doGet(
          '$LOCAL_SERVER_IP_URL/register/$registerCode', token.toString());
      final responseBody = json.decode(response.data) as Map<String, dynamic>;
      ////print(responseBody);

      return response;
      /*if (responseBody['status'] == 400) {
        String messageCheck = responseBody['message'] as String;
        if (messageCheck == "รหัสไม่ถูกต้อง") {
          message = messageCheck;
        } else if (messageCheck == "รหัสถูกใช้ครบจำนวนแล้ว") {
          message = messageCheck;
        } else if (messageCheck == "รหัสหมดอายุ") {
          message = messageCheck;
        }
      } else {
        final body = responseBody['body'] as Map<String, dynamic>;
        message = "รหัสถูกต้อง";
        userType = body['userType'] as String;
        nameCompany = body['organizationName'] as String;
      }*/
    } catch (error) {
      showAlert(context);
      return error;
    }
  }

  void showAlert(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          "notification-label".i18n(),
          style: const TextStyle(
            color: theme_color4,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: Text(
          "erroroccurred".i18n(),
          style: const TextStyle(
            color: theme_color4,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
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
            child: Text(
              "allow".i18n(),
              style: const TextStyle(
                color: CupertinoColors.activeBlue,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;

    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: Color(0xFf1DD1B8),
            borderRadius: 10,
            borderLength: 80,
            borderWidth: 10,
            cutOutSize: scanArea,
          ),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              _pickQRCodeFromGallery();
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.image,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: GestureDetector(
            onTap: () {
              setState(() {
                controller!.pauseCamera();
                controller!.resumeCamera();
              });
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.qr_code_outlined,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
        )
      ],
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    ////print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p && !arkPermission) {
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No permission to access camera')),
      );*/
      setState(() {
        arkPermission = true;
      });
      showAboutDialog(context);
    }
  }

  showAboutDialog(context) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text("Permission Denied"),
          content: Text('Allow access to camera'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel')),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => openAppSettings(),
                child: Text('Settings')),
          ],
        ),
      );

  void _onQRViewCreated(QRViewController controller) {
    //print("===========create==============");
    setState(() {
      this.controller = controller;
      //this.controller!.resumeCamera();
    });

    controller.scannedDataStream.listen((scanData) {
      // //print(scanData.code);
      //if (scanData != null) {
      //controller.pauseCamera();

      //setState(() {

      //doQR(scanData.code);
      //controller.stopCamera();
      //return ;
      // registerCode = scanData.code;
      //});
      // }
    }).onData((data) async {
      controller.stopCamera();

      setState(() {
        doQR(data.code);
      });

      ////print("========================="+data.code);
    });
  }

//Gallery Picker
  Future<bool> _pickQRCodeFromGallery() async {
    XFile? pickedImageFile = null;
    try {
      pickedImageFile = await _picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      //print(e);
    }
    if (pickedImageFile != null) {
      //String rest = await FlutterQrReader.imgScan(pickedImageFile.path);
      await Scan.parse(pickedImageFile.path).then((value) {
        if (value != null) doQR(value);
      });

      /*await _getRole().then((value) {
        final responseBody = json.decode(value.data) as Map<String, dynamic>;
        if(value.responseCode == 200){

          setState(() {

            registerCode = rest;
            final body = responseBody['body'] as Map<String, dynamic>;
            message = "รหัสถูกต้อง";
            userType = body['userType'] as String;
            nameCompany = body['organizationName'] as String;
          });

        }else if (value.responseCode == 400){
          _showAlertDialog(context, responseBody['message'] as String);
        }else{

        }

      });*/

      ////print(rest);
      //return true ;

      /*if (registerCode == null) {
        _showAlertDialog(context, 'รูปแบบ QrCode ไม่ถูกต้อง');
        return false;
      } else {
        await _getRole();
      }

      if (message == "รหัสไม่ถูกต้อง") {
        _showAlertDialog(context, 'รหัสไม่ถูกต้อง');
      } else if (message == "รหัสถูกใช้ครบจำนวนแล้ว") {
        _showAlertDialog(context, 'รหัสถูกใช้ครบจำนวนแล้ว');
      } else if (message == "รูปแบบQRcodeไม่ถูกต้อง") {
        _showAlertDialog(context, 'รูปแบบQRcodeไม่ถูกต้อง');
      } else if (message == "รหัสหมดอายุ") {
        _showAlertDialog(context, 'รหัสหมดอายุ');
      } else if (message == "รหัสถูกต้อง") {
        ////print("---------------"+message);
        if(mounted){
          //Navigator.pop(context);

          return true ;
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TermScreen(
                  token: widget.token,
                  codeCompanyregister: registerCode,
                  userType: userType,
                  nameCompanyregister: nameCompany,
                )));

            /*Navigator.push(
              context,


            //);*/
          //}
        //);

        }

        message = "";
      }
*/
    }
    return true;
  }

  void _showAlertDialog(BuildContext context, String message) {
    showCupertinoDialog<void>(
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
          message,
          style: const TextStyle(
            color: CupertinoColors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text(
              "allow".i18n(),
              style: const TextStyle(
                color: CupertinoColors.activeBlue,
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () {
              message = "";
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAlertDialogWithScanCamera(
      BuildContext context, String message, QRViewController controller) {
    showCupertinoDialog<void>(
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
          message,
          style: const TextStyle(
            color: CupertinoColors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: Text(
              "allow".i18n(),
              style: const TextStyle(
                color: CupertinoColors.activeBlue,
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () {
              message = "";
              Navigator.pop(context);
              controller.resumeCamera();
            },
          ),
        ],
      ),
    );
  }

//returnbuild
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
                //print("back");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return LoginScreen();
                }));
              },
            ),
          ],
        ),
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          child: Text(
            "scanqrcodelabel".i18n(),
            style: const TextStyle(
              color: Color(0xFF118E7D),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              // No need to specify fontFamily, it will use the default font (Roboto).
            ),
          ),
        ),
        backgroundColor:
            Color(0xFF66F6E2), // You can change the background color here
      ),
      body: Column(
        children: [
          Expanded(
            flex: 13,
            child: _buildQrView(context),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[800],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "scanqrcodefor".i18n(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        // Remove the font family to use the default font (Roboto)
                        // fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
