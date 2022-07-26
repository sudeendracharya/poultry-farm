import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class DashBoardApicalls with ChangeNotifier {
  var _token;

  DashBoardApicalls([this._token]);
  List _firmDetails = [];
  List _plantDetails = [];
  List _dashBoardDetails = [];
  static var reload;

  List get firmDetails {
    return _firmDetails;
  }

  List get plantDetails {
    return _plantDetails;
  }

  List get dashBoardDetails {
    return _dashBoardDetails;
  }

  Future<void> getDashBoardScreenDetails(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}api/v1/infrastructure/load-firm-plant/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      var responseData = json.decode(response.body) as Map<String, dynamic>;

      if (responseData.isNotEmpty) {
        responseData.forEach((key, value) {
          _firmDetails.add(key);
          _plantDetails.add(value);
        });
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getFirmDetails(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}api/v1/infrastructure/');
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
      _firmDetails = responseData;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getPlantDetails(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}api/v1/infrastructure/plant/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      var responseData = json.decode(response.body);

      _plantDetails = responseData;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
