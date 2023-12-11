// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:localization/src/localization_extension.dart';
// import 'package:mun_bot/env.dart';
// import 'package:mun_bot/screen/app_styles.dart';
// import 'package:mun_bot/screen/home/base_home_screen.dart';
// import 'package:mun_bot/screen/menuscreen/menu_screen.dart';
// import 'package:mun_bot/util/size_config.dart';
// import 'package:mun_bot/screen/surveys_serch/survey_search_screen.dart';
// import 'package:mun_bot/screen/widget/search_widget.dart';
// import 'package:mun_bot/controller/field_service.dart';
// import 'package:mun_bot/controller/planting_service.dart';
// import '../../entities/field.dart';
// import '../../entities/planting.dart';
// import 'package:mun_bot/screen/login/login_screen.dart';
// import '../main_screen.dart';

// class SizeTransition1 extends PageRouteBuilder {
//   final Widget page;

//   SizeTransition1(this.page)
//       : super(
//           pageBuilder: (context, animation, anotherAnimation) => page,
//           transitionDuration: Duration(milliseconds: 1000),
//           reverseTransitionDuration: Duration(milliseconds: 200),
//           transitionsBuilder: (context, animation, anotherAnimation, child) {
//             animation = CurvedAnimation(
//                 curve: Curves.fastLinearToSlowEaseIn,
//                 parent: animation,
//                 reverseCurve: Curves.fastOutSlowIn);
//             return Align(
//               alignment: Alignment.bottomCenter,
//               child: SizeTransition(
//                 sizeFactor: animation,
//                 child: page,
//                 axisAlignment: 0,
//               ),
//             );
//           },
//         );
// }

// //on tap to new page
// class DetailScreen extends StatelessWidget {
//   // In the constructor, require a Todo.
//   // ignore: use_key_in_widget_constructors
//   const DetailScreen({required this.fields});

//   // Declare a field that holds the Todo.
//   final Field fields;

//   @override
//   Widget build(BuildContext context) {
//     // Use the Todo to create the UI.
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('survey-more-detail-label'.i18n()),
//         centerTitle: true,
//         backgroundColor: theme_color,
//       ),
//       body: Container(
//         child: Container(
//             //color: kDarkBlue,
//             height: 600,
//             width: 600,
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   color: Colors.white38,
//                   child: Column(children: [
//                     Row(
//                       children: [
//                         Text(
//                           'ID'.i18n() + ' : ' + fields.fieldID.toString(),
//                           style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                           ),
//                         )
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           'Name'.i18n() + ' : ' + fields.name,
//                           style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                           ),
//                         )
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           'Address'.i18n() + ' : ' + fields.address,
//                           style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     Card(
//                       child: ListTile(
//                         leading: FlutterLogo(size: 80.0),
//                         title: Text('survey-of-cassava-disease'.i18n()),
//                         subtitle: Text('...'),
//                         trailing: Icon(Icons.arrow_drop_down),
//                       ),
//                     ),
//                     //sconst SizedBox(height: 12,),
//                     Card(
//                       child: ListTile(
//                         leading: FlutterLogo(size: 80.0),
//                         title: Text('survey-of-plant-pests'.i18n()),
//                         subtitle: Text('...'),
//                         trailing: Icon(Icons.arrow_drop_down),
//                       ),
//                     ),
//                     //const SizedBox(height: 12,),
//                     Card(
//                       child: ListTile(
//                         leading: FlutterLogo(size: 80.0),
//                         title: Text('exploration-of-natural-enemies'.i18n()),
//                         subtitle: Text('...'),
//                         trailing: Icon(Icons.arrow_drop_down),
//                       ),
//                     ),
//                   ]),
//                 ),
//               ],
//             )),
//       ),
//     );
//   }
// }

// class SearchSurveyFieldHomeScreen extends StatefulWidget {
//   const SearchSurveyFieldHomeScreen({Key? key}) : super(key: key);

//   @override
//   SearchSurveyFieldHomeScreenState createState() =>
//       SearchSurveyFieldHomeScreenState();
// }

