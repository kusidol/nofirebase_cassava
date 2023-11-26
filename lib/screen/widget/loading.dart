import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CustomLoading {
  static void showLoading() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.dark
      ..maskType = EasyLoadingMaskType.black
      ..backgroundColor = Colors.black
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..dismissOnTap = false;
    EasyLoading.show(
      status: 'loading...',
    );
  }

  static void showSuccess() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..maskType = EasyLoadingMaskType.black
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..dismissOnTap = true;
    EasyLoading.showSuccess('Success!');
  }

  static void showError(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Error', style: TextStyle(color: Colors.white)),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: Text(errorMessage, style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                // Perform the action when the "Try Again" button is pressed
                Navigator.of(context).pop();
              },
              child: Text('Try Again', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                // Perform the action when the "Exit" button is pressed
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Exit', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  static void dismissLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      EasyLoading.dismiss();
    });
  }
}
