import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

var primaryColor = const Color(0xffEDEEEA);
var secondaryColor = Colors.pink;
var tertiaryColor = const Color(0xff0f453b);
var quaternaryColor = const Color(0x800f453b);
var quinaryColor = const Color(0x800f453b);
var senaryColor = const Color(0x4D0f453b);


bool testing = false; //kDebugMode;

ThemeMode themeMode = ThemeMode.light;

void main() async {
  // await Hive.initFlutter();
  // Hive.registerAdapter(DataItemAdapter());
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
    {"screen": const ScreenB(), "title": "Screen B Title"},
    {"screen": const ScreenStartup(), "title": "StartUp"},
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






