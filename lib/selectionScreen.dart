import 'package:flutter/material.dart';
import 'package:flutter_cipherlabtest/model/Recources.dart';
import 'package:flutter_cipherlabtest/tasks.dart';
import 'package:flutter_cipherlabtest/tasksInProgressScreen.dart';

class SelectionScreen extends StatefulWidget {
  final int index;

  const SelectionScreen({super.key, required this.index});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  late final int index;

  //_SelectionScreenState({required this.index});

  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Recources.sections[index]),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            itemCount: Recources.currentButtons.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: SizedBox(
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => index == 0
                              ? TasksScreen(index: index)
                              : TasksInProgressScreen(index: index),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(10.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          Recources.currentButtons[index],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
