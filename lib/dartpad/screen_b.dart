// screen_b.dart
import 'package:elpris_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenB extends StatefulWidget {
  const ScreenB({Key? key}) : super(key: key);
  @override
  _ScreenBState createState() => _ScreenBState();
}

class _ScreenBState extends State<ScreenB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (MyApp.of(context)[1] as HomePageState).createAppBar(true, true),
      backgroundColor: primaryColor,
      body:
        FutureBuilder<DataRequiredForBuild>(
          future: (MyApp.of(context)[0] as MyAppState).getRequiredData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height*0.05,
                          left: MediaQuery.of(context).size.width*0.05,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                'Indstillinger',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: tertiaryColor,
                                  fontWeight: FontWeight.bold,
                                )
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height*0.02,
                          left: MediaQuery.of(context).size.width*0.05,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Vis priser for',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: tertiaryColor,
                                )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      setState(() {
                                      }),
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all<double>(0.0),
                                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(36.0),
                                        )
                                    ),
                                  ),
                                  child: Text(
                                      'Vest',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      setState(() {
                                      }),
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all<double>(0.0),
                                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(36.0),
                                        )
                                    ),
                                  ),
                                  child: Text(
                                      'Øst',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     left: 20,
                      //     top: 10,
                      //     right: 10,
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //           'Darkmode',
                      //           style: TextStyle(
                      //             fontSize: 14,
                      //             color: tertiaryColor,
                      //           )
                      //       ),
                      //       CupertinoSwitch(
                      //         value: snapshot.data?.prefs.getInt('theme') == 0 ? false : true,
                      //         onChanged: (value) {
                      //           setState(() {
                      //             snapshot.data!.prefs.setInt('theme', value ? 1 : 0);
                      //             changeTheme(value ? ThemeMode.dark : ThemeMode.light);
                      //           });
                      //         },
                      //         activeColor: getTertiaryColor(),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height*0.02,
                        bottom: MediaQuery.of(context).size.height*0.02,
                        left: MediaQuery.of(context).size.width*0.05,
                        right: MediaQuery.of(context).size.width*0.05,
                      ),
                      child:Text(
                        "Priserne i denne app er trukket direkte fra den nordiske elbørs 'Nordpool'. Prisen pr. kWh er for den rå strøm og uden eventuelle tillæg, abonnementer, skatter eller afgifter.",
                        textAlign: TextAlign.center,
                          style: TextStyle(
                            color: tertiaryColor,
                          )
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height*0.02,
                          left: MediaQuery.of(context).size.width*0.05,
                          right: MediaQuery.of(context).size.width*0.05,
                        ),
                      child: Text(
                          "Velkommen A/S",
                          style: TextStyle(
                            color: tertiaryColor,
                            fontWeight: FontWeight.bold,
                          )

                      ),
                    )
                  ],
                )
            ],
              );
            }
            return Container(
                alignment: Alignment.center,
                child:
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .height * 0.25,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.25,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(tertiaryColor),),
                )
            );
          }
        ),
      );
  }
}