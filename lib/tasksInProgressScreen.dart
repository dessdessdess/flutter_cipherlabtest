import 'package:flutter/material.dart';

class TasksInProgressScreen extends StatefulWidget {
  final int index;

  const TasksInProgressScreen({super.key, required this.index});

  @override
  State<TasksInProgressScreen> createState() => _TasksInProgressScreenState();
}

class _TasksInProgressScreenState extends State<TasksInProgressScreen> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('В работе'),
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.blue,
        onRefresh: () async {
          // Replace this delay with the code to be executed during refresh
          // and return asynchronous code
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: ListView(),
      ),
    );
  }
}
