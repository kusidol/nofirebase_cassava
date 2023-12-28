import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/farmer_service.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/providers/farmer_dropdown_provider.dart';
import 'package:mun_bot/screen/field/create_user_screen.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/screen/widget/no_data.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class DropdownForFarmer extends StatefulWidget {
  final Function myVoidCallback;
  const DropdownForFarmer(this.myVoidCallback, {Key? key}) : super(key: key);

  @override
  State<DropdownForFarmer> createState() => _DropdownForFarmerState();
}

class _DropdownForFarmerState extends State<DropdownForFarmer> {
  // SET UP
  String selectedFirstName = "first-name".i18n();
  String selectedLastName = "last-name".i18n();
  String selectedProvinceAddress = "province-address".i18n();
  String firstNameValue = '';
  String lastNameValue = '';
  String provinceAddressValue = '';
  void _handleSearchButton(DropdownFarmer dropdownFarmer) async {
    //call Service
    FarmerService farmerService = new FarmerService();
    String? token = tokenFromLogin?.token;
    Map<String, dynamic> jsonData = {
      "firstName": firstNameValue,
      "lastName": lastNameValue,
      "provinceAddress": provinceAddressValue,
    };
    // log("SEARCH ${jsonData}");
    List<Map<String, dynamic>> data = await farmerService.searchFarmerByKey(
        firstNameValue, lastNameValue, provinceAddressValue, token.toString());
    dropdownFarmer.updateItemsWithSearch(data);
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: theme_color2,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(1),
              offset: const Offset(0, 2),
              blurRadius: sizeWidth(8, context)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: sizeWidth(8, context),
          right: sizeWidth(8, context),
        ),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + sizeHeight(1, context),
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(sizeHeight(32, context)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: sizeHeight(8, context),
                        top: sizeHeight(8, context),
                        right: 0,
                        bottom: sizeHeight(8, context)),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                // alignment: Alignment.,
                child: Text(
                  'select-owner'.i18n(),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sizeHeight(22, context),
                      color: Colors.white),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + sizeHeight(40, context),
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeWidth(32, context)),
                      ),
                      onTap: () {
                        // Create User
                        //print("CREATE USER IN FIELD");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateUserScrenn()),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(sizeWidth(8, context)),
                        child: Icon(
                          Icons.group_add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return DropdownFarmer();
          },
        )
      ],
      child: Consumer<DropdownFarmer>(
        builder: (context, dropdownFarmer, index) {
          return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(sizeHeight(65, context)),
                child: getAppBarUI()),
            body: Container(
              decoration: dropdownFarmer.isScroll
                  ? BoxDecoration()
                  : BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/newScroll.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
              child: Column(
                children: [
                  ExpansionTile(
                      textColor: Colors.black,
                      iconColor: theme_color2,
                      title: Text('search-more'.i18n(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      onExpansionChanged: (bool isExpanded) {
                        if (!isExpanded) {
                          //print('Hello World');
                        } else {
                          //print('Save Value');
                        }
                      },
                      leading: Icon(Icons.perm_contact_calendar_outlined),
                      subtitle: Text(selectedFirstName +
                          " " +
                          selectedLastName +
                          " " +
                          selectedProvinceAddress),
                      children: [
                        Container(
                          color: Colors.tealAccent[50],
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: selectedFirstName,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    firstNameValue = value;
                                  });
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: selectedLastName,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    lastNameValue = value;
                                  });
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: selectedProvinceAddress,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    provinceAddressValue = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 2, left: 20, right: 20, bottom: 20),
                          height: 50.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              //side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))
                            ),
                            onPressed: () {
                              _handleSearchButton(dropdownFarmer);
                            },
                            padding: EdgeInsets.all(10.0),
                            color: theme_color2,
                            textColor: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "search".i18n(),
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(width: 5.0),
                                Icon(Icons.search),
                              ],
                            ),
                          ),
                        )
                      ]),
                  Expanded(
                    child: NotificationListener<ScrollEndNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          //print('เลื่อนสุดขอบหน้าจอแล้ว');
                          if (dropdownFarmer.scroll) {
                            dropdownFarmer.fetchData();
                            dropdownFarmer.isScroll = true;
                          }
                          // if (dropdownFarmer.isAllItem) {
                          //   showToastMessage(
                          //       "ข้อมูลแสดงครบทั้งหมดเป็นที่เรียบร้อยแล้ว");
                          // }
                        }
                        return true;
                      },
                      child: dropdownFarmer.dropdownSearch
                          ? ListView.builder(
                              itemCount: dropdownFarmer.farmerString.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Text('owner'.i18n() +
                                        " : ${dropdownFarmer.farmerString[index]}"),
                                    // subtitle:
                                    // Text('ID : ${dropdownFarmer.items[index].id}'),
                                    onTap: () {
                                      Map<String, dynamic> data = {
                                        'nameFarmer':
                                            dropdownFarmer.farmerString[index],
                                        'id': dropdownFarmer.items[index].id,
                                      };
                                      widget.myVoidCallback(data);

                                      Navigator.pop(context, false);
                                    },
                                  ),
                                );
                              },
                            )
                          : NoData().showNoData(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
