import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LogsApi with ChangeNotifier {
  var baseUrl = 'https://poultryfarmapp.herokuapp.com/';

  Map<String, dynamic> _activityLog = {};

  Map<String, dynamic> _medicationLog = {};

  Map<String, dynamic> _vaccinationLog = {};

  Map<String, dynamic> logException = {};

  List _batchPlanCodeList = [];

  List _activityNumbersList = [];

  List _vaccinationNumbersList = [];

  List _medicationNumbersList = [];

  List get medicationNumbersList {
    return _medicationNumbersList;
  }

  List get vaccinationNumbersList {
    return _vaccinationNumbersList;
  }

  List get activityNumbersList {
    return _activityNumbersList;
  }

  List get batchPlanCodeList {
    return _batchPlanCodeList;
  }

  Map<String, dynamic> get logExceptionData {
    return logException;
  }

  Map<String, dynamic> get vaccinationLog {
    return _vaccinationLog;
  }

  Map<String, dynamic> get medicationLog {
    return _medicationLog;
  }

  Map<String, dynamic> get activityLog {
    return _activityLog;
  }

  Future<void> getActivityLog(
      var batchCode, var activityNumber, var token) async {
    final url = Uri.parse(
        '${baseUrl}batch-plan/batch-activity/Activity/$batchCode/$activityNumber/');
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        _activityLog = responseData;
        notifyListeners();
      } else if (response.statusCode == 404) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        logException = responseData;

        notifyListeners();
      }

      print(response.statusCode);
      print(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getBatchPlanCodes(var batchPlanCode, var token) async {
    final url =
        Uri.parse('${baseUrl}batch-plan/batch-search/?search=$batchPlanCode');
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(batchCode),
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        _batchPlanCodeList = responseData;
        notifyListeners();
      } else if (response.statusCode == 404) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        logException = responseData;

        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> searchActivityNumbers(var activityNumbers, var token) async {
    final url = Uri.parse(
        '${baseUrl}activities-log/activity-search/?search=$activityNumbers');
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(batchCode),
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        _activityNumbersList = responseData;
        notifyListeners();
      } else if (response.statusCode == 404) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        logException = responseData;

        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> searchVaccinationNumbers(
      var vaccinationNumbers, var token) async {
    final url = Uri.parse(
        '${baseUrl}activities-log/vaccination-activity-search/?search=$vaccinationNumbers');
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(batchCode),
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        _vaccinationNumbersList = responseData;
        notifyListeners();
      } else if (response.statusCode == 404) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        logException = responseData;

        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> searchMedicationNumbers(var medicationNumbers, var token) async {
    final url = Uri.parse(
        '${baseUrl}activities-log/medication-activity-search/?search=$medicationNumbers');
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode(batchCode),
      );
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        _medicationNumbersList = responseData;
        notifyListeners();
      } else if (response.statusCode == 404) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        logException = responseData;

        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getMedicationLog(
      var batchCode, var medicationNumber, var token) async {
    final url = Uri.parse(
        '${baseUrl}batch-plan/batch-activity/Medicine/$batchCode/$medicationNumber/');
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _medicationLog = responseData;
        notifyListeners();
      } else if (response.statusCode == 404) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        logException = responseData;

        notifyListeners();
      }

      print(response.statusCode);
      print(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getVaccinationLog(
      var batchCode, var vaccinationNumber, var token) async {
    final url = Uri.parse(
        '${baseUrl}batch-plan/batch-activity/Vaccination/$batchCode/$vaccinationNumber/');
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _vaccinationLog = responseData;
        notifyListeners();
      } else if (response.statusCode == 404) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;

        logException = responseData;

        notifyListeners();
      }

      print(response.statusCode);
      print(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateActivityLog(var data, var token) async {
    final url = Uri.parse(
        '${baseUrl}activities-log/birdactivity-details/${data['Activity_LogId']}/');
    try {
      var response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateMedicationLog(var data, var token) async {
    final url = Uri.parse(
        '${baseUrl}activities-log/birdmedication-details/${data['Medication_LogId']}/');
    try {
      var response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
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

  Future<int> updateVaccinationLog(var data, var token) async {
    final url = Uri.parse(
        '${baseUrl}activities-log/birdvaccination-details/${data['Vaccination_LogId']}/');
    try {
      var response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
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
}
