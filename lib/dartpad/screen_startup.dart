import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'DataFetcher.dart';
import 'main.dart';

class ScreenStartup extends StatefulWidget {
  const ScreenStartup({super.key});

  @override
  State<ScreenStartup> createState() => _ScreenStartup();
}

class _ScreenStartup extends State<ScreenStartup> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (MyApp.of(context)[1] as HomePageState).createAppBar(true, false),
      backgroundColor: primaryColor,
      body:
          FutureBuilder<DataRequiredForBuild>(
              future: (MyApp.of(context)[0] as MyAppState).getRequiredData(),
              builder: (context, snapshot) {
                return
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.05,
                              //bottom: MediaQuery.of(context).size.height*0.02,
                              //left: MediaQuery.of(context).size.width*0.03,
                              //right: MediaQuery.of(context).size.width*0.03,
                            ),
                            child:
                            Stack(
                              children: [
                                const Image(
                                  image: AssetImage('assets/images/dk.png'),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.58,
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.6,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all<
                                              Color>(Colors.transparent),
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(Colors.transparent),
                                          shadowColor: MaterialStateProperty.all<
                                              Color>(Colors.transparent),
                                        ),
                                        onPressed: () {
                                          (MyApp.of(context)[1] as HomePageState).selectScreen(0);
                                          //homepage.selectScreen(0);
                                        },
                                        child: Container(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.38,
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.6,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all<
                                              Color>(Colors.transparent),
                                          backgroundColor: MaterialStateProperty
                                              .all<Color>(Colors.transparent),
                                          shadowColor: MaterialStateProperty.all<
                                              Color>(Colors.transparent),
                                        ),
                                        onPressed: () {
                                          (MyApp.of(context)[1] as HomePageState).selectScreen(0);
                                        },
                                        child: Container(),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     InkWell(
                          //       onTap: () {}, // Image tapped
                          //       splashColor: Colors.white10, // Splash color over image
                          //       child: Ink.image(
                          //         fit: BoxFit.cover, // Fixes border issues
                          //         width: MediaQuery.of(context).size.width*0.6,
                          //         height: MediaQuery.of(context).size.height*0.6,
                          //         image:
                          //           const AssetImage(
                          //             'assets/images/dkvest.png',
                          //           ),
                          //       ),
                          //     ),
                          //     Expanded(
                          //         child: InkWell(
                          //           onTap: () {}, // Image tapped
                          //           splashColor: Colors.white10, // Splash color over image
                          //           child: Ink.image(
                          //             //fit: BoxFit.cover, // Fixes border issues
                          //             width: MediaQuery.of(context).size.width*0.6,
                          //             height: MediaQuery.of(context).size.height*0.6,
                          //             image:
                          //             const AssetImage(
                          //               'assets/images/dkost.png',
                          //             ),
                          //           ),
                          //         )
                          //     )
                          //   ]
                          // )
                        ),
                        Expanded(child:
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  //top: MediaQuery.of(context).size.height*0.01,
                                  bottom: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.02,
                                  left: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.03,
                                  right: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.03,
                                ),
                                child: Text('Bor du i vest eller øst?',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: tertiaryColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.01,
                                  bottom: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.02,
                                  left: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.03,
                                  right: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.03,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.30,
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.065,
                                        child:
                                        ElevatedButton(
                                          onPressed: () {
                                            (MyApp.of(context)[1] as HomePageState).selectScreen(0);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty
                                                .all<Color>(tertiaryColor),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(36.0),
                                                  side: BorderSide(
                                                      color: tertiaryColor),
                                                )
                                            ),
                                          ),
                                          child: const Text(
                                            'Vest',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.30,
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.065,
                                        child:
                                        ElevatedButton(
                                          onPressed: () {
                                            (MyApp.of(context)[1] as HomePageState).selectScreen(0);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty
                                                .all<Color>(primaryColor),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(36.0),
                                                  side: BorderSide(
                                                      color: tertiaryColor),
                                                )
                                            ),
                                          ),
                                          child: Text(
                                            'Øst',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: tertiaryColor,
                                            ),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              )
                            ])
                        )
                      ]
                  );
              })
    );
  }
}