// class SearchSurveyFieldHomeScreenState
//     extends State<SearchSurveyFieldHomeScreen> {
//   List<Planting> _plants = [];
//   List<Field> _fields = [];
//   String query = '';
//   Timer? debouncer;

//   bool isLoading = true;

//   //scroll to top
//   ScrollController scrollController = ScrollController();
//   bool showbtn = false;

//   @override
//   void initState() {
//     scrollController.addListener(() {
//       //scroll listener
//       double showoffset =
//           10.0; //Back to top botton will show on scroll offset 10.0

//       if (scrollController.offset > showoffset) {
//         showbtn = true;
//         setState(() {
//           //update state
//         });
//       } else {
//         showbtn = false;
//         setState(() {
//           //update state
//         });
//       }
//     });
//     super.initState();
//     asyncFunction();
//     //init();
//   }

//   asyncFunction() async {
//     await _onloadField();
//     if (mounted) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   _onloadField() async {
//     //print("onload Fields");
//     FieldService fieldService = new FieldService();
//     String? token = tokenFromLogin?.token;
//     _fields = await fieldService.getFields(token.toString(), 1, 20);
//     PlantingService plantingService = new PlantingService();
//     _plants = await plantingService.getPlanting(token.toString(), 1, 20);
//     //getAll();
//   }

//   @override
//   void dispose() {
//     debouncer?.cancel();
//     super.dispose();
//   }

//   void debounce(
//     VoidCallback callback, {
//     Duration duration = const Duration(milliseconds: 1000),
//   }) {
//     if (debouncer != null) {
//       debouncer!.cancel();
//     }

//     debouncer = Timer(duration, callback);
//   }

//   Future init() async {
//     String? token = tokenFromLogin?.token;
//     final _plants = await PlantingService.getPlantings(query, token.toString());

