import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

import '../../main.dart';

class TransferJournalApi with ChangeNotifier {
  List _transferOutJournalData = [];

  Map<String, dynamic> _individualTransferOutJournalData = {};

  List _transferException = [];

  List get transferException {
    return _transferException;
  }

  List get transferOutJournalData {
    return _transferOutJournalData;
  }

  Map<String, dynamic> get individualTransferOutJournalData {
    return _individualTransferOutJournalData;
  }

  void handleException(var response) {
    var responseData = json.decode(response.body) as Map<String, dynamic>;
    _transferException.clear();
    responseData.forEach((key, value) {
      _transferException.add({'Key': key, 'Value': value});
    });

    notifyListeners();
  }

  Future<int> addTransferOutJournal(
    var data,
    var token,
  ) async {
    log(token);
    final url = Uri.parse('${baseUrl}inventory-operations/transferout-list/');
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

  Future<int> updateTransferOutJournal(
    var data,
    var id,
    var token,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}inventory-operations/transferout-details/$id/');
    try {
      final response = await http.put(
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

  Future<int> deleteTransferOutJournal(
    var data,
    var token,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}inventory-operations/transferout-details/0/');
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
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getTransferOutJournal(
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}inventory-operations/transferout-list/');
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
            "Transfer_Out_Id": data['Transfer_Out_Id'],
            "Created_Date": data['Created_Date'],
            "Transfer_Out_Code": data['Transfer_Out_Code'],
            "Dispatch_Date": data['Dispatch_Date'],
            "WareHouse_Id": data['WareHouse_Id_From'],
            "From_WareHouse_Name": data['WareHouse_Id_From__WareHouse_Code'],
            "Product_Id": data['Product'],
            "Product_Name": data['Product__Product_Name'],
            "Product_Category_Id": data['Product__Product_Category_Id'],
            "Product_Category_Name":
                data['Product__Product_Category_Id__Product_Category_Name'],
            "Product_Sub_Category_Id": data['Product__Product_Sub_Category_Id'],
            "Product_Sub_Category_Name": data[
                'Product__Product_Sub_Category_Id__Product_Sub_Category_Name'],
            "Batch_Plan_Id": data['Batch_Plan_Id'],
            "Batch_Plan_Code": data['Batch_Plan_Id__Batch_Plan_Code'],
            "Transfer_Quantity": data['Transfer_Quantity'],
            "Unit_Id": data['Unit_Id'],
            "Unit_Name": data['Unit_Id__Unit_Name'],
            "Transfer_Status": data['Transfer_Status'],
            "Remarks": data['Remarks'],
            "From_Plant_Id": data['WareHouse_Id_From__WareHouse_Plant_Id'],
            "From_Plant_Name":
                data['WareHouse_Id_From__WareHouse_Plant_Id__Plant_Name'],
            "From_Firm_Id":
                data['WareHouse_Id_From__WareHouse_Plant_Id__Firm_Id'],
            "From_Firm_Name": data[
                'WareHouse_Id_From__WareHouse_Plant_Id__Firm_Id__Firm_Name'],
            "WareHouse_Id_To": data['WareHouse_Id_To'],
            "To_WareHouse_Name": data['WareHouse_Id_To__WareHouse_Name'],
            "To_Plant_Id": data['WareHouse_Id_To__WareHouse_Plant_Id'],
            "To_Plant_Name":
                data['WareHouse_Id_To__WareHouse_Plant_Id__Plant_Name'],
            "To_Firm_Id": data['WareHouse_Id_To__WareHouse_Plant_Id__Firm_Id'],
            "To_Firm_Name":
                data['WareHouse_Id_To__WareHouse_Plant_Id__Firm_Id__Firm_Name'],
            'Is_Selected': false,
          });
        }
        _transferOutJournalData = temp;

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

  Future<int> getIndividualTransferOutJournal(
    var id,
    var token,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}inventory-operations/transferout-data/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        _individualTransferOutJournalData = responseData;

        notifyListeners();
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> addTransferInJournal(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}inventory-operations/transferin-list/');
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
}
