import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../../main.dart';

class InventoryApi with ChangeNotifier {
  List _batchDetails = [];

  Map<String, dynamic> _singleBatchDetails = {};

  List _logDailyBatchList = [];

  List _inventoryBatchExceptions = [];

  List get logDailyBatchList {
    return _logDailyBatchList;
  }

  List get inventoryBatchExceptions {
    return _inventoryBatchExceptions;
  }

  List get batchDetails {
    return _batchDetails;
  }

  Map<String, dynamic> get singleBatchDetails {
    return _singleBatchDetails;
  }

  void handleException(var response) {
    var responseData = json.decode(response.body) as Map<String, dynamic>;
    _inventoryBatchExceptions.clear();
    responseData.forEach((key, value) {
      _inventoryBatchExceptions.add({'Key': key, 'Value': value});
    });

    notifyListeners();
  }

  Future<int> addBatch(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}batch-plan/batchplan-list/mapping/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );
      forbidden(response);
      if (response.statusCode == 400) {
        handleException(response);
      }
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> updateBatch(
    var data,
    var id,
    var token,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}batch-plan/batchplan-details/mapping/$id/');
    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );
      forbidden(response);
      if (response.statusCode == 400) {
        handleException(response);
      }

      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> deleteBatch(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}batch-plan/batch-details/0/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );
      forbidden(response);
      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getBatch(
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}batch-plan/batchplan-list/mapping/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            'Batch_Plan_Id': data['Batch_Plan_Id'],
            "Batch_Plan_Code": data['Batch_Plan_Code'],
            "Breed_Name": data['Breed_Id__Breed_Name'],
            "Activity_Code": data['Activity_Plan_Id__Activity_Code'],
            "Vaccination_Code": data['Vaccination_Plan_Id__Vaccination_Code'],
            "Medication_Code": data['Medication_Plan_Id__Medication_Code'],
            'Status': data['Status'],
            'Is_Selected': false,
          });
        }

        _batchDetails = temp;
        notifyListeners();
      }

      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getSingleBatch(
    var id,
    var token,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}batch-plan/batchplan-details/mapping/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        _singleBatchDetails = responseData;
        notifyListeners();
      }

      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> addDailyBatch(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}activities-log/batchlog-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );
      forbidden(response);
      if (response.statusCode == 400) {
        handleException(response);
      }
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getDailyBatch(
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}activities-log/batchlog-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        // List temp = [];
        // for (var data in responseData) {
        //   temp.add({
        //     "BatchLog_Id": data['BatchLog_Id'],
        //     "Average_Body_Weight": data['Average_Body_Weight'],
        //     "Weight_Unit": data['Weight_Unit'],
        //     "Total_Feed_Consumption": data['Total_Feed_Consumption'],
        //     "Feed_Consumption_Unit": data['Feed_Consumption_Unit'],
        //     "WareHouse_Id": data['WareHouse_Id'],
        //     "Batch_Id": data['Batch_Id'],
        //     // "Is_Selected": false,
        //   });
        // }

        _logDailyBatchList = responseData;
        notifyListeners();
      }

      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }
}
