import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class TransferJournalApi with ChangeNotifier {
  var baseUrl = 'https://poultryfarmapp.herokuapp.com/';

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
      _transferException.add(value);
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

      if (response.statusCode == 400) {
        handleException(response);
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
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
      if (response.statusCode == 400) {
        handleException(response);
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
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

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
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

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "Transfer_Out_Id": data['Transfer_Out_Id'],
            "Transfer_Code": data['Transfer_Code'],
            "Despatch_Date": data['Despatch_Date'],
            "Transfer_Status": data['Transfer_Status'],
            "Product": data['Product__Product_Name'],
            "Transfer_Quantity": data['Transfer_Quantity'],
            "Remarks": data['Remarks'],
            "WareHouse_Id": data['WareHouse_Id__WareHouse_Name'],
            "Batch_Id": data['Batch_Id__Batch_Code'],
            'Is_Selected': false,
          });
        }
        _transferOutJournalData = temp;

        notifyListeners();
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
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
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        _individualTransferOutJournalData = responseData;

        notifyListeners();
      }

      return response.statusCode;
    } catch (e) {
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

      if (response.statusCode == 400) {
        handleException(response);
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }
}
