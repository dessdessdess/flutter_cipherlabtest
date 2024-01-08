class WorkTask {
  final String number;
  final DateTime date;
  final String docType;
  final String guid;
  final String client;
  final List<Good> goods;
  final List<GTIN> gtins;

  WorkTask(
      {required this.number,
      required this.date,
      required this.docType,
      required this.guid,
      required this.client,
      required this.goods,
      required this.gtins});

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
      guid: json['guid'],
      client: json['client'],
      goods: goods,
      gtins: gtins,
    );
  }
}

class Good {
  final String nomenclature;
  final String nomenclatureGuid;
  final String characteristic;
  final String characteristicGuid;
  final int quantity;
  int currentQuantity;

  Good(
      {required this.nomenclature,
      required this.nomenclatureGuid,
      required this.characteristic,
      required this.characteristicGuid,
      required this.quantity,
      required this.currentQuantity});

  factory Good.fromJson(dynamic json) {
    return Good(
      nomenclature: json['nomenclature'],
      nomenclatureGuid: json['nomenclatureGuid'],
      characteristic: json['characteristic'],
      characteristicGuid: json['characteristicGuid'],
      quantity: json['quantity'],
      currentQuantity: 0,
    );
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
}
