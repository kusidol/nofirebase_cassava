import 'package:flutter/material.dart';
import 'package:mun_bot/util/size_config.dart';

class ServerDownScreen extends StatelessWidget {
  const ServerDownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/ErrorNetwork.png"),
              Text("TESTING SERVER DOWN"),
              ElevatedButton(
                  onPressed: () =>
                      {Navigator.pop(context), Navigator.pop(context)},
                  child: Row(
                    children: [
                      Icon(Icons.backspace),
                      Text(
                        "Back to Login Screen",
                        style: TextStyle(fontSize: sizeHeight(20, context)),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
