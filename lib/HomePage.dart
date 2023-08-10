import 'package:flutter/material.dart';
import 'package:flutter_cipherlabtest/SettingsPage.dart';
import 'package:flutter_cipherlabtest/model/Recources.dart';
import 'package:flutter_cipherlabtest/model/Task.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var listForDrawer = [];

  var currentSection = 0;
  var titleText = 'Приемка';

  var searchFieldIsOpened = false;

  List<Task> listOfTasks = [];

  int countOfSelectdTasks = 0;

  //final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: searchFieldIsOpened
                ? Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: TextField(
                        //focusNode: focusNode,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  searchFieldIsOpened = false;
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
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 2,
                      ),
                      // Text(
                      //   "РЦ Ростов-на-Дону",
                      //   style: TextStyle(fontSize: 10),
                      // ),
                      const Text(
                        "09/08/2023",
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
                        onPressed: () {},
                        icon: const Icon(Icons.calendar_month)),
                    // IconButton(
                    //     onPressed: () {}, icon: const Icon(Icons.warehouse)),
                    IconButton(
                        onPressed: () {
                          // showSearch(
                          //     context: context, delegate: MySearchDelegate());
                          setState(() {
                            searchFieldIsOpened = true;
                            //FocusScope.of(context).requestFocus(focusNode);
                          });
                        },
                        icon: const Icon(Icons.search)),
                  ],
            bottom: const TabBar(tabs: [
              Tab(
                text: "Задания",
              ),
              Tab(
                text: "В работе",
              )
            ]),
          ),
          body: TabBarView(children: [
            Center(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future<void>.delayed(const Duration(seconds: 2));
                  setState(() {
                    listOfTasks.clear();
                    countOfSelectdTasks = 0;
                    listOfTasks.add(Task("Г00235461", DateTime.now(),
                        "Реализация товаров услуг", "guid", false));
                    listOfTasks.add(Task("Р1739204", DateTime.now(),
                        "Реализация товаров услуг", "guid", false));
                    listOfTasks.add(Task("Р1739373", DateTime.now(),
                        "Перемещение товаров", "guid", false));
                    listOfTasks.add(Task("Р1739206", DateTime.now(),
                        "Перемещение товаров", "guid", false));
                    listOfTasks.add(Task("Р1739321321", DateTime.now(),
                        "Реализация товаров услуг", "guid", false));
                    listOfTasks.add(Task("Р17392065475", DateTime.now(),
                        "Перемещение товаров", "guid", false));
                    listOfTasks.add(Task("Г0045614754", DateTime.now(),
                        "Реализация товаров услуг", "guid", false));
                    listOfTasks.add(Task("Р00678424", DateTime.now(),
                        "Реализация товаров услуг", "guid", false));
                  });
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: ListView.separated(
                            itemCount: listOfTasks.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: ((context, index) => Padding(
                                  padding: EdgeInsets.zero,
                                  child: ListTile(
                                    leading: listOfTasks[index].selected
                                        ? const Icon(
                                            Icons.check_box,
                                            color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.check_box_outline_blank,
                                          ),
                                    title: Padding(
                                      padding: EdgeInsets.zero,
                                      child: Text(listOfTasks[index].docType),
                                    ),
                                    subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                              child: Text(
                                                  listOfTasks[index].number)),
                                          Text(DateFormat('dd.MM.yyyy')
                                              .format(listOfTasks[index].date))
                                        ]),
                                    onTap: () {
                                      setState(() {
                                        listOfTasks[index].selected =
                                            !listOfTasks[index].selected;
                                        countOfSelectdTasks = listOfTasks
                                            .where((element) =>
                                                element.selected == true)
                                            .length;
                                      });
                                    },
                                  ),
                                ))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text(countOfSelectdTasks == 0
                                  ? "Принять задания"
                                  : "Принять задания ($countOfSelectdTasks)"))),
                    )
                  ],
                ),
              ),
            ),
            const Center(
              child: Text("В работе"),
            )
          ]),
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
          drawer: Drawer(
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: listForDrawer.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return DrawerHeader(
                        decoration: const BoxDecoration(color: Colors.blue),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Flexible(
                                  child: Text(
                                    "Абзанов Руслан Азатович",
                                    style: TextStyle(
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
                                const Flexible(
                                  child: Text(
                                    "Ростов-на-Дону РЦ «Транзит», Доватора 154/3",
                                    style: TextStyle(fontSize: 14),
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
                              countOfSelectdTasks = 0;

                              if (currentSection < Recources.sections.length) {
                                titleText = Recources.sections
                                    .elementAt(currentSection);
                                setState(() {});
                              } else {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const SettingsPage();
                                }));
                              }
                            },
                          ),
                        ],
                      );
                    }
                  }))),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults

    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox(
      height: 0,
    );
  }
}
