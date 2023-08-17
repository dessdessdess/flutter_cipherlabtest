class AuthInfo {
  final bool result;
  final String userGuid;
  final String user;
  final String pin;
  final List<Warehouse> warehouses;

  const AuthInfo({
    required this.result,
    required this.userGuid,
    required this.user,
    required this.pin,
    required this.warehouses,
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    List<dynamic> dss = json['Склады'];

    List<Warehouse> warehouses = List<Warehouse>.from(dss.map((element) {
      final Map<String, dynamic> el = element;
      return Warehouse.fromJson(el);
    }));

    return AuthInfo(
      result: json['Result'],
      userGuid: json['USERGUID'],
      user: json['User'],
      pin: json['PIN'],
      warehouses: warehouses,
    );
  }

  Map<String, dynamic> toJson() => {
        'userGuid': userGuid,
        'user': user,
        'pin': pin,
        'warehouses': warehouses,
      };
}

class Warehouse {
  final String name;
  final String guid;

  Warehouse({required this.name, required this.guid});

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
        name: json['Склад'] ?? json['name'],
        guid: json['GUIDСклада'] ?? json['guid']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'guid': guid,
      };
}
