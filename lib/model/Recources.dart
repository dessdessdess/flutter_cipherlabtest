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
  String warehouseName;

  SharedData({
    required this.userName,
    required this.warehouseName,
  });

  static final shared = SharedData(userName: '', warehouseName: '');

  factory SharedData.fromJson(Map<String, dynamic> json) {
    return SharedData(userName: json['user'], warehouseName: json['storage']);
  }
}
