import 'dart:async';
//import 'package:filter_list/filter_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/util/ui/search_item.dart';
import 'package:mun_bot/util/ui/searchable.dart';
import 'package:mun_bot/util/ui/user_list.dart';

enum SearchIndicatorShape { line, dot }

class MultiSearchView extends StatefulWidget {
  const MultiSearchView({
    Key? key,
    this.inputHint,
    this.iconColor,
    this.inputHintTextStyle,
    this.inputTextStyle,
    this.width,
    this.slidingAnimationDuration,
    this.searchIndicatorShape,
    this.indicatorColor,
    this.removeItemIconColor,
    this.searchableItemTextStyle,
    this.right,
    required this.onSelectItem,
    required this.onSearchComplete,
    required this.onDeleteAlternative,
    required this.onItemDeleted,
    required this.onSearchCleared,
  }) : super(key: key);
  final String? inputHint;
  final Color? iconColor;
  final TextStyle? inputHintTextStyle;
  final TextStyle? inputTextStyle;
  final double? width;
  final Duration? slidingAnimationDuration;
  final SearchIndicatorShape? searchIndicatorShape;
  final Color? indicatorColor;
  final Color? removeItemIconColor;
  final TextStyle? searchableItemTextStyle;
  final double? right;

  final Function onSelectItem;
  final Function onSearchComplete;
  final Function onDeleteAlternative;
  final Function onItemDeleted;
  final Function onSearchCleared;

  @override
  _MultiSearchViewState createState() => _MultiSearchViewState();
}

