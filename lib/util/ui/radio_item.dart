import 'package:flutter/material.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/util/size_config.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final Widget? title;
  final ValueChanged<T?> onChanged;

  const MyRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    this.title,
  });

  get context => null;

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        height: sizeHeight(56, context),
        padding: EdgeInsets.symmetric(horizontal: sizeWidth(16, context)),
        child: Row(
          children: [
            _customRadioButton,
            SizedBox(width: sizeWidth(12, context)),
            if (title != null) title,
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: sizeWidth(12, context), vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? theme_color4 : null,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? theme_color4 : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Text(
        leading,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[600]!,
          fontWeight: FontWeight.bold,
          fontSize: sizeHeight(18, context),
        ),
      ),
    );
  }
}
