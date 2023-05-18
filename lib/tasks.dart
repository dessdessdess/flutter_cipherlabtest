import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  final int index;

  const TasksScreen({super.key, required this.index});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Задания"),
      ),
      body: const Center(
        child: Text("Tasks"),
      ),
    );
  }
}
