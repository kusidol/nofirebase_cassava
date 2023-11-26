import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:localization/localization.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/screen/widget/no_data.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import '../main.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  // late List<String> notifications;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  late GlobalKey<RefreshIndicatorState> refreshKey;
  late Random r;
  String? token;
  late List<Map<String, dynamic>> messageItems = [];

  @override
  void initState() {
    super.initState();
    token = tokenFromLogin?.token;
    //print(token);
    refreshKey = GlobalKey<RefreshIndicatorState>();
    r = Random();
    messageItems = [];
    // notifications = [];
    // addNotifications();
    // messageItems = [];
    // getAllmessage();
  }

  Future<void> getAllmessage() async {
    Service service = Service();
    var response = await service.doGet(
        "$LOCAL_SERVER_IP_URL/messagereceiver/", token.toString());
    // print(response);
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.data);
      if (responseBody['status'] == 200) {
        List<dynamic> messages = responseBody['body'];
        for (var message in messages) {
          Map<String, dynamic> saveMessage = {
            'sendDate': message['sendDate'],
            'title': message['title'],
            'text': message['text'],
            'type': message['type'],
            'messageId': message['messageId'],
            'readStatus': message['readStatus'],
            'sender': message['sender'],
            'receiver': message['receiver'],
          };
          messageItems.add(saveMessage);
        }

        messageItems.forEach((item) => print(item));
      }
    }
  }

  Future<void> sendIdReadmessage(int messageId) async {
    print(messageId);
    String sendID = messageId.toString();
    Service service = Service();
    var response = await service.doPostWithFormData(
        "$LOCAL_SERVER_IP_URL/messagereceiver/messages/" + sendID,
        token.toString(),
        messageId);
    print(response);
    if (response.statusCode == 200) {
      print("Success send ReaderID");
    } else {
      print("Error send ReaderID");
    }
  }

  Future<void> deleteMessage(int messageId) async {
    print(messageId);
    var jsonBody = {
      "messageId": messageId,
    };
    String deleteID = messageId.toString();
    Service service = Service();
    var response = await service.delete(
        "$LOCAL_SERVER_IP_URL/messagereceiver/", token.toString(), jsonBody);
    print(response);
    if (response.statusCode == 200) {
      print("Success delete Message");
    } else {
      print("Error delete Message");
    }
  }

  Future<Null> refreshList() async {
    // Simulate a delay of 1 second
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      messageItems = [];
    });

    return null;
  }

  Widget refreshBg() {
    return Container(
      alignment: Alignment.centerRight,
      padding:
          EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.0256),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  Widget list() {
    double _w = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      onRefresh:
          refreshList, // Call refreshList when the refresh action is triggered
      child: ListView.builder(
        padding: EdgeInsets.all(_w * 0.0051),
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: messageItems.length,
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            delay: Duration(milliseconds: 100),
            child: SlideAnimation(
              duration: Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              child: FadeInAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                duration: Duration(milliseconds: 2500),
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: _w / MediaQuery.of(context).size.height * 0.108,
                  ),
                  child: row(context, index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget row(context, index) {
    final message = messageItems[index];
    final title = message['title'];
    final sender = message['sender'];
    final info = message['text'];
    String date = DateFormat("dd/MM/yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(message['sendDate']));
    final String senderFirstText = sender.substring(0, 1).toUpperCase();

    return Dismissible(
      key: Key(
          (message['messageId']).toString()), // Use a unique key for each item
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red, // Background color when swiping
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),

      onDismissed: (direction) async {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("comfirm-delete-title".i18n()),
            content: Text('comfirm-delete-message'.i18n()),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    {Navigator.pop(context, 'Cancel'), refreshList()},
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pop(context, 'OK'),
                  deleteMessage(message['messageId'])
                },
                child: Text('OK'),
              ),
            ],
          ),
        );

        // Update the UI by removing the item from the list
        // setState(() {
        //   messageItems.removeAt(index);
        // });
      },

      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: title,
                descriptions: info,
                senderFirstText: senderFirstText,
                sendDate: date.toString(),
                sender: sender,
                text: 'back'.i18n(),
                refreshCallback: refreshList,
              );
            },
          );
          sendIdReadmessage(message['messageId']);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.height * 0.0064,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.height * 0.0102,
            ),
            child: ListTile(
              leading: Container(
                width: sizeWidth(50, context),
                height: sizeWidth(50, context),
                decoration: BoxDecoration(
                  color: Color(0xFFEE6910).withOpacity(1.0),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    senderFirstText,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sender,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: message['readStatus'] == 'Y' ? Colors.grey : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      date.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: message['readStatus'] == 'Y'
                              ? Colors.grey
                              : null),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: theme_color,
            ),
          ),
          ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme_color2.withOpacity(.5),
                      theme_color3.withOpacity(.5),
                      theme_color4.withOpacity(.9),
                      Colors.white.withOpacity(.8),
                      Colors.white.withOpacity(1),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.height * 0.032),
                        child: Column(
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.032,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.white,
                                            size: sizeHeight(20, context),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.178),
                                  Column(
                                    children: [
                                      Text(
                                        "notification-label".i18n(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.030,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.032,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.019),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.2,
                            color: Colors.grey[100],
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.0192,
                                    left: MediaQuery.of(context).size.height *
                                        0.0128,
                                    right: MediaQuery.of(context).size.height *
                                        0.0128),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.2,
                                        child: RefreshIndicator(
                                          key: refreshKey,
                                          onRefresh: () async {
                                            await refreshList();
                                          },
                                          child: FutureBuilder(
                                            future: getAllmessage(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                    'Error occurred: ${snapshot.error}',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                if (messageItems.isEmpty) {
                                                  return Center(
                                                    child: NoData()
                                                        .showNoData(context),
                                                  );
                                                } else {
                                                  return list();
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 50;
}

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text, senderFirstText, sender, sendDate;
  final Function refreshCallback;
  const CustomDialogBox({
    Key? key,
    required this.title,
    required this.descriptions,
    required this.text,
    required this.sender,
    required this.sendDate,
    required this.senderFirstText,
    required this.refreshCallback,
  }) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  void onDialogDismissed() {
    // Perform your desired function here
    print("Dialog dismissed");
    // Call other functions or update state as needed
  }

  @override
  void dispose() {
    // Call your function here when the dialog is dismissed
    performFunctionOnDialogDismissed();

    super.dispose();
  }

  void performFunctionOnDialogDismissed() {
    // Implement your function logic here
    print('Dialog dismissed. Performing function...');
    widget.refreshCallback();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: 35,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Color(0xFF4F4E4E),
                    offset: Offset(0, 10),
                    blurRadius: sizeHeight(10, context)),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                  widget.sendDate,
                  style: TextStyle(
                      fontSize: sizeHeight(12, context),
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFBDBDBD)),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                child: Text(
                  widget.sender,
                  style: TextStyle(
                      fontSize: sizeHeight(12, context),
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFBDBDBD)),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: sizeHeight(10, context)),
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: sizeHeight(16, context),
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: sizeHeight(10, context)),
                child: Text(
                  widget.descriptions,
                  style: TextStyle(fontSize: sizeHeight(14, context)),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                color: theme_color4,
                margin: EdgeInsets.only(top: sizeHeight(20, context)),
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: sizeWidth(100, context),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                sizeHeight(20, context)), // Add circular border
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.text,
                          style: TextStyle(
                              fontSize: sizeHeight(18, context),
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: Container(
              width: sizeWidth(50, context),
              height: sizeWidth(50, context),
              decoration: BoxDecoration(
                color: Color(0xFFEE6910).withOpacity(1.0),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.senderFirstText,
                  style: TextStyle(
                      color: Colors.white, fontSize: sizeHeight(25, context)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
