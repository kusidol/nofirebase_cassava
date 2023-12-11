import 'dart:io';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mun_bot/entities/enemy.dart';

import 'package:image_picker/image_picker.dart';
import 'package:mun_bot/util/ui/multi_search_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:mun_bot/env.dart';

final _colorBase = Color(0xFF645CAA);
TextEditingController humidityController = TextEditingController();

class BaseSurveySubPoint extends StatefulWidget {
  const BaseSurveySubPoint({Key? key}) : super(key: key);

  // String _param;

  // BaseSurveySubPoint(this._param);

  @override
  State<StatefulWidget> createState() => _BaseSurveySubPoint();
}

class _BaseSurveySubPoint extends State<BaseSurveySubPoint> {
  //final _floatingController = FloatingSearchBarController();

  bool isVisible = true;

  double _searchMargin = 55;

  List _loadSurvey = [];

  int _length = Random().nextInt(5);

  int _selectedView = 1;

  void clearParameter() {
    Provider.of<TabPassModel>(context, listen: false).passParameter("");
  }

  @override
  initState() {
    //("init");
    ////print(widget._param.parameter);
    ////print(widget._param.isEmpty);
    clearParameter();
    ////print(widget._param.isEmpty);
  }

  bool isSelected = false;
  double _himidityValue = 5;
  final picker = ImagePicker();
  var _image;
  String _pathImage = "";
  _getImage(ImageSource imageSource) async {
    //imageCache.clear();
    //var _imageFile = null;

    final _imageFile = await picker.pickImage(
        source: imageSource, maxWidth: 1920, maxHeight: 1080, imageQuality: 100
        //imageQuality: quality,
        );
//if user doesn't take any image, just return.
    if (_imageFile == null) {
      return null;
    }

    setState(
      () {
        _image = _imageFile;
        isSelected = true;
        //saveExperiment(_image) ;
        _pathImage = _image.path;
        GallerySaver.saveImage(_pathImage);
        //print(_pathImage);
        //_image = null ;
      },
    );
  }

