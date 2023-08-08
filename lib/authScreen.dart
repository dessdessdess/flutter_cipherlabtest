import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cipherlabtest/mainScreen.dart';
import 'package:flutter_cipherlabtest/model/ApiService.dart';
import 'package:flutter_cipherlabtest/model/SharedPrefData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  static const eventChannel = EventChannel('samples.flutter.dev/getscancode');

  String user = '';
  final TextEditingController _passwordEditingController =
      TextEditingController();

  Future<void> scanEventHandle() async {
    try {
      eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    } on PlatformException catch (e) {
      debugPrint("Failed to Invoke: '${e.message}'.");
    }
  }

  void _onEvent(Object? event) {
    var scannedCode = "$event";
    var index = scannedCode.indexOf('User=');

    if (index > -1) {
      var userGuid = scannedCode.substring(index, 49);

      ApiService.auth(userGuid).then(
        (authInfo) {
          setData(authInfo);
          setState(() {
            user = authInfo.user;
          });
        },
      );
    }
  }

  void _onError(Object error) {
    setState(() {
      user = '';
    });
  }

  setData(AuthInfo authInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", authInfo.user);
    prefs.setString("userGuid", authInfo.userGuid);
    prefs.setString("storage", authInfo.storage);
    prefs.setString("storageGuid", authInfo.storageGuid);
    prefs.setString("pin", authInfo.pin);
  }

  loginButtonTapped() {
    var password = _passwordEditingController.text;
    SharedPrefData.passwordVerificationPassed(password).then((isAuthorised) {
      if (isAuthorised) {
        FocusScope.of(context).requestFocus(FocusNode());
        saveIsAuthorised();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const MainScreen(),
            ),
            (route) => false);
      }
    });
  }

  Future<void> saveIsAuthorised() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isAuthorised", true);
  }

  @override
  void initState() {
    super.initState();
    scanEventHandle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user.isEmpty
          ? const Center(
              child: Text(
                'Отсканируйте штрихкод авторизации',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    user,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                  child: TextField(
                    controller: _passwordEditingController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Пароль',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: ElevatedButton(
                      onPressed: loginButtonTapped,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Войти',
                          style: TextStyle(fontSize: 32),
                        ),
                      )),
                ),
              ],
            ),
    );
  }
}
