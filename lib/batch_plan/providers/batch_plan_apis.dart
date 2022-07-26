import 'dart:convert';
import 'dart:developer';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';

import '../../main.dart';

class BatchApis with ChangeNotifier {
  var _token;

  Map<String, dynamic> _individualBatchPlan = {};

  List batchPlanExceptionData = [];

  BatchApis([this._token]);
  List _batchPlan = [];

  List _batchPlanMapping = [];

  Map<String, dynamic> get individualBatchPlan {
    return _individualBatchPlan;
  }

  List get batchPlan {
    return _batchPlan;
  }

  List get batchPlanException {
    return batchPlanExceptionData;
  }

  List get batchPlanMapping {
    return _batchPlanMapping;
  }

  // var baseUrl = 'https://poultryfarmapp.herokuapp.com/';

  void clear() {
    batchPlanExceptionData.clear();
  }

  Future<int> getBatchPlan(
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}batch-plan/batchplan-list/mapping/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // print(response.statusCode);
      // print('batch plan ${response.body}');
      forbidden(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        List temp = [];

        for (var data in responseData) {
          temp.add({
            'Batch_Plan_Id': data['Batch_Plan_Id'],
            'Batch_Code': data['Batch_Plan_Code'],
            'Breed_Id': data['Breed_Id__Breed_Name'],
            'Activity_Code': data['Activity_Plan_Id__Activity_Code'],
            'Medication_Code': data['Medication_Plan_Id__Medication_Code'],
            'Vaccination_Code': data['Vaccination_Plan_Id__Vaccination_Code'],
            'Is_Selected': false,
          });
        }

        _batchPlan = temp;

        notifyListeners();
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getIndividualBatchPlan(
    var id,
    var token,
  ) async {
    final url =
        Uri.parse('${baseUrl}batch-plan/batchplan-details/mapping/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        // body: json.encode({'Batch_Plan_Id': id}),
      );
      forbidden(response);
      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);

        _individualBatchPlan = responseData;
        debugPrint(responseData.toString());
      }

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> deleteBatchPlanStepOne(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}batch-plan/batchplan-details/mapping/0/');
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

  void handleException(var response) {
    var responseData = json.decode(response.body) as Map<String, dynamic>;

    responseData.forEach((key, value) {
      batchPlanExceptionData.clear();
      batchPlanExceptionData.add({'Key': key, 'Value': value});
    });

    notifyListeners();
  }

  Future<int> addBatchPlanStepOne(
    var data,
    var token,
  ) async {
    clear();
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

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> addBatchPlanStepTwo(
    var data,
    var token,
  ) async {
    clear();
    final url = Uri.parse('${baseUrl}activities-log/setallactivities-list/');
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
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> deleteBatchPlan(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}batch-plan/batchplan-details/0/');
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

  Future<int> updateBatchPlan(
    var data,
    var id,
    var token,
  ) async {
    clear();
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

  Future<int> getBatchPlanMapping(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}activity-plan/batch-plan-mapping/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      var responseData = json.decode(response.body);
      // for (var data in responseData) {
      //   _firmDetails.add(data['Firm_Name']);
      // }
      _batchPlanMapping = responseData;
      // log(responseData.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> addBatchPlanMapping(
    var data,
    var token,
  ) async {
    clear();
    final url = Uri.parse('${baseUrl}activity-plan/batch-plan-mapping/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Batch_Plan_Id': data['Batch_Plan_Id'],
          'Batch_Code': data['Batch_Code'],
          'Batch_Status': data['Status'],
          'Required_Qunatity': data['Required_Quantity'],
          'Required_Date_Of_Delivery': data['Required_Date_Of_Delivery'],
          'Received_Quantity': data['Received_Quantity'],
          'Received_Date': data['Received_Date'],
          'Hatch_Date': data['Hatch_Date'],
          'Bird_Age_Name': data['Bird_Age_Name'],
        }),
      );
      forbidden(response);
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }
}
