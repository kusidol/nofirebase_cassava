import 'package:flutter/material.dart';
import '../app-scale.dart';

class CustomSigInButton extends StatelessWidget {

  CustomSigInButton.mini({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.color,
    this.fontScale,
    this.bgColor,
    this.icon,
    this.shape,

  }) : mini = true;


  CustomSigInButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.width,
      this.height,
      this.color,
      this.bgColor,
      this.fontScale,
      this.shape,
      this.icon,})
      //: super(key: key);
        : mini = false;

  final double? width;
  final double? height;
  final Color? color;
  final fontScale;
  final Color? bgColor;
  final Widget? icon;
  final String? text;
  final VoidCallback onPressed;
  final OutlinedBorder? shape;
  bool mini;

  Widget build(BuildContext context) {
    double? width = this.width;
    double? height = this.height;
    AppScale scale = AppScale(context);
    Text text =
        Text(this.text!, style: TextStyle(fontSize: scale.ofHeight(fontScale)));

    if (this.width != null && this.width! <= 1) {
      width = scale.ofWidth(this.width!);
    }

    if (this.height != null && this.height! <= 1) {
      height = scale.ofHeight(this.height!);
    }

    return /*MaterialButton(
        color: Colors.blue,

        shape: shape ?? StadiumBorder(),
        child: Container(
          width: width,

          child: Row(

            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(6),
                child: _text(),
              ),

            ],
          ),
        ),

    );*/

      !mini ? Container(
                width: width,
                height: height,
                margin: EdgeInsets.all(scale.ofHeight(0.011)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: color,
                      onPrimary: bgColor,
                      shape: shape ?? RoundedRectangleBorder(),
                  ),

                  child: icon == null
                      ? text
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Padding(
                                child: icon,
                                padding:
                                    EdgeInsets.all(6),
                              ),
                              text
                            ]),
                  onPressed: onPressed,
                )
              )
          :Container(
              padding: EdgeInsets.all(4),
              width: 70,
              height: 70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: color,
                  shape: CircleBorder(),
                ),

                child: icon,
                onPressed: onPressed,

              ),
          ) ;
  }

  Widget _text() {
    return Text(
      "Test",
      style: TextStyle(
        fontSize: 20,

      ),
    );
  }
}
