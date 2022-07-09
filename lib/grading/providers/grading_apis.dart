import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class GradingApis with ChangeNotifier {
  List _eggGradingList = [];
  List _birdGradingList = [];
  List get eggGradingList {
    return _eggGradingList;
  }

  List get birdGradingList {
    return _birdGradingList;
  }

  Future<int> getEggGrading(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/api/v1/grade-types/add-egg-grade/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      var responseData = json.decode(response.body);

      _eggGradingList = responseData;

      // log(responseData.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> postEggGrading(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/api/v1/grade-types/add-egg-grade/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Egg_Grade_Name': data,
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateEggGrading(
    var name,
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/api/v1/grade-types/edit-egg-grade/$id');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Egg_Grade_Name': name,
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteEggGrading(
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/api/v1/grade-types/edit-egg-grade/$id');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        getEggGrading(token);
      }

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getBirdGrading(
    var token,
  ) async {
    log(token.toString());
    //log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/api/v1/grade-types/add-bird-grade/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      var responseData = json.decode(response.body);

      _birdGradingList = responseData;

      // log(responseData.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> postBirdGrading(
    var data,
    var token,
  ) async {
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/api/v1/grade-types/add-bird-grade/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Bird_Grade_Name': data,
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateBirdGrading(
    var name,
    var id,
    var token,
  ) async {
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/api/v1/grade-types/edit-bird-grade/$id');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Bird_Grade_Name': name,
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteBirdGrading(
    var id,
    var token,
  ) async {
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/api/v1/grade-types/edit-bird-grade/$id');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        getBirdGrading(token);
      }

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }
}
