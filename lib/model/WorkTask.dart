import 'dart:convert';

class WorkTask {
  final String number;
  final DateTime date;
  final String docType;
  final String docTypeInternal;
  final String guid;
  final String client;
  final List<Good> goods;
  final List<GTIN> gtins;
  List<String> marks;
  bool completed;
  final String warehouseGuid;

  WorkTask(
      {required this.number,
      required this.date,
      required this.docType,
      required this.docTypeInternal,
      required this.guid,
      required this.client,
      required this.goods,
      required this.gtins,
      required this.marks,
      required this.completed,
      required this.warehouseGuid});

  factory WorkTask.fromJson(dynamic json) {
    List<Good> goods = [];
    List<GTIN> gtins = [];

    final goodsMap = json['goods'];
    goodsMap.forEach((element) {
      goods.add(Good.fromJson(element));
    });

    final gtinsMap = json['gtins'];
    gtinsMap.forEach((element) {
      gtins.add(GTIN.fromJson(element));
    });

    final docDate = DateTime.parse(json['date']);

    return WorkTask(
        number: json['number'],
        date: docDate,
        docType: json['docType'],
        docTypeInternal: json['docTypeInternal'],
        guid: json['guid'],
        client: json['client'],
        goods: goods,
        gtins: gtins,
        marks: [],
        completed: json.containsKey('completed')
            ? json['completed'] == 1
                ? true
                : false
            : false,
        warehouseGuid: json['warehouseGuid']);
  }

  factory WorkTask.fromMap(dynamic json) {
    List<Good> goods = [];
    List<GTIN> gtins = [];

    final goodsMap = jsonDecode(json['goods']);
    goodsMap.forEach((element) {
      goods.add(Good.fromJson(element));
    });

    final gtinsMap = jsonDecode(json['gtins']);
    gtinsMap.forEach((element) {
      gtins.add(GTIN.fromJson(element));
    });

    final docDate = DateTime.parse(json['date']);

    return WorkTask(
        number: json['number'],
        date: docDate,
        docType: json['docType'],
        docTypeInternal: json['docTypeInternal'],
        guid: json['guid'],
        client: json['client'],
        goods: goods,
        gtins: gtins,
        marks: [],
        completed: json.containsKey('completed')
            ? json['completed'] == 1
                ? true
                : false
            : false,
        warehouseGuid: json['warehouseGuid']);
  }

  Map<String, dynamic> toJson() {
    return {
      'docTypeInternal': docTypeInternal,
      'guid': guid,
      'warehouseGuid': warehouseGuid,
      'marks': marks
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'date': date.toIso8601String(),
      'docType': docType,
      'docTypeInternal': docTypeInternal,
      'guid': guid,
      'client': client,
      'completed': completed ? 1 : 0,
      'warehouseGuid': warehouseGuid,
      'marks': jsonEncode(marks),
      'goods': jsonEncode(goods),
      'gtins': jsonEncode(gtins)
    };
  }
}

class Good {
  final String nomenclature;
  final String nomenclatureGuid;
  final String characteristic;
  final String characteristicGuid;
  final int quantity;
  int currentQuantity;
  bool completed;

  Good(
      {required this.nomenclature,
      required this.nomenclatureGuid,
      required this.characteristic,
      required this.characteristicGuid,
      required this.quantity,
      required this.currentQuantity,
      required this.completed});

  factory Good.fromJson(dynamic json) {
    return Good(
        nomenclature: json['nomenclature'],
        nomenclatureGuid: json['nomenclatureGuid'],
        characteristic: json['characteristic'],
        characteristicGuid: json['characteristicGuid'],
        quantity: json['quantity'],
        currentQuantity:
            json.containsKey('currentQuantity') ? json['currentQuantity'] : 0,
        completed: json.containsKey('completed')
            ? json['completed'] == 1
                ? true
                : false
            : false);
  }

  Map<String, dynamic> toJson() {
    return {
      'nomenclature': nomenclature,
      'nomenclatureGuid': nomenclatureGuid,
      'characteristic': characteristic,
      'characteristicGuid': characteristicGuid,
      'quantity': quantity,
      'currentQuantity': currentQuantity,
      'completed': completed ? 1 : 0,
    };
  }
}

class GTIN {
  final String nomenclatureGuid;
  final String characteristicGuid;
  final String gtin;

  GTIN(
      {required this.nomenclatureGuid,
      required this.characteristicGuid,
      required this.gtin});

  factory GTIN.fromJson(dynamic json) {
    return GTIN(
      nomenclatureGuid: json['nomenclatureGuid'],
      characteristicGuid: json['characteristicGuid'],
      gtin: json['gtin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "nomenclatureGuid": nomenclatureGuid,
      "characteristicGuid": characteristicGuid,
      "gtin": gtin,
    };
  }
}
