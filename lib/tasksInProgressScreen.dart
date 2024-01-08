import 'package:flutter/material.dart';
import 'package:flutter_cipherlabtest/detailTask.dart';
import 'package:flutter_cipherlabtest/model/ApiService.dart';

class TasksInProgressScreen extends StatefulWidget {
  final int index;

  const TasksInProgressScreen({super.key, required this.index});

  @override
  State<TasksInProgressScreen> createState() => _TasksInProgressScreenState();
}

class _TasksInProgressScreenState extends State<TasksInProgressScreen> {
  var isLoading = false;
  late int index;

  List<InventoryDoc> tasks = [];

  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

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
          await Future<void>.delayed(const Duration(seconds: 3));
          // ApiService.getWorkTasks(index).then((tasksFromApi) => {
          //       setState(() {
          //         //tasks = tasksFromApi;
          //       })
          //     });
        },
        child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: SizedBox(
                  height: 100,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => DetailTask(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(10.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        //border: BoxBorder.lerp(null, null, 10),
                        color: Colors.blue[400],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                tasks[index].number,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tasks[index].date,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
