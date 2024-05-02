import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:selby/core/configuration.dart';
import 'package:selby/core/ui.dart';
import 'package:selby/models/autos_model.dart';
import 'package:selby/models/properties_model.dart';
import 'package:selby/models/user_model.dart';
import 'package:selby/presentation/chat/individual_chat_screen.dart';
import 'package:selby/presentation/chat/message_screen.dart';
import 'package:selby/provider/auth_provider.dart';
import 'package:selby/provider/autos_provider.dart';
import 'package:selby/provider/msg_provider.dart';
import 'package:selby/provider/properties_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutosDetailsScreen extends StatefulWidget {
  final String autosId;

  const AutosDetailsScreen({super.key, required this.autosId});

  @override
  State<AutosDetailsScreen> createState() => _AutosDetailsScreenState();
}

class _AutosDetailsScreenState extends State<AutosDetailsScreen> {
  String? userId;
  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.get('userId').toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserId();
    setState(() {
      userId;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,000');
    final provider = Provider.of<PropertiesProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: AppColors.main,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/selby_logo.png',
                width: 100,
              )
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Ionicons.notifications_outline,
                color: AppColors.white,
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Ionicons.search_outline,
            //     color: AppColors.white,
            //   ),
            // ),
          ],
        ),
        body: FutureBuilder(
            future: provider.fetchPropertiesById(widget.autosId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<PropertiesModel> cdata = snapshot.data;
                final List<String> images = [];
                final List flist = [];
                // print("${Config.imageUrl}${cdata[0].image}");
                for (var items in cdata[0].image!) {
                  images.add('${Configuration.imageUrl}$items');
                }

                // List<String> list1 = cdata[0].features?.map((f)=>f.substring(0,1)).toList();

                for (var items in cdata[0].features!) {
                  flist.add('$items');
                }

                // cdata[0].features.map((key, value){
                //   print('$key : $value');
                // });
                print(flist);
                // for (int i = 0; i <= cdata[0].features!.length; i++) {
                //   features.add('$i');
                // }
                // print(features);
                // String img = images
                //     .join(',')
                //     .toString()
                //     .replaceAll('[', '')
                //     .replaceAll(']', '');
                // print(images
                //     .join(',')
                //     .toString()
                //     .replaceAll('[', '')
                //     .replaceAll(']', ''));
                return ListView.builder(
                    itemCount: cdata.length,
                    itemBuilder: (BuildContext context, index) {
                      return Stack(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Stack(children: <Widget>[
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: 320.0,
                                      viewportFraction: 1.0,
                                      // aspectRatio: 2 / 1,
                                      //viewportFraction: 0.8,
                                      //initialPage: 0,
                                      enableInfiniteScroll: false,
                                      // reverse: false,
                                      // autoPlay: true,
                                      // autoPlayInterval: Duration(seconds: 3),
                                      // autoPlayAnimationDuration:
                                      //  Duration(milliseconds: 800),
                                      //autoPlayCurve: Curves.fastOutSlowIn,
                                      //enlargeCenterPage: false,
                                      // scrollDirection: Axis.horizontal,
                                    ),
                                    items: images.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 320,
                                            //margin: EdgeInsets.symmetric(horizontal: 5.0),
                                            // decoration: BoxDecoration(
                                            //   color: Colors.amber
                                            // ),
                                            child: Image.network(
                                              "$i",
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 320,
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  Container(
                                    height: 110.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        gradient: LinearGradient(
                                            begin: FractionalOffset.topCenter,
                                            end: FractionalOffset.bottomCenter,
                                            colors: [
                                              AppColors.main.withOpacity(0.3),
                                              Colors.grey.withOpacity(0.1),
                                            ],
                                            stops: [
                                              0.01,
                                              1.0
                                            ])),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 15, 0),
                                    child: Container(
                                      height: 120.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // InkWell(
                                          //   onTap: () {
                                          //     Navigator.pop(context);
                                          //   },
                                          //   child: Icon(
                                          //     Ionicons.arrow_redo,
                                          //     color: Colors.white,
                                          //     size: 28,
                                          //   ),
                                          // ),
                                          Icon(
                                            Ionicons.share_social,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 10, 0),
                                        child: Text(
                                          '\u{20B9} ${formatter.format(int.parse(cdata[index].price.toString()))}',
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 48, 52, 1),
                                              letterSpacing: .1,
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 15, 5, 0),
                                        child: Text(
                                            "${cdata[index].title}"
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 48, 52, 1),
                                                letterSpacing: .1,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 5, 10),
                                        child: Text(
                                            "${cdata[index].description}",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 48, 52, 1),
                                                letterSpacing: .1,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 3, 5, 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Details",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 48, 52, 1),
                                                    letterSpacing: .1,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            for (var i in flist)
                                              Text(
                                                "${i}",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 48, 52, 1),
                                                    letterSpacing: .1,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                          ],
                                        ),
                                      ),

                                      // SingleChildScrollView(
                                      //   scrollDirection: Axis.horizontal,
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.fromLTRB(
                                      //         15, 17, 17, 10),
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.spaceBetween,
                                      //       children: [
                                      //         Container(
                                      //           padding:
                                      //               const EdgeInsets.symmetric(
                                      //                   horizontal: 10,
                                      //                   vertical: 6),
                                      //           decoration: BoxDecoration(
                                      //               color: Colors.grey
                                      //                   .withOpacity(0.2),
                                      //               borderRadius:
                                      //                   BorderRadius.all(
                                      //                       Radius.circular(
                                      //                           10))),
                                      //           //color: Color.fromRGBO(248, 249, 251, 1),
                                      //           child: Row(
                                      //             mainAxisAlignment:
                                      //                 MainAxisAlignment
                                      //                     .spaceAround,
                                      //             crossAxisAlignment:
                                      //                 CrossAxisAlignment.start,
                                      //             children: [
                                      //               Icon(
                                      //                 Ionicons.funnel_outline,
                                      //                 color: Color.fromRGBO(
                                      //                     0, 48, 52, 1),
                                      //                 size: 14,
                                      //               ),
                                      //               Padding(
                                      //                 padding:
                                      //                     const EdgeInsets.only(
                                      //                         left: 7),
                                      //                 child: Text(
                                      //                   "${cdata[index].fuel}"
                                      //                       .toUpperCase(),
                                      //                   style: TextStyle(
                                      //                     color: Color.fromRGBO(
                                      //                         0, 48, 52, 1),
                                      //                     fontSize: 13,
                                      //                     fontWeight:
                                      //                         FontWeight.w500,
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //         Container(
                                      //           padding:
                                      //               const EdgeInsets.symmetric(
                                      //                   horizontal: 20,
                                      //                   vertical: 6),
                                      //           // color: Color.fromRGBO(248, 249, 251, 1),
                                      //           decoration: BoxDecoration(
                                      //               color: Colors.grey
                                      //                   .withOpacity(0.2),
                                      //               borderRadius:
                                      //                   BorderRadius.all(
                                      //                       Radius.circular(
                                      //                           10))),
                                      //           child: Row(
                                      //             mainAxisAlignment:
                                      //                 MainAxisAlignment
                                      //                     .spaceAround,
                                      //             crossAxisAlignment:
                                      //                 CrossAxisAlignment.start,
                                      //             children: [
                                      //               Icon(
                                      //                 Ionicons
                                      //                     .speedometer_outline,
                                      //                 color: Color.fromRGBO(
                                      //                     0, 48, 52, 1),
                                      //                 size: 14,
                                      //               ),
                                      //               Padding(
                                      //                 padding:
                                      //                     const EdgeInsets.only(
                                      //                         left: 7),
                                      //                 child: Text(
                                      //                   "${formatter.format(int.parse(cdata[index].kms.toString()))} KM",
                                      //                   style: TextStyle(
                                      //                     color: Color.fromRGBO(
                                      //                         0, 48, 52, 1),
                                      //                     fontSize: 13,
                                      //                     fontWeight:
                                      //                         FontWeight.w500,
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //         Container(
                                      //           padding:
                                      //               const EdgeInsets.symmetric(
                                      //                   horizontal: 20,
                                      //                   vertical: 6),
                                      //           // color: Color.fromRGBO(248, 249, 251, 1),
                                      //           decoration: BoxDecoration(
                                      //               color: Colors.grey
                                      //                   .withOpacity(0.2),
                                      //               borderRadius:
                                      //                   BorderRadius.all(
                                      //                       Radius.circular(
                                      //                           10))),
                                      //           child: Row(
                                      //             mainAxisAlignment:
                                      //                 MainAxisAlignment
                                      //                     .spaceAround,
                                      //             crossAxisAlignment:
                                      //                 CrossAxisAlignment.start,
                                      //             children: [
                                      //               Icon(
                                      //                 Ionicons.filter_outline,
                                      //                 color: Color.fromRGBO(
                                      //                     0, 48, 52, 1),
                                      //                 size: 14,
                                      //               ),
                                      //               Padding(
                                      //                 padding:
                                      //                     const EdgeInsets.only(
                                      //                         left: 7),
                                      //                 child: Text(
                                      //                   "${cdata[index].transmission}"
                                      //                       .toUpperCase(),
                                      //                   style: TextStyle(
                                      //                     color: Color.fromRGBO(
                                      //                         0, 48, 52, 1),
                                      //                     fontSize: 13,
                                      //                     fontWeight:
                                      //                         FontWeight.w500,
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                      //   child: Container(
                                      //     decoration: BoxDecoration(
                                      //       border: Border(
                                      //         top: BorderSide(
                                      //           color: TColor.primary.withOpacity(0.4),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.fromLTRB(
                                      //       20, 10, 20, 10),
                                      //   child: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.spaceBetween,
                                      //     crossAxisAlignment:
                                      //         CrossAxisAlignment.start,
                                      //     children: [
                                      //       Container(
                                      //         padding:
                                      //             const EdgeInsets.fromLTRB(
                                      //                 10, 10, 30, 10),
                                      //         // color: Color.fromRGBO(248, 249, 251, 1),
                                      //         decoration: BoxDecoration(
                                      //             color: Colors.grey
                                      //                 .withOpacity(0.2),
                                      //             borderRadius:
                                      //                 BorderRadius.all(
                                      //                     Radius.circular(10))),
                                      //         child: Column(
                                      //           crossAxisAlignment:
                                      //               CrossAxisAlignment.start,
                                      //           children: [
                                      //             Icon(
                                      //               Ionicons.arrow_down_outline,
                                      //               color: Color.fromRGBO(
                                      //                   0, 48, 52, 1),
                                      //               size: 15,
                                      //             ),
                                      //             Padding(
                                      //               padding:
                                      //                   const EdgeInsets.only(
                                      //                       top: 10),
                                      //               child: Text(
                                      //                 "OWNER",
                                      //                 style: TextStyle(
                                      //                   color: Color.fromRGBO(
                                      //                       0, 48, 52, 1),
                                      //                   fontSize: 12,
                                      //                   fontWeight:
                                      //                       FontWeight.w500,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             Padding(
                                      //               padding:
                                      //                   const EdgeInsets.only(
                                      //                       top: 2),
                                      //               child: Text(
                                      //                 "${cdata[index].owner}",
                                      //                 style: TextStyle(
                                      //                   color: Color.fromRGBO(
                                      //                       0, 48, 52, 1),
                                      //                   fontSize: 13,
                                      //                   fontWeight:
                                      //                       FontWeight.w500,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //       Container(
                                      //         padding:
                                      //             const EdgeInsets.fromLTRB(
                                      //                 10, 10, 30, 10),
                                      //         // color: Color.fromRGBO(248, 249, 251, 1),
                                      //         decoration: BoxDecoration(
                                      //             color: Colors.grey
                                      //                 .withOpacity(0.2),
                                      //             borderRadius:
                                      //                 BorderRadius.all(
                                      //                     Radius.circular(10))),
                                      //         child: Column(
                                      //           crossAxisAlignment:
                                      //               CrossAxisAlignment.start,
                                      //           children: [
                                      //             Icon(
                                      //               Icons.place_outlined,
                                      //               color: Color.fromRGBO(
                                      //                   0, 48, 52, 1),
                                      //               size: 15,
                                      //             ),
                                      //             Padding(
                                      //               padding:
                                      //                   const EdgeInsets.only(
                                      //                       top: 10),
                                      //               child: Text(
                                      //                 "GUWAHATI",
                                      //                 style: TextStyle(
                                      //                   color: Color.fromRGBO(
                                      //                       0, 48, 52, 1),
                                      //                   fontSize: 12,
                                      //                   fontWeight:
                                      //                       FontWeight.w500,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             Padding(
                                      //               padding:
                                      //                   const EdgeInsets.only(
                                      //                       top: 2),
                                      //               child: Text(
                                      //                 "Assam",
                                      //                 style: TextStyle(
                                      //                   color: Color.fromRGBO(
                                      //                       0, 48, 52, 1),
                                      //                   letterSpacing: .1,
                                      //                   fontSize: 13,
                                      //                   fontWeight:
                                      //                       FontWeight.w500,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //       Container(
                                      //         padding:
                                      //             const EdgeInsets.fromLTRB(
                                      //                 10, 10, 30, 10),
                                      //         // color: Color.fromRGBO(248, 249, 251, 1),
                                      //         decoration: BoxDecoration(
                                      //             color: Colors.grey
                                      //                 .withOpacity(0.2),
                                      //             borderRadius:
                                      //                 BorderRadius.all(
                                      //                     Radius.circular(10))),
                                      //         child: Column(
                                      //           crossAxisAlignment:
                                      //               CrossAxisAlignment.start,
                                      //           children: [
                                      //             Icon(
                                      //               Ionicons
                                      //                   .calendar_number_outline,
                                      //               color: Color.fromRGBO(
                                      //                   0, 48, 52, 1),
                                      //               size: 15,
                                      //             ),
                                      //             Padding(
                                      //               padding:
                                      //                   const EdgeInsets.only(
                                      //                       top: 10),
                                      //               child: Text(
                                      //                 "POSTING DATE",
                                      //                 style: TextStyle(
                                      //                   color: Color.fromRGBO(
                                      //                       0, 48, 52, 1),
                                      //                   fontSize: 12,
                                      //                   fontWeight:
                                      //                       FontWeight.w500,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             Padding(
                                      //               padding:
                                      //                   const EdgeInsets.only(
                                      //                       top: 2),
                                      //               child: Text(
                                      //                 "01-Oct-20",
                                      //                 style: TextStyle(
                                      //                   color: Color.fromRGBO(
                                      //                       0, 48, 52, 1),
                                      //                   letterSpacing: .1,
                                      //                   fontSize: 13,
                                      //                   fontWeight:
                                      //                       FontWeight.w500,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.fromLTRB(
                                      //       15, 0, 15, 15),
                                      //   child: Container(
                                      //     decoration: BoxDecoration(
                                      //       border: Border(
                                      //         top: BorderSide(
                                      //           width: 1,
                                      //           color: AppColors.main
                                      //               .withOpacity(0.5),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // Padding(
                                      //   padding: const EdgeInsets.fromLTRB(
                                      //       15, 0, 5, 15),
                                      //   child: Text("Description",
                                      //       style: TextStyle(
                                      //           color: Color.fromRGBO(
                                      //               0, 48, 52, 1),
                                      //           letterSpacing: .1,
                                      //           fontSize: 15,
                                      //           fontWeight: FontWeight.w600)),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 15, 10),
                                        // child: Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.start,
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: [
                                        //     Container(
                                        //         width: MediaQuery.of(context)
                                        //                 .size
                                        //                 .width -
                                        //             30,
                                        //         padding:
                                        //             const EdgeInsets.symmetric(
                                        //                 horizontal: 10,
                                        //                 vertical: 20),
                                        //         // color: Color.fromRGBO(248, 249, 251, 1),
                                        //         decoration: BoxDecoration(
                                        //             color: Colors.grey
                                        //                 .withOpacity(0.2),
                                        //             borderRadius:
                                        //                 BorderRadius.all(
                                        //                     Radius.circular(
                                        //                         10))),
                                        //         child: Column(
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           children: [
                                        //             Text(
                                        //               "${cdata[index].description}",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Insurance, Company Service, Loan avilable",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Padding(
                                        //               padding: const EdgeInsets
                                        //                   .fromLTRB(
                                        //                   0, 10, 0, 10),
                                        //               child: Text(
                                        //                 "ADDITIONAL VEHICLE INFORMATION:",
                                        //                 style: TextStyle(
                                        //                   color: Color.fromRGBO(
                                        //                       0, 48, 52, 1),
                                        //                   letterSpacing: .1,
                                        //                   fontSize: 12,
                                        //                   fontWeight:
                                        //                       FontWeight.w600,
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Registration Transfer: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Insurance: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Color: Red",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Air Conditioning: Automatic Climate Control",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "USB Compatibility: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Aux Compatibility: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Service History: Available",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Registration Place: AS",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Accidental: No",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Parking Sensors: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Flood Affected: No",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Rear Window Wiper: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Cruise Control: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Power Windows: Front & Rear",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Fog Lamps: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Interior color: Beige",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Finance: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Exchange: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Type of Car: SUV",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Battery Condition: New",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Insurance Type: Comprehensive",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Condition: Used",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Power Steering: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Adjustable Steering: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "ABS: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Make Month: May",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Alloy Wheels: Yes",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Lock System: Remote Controlled Central",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Tyre Condition: New",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //             Text(
                                        //               "Number of Airbags: 2 Airbags",
                                        //               style: TextStyle(
                                        //                 color: Color.fromRGBO(
                                        //                     0, 48, 52, 1),
                                        //                 letterSpacing: .1,
                                        //                 fontSize: 12,
                                        //                 fontWeight:
                                        //                     FontWeight.w400,
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         )),
                                        //   ],
                                        // ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Text('${userId}'),
                                // Text('${cdata[0].userId}'),
                                if (userId != cdata[0].userId)
                                  MaterialButton(
                                    onPressed: () async {
                                      // final authProv = Provider.of<AuthProvider>(
                                      //     context,
                                      //     listen: false);

                                      final msgProv =
                                          Provider.of<MessageProvider>(context,
                                              listen: false);

                                      // UserModel clientModel =
                                      //     await authProv.fetchUsersById(
                                      //         "${cdata[index].userId.toString()}");
                                      // UserModel myModel = await authProv
                                      //     .fetchUsersById(userId.toString());
                                      await msgProv.getRoomId(
                                          clientModel:
                                              "${cdata[index].userId.toString()}",
                                          myModel: userId,
                                          productId: widget.autosId);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IndividualChatScreen(
                                                      productId:
                                                          "${cdata[index].sId.toString()}",
                                                      // roomId:
                                                      //     "${cdata[index].userId.toString()}",
                                                      userId: userId.toString(),
                                                      receiver:
                                                          "${cdata[index].userId.toString()}")));
                                    },
                                    child: Text("Chat"),
                                  ),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                    // Padding(
                    //   child: Container(
                    //     height: 10,
                    //     color: Colors.white,
                    //   ),
                    //   padding: EdgeInsets.all(0),
                    // ),

                    );
              }
            }));
  }
}
