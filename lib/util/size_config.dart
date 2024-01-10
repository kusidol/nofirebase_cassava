import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  static double AlertfontSize = 15;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;
  }
}

//h/w=1.9
//w/h=0.5

double scale = SizeConfig.screenHeight! / SizeConfig.screenWidth!;
double sizeHeight(double height, context) {
  if (scale >= 1.9) {
    return SizeConfig.screenHeight! * (height / 781.0909090909091);
  } else if (scale < 1.9) {
    return SizeConfig.screenHeight! * (height / 881.0909090909091);
  } else {
    return SizeConfig.screenHeight! * (height / 781.0909090909091);
  }
}

double sizeWidth(double width, context) {
  if (scale >= 1.9) {
    return SizeConfig.screenWidth! * (width / 392.72727272727275);
  } else if (scale < 1.9) {
    return SizeConfig.screenWidth! * (width / 492.72727272727275);
  } else {
    return SizeConfig.screenWidth! * (width / 392.72727272727275);
  }
}
