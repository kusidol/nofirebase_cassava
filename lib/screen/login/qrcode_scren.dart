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
import 'package:scan/scan.dart';
import 'package:mun_bot/screen/login/staff_register_screen.dart';
import 'package:mun_bot/screen/main_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
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
class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isCameraInitialized = false;
  bool arkPermission = false ;
  String? registerCode;
  String message = "";
  String userType = "";
  String nameCompany = "";

  @override
  void initState() {
    super.initState();
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

void didChangeAppLifecycleState(AppLifecycleState state) async {
  if (state == AppLifecycleState.resumed) {
    final granted = await Permission.camera.isGranted;
    if (granted && controller != null) {
     // Check if the controller is not null before using it
      controller!.resumeCamera();
    } else {
      // If the camera permission is not granted, you may want to handle it
      // You might want to show an error message or navigate to a different screen
    }
  }
}


  Future<void> _getRole() async {
    final String? token = widget.token;
    final Service service = Service();
    try {
      final response = await service.doGet(
          '$LOCAL_SERVER_IP_URL/register/$registerCode', token.toString());
      final responseBody = json.decode(response.data) as Map<String, dynamic>;
      print(responseBody);
      if (responseBody['status'] == 400) {
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
      }
    } catch (error) {
      showAlert(context);
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
      ],
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p)  {
    //print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p && !arkPermission) {
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No permission to access camera')),
      );*/
      setState(() {
        arkPermission = true ;
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
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      if (scanData != null) {
        controller.pauseCamera();
        setState(() {
          registerCode = scanData.code;
        });
      }
      await _getRole();

      if (message == "รหัสไม่ถูกต้อง") {
        _showAlertDialogWithScanCamera(context,  "invalidcode".i18n(), controller);
      } else if (message == "รูปแบบQRcodeไม่ถูกต้อง") {
        _showAlertDialogWithScanCamera(
            context,  "formatqrcoderror".i18n(), controller);
      } else if (message == "รหัสถูกใช้ครบจำนวนแล้ว") {
        _showAlertDialogWithScanCamera(
            context, "fullcode".i18n(), controller);
      } else if (message == "รหัสหมดอายุ") {
        _showAlertDialogWithScanCamera(context,  "dateoutcode".i18n(), controller);
      } else if (message == "รหัสถูกต้อง") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TermScreen(
              token: widget.token,
              codeCompanyregister: registerCode,
              userType: userType,
              nameCompanyregister: nameCompany,
            ),
          ),
        );
        controller.resumeCamera();
      }
      message = "";
    });
  }

//Gallery Picker
  Future<void> _pickQRCodeFromGallery() async {
    QRViewController controller;
    var pickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      registerCode = await Scan.parse(pickedImageFile.path);
      if (registerCode == null) {
        _showAlertDialog(context, "formatqrcoderror".i18n());
        return;
      } else {
        await _getRole();
      }
      if (message == "รหัสไม่ถูกต้อง") {
        _showAlertDialog(context, "invalidcode".i18n());
      } else if (message == "รหัสถูกใช้ครบจำนวนแล้ว") {
        _showAlertDialog(context, "fullcode".i18n());
      } else if (message == "รูปแบบQRcodeไม่ถูกต้อง") {
        _showAlertDialog(context,  "formatqrcoderror".i18n());
      } else if (message == "รหัสหมดอายุ") {
        _showAlertDialog(context, "dateoutcode".i18n());
      } else if (message == "รหัสถูกต้อง") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TermScreen(
              token: widget.token,
              codeCompanyregister: registerCode,
              userType: userType,
              nameCompanyregister: nameCompany,
            ),
          ),
        );
        message = "";
      }
    }
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
                print("back");
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
