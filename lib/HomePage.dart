import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cipherlabtest/DetailWorkTaskPage.dart';
import 'package:flutter_cipherlabtest/SettingsPage.dart';
import 'package:flutter_cipherlabtest/authScreen.dart';
import 'package:flutter_cipherlabtest/model/ApiService.dart';
import 'package:flutter_cipherlabtest/model/Recources.dart';
import 'model/Task.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/WorkTask.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
  //final focusNode = FocusNode();

  var currentTabIndex = 0;

  bool _tasksIsFetching = false;
  bool _workTasksIsFetching = false;

  String currentWarehouse = '';
  String currentWarehouseGUID = '';
  DateTime currentDate = DateTime.now();

  @override
  initState() {
    super.initState();
    searchController.addListener(searchQueryChanged);

    loadSharedData();
  }

  loadSharedData() async {
    final pref = await SharedPreferences.getInstance();
    final sharedDataString = pref.getString("sharedData") ?? "";
    if (sharedDataString.isNotEmpty) {
      sharedData = SharedData.fromJson(json.decode(sharedDataString));
      currentWarehouse = sharedData.warehouses[0].name;
      currentWarehouseGUID = sharedData.warehouses[0].guid;
    }

    // final currentDateInt = pref.getInt("currentDate") ?? 0;
    // if (currentDateInt != 0) {
    //   currentDate = DateTime.fromMillisecondsSinceEpoch(currentDateInt);
    // }

    setState(() {});
  }

  clearSharedData() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear().then((value) {
      sharedData = SharedData.shared;
      listOfTasks.clear();
      listOfWorkTasks.clear();
      setState(() {});
    });
  }

  // void saveCurrentDate(DateTime? value) async {
  //   if (value != null) {
  //     currentDate = value;
  //     final pref = await SharedPreferences.getInstance();
  //     pref.setInt('currentDate', currentDate.millisecondsSinceEpoch);
  //     setState(() {});
  //   }
  // }

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

  void clearListOfTasks() {
    listOfTasks.clear();
    filteredListOfTasks.clear();
    listOfWorkTasks.clear();
    filteredListOfWorkTasks.clear();
  }

  void showCustomError(BuildContext context, String text) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (context) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  child: const Text('ОК'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )));
  }

  tabIndexChanged(TabController tabController) {
    //if (tabController.indexIsChanging) {
    if (searchFieldIsOpened) {
      searchFieldIsOpened = false;
      searchController.text = '';
    }
    currentTabIndex = tabController.index;
    setState(() {});
    // }
  }

  Future<void> fetchTasks() async {
    // print(currentSection);
    // await Future<void>.delayed(const Duration(seconds: 1));

    countOfSelectedTasks = 0;
    ApiService.getTasks(currentSection, sharedData.userGuid,
            currentWarehouseGUID, currentDate)
        .then((value) {
      listOfTasks = value;
      filteredListOfTasks = listOfTasks;
      _tasksIsFetching = false;
      setState(() {});
    });
  }

  Future<void> fetchWorkTasks() async {
    // print(currentSection);
    // await Future<void>.delayed(const Duration(seconds: 1));

    ApiService.getWorkTasks(currentSection, sharedData.userGuid,
            currentWarehouseGUID, currentDate)
        .then((value) {
      listOfWorkTasks = value;
      filteredListOfWorkTasks = listOfWorkTasks;
      _workTasksIsFetching = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (context) {
        final tabController = DefaultTabController.of(context);

        tabController.addListener(() => tabIndexChanged(tabController));

        return Scaffold(
            appBar: kdAppBar(),
            body: TabBarView(
                controller: tabController,
                children: [kdTasks(), kdWorkTasks()]),
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
            drawer: kdDrawer());
      }),
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
                Text(
                  DateFormat('dd.MM.yyyy').format(currentDate),
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
      actions: searchFieldIsOpened
          ? <Widget>[
              const SizedBox(
                width: 0,
              )
            ]
          : [
              Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        firstDate: DateTime(2023),
                        initialDate: currentDate,
                        lastDate: DateTime(2030),
                      ).then((value) {
                        if (value != null) {
                          currentDate = value;
                          clearListOfTasks();
                          fetchTasks();
                          fetchWorkTasks();
                          setState(() {});
                        }
                      });
                    },
                    icon: const Icon(Icons.calendar_month));
              }),
              Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      //currentTabIndex = DefaultTabController.of(context).index;
                      setState(() {
                        searchFieldIsOpened = true;
                      });
                    },
                    icon: const Icon(Icons.search));
              }),
            ],
      bottom: const TabBar(padding: EdgeInsets.all(0), tabs: [
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
      child: listOfWorkTasks.isEmpty
          ? Builder(builder: (context) {
              return _workTasksIsFetching
                  ? Image.asset(
                      'assets/images/loading.gif',
                      height: 50,
                      width: 50,
                    )
                  : OutlinedButton(
                      onPressed: () {
                        if (sharedData.userName.isEmpty) {
                          showCustomError(
                              context, 'Пожалуйста, авторизуйтесь!');
                        } else {
                          setState(() {
                            _workTasksIsFetching = true;
                          });
                          fetchWorkTasks();
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.refresh_outlined),
                          Text('Обновить'),
                        ],
                      ));
            })
          : RefreshIndicator(
              onRefresh: fetchWorkTasks,
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
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return DetailWorkTaskPage(workTask: workTask);
                        }));
                      },
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
      child: listOfTasks.isEmpty
          ? Builder(builder: (context) {
              return _tasksIsFetching
                  ? Image.asset(
                      'assets/images/loading.gif',
                      height: 50,
                      width: 50,
                    )
                  : OutlinedButton(
                      onPressed: () {
                        if (sharedData.userName.isEmpty) {
                          showCustomError(
                              context, 'Пожалуйста, авторизуйтесь!');
                        } else {
                          setState(() {
                            _tasksIsFetching = true;
                          });
                          fetchTasks();
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.refresh_outlined),
                          Text('Обновить'),
                        ],
                      ));
            })
          : RefreshIndicator(
              onRefresh: fetchTasks,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        itemCount: filteredListOfTasks.length,
                        separatorBuilder: (context, index) => const Divider(
                              height: 1,
                            ),
                        itemBuilder: ((context, index) {
                          if (filteredListOfTasks.length > index) {
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(child: Text(task.number)),
                                      Text(DateFormat('dd.MM.yyyy')
                                          .format(task.date))
                                    ]),
                                onTap: () {
                                  setState(() {
                                    task.selected = !task.selected;

                                    countOfSelectedTasks = listOfTasks
                                        .where((element) =>
                                            element.selected == true)
                                        .length;
                                  });
                                },
                              ),
                            );
                          }
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
                                      return AuthScreen(sharedData: sharedData);
                                    },
                                  ))
                                      .then((value) {
                                        sharedData = value;
                                        currentWarehouse =
                                            sharedData.warehouses[0].name;
                                        currentWarehouseGUID =
                                            sharedData.warehouses[0].guid;
                                        setState(() {});
                                      })
                                      .catchError((onError) {})
                                      .onError((error, stackTrace) => null);
                                },
                                icon: const Icon(Icons.account_box),
                                label: const Text("Авторизоваться")),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      clearSharedData();
                                    },
                                    iconSize: 24,
                                    icon: const Icon(Icons.exit_to_app)),
                              ],
                            ),
                            DropdownButton<String>(
                                isExpanded: true,
                                underline: const SizedBox(height: 0),
                                value: currentWarehouse,
                                items: sharedData.warehouses
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e.name,
                                          child: Text(
                                            e.name,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (item) {
                                  setState(() {
                                    clearListOfTasks();
                                    currentWarehouse = item ?? '';
                                    currentWarehouseGUID = sharedData.warehouses
                                        .firstWhere((element) =>
                                            element.name == currentWarehouse)
                                        .guid;
                                  });
                                })
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Flexible(
                            //       child: Text(
                            //         sharedData.warehouses[0].name,
                            //         style: const TextStyle(fontSize: 14),
                            //       ),
                            //     ),
                            //     IconButton(
                            //         onPressed: () {},
                            //         icon: const Icon(Icons.warehouse))
                            //   ],
                            // ),
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
                        clearListOfTasks();
                        countOfSelectedTasks = 0;

                        final tabController = DefaultTabController.of(context);
                        tabController.index = 0;
                        tabIndexChanged(tabController);

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
