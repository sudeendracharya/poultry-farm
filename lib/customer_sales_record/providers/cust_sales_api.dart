import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';

class CustomerSalesApis with ChangeNotifier {
  List _salesInfo = [];
  List _customerInfo = [];

  List get salesInfo {
    return _salesInfo;
  }

  List get customerInfo {
    return _customerInfo;
  }

  Future<void> getSalesInfo(
    var token,
  ) async {
    log(token);
    //log(data.toString());
    final url = Uri.parse('https://poultryfarmerp.herokuapp.com/sale-record/');
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
      _salesInfo = responseData;
      log(responseData.toString());
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getCustomerInfo(
    var token,
  ) async {
    log(token);
    //log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/sale-record/customer-info/');
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
      _customerInfo = responseData;
      log(responseData.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addCustomerInfo(
    var data,
    var token,
  ) async {
    log(token);
    log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/sale-record/customer-info/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Customer_Name': data['Customer_Name'],
          'Customer_Contact_Number': data['Customer_Contact_Number']
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }
}
