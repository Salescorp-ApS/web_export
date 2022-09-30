import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;


var primaryColor = const Color(0xffEDEEEA);
var secondaryColor = Colors.pink;
var tertiaryColor = const Color(0xff0f453b);
var quaternaryColor = const Color(0x800f453b);
var quinaryColor = const Color(0x800f453b);
var senaryColor = const Color(0x4D0f453b);


bool testing = false; //kDebugMode;

ThemeMode themeMode = ThemeMode.light;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();

  static List<Object?> of(BuildContext context) =>
    [context.findAncestorStateOfType<MyAppState>()!, context.findAncestorStateOfType<HomePageState>()];
}

class MyAppState extends State<MyApp> {
  late Future<DataRequiredForBuild> _dataRequiredForBuild;

  @override
  void initState() {
    super.initState();
    _dataRequiredForBuild = _fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
        title: 'El-Pris',
        debugShowCheckedModeBanner: testing,
        theme: ThemeData(
          textTheme: GoogleFonts.mulishTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        darkTheme: ThemeData.dark(), // standard dark theme
        themeMode: themeMode, // device controls theme
        home: HomePage(),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
        ),
      );
  }

  // void changeTheme(ThemeMode themeMode) {
  //   setState(() {
  //     _themeMode = themeMode;
  //   });
  //   print(_themeMode);
  // }

  Future<DataRequiredForBuild> getRequiredData(){
    return _dataRequiredForBuild;
  }

}

void changeTheme(ThemeMode theme) {
  themeMode = theme;
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedScreenIndex = 0;
  int get selectedScreenIndex => _selectedScreenIndex;

  @override
  void initState() {
    super.initState();
  }

  final List _screens = [
    {"screen": const ScreenA(), "title": "Screen A Title"},
  ];

  void selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      _screens[0]["screen"];
  }

  AppBar createAppBar(bool showButton, bool enableButton){
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            "assets/images/velkommen-logo.png",
            scale: 3,
          ),
          Text(
              "v1.13",
              style: TextStyle(
                color: tertiaryColor,
                fontSize: 14,
              )
          )
          ,
          SizedBox(
            width: MediaQuery.of(context).size.width*0.15,
            child: ElevatedButton(
              onPressed: () =>
                  setState(() {
                    if (enableButton) {
                      selectedScreenIndex == 0 ? selectScreen(1) : selectScreen(0);
                    }
                  }),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(0.0),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.0),
                    ),
                  )
              ),
              child: Icon(
                selectedScreenIndex == 0 ? Icons.settings : Icons.home,
                color: enableButton ? tertiaryColor : Colors.transparent,
                size: 40,
              ),
            )
          )
        ],
      ),
    );
  }

}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [home, settings];
  //static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Hjem', icon: Icons.home);
  static const settings = MenuItem(text: 'Indstillinger', icon: Icons.settings);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(
            item.icon,
            color: Colors.white,
            size: 22
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item, homePage) {
    switch (item) {
      case MenuItems.home:
        homePage.selectScreen(0);
        break;
      case MenuItems.settings:
        homePage.selectScreen(1);
        break;
    }
  }
}

class DataRequiredForBuild {
  List<List<DataItem>> dkData;

  DataRequiredForBuild({
    required this.dkData,
  });
}

Future<DataRequiredForBuild> _fetchAllData() async {
  List<List<DataItem>> dkData = [await fetchDataAlt(1), await fetchDataAlt(2)];

  return DataRequiredForBuild(
    dkData: dkData,
  );
}




DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

class DataItem {
  DateTime startTime;
  double value;
  DataItem(
      {required this.startTime, required this.value});
}

List<DataItem> parseRows(String responseBody, int dk1) {
  final rows = jsonDecode(responseBody)['data']['Rows'];
  rows.removeWhere((x) => !x['Name'].contains('nbsp'));
  rows.removeWhere((x) => x['Columns'][0]['Value'].replaceAll(' ','').replaceAll(',', '.') == '-');
  final res = rows.map<DataItem>((x) => DataItem(startTime: DateTime.parse(x['StartTime']), value: double.parse(x['Columns'][dk1]['Value'].replaceAll(' ','').replaceAll(',', '.'))));
  return res.toList();
}

// Alternative API service

