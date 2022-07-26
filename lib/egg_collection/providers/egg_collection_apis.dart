import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';

import '../../main.dart';

class EggCollectionApis with ChangeNotifier {
  List _eggCollection = [];
  List _mortality = [];

  List get eggCollection {
    return _eggCollection;
  }

  List get mortality {
    return _mortality;
  }

  Future<int> getEggCollection(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}egg-collection/egg-collection/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      var responseData = json.decode(response.body);
      // for (var data in responseData) {
      //   _firmDetails.add(data['Firm_Name']);
      // }
      _eggCollection = responseData;
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addEggCollection(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}egg-collection/egg-collection/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Egg_Collection_Id': data['Egg_Collection_Id'],
          'Egg_Grade_Id': data['Egg_Grade_Id'],
          'Egg_Quantity': data['Egg_Quantity'],
          'Egg_Collection_Date': data['Egg_Collection_Date'],
          'Average_Egg_Weight': data['Average_Egg_Weight'],
          'Egg_Collection_Status': data['Egg_Collection_Status'],
          'Is_Cleared': data['Is_Cleared'],
          'WareHouse_Id': data['Ware_House_Id'],
          'Unit': data['Unit'],
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getBirdMortality(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}inventory-management/bird-mortality/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      var responseData = json.decode(response.body);
      // for (var data in responseData) {
      //   _firmDetails.add(data['Firm_Name']);
      // }
      _mortality = responseData;
      // log(responseData.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addBirdMortality(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}inventory-management/bird-mortality/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Mortlity_Record_Code': data['Mortality_Record_Code'],
          'Ware_House_Id': data['Ware_House_Id'],
          'Mortality_Batch_Id': data['Mortality_Baatch_Id'],
          'Mortality_Date': data['Mortality_Date'],
          'Mortality_Quantity': data['Mortality_Quantity'],
          'Mortality_Description': data['Mortality_Description'],
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }
}
