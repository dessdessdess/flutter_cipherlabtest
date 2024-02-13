import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cipherlabtest/model/DBService.dart';
import 'package:flutter_cipherlabtest/model/WorkTask.dart';
import 'package:intl/intl.dart';

class DetailWorkTaskPage extends StatefulWidget {
  final WorkTask workTask;

  const DetailWorkTaskPage({
    super.key,
    required this.workTask,
  });

  @override
  State<DetailWorkTaskPage> createState() => _DetailWorkTaskPageState();
}

class _DetailWorkTaskPageState extends State<DetailWorkTaskPage> {
  static const eventChannel = EventChannel('samples.flutter.dev/getscancode');

  late WorkTask workTask;

  @override
  void initState() {
    super.initState();
    workTask = widget.workTask;
    scanEventHandle();
  }

  Future<void> scanEventHandle() async {
    try {
      eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    } on PlatformException catch (e) {
      debugPrint("Failed to Invoke: '${e.message}'.");
    }
  }

  void _onEvent(Object? event) {
    for (var element in workTask.gtins) {
      debugPrint(element.gtin);
    }
    var scannedCode = "$event";

    if (scannedCode.startsWith('01')) {
      final gtin = scannedCode.substring(2, 16);

      final findedGTIN = workTask.gtins.firstWhere(
          (element) => element.gtin == gtin,
          orElse: () =>
              GTIN(nomenclatureGuid: '', characteristicGuid: '', gtin: ''));

      if (findedGTIN.nomenclatureGuid.isNotEmpty) {
        var currentGood = workTask.goods.firstWhere((element) =>
            element.nomenclatureGuid == findedGTIN.nomenclatureGuid &&
            element.characteristicGuid == findedGTIN.characteristicGuid);

        if (currentGood.currentQuantity < currentGood.quantity &&
            !workTask.marks.contains(scannedCode)) {
          workTask.marks.add(scannedCode);
          currentGood.currentQuantity++;
          if (currentGood.currentQuantity == currentGood.quantity) {
            currentGood.completed = true;

            var completed = true;
            for (var element in workTask.goods) {
              if (element.currentQuantity < element.quantity) {
                completed = false;
              }
            }

            workTask.completed = completed;
          }
          setState(() {});
        }
      }
    }
  }

  void _onError(Object error) {
    debugPrint(error.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            workTask.docType,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    workTask.number,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(DateFormat('dd.MM.yyyy').format(workTask.date),
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Клиент:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    // flex: 3,
                    child: Text(
                      workTask.client,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              const Divider(
                height: 15,
                thickness: 5,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: workTask.goods.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 1,
                    );
                  },
                  itemBuilder: (context, index) {
                    final good = workTask.goods[index];

                    const style = TextStyle(fontSize: 20);

                    return GestureDetector(
                      onTap: () {
                        if (good.completed) {
                          return;
                        }

                        good.currentQuantity++;
                        if (good.currentQuantity == good.quantity) {
                          good.completed = true;
                        }

                        var completed = true;
                        for (var element in workTask.goods) {
                          if (element.currentQuantity < element.quantity) {
                            completed = false;
                          }
                        }

                        workTask.completed = completed;

                        DBService.db.updateWorktask(workTask);

                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  good.nomenclature,
                                  style: style,
                                ),
                                good.characteristic.isEmpty
                                    ? const SizedBox(
                                        height: 0,
                                      )
                                    : Text(good.characteristic),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    good.currentQuantity.toString(),
                                    style: style,
                                  ),
                                  const Text(
                                    ' / ',
                                    style: style,
                                  ),
                                  Text(
                                    good.quantity.toString(),
                                    style: style,
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