Future<List<DataItem>> fetchDataAlt(int region) async{
  var formatter = DateFormat('yyyy-MM-dd');
  String now = formatter.format(DateTime.now().add(const Duration(days: 2)));
  String date = formatter.format(DateTime.now().subtract(const Duration(days: 5)));
  String url = 'https://api.energidataservice.dk/dataset/Elspotprices?offset=0&start=${date}T00:00&end=${now}T00:00&filter=%7B%22PriceArea%22:%22DK${region}%22%7D&sort=HourDK%20ASC&timezone=dk';
  final response = await http
      .get(Uri.parse(url), headers: {'Accept': 'text/json'});
  return parseRowsAlt(response.body, region);
}

List<DataItem> parseRowsAlt(String responseBody, int region) {
  final rows = jsonDecode(responseBody)['records'];
  final res = rows.map<DataItem>((x) => DataItem(startTime: DateTime.parse(x['HourDK']), value: x['SpotPriceDKK']));
  return res.toList();
}



class ScreenA extends StatefulWidget {
  const ScreenA({Key? key}) : super(key: key);

  @override
  State<ScreenA> createState() => _ScreenA();
}

class _ScreenA extends State<ScreenA> {
  double initGraphWidth = 2000;
  List<DataItem> dk1 = [];
  List<DataItem> dk2 = [];
  int chosenRegion = 1;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<DataRequiredForBuild>(
        future: (MyApp.of(context)[0] as MyAppState).getRequiredData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dk1 = snapshot.data!.dkData[0];
            dk2 = snapshot.data!.dkData[1];
            ScrollController controller = getControllerWithOffset(
                scrollToCurrent(
                    snapshot.data!.dkData[chosenRegion-1])
            );
            return
              Scaffold(
                  backgroundColor: Colors.white,
                  body:
                  ListView(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 20, left: 20) ,
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.15,
                                    ),
                                    Column(
                                        children: [
                                          Text(
                                              'Øre pr. kwh',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: tertiaryColor,
                                              )
                                          ),
                                          Text(
                                              '(${chosenRegion == 1 ? 'Vest' : 'Øst'})',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: tertiaryColor,
                                              )
                                          ),
                                        ]
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                                      child: SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.15,
                                          height: MediaQuery.of(context).size.height * 0.10,
                                          child:
                                          Column(
                                            children: [
                                              CupertinoSwitch(
                                                value: chosenRegion == 1 ? false : true,
                                                onChanged: (value) {
                                                  setState(() {
                                                    chosenRegion = value ? 2 : 1;
                                                  });
                                                },
                                                activeColor: tertiaryColor,
                                                trackColor: tertiaryColor,
                                              ),
                                              Text(
                                                  'Vest | Øst ',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: tertiaryColor,
                                                  )
                                              ),
                                            ],
                                          )
                                      ),
                                    )
                                  ],
                                )
                            ),
                            SizedBox(
                                height: MediaQuery.of(context).size.height * 0.6,
                                child:
                                // RawScrollbar(
                                //     mainAxisMargin: 0,
                                //     trackVisibility: true,
                                //     trackColor: Colors.black12,
                                //     radius: const Radius.circular(50),
                                //     trackRadius: const Radius.circular(50),
                                //     controller: controller,
                                //     thickness: MediaQuery.of(context).size.height * 0.05,
                                //     thumbVisibility: true,
                                //     thumbColor: Colors.black38,
                                //     minThumbLength: 100,
                                //     child:
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  child:
                                  ListView(
                                      physics: const BouncingScrollPhysics(),
                                      controller: controller,
                                      scrollDirection: Axis.horizontal,
                                      children:
                                      [
                                        SizedBox(
                                            width: graphWidth(
                                                snapshot.data!.dkData[chosenRegion-1]),
                                            child:
                                            Padding(
                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
                                              child:
                                                Container(),
                                              // BarChart(
                                              //     BarChartData(
                                              //       maxY: toOreKWH(
                                              //           snapshot.data?.dkData[chosenRegion-1].map<double>((
                                              //               x) => x.value).reduce(
                                              //               math.max).toDouble())
                                              //           * 1.2, // Creates 20% padding above highest value
                                              //       barTouchData: BarTouchData(
                                              //           allowTouchBarBackDraw: false,
                                              //           handleBuiltInTouches: false,
                                              //           touchTooltipData: BarTouchTooltipData(
                                              //               tooltipBgColor: Colors
                                              //                   .transparent,
                                              //               getTooltipItem: (
                                              //                   BarChartGroupData group,
                                              //                   int groupIndex,
                                              //                   BarChartRodData rod,
                                              //                   int rodIndex,) {
                                              //                 return BarTooltipItem(
                                              //                   rod.toY.round()
                                              //                       .toString(),
                                              //                   TextStyle(
                                              //                     color: getColorFromIndex(
                                              //                         groupIndex,
                                              //                         snapshot.data!
                                              //                             .dkData[chosenRegion-1]),
                                              //                     fontSize: 10,
                                              //                   ),
                                              //                 );
                                              //               }
                                              //           )
                                              //       ),
                                              //
                                              //       borderData: FlBorderData(
                                              //           border: const Border(
                                              //             top: BorderSide.none,
                                              //             right: BorderSide.none,
                                              //             //left: BorderSide(width: 1, color: Colors.pink),
                                              //             //bottom: BorderSide(width: 1, color: tertiaryColor),
                                              //           )
                                              //       ),
                                              //       groupsSpace: 10,
                                              //       barGroups: snapshot.data!
                                              //           .dkData[chosenRegion-1]
                                              //           .map((dataItem) =>
                                              //           BarChartGroupData(x: daysBetween(
                                              //               DateTime.now().subtract(
                                              //                   const Duration(days: 1)),
                                              //               dataItem.startTime) * 24 +
                                              //               dataItem.startTime.hour,
                                              //             barRods: [
                                              //               BarChartRodData(
                                              //                   toY: toOreKWH(
                                              //                       dataItem.value),
                                              //                   width: 10,
                                              //                   color: getColor(
                                              //                       dataItem.startTime)
                                              //               ),
                                              //             ],
                                              //             showingTooltipIndicators: [0],
                                              //           )).toList(),
                                              //       titlesData: FlTitlesData(
                                              //         show: true,
                                              //         rightTitles: AxisTitles(
                                              //           sideTitles: SideTitles(
                                              //               showTitles: false),
                                              //         ),
                                              //         topTitles: AxisTitles(
                                              //           sideTitles: SideTitles(
                                              //               showTitles: false),
                                              //         ),
                                              //         bottomTitles: AxisTitles(
                                              //           sideTitles: SideTitles(
                                              //             showTitles: true,
                                              //             reservedSize: 42,
                                              //             getTitlesWidget: bottomTitles,
                                              //           ),
                                              //         ),
                                              //         leftTitles: AxisTitles(
                                              //           sideTitles: SideTitles(
                                              //             showTitles: false,
                                              //           ),
                                              //         ),
                                              //       ),
                                              //       gridData: FlGridData(show: false),
                                              //     )
                                              // ),
                                            )

                                        )
                                      ]
                                  ) ,
                                )
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(
                            //     bottom: MediaQuery.of(context).size.height*0.01,
                            //   ),
                            //   child: Text(
                            //       'Tidspunkt',
                            //       style: TextStyle(
                            //         fontSize: 12,
                            //         color: tertiaryColor,
                            //       )
                            //   ),
                            // ),
                            SizedBox(
                              width: math.max(math.min(MediaQuery.of(context).size.width*0.50, 600), 250),
                              child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: tertiaryColor,
                                  child:
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: MediaQuery.of(context).size.height*0.02,
                                                bottom: MediaQuery.of(context).size.height*0.02,
                                                left: MediaQuery.of(context).size.width*0.05,
                                                right: MediaQuery.of(context).size.width*0.05,
                                              ),
                                              child: Text(
                                                "Pris lige nu",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context).size.height*0.02,
                                                  bottom: MediaQuery.of(context).size.height*0.02,
                                                  right: MediaQuery.of(context).size.width*0.05,
                                                ),
                                                child:
                                                RichText(
                                                  text: TextSpan(
                                                      style: TextStyle(
                                                        color: primaryColor,
                                                        fontSize: 18,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(text: toOreKWH(
                                                            getCurrentValue())
                                                            .round()
                                                            .toString()),
                                                        const TextSpan(
                                                            text: '   øre/kWh',
                                                            style: TextStyle(
                                                                fontSize: 10))
                                                      ]
                                                  ),
                                                ))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: MediaQuery.of(context).size.width*0.05,
                                                bottom: MediaQuery.of(context).size.height*0.02,
                                              ),
                                              child: Text(
                                                "Billigste pris i dag",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: MediaQuery.of(context).size.width*0.05,
                                                bottom: MediaQuery.of(context).size.height*0.02,
                                              ),
                                              child: Text(
                                                "Kl. ${getCheapestTime()}-${getCheapestTime() +
                                                    1}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]
                                  )
                              ),
                            )
                          ],
                        )
                      ])
              );
          }
          else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return
            Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
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
                        valueColor: AlwaysStoppedAnimation<Color>(tertiaryColor),
                      ),
                    )
                )
            );
        }
    );
  }

  // Widget leftTitles(double value, TitleMeta meta) {
  //   var style = TextStyle(
  //     color: secondaryColor, // Color(0xff7589a2),
  //     fontWeight: FontWeight.bold,
  //     fontSize: 10,
  //   );
  //
  //   if (value%100 == 0){
  //     return SideTitleWidget(
  //       axisSide: meta.axisSide,
  //       space: 4,
  //       child: Text(value.toInt().toString(), style: style),
  //     );
  //   }
  //   else {
  //     return Container();
  //   }
  // }
  //
  // Widget bottomTitles(double value, TitleMeta meta) {
  //   List<DataItem> data = [];
  //   if (chosenRegion == 1){
  //     data = dk1;
  //   }
  //   else {
  //     data = dk2;
  //   }
  //   Widget text = Text(
  //     "${value.toInt()%24}-${(value.toInt()%24)+1}",
  //     style: TextStyle(
  //       color: getColorFromIndex(value.toInt()+96, data),
  //       fontWeight: FontWeight.bold,
  //       fontSize: 8,
  //     ),
  //   );
  //   text = Transform.rotate(
  //     angle: -math.pi / 4,
  //     child: text,
  //   );
  //
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     space: 16, //margin top
  //     child: text,
  //   );

  Color getColor(DateTime startTime) {
    if (startTime.day == DateTime.now().day && startTime.hour == DateTime.now().hour){
      return tertiaryColor;
    }
    else if (startTime.day == DateTime.now().day) {
      return quaternaryColor;
    }
    return senaryColor;
  }

  int getCheapestTime() {
    List<DataItem> data = [];
    if (chosenRegion == 1){
      data = dk1;
    }
    else {
      data = dk2;
    }
    DataItem item;
    for (var i = 0; i < data.length; i++) {
      item = data[i];
      if (item.startTime.day == DateTime.now().day && item.startTime.hour == DateTime.now().hour) {
        double lowestPrice = item.value;
        int lowestPriceTime = item.startTime.hour;
        for (var j = i; j < data.length; j++){
          if ((item.startTime.add(const Duration(hours:1))).day != DateTime.now().day) {
            return lowestPriceTime;
          }
          item = data[j];
          double val = item.value;
          if (val < lowestPrice){
            lowestPrice = val;
            lowestPriceTime = item.startTime.hour;
          }
        }
        return lowestPriceTime;
      }
    }
    return -1;
  }

  Color getColorFromIndex(int index, List<DataItem> items) {
    DataItem item = items[index];
    if (item.startTime.day == DateTime.now().day && item.startTime.hour == DateTime.now().hour) {
      return tertiaryColor;
    }
    else if (item.startTime.day == DateTime.now().day) {
      return quaternaryColor;
    }
    return quinaryColor;
  }

  double getCurrentValue() {
    List<DataItem> data = [];
    if (chosenRegion == 1){
      data = dk1;
    }
    else {
      data = dk2;
    }
    DataItem item;
    for (var i = 0; i < data.length; i++) {
      item = data[i];
      if (item.startTime.day == DateTime.now().day && item.startTime.hour == DateTime.now().hour) {
        return item.value;
      }
    }
    return -0.0;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  double toOreKWH(double? value) {
    return value! / 10;
  }

  double scrollToCurrent(List<DataItem> items) {
    double currentGraphWidth = graphWidth(items);
    double daysOfData = items.length / 24;
    double currentDay;

    if (items[items.length-1].startTime.day == DateTime.now().day) {
      currentDay = daysOfData - 1;
    }
    else {
      currentDay = daysOfData - 2;
    }
    double scrollTo = (currentGraphWidth/daysOfData)*currentDay + ((currentGraphWidth/daysOfData/(24))*(DateTime.now().hour-1));
    return scrollTo;
  }

  double graphWidth(List<DataItem> items) {
    return initGraphWidth * (items.length/72);
  }

  ScrollController _controller = ScrollController();

  ScrollController getControllerWithOffset(double offset) {
    _controller = ScrollController(
      initialScrollOffset: offset,
    );
    return _controller;
  }

}

class MyCustomScrollBehavior extends ScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

