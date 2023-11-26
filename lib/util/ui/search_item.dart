import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/util/ui/multi_search_flutter.dart';
import 'package:mun_bot/util/ui/searchable.dart';

class SearchItem extends StatefulWidget {
  const SearchItem(
      {Key? key,
      required this.data,
      this.searchIndicatorShape,
      this.indicatorColor,
      this.removeItemIconColor,
      this.searchableItemTextStyle,
      required this.onDelete,
      required this.onSelect})
      : super(key: key);
  final Searchable data;
  final SearchIndicatorShape? searchIndicatorShape;
  final Color? indicatorColor;
  final Color? removeItemIconColor;
  final TextStyle? searchableItemTextStyle;
  final Function onDelete;
  final Function onSelect;

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  @override
  Widget build(BuildContext context) {
    double width = (widget.data.label!.length) * 15;
    width = width < 50 ? 50 : width;
    double underline = (widget.data.label!.length) * 9.25;

    return Card(
      child: Container(
        width: width,
        height: sizeHeight(50, context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: sizeHeight(10, context),
            ),
            GestureDetector(
              onTap: () {
                widget.data.isSelected?.value =
                    !(widget.data.isSelected?.value ?? false);
                widget.onSelect(widget.data);
              },
              child: Row(
                children: [
                  SizedBox(
                    width: sizeWidth(10, context),
                  ),
                  Text(
                    widget.data.label ?? '',
                    style: widget.searchableItemTextStyle ??
                        TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: sizeWidth(4, context),
                  ),
                  InkWell(
                      onTap: () {
                        widget.onDelete();
                      },
                      child: Icon(
                        Icons.close,
                        size: sizeHeight(15, context),
                        color: widget.removeItemIconColor,
                      ))
                ],
              ),
            ),
            SizedBox(
              height: sizeHeight(5, context),
            ),
            ValueListenableBuilder<bool>(
                valueListenable:
                    widget.data.isSelected ?? ValueNotifier<bool>(false),
                builder: (BuildContext context, bool value, Widget? child) {
                  return Visibility(
                    visible: value,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          height: sizeHeight(3, context),
                          width: widget.searchIndicatorShape != null
                              ? (widget.searchIndicatorShape?.index ==
                                      SearchIndicatorShape.dot.index
                                  ? 7
                                  : 20)
                              : underline,
                          decoration: BoxDecoration(
                              color: widget.indicatorColor ??
                                  Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(sizeHeight(10, context)))),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
        decoration: BoxDecoration(shape: BoxShape.circle),
      ),
    );
  }
}
