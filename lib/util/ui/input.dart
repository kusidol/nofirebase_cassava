import 'package:flutter/material.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/util/ui/text_form_field.dart';

enum InputStatus { valid, invalid, none }

class AnimTFF extends StatefulWidget {
  final FormFieldValidator<String>? validator1;
  final bool? isOnlyNumber;
  final String labelText;
  final String successText;
  final String? errorText;
  final bool suffix;
  final Color errorColor;
  final Color successColor;
  final Color backgroundColor;
  final Color labelColor;
  final Icon successIcon;
  final Icon errorIcon;
  final Icon inputIcon;
  final void Function(String) textInput;
  final bool readyOnly;

  const AnimTFF(
    this.textInput, {
    Key? key,
    this.validator1,
    this.successIcon = const Icon(
      Icons.check,
      color: Colors.white,
    ),
    this.errorIcon = const Icon(
      Icons.warning,
      color: Colors.white,
    ),
    required this.inputIcon,
    required this.labelText,
    required this.successText,
    this.isOnlyNumber,
    this.errorText,
    this.suffix = true,
    this.errorColor = Colors.red,
    this.successColor = Colors.green,
    this.backgroundColor = Colors.white,
    this.labelColor = Colors.grey,
    this.readyOnly = false,
  }) : super(key: key);

  @override
  _AnimTFFState createState() => _AnimTFFState();
}

class _AnimTFFState extends State<AnimTFF> {
  InputStatus inputStatus = InputStatus.none;
  String? lableText;
  Border? border;
  Color? labelColor;
  FocusNode? focusNode;

  String? showError;
  String? get text => widget.labelText;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode()
      ..addListener(() {
        if (focusNode!.hasFocus && inputStatus == InputStatus.none) {
          setState(() {
            print(" focus on none");
            var color = Colors.deepPurple;
            border = getBorder(color);
            labelColor = color;
          });
        } else if (focusNode!.hasFocus && inputStatus == InputStatus.invalid) {
          print("-------focus on Invalid----");
          if (widget.errorText == null) {
            setState(() {
              var color = Colors.deepPurple;
              border = getBorder(color);
              lableText = null;
              inputStatus = InputStatus.none;
              showError = null;
            });
          }
        } else if (focusNode!.hasFocus && inputStatus == InputStatus.valid) {
          print("-------focus on valid----");
          if (widget.errorText == null) {
            setState(() {
              var color = Colors.deepPurple;
              border = getBorder(color);
              showError = null;
              inputStatus = InputStatus.none;
            });
          }
        }
      });
    setInputDetails();
  }

  @override
  void dispose() {
    focusNode?.dispose();

    super.dispose();
  }

  String? validator(String? text) {
    print("validate now");
    String? error;
    if (widget.validator1 == null) return null;

    if (widget.validator1!(text) != null)
      showError = widget.validator1!(text) as String;
    InputStatus inst;
    if (showError == null) {
      inst = InputStatus.valid;
    } else {
      inst = InputStatus.invalid;
    }

    if (inst != inputStatus) {
      inputStatus = inst;
      setInputDetails(showError);
      setState(() {});
    }

    return showError;
  }

  Border getBorder(Color color) {
    return Border.all(width: sizeWidth(3, context), color: color);
  }

  void setInputDetails([String? error]) {
    switch (inputStatus) {
      case InputStatus.invalid:
        var color = widget.errorColor;
        lableText = showError;
        border = getBorder(color);
        labelColor = color;
        break;
      case InputStatus.valid:
        var color = widget.successColor;
        lableText = lableText;
        border = getBorder(color);
        labelColor = color;
        break;
      // case InputStatus.active:
      //   var color = widget.labelColor;
      //   lableText = null;
      //    border = getBorder(Colors.white);
      //   showError=null;
      //   break;
      default:
        labelColor = widget.labelColor;
        lableText = widget.labelText;
        border = getBorder(Colors.white);
        showError = null;
    }
  }

  final fieldText = TextEditingController();

  void clearText() {
    fieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    print("showError : ${showError}");
    print(" label Text : ${lableText}");
    // if(widget.errorText ){
    //   inputStatus=InputStatus.none;
    //   setInputDetails(showError);
    // }
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: border =
            Border.all(width: sizeWidth(2, context), color: theme_color4),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (!widget.suffix) getInputIcon(),
            Expanded(
              child: widget.isOnlyNumber == true
                  ? CTextFormField(
                      readOnly: widget.readyOnly,
                      keyboardType: TextInputType.number,
                      controller: fieldText,
                      focusNode: focusNode,
                      onChanged: (text) {
                        widget.textInput(text);
                      },
                      onTap: () {
                        if (validator(text) != null) {
                          clearText();
                        }
                      },
                      decoration: InputDecoration(
                          // errorText: showError,
                          border: InputBorder.none,
                          labelText: lableText,
                          labelStyle: TextStyle(color: labelColor),
                          contentPadding:
                              EdgeInsets.all(sizeHeight(10, context))),
                      validator: validator,
                    )
                  : CTextFormField(
                      readOnly: widget.readyOnly,
                      controller: fieldText,
                      focusNode: focusNode,
                      onChanged: (text) {
                        widget.textInput(text);
                      },
                      onTap: () {
                        if (validator(text) != null) {
                          clearText();
                        }
                      },
                      decoration: InputDecoration(
                          // errorText: showError,
                          border: InputBorder.none,
                          labelText: lableText,
                          labelStyle: TextStyle(color: labelColor),
                          contentPadding:
                              EdgeInsets.all(sizeHeight(10, context))),
                      validator: validator,
                    ),
            ),
            if (widget.suffix) getInputIcon()
          ],
        ),
      ),
    );
  }

  Widget getInputIcon() {
    return SizedBox(
      width: sizeWidth(50, context),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          widget.inputIcon,
          buildIcon(
            inputStatus == InputStatus.invalid,
            widget.errorColor,
            widget.errorIcon,
          ),
          buildIcon(
            inputStatus == InputStatus.valid,
            widget.successColor,
            widget.successIcon,
          )
        ],
      ),
    );
  }

  Widget buildIcon(bool shouldAnimate, Color color, Icon icon,
      [Curve curve = Curves.fastOutSlowIn]) {
    final double animVal = shouldAnimate ? 0 : -50;
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      right: widget.suffix ? animVal : null,
      top: 0,
      left: widget.suffix ? null : animVal,
      bottom: 0,
      curve: curve,
      child: Container(
          width: sizeWidth(50, context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(sizeHeight(16, context)),
              //left: Radius.circular(15),
              // right: Radius.circular(20),
            ),
            color: color,
          ),
          child: icon),
    );
  }
}
