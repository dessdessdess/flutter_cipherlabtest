import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_cipherlabtest/model/ApiService.dart';

class DetailTask extends StatefulWidget {
  const DetailTask({super.key});

  @override
  State<DetailTask> createState() => _DetailTaskState();
}

class _DetailTaskState extends State<DetailTask> {
  static const eventChannel = EventChannel('samples.flutter.dev/getscancode');

  List<int> numbers = [0, 0, 0, 0, 0, 0, 0, 0];
  List<InventoryGood> detailTask = [
    const InventoryGood(
        nomenclatureGuid: "nomenclatureGuid",
        nomenclature: "010 Apex Radial 160/60 -17 69W TL Rear",
        characteristicGuid: "characteristicGuid",
        characteristic: "2022",
        quantity: "29"),
    const InventoryGood(
        nomenclatureGuid: "nomenclatureGuid",
        nomenclature: "Battlax BT-020 190/60 ZR17 78W TL Rear",
        characteristicGuid: "characteristicGuid",
        characteristic: "2023",
        quantity: "56"),
    const InventoryGood(
        nomenclatureGuid: "nomenclatureGuid",
        nomenclature: "ContiRaceAttack Comp.End 190/50 ZR17 73W TL Rear",
        characteristicGuid: "characteristicGuid",
        characteristic: "2022",
        quantity: "32"),
    const InventoryGood(
        nomenclatureGuid: "nomenclatureGuid",
        nomenclature: "Diablo Rosso Corsa 190/55 ZR17 75W TL Rear",
        characteristicGuid: "characteristicGuid",
        characteristic: "2023",
        quantity: "44"),
    const InventoryGood(
        nomenclatureGuid: "nomenclatureGuid",
        nomenclature: "Diablo Supercorsa V2 180/60 ZR17 75W TL Rear SP",
        characteristicGuid: "characteristicGuid",
        characteristic: "2022",
        quantity: "12"),
    const InventoryGood(
        nomenclatureGuid: "nomenclatureGuid",
        nomenclature: "K97 130/70 R17 62H TL Rear",
        characteristicGuid: "characteristicGuid",
        characteristic: "2023",
        quantity: "15"),
    const InventoryGood(
        nomenclatureGuid: "nomenclatureGuid",
        nomenclature: "Phantom Sportscomp RS 110/80 R18 58V TL Front",
        characteristicGuid: "characteristicGuid",
        characteristic: "2022",
        quantity: "22"),
    const InventoryGood(
        nomenclatureGuid: "nomenclatureGuid",
        nomenclature: "Power RS 190/55 ZR17 75W TL Rear",
        characteristicGuid: "characteristicGuid",
        characteristic: "2023",
        quantity: "10"),
  ];

  Future<void> scanEventHandle() async {
    try {
      eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    } on PlatformException catch (e) {
      debugPrint("Failed to Invoke: '${e.message}'.");
    }
  }

  void _onEvent(Object? event) {
    setState(() {
      numbers[0] = numbers[0] + 1;
    });
  }

  void _onError(Object error) {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scanEventHandle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Г001361"),
      ),
      body: ListView.builder(
          itemCount: detailTask.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                color: Colors.blue[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detailTask[index].nomenclature,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            detailTask[index].characteristic,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    // Expanded(
                    //     child: Container(
                    //   width: double.infinity,
                    // )),
                    Column(
                      children: [
                        Text(
                          detailTask[index].quantity,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          numbers[index].toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
