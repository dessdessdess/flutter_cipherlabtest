import 'package:flutter/material.dart';
import 'package:flutter_cipherlabtest/model/Recources.dart';
import 'package:flutter_cipherlabtest/model/SharedPrefData.dart';
import 'package:flutter_cipherlabtest/selectionScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var user = '';
  var storage = '';

  @override
  void initState() {
    super.initState();

    SharedPrefData.getUser().then((value) {
      user = value;
      setState(() {});
    });

    SharedPrefData.getStorage().then((value) {
      storage = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.white,
    //   statusBarIconBrightness: Brightness.dark,
    // ));

    return Scaffold(
        appBar: AppBar(
          title: const Text("KDMobile"),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings,
                ))
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      user,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Text(
                        storage,
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: Recources.sections.length,
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
                                  builder: (BuildContext context) =>
                                      SelectionScreen(index: index),
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
                                  Recources.sections[index],
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
