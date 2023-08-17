import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cipherlabtest/model/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/AuthInfo.dart';
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

  String user = '';
  bool _passwordCorrect = true;
  String errorMessage = '';

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
    // _user = '';
    // _errorMessage = '';

    var scannedCode = "$event";
    var index = scannedCode.indexOf('User=');

    if (index > -1) {
      var userGuid = scannedCode.substring(index, 41); //49

      ApiService.auth(userGuid).then(
        (authInfo) {
          if (authInfo != null) {
            if (authInfo.result) {
              setData(authInfo);
              user = authInfo.user;
            } else {
              errorMessage = '${authInfo.user} не назначена роль Кладовщик';
            }
          } else {
            errorMessage = 'Что-то пошло не так...';
          }

          setState(() {});
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
      body: user.isEmpty
          ? errorMessage.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Отсканируйте штрихкод авторизации',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
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
              : BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: AlertDialog(
                    title: const Text('Внимание'),
                    content: Text(errorMessage),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              errorMessage = '';
                            });
                          },
                          child: const Text('OK'))
                    ],
                  ))
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        user,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: TextField(
                        controller: _passwordEditingController,
                        obscureText: true,
                        style: const TextStyle(fontSize: 18),
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
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            child: Text(
                              'Неправильный пароль!',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 32),
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
              ),
            ),
    );
  }
}
