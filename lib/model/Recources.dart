import 'package:flutter_cipherlabtest/model/AuthInfo.dart';

class Recources {
  static final sections = [
    "Приемка",
    "Отгрузка",
    "Возврат",
    "Инвентаризация",
    //"Cезонное хранение",
    "Комплектация",
    "Списание товаров",
  ];

  static final currentButtons = [
    "Задания",
    "В работе",
  ];
}

class SharedData {
  String userName;
  List<Warehouse> warehouses;
  String userGuid;

  String pin;

  SharedData({
    required this.userName,
    required this.warehouses,
    required this.userGuid,
    required this.pin,
  });

  static final shared =
      SharedData(userName: '', warehouses: [], userGuid: '', pin: '');

  factory SharedData.fromJson(Map<String, dynamic> json) {
    List<dynamic> dss = json['warehouses'];
    List<Warehouse> warehouses = List<Warehouse>.from(dss.map((element) {
      final Map<String, dynamic> el = element;
      return Warehouse.fromJson(el);
    }));

    return SharedData(
        userName: json['user'],
        warehouses: warehouses,
        userGuid: json['userGuid'],
        pin: json['pin']);
  }
}
