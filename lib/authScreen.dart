import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cipherlabtest/mainScreen.dart';
import 'package:flutter_cipherlabtest/model/ApiService.dart';
import 'package:flutter_cipherlabtest/model/SharedPrefData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/Recources.dart';

class AuthScreen extends StatefulWidget {
  SharedData sharedData;

  AuthScreen({super.key, required this.sharedData});

  @override
  State<StatefulWidget> createState() {
    return AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  static const eventChannel = EventChannel('samples.flutter.dev/getscancode');

  late SharedData sharedData;

  String _user = '';
  bool _passwordCorrect = true;

  final TextEditingController _passwordEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    sharedData = widget.sharedData;
    scanEventHandle();
    _passwordEditingController.addListener(() {
      if (_passwordEditingController.text.isEmpty) {
        _passwordCorrect = true;
        setState(() {});
      }
    });
  }

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
      var userGuid = scannedCode.substring(index, 41); //49

      ApiService.auth(userGuid).then(
        (authInfo) {
          setData(authInfo);
          setState(() {
            _user = authInfo.user;
          });
        },
      );
    }
  }

  void _onError(Object error) {
    setState(() {
      _user = '';
    });
  }

  setData(AuthInfo authInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final sharedDataString = jsonEncode(authInfo.toJson());

    prefs.setString('sharedData', sharedDataString);
    sharedData = SharedData.fromJson(json.decode(sharedDataString));
  }

  loginButtonTapped() {
    final currentPassword = _passwordEditingController.text;

    if (currentPassword == sharedData.pin) {
      Navigator.pop(context, sharedData);
    } else {
      _passwordCorrect = false;
      setState(() {});
    }
  }

  Future<void> saveIsAuthorised() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isAuthorised", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Авторизация"),
      ),
      body: _user.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Отсканируйте штрихкод авторизации',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _onEvent(
                            "User=5ec715b1-40b1-11e9-bba5-14187764496c"); //Плотников
                      },
                      child: const Text('Тестовый вход'))
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    _user,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: TextField(
                    controller: _passwordEditingController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Пароль',
                    ),
                  ),
                ),
                _passwordCorrect
                    ? const SizedBox(
                        height: 0,
                      )
                    : const Padding(
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Text(
                          'Неправильный пароль!',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: ElevatedButton(
                      onPressed: loginButtonTapped,
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Войти',
                          style: TextStyle(fontSize: 24),
                        ),
                      )),
                ),
              ],
            ),
    );
  }
}
