import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<AuthInfo> auth(String userGuid) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic 0J7QsdC80LXQvdCU0J7QmtCe0KDQnzpSamh2bXQyNzU0'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://192.168.11.30/Brinex_abzanov.r/hs/StoragePointV2/Auth'));
    request.body = json.encode({"Параметрыавторизации": userGuid});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return AuthInfo.fromJson(
          jsonDecode(await response.stream.bytesToString()));
    } else {
      debugPrint(response.reasonPhrase);
    }

    return const AuthInfo(
        result: "result",
        userGuid: "userGuid",
        user: "user",
        pin: "pin",
        storageGuid: "storageGuid",
        storage: "storage");
  }

  static Future<List<InventoryDoc>> getTasksInProgress(int index) async {
    return [
      const InventoryDoc(
          number: 'Г0001361',
          date: '19.05.2023',
          warehouse: 'Тамбов 1, Тулиновская 6 ',
          docType: 'Инвентаризация товаров на складе ',
          guid: '123',
          goods: []),
      const InventoryDoc(
          number: 'Г0001362',
          date: '20.05.2023',
          warehouse: 'Тамбов 1, Тулиновская 6 ',
          docType: 'Инвентаризация товаров на складе ',
          guid: '124',
          goods: []),
      const InventoryDoc(
          number: 'Г0001363',
          date: '21.05.2023',
          warehouse: 'Тамбов 1, Тулиновская 6 ',
          docType: 'Инвентаризация товаров на складе ',
          guid: '125',
          goods: []),
      const InventoryDoc(
          number: 'Г0001364',
          date: '22.05.2023',
          warehouse: 'Тамбов 1, Тулиновская 6 ',
          docType: 'Инвентаризация товаров на складе ',
          guid: '123',
          goods: []),
      const InventoryDoc(
          number: 'Г0001365',
          date: '23.05.2023',
          warehouse: 'Тамбов 1, Тулиновская 6 ',
          docType: 'Инвентаризация товаров на складе ',
          guid: '124',
          goods: []),
      const InventoryDoc(
          number: 'Г0001366',
          date: '24.05.2023',
          warehouse: 'Тамбов 1, Тулиновская 6 ',
          docType: 'Инвентаризация товаров на складе ',
          guid: '125',
          goods: [])
    ];
  }
}

class AuthInfo {
  final String result;
  final String userGuid;
  final String user;
  final String pin;
  final String storageGuid;
  final String storage;

  const AuthInfo({
    required this.result,
    required this.userGuid,
    required this.user,
    required this.pin,
    required this.storageGuid,
    required this.storage,
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    return AuthInfo(
      result: json['Result'],
      userGuid: json['USERGUID'],
      user: json['User'],
      pin: json['PIN'],
      storageGuid: json['Storage'],
      storage: json['StorageName'],
    );
  }
}

class InventoryDoc {
  final String number;
  final String date;
  final String warehouse;
  final String docType;
  final String guid;
  final List<InventoryGood> goods;

  const InventoryDoc({
    required this.number,
    required this.date,
    required this.warehouse,
    required this.docType,
    required this.guid,
    required this.goods,
  });

  factory InventoryDoc.fromJson(Map<String, dynamic> json) {
    return InventoryDoc(
      number: json['Номер'],
      date: json['Дата'],
      warehouse: json['Склад'],
      docType: json['ВидДокумента'],
      guid: json['GUID'],
      goods: json['Товары'],
    );
  }
}

class InventoryGood {
  final String nomenclatureGuid;
  final String nomenclature;
  final String characteristicGuid;
  final String characteristic;
  final String quantity;

  const InventoryGood({
    required this.nomenclatureGuid,
    required this.nomenclature,
    required this.characteristicGuid,
    required this.characteristic,
    required this.quantity,
  });

  factory InventoryGood.fromJson(Map<String, dynamic> json) {
    return InventoryGood(
      nomenclatureGuid: json['GUIDНоменклатуры'],
      nomenclature: json['Номенклатура'],
      characteristicGuid: json['GUIDХарактеристики'],
      characteristic: json['Характеристика'],
      quantity: json['Количество'],
    );
  }
}
