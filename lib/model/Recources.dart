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
  String userGuid;
  String warehouseGuid;
  String pin;

  SharedData({
    required this.userName,
    required this.warehouseName,
    required this.userGuid,
    required this.warehouseGuid,
    required this.pin,
  });

  static final shared = SharedData(
      userName: '',
      warehouseName: '',
      userGuid: '',
      warehouseGuid: '',
      pin: '');

  factory SharedData.fromJson(Map<String, dynamic> json) {
    return SharedData(
        userName: json['user'],
        warehouseName: json['storage'],
        userGuid: json['userGuid'],
        warehouseGuid: json['storageGuid'],
        pin: json['pin']);
  }
}
