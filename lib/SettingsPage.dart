import 'package:flutter/material.dart';
import 'package:flutter_cipherlabtest/model/Recources.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: Center(child: Text('Настройки')),
    );
  }
}