  Widget _buildListOrGridView() {
    Widget _selectPopup() => PopupMenuButton<int>(
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 1,
                child: Icon(
                  Icons.list,
                  color: Colors.black87,
                )),
            PopupMenuItem(
              value: 2,
              child: Icon(
                Icons.grid_view,
                color: Colors.black87,
              ),
            ),
          ],
          initialValue: 0,
          onCanceled: () {
            //print("You have canceled the menu.");
          },
          onSelected: (value) {
            setState(() {
              _selectedView = value;
            });
          },
          icon: _selectedView == 1
              ? Icon(
                  Icons.list,
                  color: Colors.black87,
                )
              : Icon(Icons.grid_view, color: Colors.black87),
          offset: Offset(0, 65),
        );

    return Positioned(
      //top: SizeConfig.screenHeight!*0.075,
      right: 0,

      child: Container(
          height: SizeConfig.screenHeight! * 0.08705772811918063213387187943226,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0, //spread radius
                  blurRadius: 15, // blur radius
                  offset: Offset(10, 2))
            ],
            //color: Colors.grey
            //borderRadius: BorderRadius.circular(100),
          ),
          child: Card(child: _selectPopup())),
    );
  }

  Widget _buildListView() {
    String storyImage = 'assets/images/map.png';
    String surveyImage = 'assets/images/cassava_field.jpg';
    String userImage = 'assets/images/unknown_user.png';
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 20,
      itemBuilder: (context, index) {
        final int number_index = index + 1;
        final String number_index_string = "$number_index";
        return Card(
            elevation: 5,
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight! * 0.20,
              child: GestureDetector(
                // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) =>
                //         itemListNewScreen2(number_index: number_index_string))),
                child: AspectRatio(
                  aspectRatio: 1.6 / 2,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(padding: EdgeInsets.all(3)),
                            Container(
                              width: SizeConfig.screenWidth! * 0.35,
                              height: SizeConfig.screenHeight! *
                                  0.09401303538175046480431755840607,

                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.nature,
                                        color: theme_color4,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.screenWidth! *
                                            0.01024208566108007436869080934497,
                                      ),
                                      Text(
                                        'ต้นที่ : $number_index',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: SizeConfig.screenHeight! *
                                              0.02304469273743016732955432102619,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        color: theme_color4,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.screenWidth! *
                                            0.01024208566108007436869080934497,
                                      ),
                                      Text(
                                        "รูปทั้งหมด : $number_index",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: SizeConfig.screenHeight! *
                                              0.0204469273743016732955432102619,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // color: Colors.white,
                            ),
                            Spacer(),
                            Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        child: GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        itemListNewScreen2(
                                                            number_index:
                                                                number_index_string))),
                                            child: Row(children: [
                                              Hero(
                                                  tag: number_index_string,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              surveyImage),
                                                          fit: BoxFit.cover),
                                                    ),
                                                    width: SizeConfig
                                                            .screenWidth! *
                                                        0.40,
                                                    height: SizeConfig
                                                            .screenHeight! *
                                                        0.10,
                                                  )),
                                            ]))),
                                    Container(
                                      color: theme_color,
                                      child: IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          _getImage(ImageSource.camera);
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                        ),
                                      ),
                                      //color: Colors.black.withOpacity(0.2),
                                      width: SizeConfig.screenWidth! * 0.1,
                                      height: SizeConfig.screenHeight! * 0.10,
                                    ),
                                    Padding(padding: EdgeInsets.all(3)),
                                  ]),
                              //color: Colors.green.shade400,

                              width: SizeConfig.screenWidth! * 0.60,
                              height: SizeConfig.screenHeight! * 0.10,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "ระดับ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'OpenSans',
                                  fontSize: 18),
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            Container(
                                height: SizeConfig.screenHeight! * 0.07,
                                width: SizeConfig.screenWidth! * 0.05,
                                //width: SizeConfig.screenWidth! * 0.1,
                                child: TextField(
                                  controller: humidityController,
                                )),
                            SizedBox(
                              width: SizeConfig.screenWidth! * 0.025,
                            ),
                            Container(
                              width: SizeConfig.screenWidth! * 0.53,
                              child: SliderTheme(
                                data: SliderThemeData(
                                  thumbColor: theme_color2,
                                  overlayColor: theme_color,
                                  activeTrackColor: theme_color,
                                  inactiveTrackColor: Colors.purple.shade50,
                                  //thumbShape: RoundSliderThumbShape(
                                  //enabledThumbRadius: 10)
                                ),
                                child: Slider(
                                  min: 0,
                                  max: 5,
                                  divisions: 5,
                                  value: _himidityValue,
                                  onChanged: (value) {
                                    _himidityValue = value;
                                    setState(() {
                                      String t =
                                          ((((_himidityValue * 1000).ceil() /
                                                              1000) *
                                                          100)
                                                      .ceil() /
                                                  100)
                                              .toString()
                                              .substring(0, 1);
                                      humidityController.text = t;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }

  Widget _buildMultiSearchBar() {
    return Container(
      child: Card(
        child: Column(
          children: [
            MultiSearchView(
              right: 110,
              onDeleteAlternative: (value) {},
              onSearchComplete: (value) {},
              onSelectItem: (value) {},
              onItemDeleted: (value) {},
              onSearchCleared: (value) {},
            )
          ],
        ),
      ),
      decoration: new BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 0, //spread radius
              blurRadius: 50, // blur radius
              offset: Offset(2, 2))
        ],
      ),
    );
  }

  Widget _buildGridView() {
    String storyImage = 'assets/images/map.png';
    String userImage = 'assets/images/unknown_user.png';

    return GridView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        final int number_index = index + 1;
        return Container(
          // color: Colors.deepOrange, // กล่องอันเล็กๆ
          padding: EdgeInsets.all(2.5),
          width: SizeConfig.screenWidth! * 0.275,
          height: SizeConfig.screenHeight! * 0.275,
          child: GestureDetector(
            child: AspectRatio(
              aspectRatio: 1.6 / 2,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 2.3),
                        width: SizeConfig.screenWidth! * 0.275,
                        height: SizeConfig.screenHeight! * 0.155,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: AssetImage(storyImage), fit: BoxFit.cover),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                    Colors.black.withOpacity(.9),
                                    Colors.black.withOpacity(.1),
                                  ])),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // color: Colors.white,
                                child: Text(
                                  "$number_index",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 23),
                                ),
                                width: SizeConfig.screenWidth! *
                                    0.05121042830540037184345404672486,
                                height: SizeConfig.screenHeight! *
                                    0.03200651769087523240215877920304,
                                // color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 2.3, top: 3),
                        width: SizeConfig.screenWidth! * 0.275,
                        height: SizeConfig.screenHeight! *
                            0.03200651769087523240215877920304,
                        // color: Colors.white,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                        child: NumberInputPrefabbed.squaredButtons(
                          controller: TextEditingController(),
                          numberFieldDecoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          incDecBgColor: theme_color,
                          incIcon: Icons.add,
                          incIconSize: 22,
                          incIconColor: Colors.white,
                          decIcon: Icons.remove,
                          decIconSize: 22,
                          decIconColor: Colors.white,
                          buttonArrangement: ButtonArrangement.incRightDecLeft,
                          scaleWidth: 1,
                          min: 0,
                          max: 100,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
    );
  }

  Widget _buildSurveySubPointList() {
    return Container(
      // color: Colors.green,
      padding: EdgeInsets.only(top: 20),
      width: SizeConfig.screenWidth,
      height:
          SizeConfig.screenHeight! * 0.8, //แก้เพราะเพิ่มconatainer text survay
      child: _selectedView == 1 ? _buildListView() : _buildGridView(),
    );
  }

  Widget _buildBack() {
    return Positioned(
      bottom: SizeConfig.screenHeight! * 0.01,
      right: SizeConfig.screenWidth! * 0.01,
      child: GestureDetector(
        child: isVisible == true
            ? Container(
                //color:Colors.blue,
                width: 60,
                height: 60,
                child: SizedBox.fromSize(
                  size: Size(56, 56), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        //splashColor: Colors.green, // splash color
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => NewSurveyScreen()),
                          // );
                          Navigator.of(context).pop();
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              // Icons.add_location_alt_rounded,
                              Icons.arrow_back_rounded,
                              color: theme_color2,
                            ),
                            // icon
                            //Text("Add"), // text
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
            : Container(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text("การสำรวจโรคพืช"),
            toolbarHeight: SizeConfig.screenHeight! * 0.065,
            backgroundColor: theme_color,
            actions: <Widget>[_buildListOrGridView()],
          ),
          body: Column(children: [
            Stack(
              children: [
                _buildSurveySubPointList(),
              ],
            ),
          ])),
    );
  }
}

class itemListNewScreen2 extends StatelessWidget {
  final String number_index;

  const itemListNewScreen2({Key? key, required this.number_index})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: theme_color,
          title: Text("จุดย่อยที่ " + number_index),
          centerTitle: true,
        ),
        body: Hero(
          transitionOnUserGestures: true,
          tag: number_index,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildImage(),
            ],
          ),
        ),
      );

  Widget buildImage() {
    String surveyImage = 'assets/images/cassava_field.jpg';
    return AspectRatio(
        aspectRatio: 1,
        child: Container(
            child: Row(
              children: [],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(surveyImage), fit: BoxFit.cover),
            )));
  }
}
