import 'package:flutter/material.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/util/size_config.dart';

class ServerDownScreen extends StatelessWidget {
  const ServerDownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: sizeWidth(300, context),
                  height: sizeHeight(300, context),
                  child: Image.asset("assets/images/server_down.png")),
              SizedBox(
                width: SizeConfig.screenWidth! * 0.9,
                child: Text(
                  'ไม่สามารถเชื่อมต่อกับเซิฟเวอร์ได้ในขณะนี้ กรุณาลองใหม่ในภายหลัง',
                  style: TextStyle(fontSize: sizeHeight(20, context)),
                ),
              ),
              SizedBox(
                height: sizeHeight(50, context),
              ),
              // Text("TESTING SERVER DOWN"),
              InkWell(
                splashColor: Colors.yellow, // Customize the splash color
                highlightColor: Colors.orange,
                borderRadius: BorderRadius.circular(sizeHeight(15, context)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sizeHeight(15,
                          context)), // Adjust the value for different border radii
                      gradient: LinearGradient(
                        colors: [
                          theme_color,
                          theme_color2
                        ], // Customize your gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    width: sizeWidth(250, context),
                    height: sizeHeight(52, context),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Back to Login Screen",
                        style: TextStyle(fontSize: sizeHeight(20, context)),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
