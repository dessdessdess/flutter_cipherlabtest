import 'package:flutter/material.dart';
import 'package:flutter_cipherlabtest/HomePage.dart';
// import 'package:flutter_cipherlabtest/model/SharedPrefData.dart';
// import 'package:flutter_cipherlabtest/authScreen.dart';
// import 'mainScreen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

//  // var isAuthorised = false;
//   await SharedPrefData.isAuthorised().then(
//     (value) {
//       isAuthorised = value;
//     },
//   );

  runApp(MainApp(
      // isAuthorized: isAuthorised,
      ));

  FlutterNativeSplash.remove();
}

class MainApp extends StatefulWidget {
  // late bool isAuthorized;

  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  //late bool isAuthorized;

  //_MainAppState({required this.isAuthorized});

  @override
  void initState() {
    super.initState();
    //isAuthorized = widget.isAuthorized;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        //home: isAuthorized ? const MainScreen() : const AuthScreen());
        home: HomePage());
  }
}
