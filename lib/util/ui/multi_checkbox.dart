import 'package:flutter/material.dart';

class MyCheckBox extends StatefulWidget {
  final String title;
  final ValueChanged<bool> onChanged;
  
  const MyCheckBox({Key? key, required this.title, required this.onChanged}) : super(key: key);

  @override
  _MyCheckBoxState createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  bool isChecked = false;
  List<String> _checkedItems = [];
  
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: isChecked,
      onChanged: (value) {
        setState(() {
          isChecked = value!;
          widget.onChanged(value);
        });
      },
    );
  }
}