//     setState(() => this._plants = _plants);
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new_rounded,
//                 color: Colors.white),
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => MainScreen()),
//             ),
//           ),
//           centerTitle: true,
//           title: Text(
//             'survey-search-label'.i18n(),
//             style: GoogleFonts.poppins(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 22,
//             ),
//           ),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//         ),
//         extendBodyBehindAppBar: true,
//         body: Stack(
//           //alignment: Alignment.topLeft,
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               decoration: const BoxDecoration(
//                 color: Colors.deepPurple,
//               ),
//             ),
//             /*Container(
//               //physics: const BouncingScrollPhysics(),
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       const Color.fromRGBO(85, 73, 148, 1).withOpacity(0.5),
//                       const Color.fromRGBO(247, 117, 168, 1).withOpacity(.5),
//                       const Color.fromRGBO(247, 117, 168, 1).withOpacity(.9),
//                       Colors.white.withOpacity(.8),
//                       Colors.white.withOpacity(1),
//                     ],
//                   ),
//                 ),
//               ),
//             ),*/
//             SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 280 * 0.5),
//                 child: Container(
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       topRight: Radius.circular(19),
//                       topLeft: Radius.circular(19),
//                     ),
//                     child: Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height - 84,
//                       color: Colors.white,
//                       child: Center(
//                           child: Padding(
//                         padding: const EdgeInsets.only(
//                             top: 9, left: 13.5, right: 13.5),
//                         child: Column(
//                           children: [
//                             Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Text(
//                                     'all-survey-results'.i18n(),
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 18,
//                                     ),
//                                     //maxLines: 1,
//                                     //textAlign: TextAlign.left,
//                                   ),
//                                   IconButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         SizeTransition1(
//                                             const SearchSurveyFieldScreen()),
//                                       );
//                                     },
//                                     icon: const Icon(Icons.filter_list_rounded),
//                                   )
//                                 ]),
//                             buildSearch(),
//                             Expanded(
//                               child: _buildListView(),
//                               /*child: ListView.builder(
//                                 physics: const BouncingScrollPhysics(),
//                                 scrollDirection: Axis.vertical,
//                                 itemCount: 15,
//                                 itemBuilder: (context, index) {
//                                   return Container(
//                                     width: 300,
//                                     height: 180,
//                                     child: Card(
//                                       borderOnForeground: false,
//                                       clipBehavior: Clip.hardEdge,
//                                       color: theme_color,
//                                       elevation: 5,
//                                       shadowColor: kLightGrey,
//                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                                       /*child: Padding(
//                                         padding: EdgeInsets.all(1),
//                                         child: Image.asset('assets/images/logouse.png',width: 50,height: 50,),
//                                       ),*/
//                                     ),
//                                   );
//                                 },
//                               ),*/
//                             ),
//                           ],
//                         ),
//                       )),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );

//   Widget buildSearch() => SearchWidget(
//         text: query,
//         hintText: 'key-id-number'.i18n(),
//         onChanged: searchBook,
//       );

//   Widget buildPlanting(Field field) => ListTile(
//         title: Text(field.code),
//         subtitle: Text(field.name),
//       );

//   Future searchBook(String query) async => debounce(() async {
//         //final _plants = await PlantingService.getPlantings(query);

//         if (!mounted) return;

//         setState(() {
//           this.query = query;
//           this._fields = _fields;
//         });
//       });

//   Widget _buildListView() {
//     String storyImage = 'assets/images/cassava_field.jpg';
//     String userImage = 'assets/images/unknown_user.png';
//     //print(_fields.length);
//     if (isLoading) {
//       return Center(
//         child: Container(
//           height: 30,
//           width: 30,
//           child: const CircularProgressIndicator(
//             color: Colors.deepPurple,
//           ),
//         ),
//       );
//     } else {
//       return ListView.builder(
//         physics: const BouncingScrollPhysics(),
//         scrollDirection: Axis.vertical,
//         itemCount: 9, //_fields.length,
//         itemBuilder: (context, index) {
//           return Container(
//             padding: const EdgeInsets.all(10),
//             width: 200,
//             height: 200,
//             child: GestureDetector(
//               onTap: () {
//                 /*//print('ontap fieldId ' + _fields[index].fieldID.toString());
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DetailScreen(fields: _fields[index]),
//                   ),
//                 );*/

//                 //    Provider.of<TabPassModel>(context, listen: false)
//                 //        .passParameter(index.toString());
//                 //  widget.mainTapController
//                 //      .animateTo(widget.mainTapController.index + 1);
//               },
//               child: AspectRatio(
//                 aspectRatio: 1.6 / 2,
//                 child: Container(
//                   //margin: EdgeInsets.only(right: 5),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     image: DecorationImage(
//                         image: AssetImage(storyImage), fit: BoxFit.cover),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.35),
//                         spreadRadius: 5,
//                         blurRadius: 7,
//                         offset: Offset(0, 3), // changes position of shadow
//                       ),
//                     ],
//                   ),
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       gradient:
//                           LinearGradient(begin: Alignment.bottomRight, colors: [
//                         Colors.black.withOpacity(.9),
//                         Colors.black.withOpacity(.1),
//                       ]),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.white, width: 2),
//                               image: DecorationImage(
//                                   image: AssetImage(userImage),
//                                   fit: BoxFit.cover)),
//                         ),
//                         Container(
//                           child: Column(children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   'นายอุดม สวนไร่',
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 22,
//                                   ),
//                                   /*_fields[index].fieldID.toString(),
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 18,
//                                   ),*/
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   '1 มิ.ย. 2565',
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 18,
//                                   ),
//                                   /*"" + _fields[index].name.toString(),
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 18,
//                                   ),*/
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   'นายอุดม แปลง1',
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 18,
//                                   ),
//                                   /*"" + _fields[index].address.toString(),
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 18,
//                                   ),*/
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   'แควน้อย, กาญจนบุรี',
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 18,
//                                   ),
//                                   /*"" + _fields[index].address.toString(),
//                                   style: GoogleFonts.poppins(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 18,
//                                   ),*/
//                                 ),
//                               ],
//                             ),
//                           ]),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }

//   bool isItemDisabled(String s) {
//     //return s.startsWith('I');

//     if (s.startsWith('I')) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   void itemSelectionChanged(String? s) {
//     //print(s);
//   }
// }