class _MultiSearchViewState extends State<MultiSearchView>
    with TickerProviderStateMixin {
  var showInput;
  late AnimationController _iconAnimationController;
  late StreamController<List<Searchable>> _streamList;
  late ScrollController _scrollController;
  var listSearch = <Searchable>[];
  late TextEditingController _inputController;
  late FocusNode _focusNode;
  bool isSearch = true;
  final ValueNotifier<bool> _isSearchIcon = ValueNotifier<bool>(true);

  List<User>? selectedUserList = [];

  @override
  void initState() {
    super.initState();
    _streamList = StreamController<List<Searchable>>();
    _iconAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _scrollController = new ScrollController();
    _inputController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: sizeHeight(40, context),
          width: (widget.width ?? MediaQuery.of(context).size.width) -
              sizeWidth(65, context) -
              widget.right!,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            controller: _scrollController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                width: (widget.width ?? MediaQuery.of(context).size.width) - 50,
                height: sizeHeight(30, context),
                child: StreamBuilder(
                    stream: _streamList.stream,
                    builder:
                        (context, AsyncSnapshot<List<Searchable>>? snapshot) {
                      return ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: ((snapshot != null && snapshot.data != null)
                                  ? ((snapshot.data?.isNotEmpty ?? false)
                                      ? (snapshot.data
                                          ?.map((e) => SearchItem(
                                                searchIndicatorShape:
                                                    widget.searchIndicatorShape,
                                                searchableItemTextStyle: widget
                                                    .searchableItemTextStyle,
                                                indicatorColor:
                                                    widget.indicatorColor,
                                                removeItemIconColor:
                                                    widget.removeItemIconColor,
                                                data: Searchable(
                                                    label: e.label,
                                                    isSelected: e.isSelected),
                                                onDelete: () async {
                                                  var pos = await removeItem(e);
                                                  widget.onItemDeleted(e.label);
                                                  if (pos > -1)
                                                    widget.onDeleteAlternative(
                                                        listSearch[pos].label);
                                                  //else
                                                  //  widget.onSearchCleared();
                                                },
                                                onSelect: (data) {
                                                  selectItem(e);
                                                  widget.onSelectItem(e.label);
                                                },
                                              ))
                                          .toList())
                                      : [])
                                  : []) ??
                              []);
                    }),
              ),
              Container(
                  padding: EdgeInsets.only(left: sizeWidth(20, context)),
                  width: (widget.width ?? MediaQuery.of(context).size.width) -
                      sizeWidth(60, context) -
                      widget.right!,
                  child: new TextField(
                      controller: _inputController,
                      onSubmitted: (value) {
                        if (selectedUserList!.length != 0) {
                          for (int index = 0;
                              index < selectedUserList!.length;
                              index += 1) {
                            _submitContent(
                                value + ' : ' + selectedUserList![index].name!);
                          }
                        } else
                          _submitContent(value);
                        widget.onSearchComplete(value);
                        clearFilter();
                      },
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintStyle: widget.inputHintTextStyle,
                          hintText: widget.inputHint ?? "Search",
                          suffixIcon: IconButton(
                              icon: Icon(Icons.list_alt_outlined,
                                  color: Colors.black),
                              onPressed: () {
                                //_openFilterDialog();
                              })),
                      style: widget.inputTextStyle ??
                          TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: sizeHeight(22, context))))
            ],
          ),
        ),
        Row(
          children: [
            Container(
              height: sizeHeight(40, context),
              width: sizeWidth(60, context),
              child: GestureDetector(
                onTap: () {
                  _iconAnimationController.forward();
                  isSearch ? startNewSearch() : exitSearch();
                  color:
                  widget.iconColor ?? Colors.black;
                },
                child: ValueListenableBuilder<bool>(
                    valueListenable: _isSearchIcon,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return Icon(
                        value ? Icons.search : Icons.close,
                        color: widget.iconColor ?? Colors.black,
                      );
                    }),
              ),
            )
          ],
        )
      ],
    );
  }

  /// update list when the user hit the keyboard search button
  Future<void> _submitContent(String value) async {
    await resetItemIndicator();
    listSearch
        .add(Searchable(label: value, isSelected: ValueNotifier<bool>(true)));
    _streamList.sink.add(listSearch);
    _isSearchIcon.value = true;
    _moveScrollToStart();
  }

  /// clear active indicator before setting the indicator position
  Future<void> resetItemIndicator() async {
    listSearch.forEach((e) {
      if (e.isSelected?.value == true) {
        e.isSelected?.value = false;
      }
    });
  }

  /// hide the TextField by scrolling the the end
  void _moveScrollToEnd() {
    isSearch = !isSearch;
    new Future.delayed(Duration(seconds: 0), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration:
              widget.slidingAnimationDuration ?? Duration(milliseconds: 800),
          curve: Curves.ease);
    });
  }

  /// show the TextField by scrolling the the beginning
  void _moveScrollToStart() {
    isSearch = !isSearch;
    new Future.delayed(Duration(seconds: 0), () {
      _scrollController
          .animateTo(_scrollController.position.minScrollExtent,
              duration: widget.slidingAnimationDuration ??
                  Duration(milliseconds: 800),
              curve: Curves.ease)
          .whenComplete(() => clearInputField());
    });
  }

  /// well this one is clear we just reset the input text :p
  clearInputField() {
    _inputController.text = '';
  }

  clearFilter() {
    selectedUserList?.clear();
  }

  /// removing an item for the search list after clicking on the delete icon
  Future<int> removeItem(Searchable e) async {
    var newPosition = -1;
    newPosition = await manageSwipeIndicator(e, newPosition);
    listSearch.remove(e);
    _streamList.sink.add(listSearch);
    return newPosition;
  }

  /// set the indicator to a new position after deleting an item
  Future<int> manageSwipeIndicator(Searchable e, int newPosition) async {
    if (listSearch.length > 1) {
      var deletedPosition = listSearch.indexOf(e);
      if (e.isSelected?.value == true) {
        if (deletedPosition == 0) {
          listSearch[1].isSelected = ValueNotifier<bool>(true);
          newPosition = 0;
        } else {
          newPosition = deletedPosition - 1;
          listSearch[newPosition].isSelected = ValueNotifier<bool>(true);
        }
      }
    }
    return newPosition;
  }

  /// this function will be triggered when you click on the search icon
  startNewSearch() {
    _isSearchIcon.value = false;
    _focusNode.requestFocus();
    _moveScrollToEnd();
  }

  /// this function will be triggered when you click on the exit icon
  exitSearch() {
    _isSearchIcon.value = true;
    clearInputField();
    _focusNode.unfocus();
    _moveScrollToStart();
    clearFilter();
  }

  /// switching to a new search when the user select a new item
  Future<void> selectItem(Searchable e) async {
    await resetItemIndicator();
    listSearch.firstWhere((item) {
      return e == item;
    })
      ..isSelected = ValueNotifier<bool>(true);
    _streamList.sink.add(listSearch);
  }

  @override
  void dispose() {
    _streamList.sink.close();
    _iconAnimationController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /*Future<void> _openFilterDialog() async {
    await FilterListDialog.display<User>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context),
      headlineText: 'Select Filter',
      height: 500,
      listData: userList,
      selectedListData: selectedUserList,
      choiceChipLabel: (item) => item!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (user, query) {
        return user.name!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedUserList = List.from(list!);
        });
        Navigator.pop(context);
      },
    );

  }*/
}
