import 'package:flutter/material.dart';
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
  late WorkTask workTask;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    workTask = widget.workTask;
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
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(DateFormat('dd.MM.yyyy').format(workTask.date),
                      style: const TextStyle(fontSize: 24)),
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
                  separatorBuilder: (context, int) {
                    return const Divider(
                      height: 1,
                    );
                  },
                  itemBuilder: (context, index) {
                    final good = workTask.goods[index];

                    const style = TextStyle(fontSize: 20);

                    return Row(
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
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
