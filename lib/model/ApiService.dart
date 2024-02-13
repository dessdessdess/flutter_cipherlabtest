import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cipherlabtest/model/AcceptedTasksByOtherUser.dart';
import 'package:flutter_cipherlabtest/model/Task.dart';
import 'package:flutter_cipherlabtest/model/WorkTask.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AuthInfo.dart';

class ApiService {
  static const headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Basic 0J7QsdC80LXQvdCU0J7QmtCe0KDQnzpSamh2bXQyNzU0'
  };

  static const serverAddress =
      'http://192.168.11.30/Brinex_abzanov.r/hs/StoragePoint';

  static const version = 'v1';

  static Future<AuthInfo?> auth(String userGuid) async {
    // if (userGuid == 'User=5ec715b1-40b1-11e9-bba5-14187764496c') {
    //   return AuthInfo(
    //       result: true,
    //       userGuid: "5ec715b1-40b1-11e9-bba5-14187764496c",
    //       user: "Плотников Евгений Васильевич",
    //       pin: "1111",
    //       warehouses: [
    //         Warehouse(
    //             name: 'Воронеж РЦ',
    //             guid: 'c17efa2e-2ea0-11e9-bb9f-14187764496c'),
    //         Warehouse(
    //             name: 'Воронеж РЦ «Транзит»',
    //             guid: '55a210a0-2ec7-11e9-bb9f-14187764496c'),
    //         Warehouse(
    //             name: 'Воронеж РЦ «СпецЗаказ»',
    //             guid: '86fe2ee3-2ec7-11e9-bb9f-14187764496c')
    //       ]);
    // }

    // var headers = {
    //   'Content-Type': 'application/json',
    //   'Authorization': 'Basic 0J7QsdC80LXQvdCU0J7QmtCe0KDQnzpSamh2bXQyNzU0'
    // };

    try {
      var request =
          http.Request('POST', Uri.parse('$serverAddress/$version/Auth'));
      request.body = json.encode({"Параметрыавторизации": userGuid});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return AuthInfo.fromJson(
            jsonDecode(await response.stream.bytesToString()));
      } else {
        debugPrint(response.reasonPhrase);
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<List<Task>> getTasks(int currentSection, String userGuid,
      String warehouseGuid, DateTime date) async {
    Uri uri;

    List<Task> tasks = [];

    switch (currentSection) {
      case 1:
        uri = Uri.parse('$serverAddress/$version/Read/Tasks');
        break;
      default:
        return tasks;
    }

    var request = http.Request('POST', uri);
    request.body = json.encode({
      "GUIDПользователя": userGuid,
      'GUIDСклада': warehouseGuid,
      'Дата': date.toIso8601String()
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final List<dynamic> taskList =
            jsonDecode(await response.stream.bytesToString());

        for (var el in taskList) {
          tasks.add(Task.fromJson(el));
        }

        return tasks;
      } else {
        debugPrint(response.reasonPhrase);
        return tasks;
      }
    } catch (e) {
      debugPrint(e.toString());
      return tasks;
    }
  }

  static Future<List<WorkTask>> getWorkTasks(int currentSection,
      String userGuid, String warehouseGuid, DateTime date) async {
    Uri uri;

    List<WorkTask> workTasks = [];

    switch (currentSection) {
      case 1:
        uri = Uri.parse('$serverAddress/$version/Read/TasksInProgress');
        break;
      default:
        return workTasks;
    }

    var request = http.Request('POST', uri);
    request.body = json.encode({
      "GUIDПользователя": userGuid,
      'GUIDСклада': warehouseGuid,
      'Дата': date.toIso8601String()
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final taskList = jsonDecode(await response.stream.bytesToString());

        taskList.forEach((el) {
          workTasks.add(WorkTask.fromJson(el));
        });

        return workTasks;
      } else {
        debugPrint(response.reasonPhrase);
        return workTasks;
      }
    } catch (e) {
      debugPrint(e.toString());
      return workTasks;
    }
  }

  static Future<List<AcceptedTasksByOtherUser>> sendAcceptedTasks(
      int currentSection, String userGuid, List<Task> acceptedTasks) async {
    List<AcceptedTasksByOtherUser> acceptedTasksByOtherUser = [];
    Uri uri;
    switch (currentSection) {
      case 1:
        uri = Uri.parse('$serverAddress/$version/Write/AcceptedTasks');
        break;
      default:
        return acceptedTasksByOtherUser;
    }

    var request = http.Request('POST', uri);
    request.body = json.encode({"userGuid": userGuid, 'tasks': acceptedTasks});
    request.headers.addAll(headers);

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        final taskList = jsonDecode(await response.stream.bytesToString());

        taskList.forEach((el) {
          acceptedTasksByOtherUser.add(AcceptedTasksByOtherUser.fromJson(el));
        });

        return acceptedTasksByOtherUser;
      } else {
        debugPrint(response.reasonPhrase);
        return acceptedTasksByOtherUser;
      }
    } catch (e) {
      debugPrint(e.toString());
      return acceptedTasksByOtherUser;
    }
  }

  static Future<bool> sendCompletedTasks(List<WorkTask> completedTasks) async {
    var success = false;

    Uri uri = Uri.parse('$serverAddress/$version/Write/CompletedTasks');

    var request = http.Request('POST', uri);
    request.body = json.encode(completedTasks);
    request.headers.addAll(headers);

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        //final taskList = jsonDecode(await response.stream.bytesToString());

        success = true;
        return success;
      } else {
        debugPrint(response.reasonPhrase);
        return success;
      }
    } catch (e) {
      debugPrint(e.toString());
      return success;
    }
  }

  static Future<bool> sendCancelledTasks(
      String userGuid, String guid, String docTypeInternal) async {
    var success = false;

    Uri uri = Uri.parse('$serverAddress/$version/Write/CancelledTasks');

    var request = http.Request('POST', uri);
    request.body = json.encode({
      'guid': guid,
      'userGuid': userGuid,
      'docTypeInternal': docTypeInternal
    });
    request.headers.addAll(headers);

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        success = true;
        return success;
      } else {
        debugPrint(response.reasonPhrase);
        return success;
      }
    } catch (e) {
      debugPrint(e.toString());
      return success;
    }
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
