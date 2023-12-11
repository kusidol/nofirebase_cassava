import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mun_bot/providers/fieldService_provider.dart';

import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/env.dart';
import '../../main.dart';
import 'dart:developer';
import 'package:mun_bot/screen/login/login_screen.dart';

class dropdownForServiceAPI extends StatefulWidget {
  const dropdownForServiceAPI({Key? key}) : super(key: key);

  @override
  State<dropdownForServiceAPI> createState() => _dropdownForServiceAPIState();
}

class _dropdownForServiceAPIState extends State<dropdownForServiceAPI> {
  int pageService = 1;
  List<String> fieldItemsForDropdown = [];
  List<Field> listFieldOnUser = [];

  String? selectedIndex = "";

  @override
  void initState() {
    super.initState();
    asyncFunction();
  }

  asyncFunction() async {
    FieldService fieldService = new FieldService();
    String? token = tokenFromLogin?.token;
    List<Field> data =
        await fieldService.getFields(token.toString(), pageService, 2);
    //print("data = ${data.length}");
    List<String> test = [];
    data.forEach((e) {
      test.add(e.fieldID.toString());
    });
    if (mounted) {
      setState(() {
        fieldItemsForDropdown = test;
        listFieldOnUser = data;
      });
    }
  }

  Future<void> fetchData() async {
    //print("Before PageService : ${pageService}");
    pageService++;
    //print("After PageService : ${pageService}");

    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;
    List<Field> data =
        await fieldService.getFields(token.toString(), pageService, 2);
    List<String> test = [];
    data.forEach((e) {
      test.add(e.fieldID.toString());
    });

    setState(() {
      fieldItemsForDropdown.addAll(test);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dropdown for field services'),
        ),
        body: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.extentAfter == 0) {
                fetchData();
              }
              return true;
            },
            child: ListView.builder(
                itemCount: fieldItemsForDropdown.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text(fieldItemsForDropdown[index]),
                      onTap: () {
                        selectedIndex = fieldItemsForDropdown[index];
                        //print("selectedIndex : ${selectedIndex}");
                        Navigator.pop(context,
                            selectedIndex); // ส่งค่า selectedIndex กลับไปยังหน้าก่อนหน้า
                      },
                    ),
                  );
                })));
  }
}
