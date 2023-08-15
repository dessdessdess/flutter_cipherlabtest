import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cipherlabtest/SettingsPage.dart';
import 'package:flutter_cipherlabtest/authScreen.dart';
import 'package:flutter_cipherlabtest/model/Recources.dart';
import 'package:flutter_cipherlabtest/model/SharedPrefData.dart';
import 'model/Task.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/WorkTask.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var sharedData = SharedData.shared;

  var listForDrawer = [];

  var currentSection = 0;
  var titleText = 'Приемка';

  var searchFieldIsOpened = false;

  List<Task> listOfTasks = [];
  List<Task> filteredListOfTasks = [];

  List<WorkTask> listOfWorkTasks = [];
  List<WorkTask> filteredListOfWorkTasks = [];

  int countOfSelectedTasks = 0;

  final searchController = TextEditingController();

  var currentTabIndex = 0;

  @override
  initState() {
    super.initState();
    searchController.addListener(searchQueryChanged);

    loadData();
  }

  loadData() async {
    final pref = await SharedPreferences.getInstance();
    final sharedDataString = pref.getString("sharedData") ?? "";
    if (sharedDataString.isNotEmpty) {
      sharedData = SharedData.fromJson(json.decode(sharedDataString));
    }
  }

  searchQueryChanged() {
    final searchQuery = searchController.text.toLowerCase();

    if (searchQuery.isEmpty) {
      if (currentTabIndex == 0) {
        filteredListOfTasks = listOfTasks;
      } else {
        filteredListOfWorkTasks = listOfWorkTasks;
      }
    } else {
      if (currentTabIndex == 0) {
        filteredListOfTasks = listOfTasks
            .where((element) => element.number.contains(searchQuery))
            .toList();
      } else {
        filteredListOfWorkTasks = listOfWorkTasks
            .where((element) => element.number.contains(searchQuery))
            .toList();
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: kdAppBar(),
          body: TabBarView(children: [kdTasks(), kdWorkTasks()]),
          onDrawerChanged: (isOpened) {
            if (listForDrawer.isEmpty) {
              listForDrawer.add("Drawer header");
              Recources.sections.forEach((element) {
                listForDrawer.add(element);
              });
              listForDrawer.add("Настройки");
              setState(() {});
            }
          },
          drawer: kdDrawer()),
    );
  }

  AppBar kdAppBar() {
    return AppBar(
      title: searchFieldIsOpened
          ? Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextField(
                  //focusNode: focusNode,
                  autofocus: true,
                  controller: searchController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchFieldIsOpened = false;
                            searchController.text = '';
                          });
                        },
                      ),
                      hintText: 'Поиск...',
                      border: InputBorder.none),
                ),
              ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  maxLines: 2,
                ),
                const Text(
                  '15/08/2023',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
      actions: searchFieldIsOpened
          ? [
              const SizedBox(
                width: 0,
              )
            ]
          : [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.calendar_month)),
              Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      currentTabIndex = DefaultTabController.of(context).index;
                      setState(() {
                        searchFieldIsOpened = true;
                      });
                    },
                    icon: const Icon(Icons.search));
              }),
            ],
      bottom: const TabBar(tabs: [
        Tab(
          text: "Задания",
        ),
        Tab(
          text: "В работе",
        )
      ]),
    );
  }

  Center kdWorkTasks() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(seconds: 2));

          setState(() {
            listOfWorkTasks = WorkTask.getExampleWorkTasks();
            filteredListOfWorkTasks = listOfWorkTasks;
          });
        },
        child: ListView.separated(
            itemCount: filteredListOfWorkTasks.length,
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
              );
            },
            itemBuilder: (context, index) {
              final workTask = filteredListOfWorkTasks[index];
              return ListTile(
                onTap: () {},
                title: Text(workTask.docType),
                subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(workTask.number),
                      Text(DateFormat('dd.MM.yyyy').format(workTask.date))
                    ]),
              );
            }),
      ),
    );
  }

  Center kdTasks() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future<void>.delayed(const Duration(seconds: 2));
          setState(() {
            countOfSelectedTasks = 0;
            listOfTasks = Task.getExampleTasks();
            filteredListOfTasks = listOfTasks;
          });
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                  itemCount: filteredListOfTasks.length,
                  separatorBuilder: (context, index) => const Divider(
                        height: 1,
                      ),
                  itemBuilder: ((context, index) {
                    final task = filteredListOfTasks[index];

                    return Padding(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        leading: task.selected
                            ? const Icon(
                                Icons.check_box,
                                color: Colors.blue,
                              )
                            : const Icon(
                                Icons.check_box_outline_blank,
                              ),
                        title: Padding(
                          padding: EdgeInsets.zero,
                          child: Text(task.docType),
                        ),
                        subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text(task.number)),
                              Text(DateFormat('dd.MM.yyyy').format(task.date))
                            ]),
                        onTap: () {
                          setState(() {
                            task.selected = !task.selected;

                            countOfSelectedTasks = listOfTasks
                                .where((element) => element.selected == true)
                                .length;
                          });
                        },
                      ),
                    );
                  })),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Text(countOfSelectedTasks == 0
                          ? "Принять задания"
                          : "Принять задания ($countOfSelectedTasks)"))),
            )
          ],
        ),
      ),
    );
  }

  Drawer kdDrawer() {
    return Drawer(
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: listForDrawer.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: sharedData.userName.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return AuthScreen();
                                    },
                                  )).then((value) {
                                    setState(() {
                                      loadData();
                                    });
                                  });
                                },
                                icon: Icon(Icons.account_box),
                                label: Text("Авторизоваться")),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    sharedData.userName,
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      print("object");
                                    },
                                    iconSize: 24,
                                    icon: const Icon(Icons.exit_to_app)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    sharedData.warehouseName,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.warehouse))
                              ],
                            ),
                          ],
                        ),
                );
              } else {
                return Column(
                  children: [
                    listForDrawer[index] == listForDrawer.last
                        ? const Divider()
                        : const SizedBox(
                            height: 0,
                          ),
                    ListTile(
                      title: Text(listForDrawer[index]),
                      onTap: () {
                        Navigator.pop(context);

                        currentSection = index - 1;
                        listOfTasks.clear();
                        listOfWorkTasks.clear();
                        countOfSelectedTasks = 0;

                        if (currentSection < Recources.sections.length) {
                          titleText =
                              Recources.sections.elementAt(currentSection);
                          setState(() {});
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SettingsPage();
                          }));
                        }
                      },
                    ),
                  ],
                );
              }
            }));
  }
}
