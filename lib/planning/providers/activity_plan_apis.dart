import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';

class ActivityApis with ChangeNotifier {
  var _token;

  var _breedReferenceList = [];

  Map<String, dynamic> _singleActivityPlan = {};

  Map<String, dynamic> _singleVaccinationPlan = {};

  Map<String, dynamic> _singleMedicationPlan = {};

  List _activityPlanException = [];

  ActivityApis([this._token]);
  var baseUrl = 'https://poultryfarmapp.herokuapp.com/';
  List _activityPlan = [];

  List _activityHeader = [];

  List _vaccinationHeader = [];
  List _medicationHeader = [];
  List _medicationPlan = [];
  List _vaccinationPlan = [];
  List _vaccinationDoctorsList = [];
  List _medicationDoctorsList = [];
  List _activityDoctorsList = [];
  List get activityPlan {
    return _activityPlan;
  }

  List get activityHeader {
    return _activityHeader;
  }

  List get activityPlanException {
    return _activityPlanException;
  }

  Map<String, dynamic> get singleActivityPlan {
    return _singleActivityPlan;
  }

  Map<String, dynamic> get singleMedicationPlan {
    return _singleMedicationPlan;
  }

  Map<String, dynamic> get singleVaccinationPlan {
    return _singleVaccinationPlan;
  }

  List get breedReferenceList {
    return _breedReferenceList;
  }

  List get vaccinationHeader {
    return _vaccinationHeader;
  }

  List get medicationHeader {
    return _medicationHeader;
  }

  List get medicationPlan {
    return _medicationPlan;
  }

  List get vaccinationPlan {
    return _vaccinationPlan;
  }

  List get doctorsList {
    return _vaccinationDoctorsList;
  }

  List get medicationDoctorsList {
    return _medicationDoctorsList;
  }

  List get activityDoctorsList {
    return _activityDoctorsList;
  }

  Future<int> getActivityPlan(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}breedversion-info/activityplan-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);

        List temp = [];
        for (int i = 0; i < responseData.length; i++) {
          temp.add({
            'Activity_Id': responseData[i]['Activity_Id'],
            'Activity_Code': responseData[i]['Activity_Code'],
            // 'Recommended_By': responseData[i]['Recommended_By'],
            'Activity_Plan': responseData[i]['Activity_Plan'],
            'Breed_Version_Id': responseData[i]
                ['Breed_Version_Id__Breed_Version'],
            'Is_Selected': false,
          });
        }
        _activityPlan = temp;
      }

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getSingleActivityPlan(var token, var id) async {
    // log(token);
    //log(data.toString());
    final url =
        Uri.parse('${baseUrl}breedversion-info/activityplan-details/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // print(response.statusCode);
      // print(response.body);

      var responseData = json.decode(response.body);
      // for (var data in responseData) {
      //   _firmDetails.add(data['Firm_Name']);
      // }
      _singleActivityPlan = responseData;

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getSingleVaccinationPlan(var token, var id) async {
    // log(token);
    //log(data.toString());
    final url =
        Uri.parse('${baseUrl}breedversion-info/vaccinationplan-details/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // print(response.statusCode);
      // print(response.body);

      var responseData = json.decode(response.body);
      // for (var data in responseData) {
      //   _firmDetails.add(data['Firm_Name']);
      // }
      _singleVaccinationPlan = responseData;

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  void handleException(var response) {
    var responseData = json.decode(response.body) as Map<String, dynamic>;
    _activityPlanException.clear();
    responseData.forEach((key, value) {
      _activityPlanException.add(value);
    });

    notifyListeners();
  }

  Future<int> addActivityPlanData(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}breedversion-info/activityplan-list/');
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

  Future<int> deleteActivityPlanData(
    var data,
    var token,
  ) async {
    final url =
        Uri.parse('${baseUrl}breedversion-info/activityplan-details/0/');
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

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addVaccinationPlanData(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}breedversion-info/vaccinationplan-list/');
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

  Future<int> deleteVaccinationPlanData(
    var data,
    var token,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}breedversion-info/vaccinationplan-details/0/');
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

  Future<int> addMedicationPlanData(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}breedversion-info/medicationplan-list/');
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

  Future<int> deleteMedicationPlanData(
    var data,
    var token,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}breedversion-info/medicationplan-details/0/');
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

  Future<int> getMedicationPlanData(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}breedversion-info/medicationplan-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);

        List temp = [];
        for (int i = 0; i < responseData.length; i++) {
          temp.add({
            'Medication_Id': responseData[i]['Medication_Id'],
            'Medication_Code': responseData[i]['Medication_Code'],
            'Medication_Plan': responseData[i]['Medication_Plan'],
            'Breed_Version_Id': responseData[i]
                ['Breed_Version_Id__Breed_Version'],
            'Is_Selected': false,
          });
        }
        _medicationPlan = temp;
      }

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getSingleMedicationPlanData(var token, var id) async {
    // log(token);
    //log(data.toString());
    final url =
        Uri.parse('${baseUrl}breedversion-info/medicationplan-details/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // print(response.statusCode);
      // print(response.body);

      var responseData = json.decode(response.body);
      // for (var data in responseData) {
      //   _firmDetails.add(data['Firm_Name']);
      // }
      _singleMedicationPlan = responseData;

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateMedicationPlanData(
    var data,
    var token,
    var id,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}breedversion-info/medicationplan-details/$id/');
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

  Future<int> updateActivityPlanData(
    var data,
    var token,
    var id,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}breedversion-info/activityplan-details/$id/');
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

  Future<int> updateVaccinationPlanData(
    var data,
    var token,
    var id,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}breedversion-info/vaccinationplan-details/$id/');
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

  Future<int> getActivityHeader(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/activity-plan/add-recommendar/');
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
      List tempList = [];
      for (var data in responseData) {
        tempList.add(data['Recommended_By']);
      }

      var doctorListData = [
        ...{...tempList}
      ];

      _activityDoctorsList = doctorListData;
      _activityHeader = responseData;

      // log(responseData.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getBreedDetails(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}breedversion-info/breedversion-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // print(response.statusCode);
      // print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        _breedReferenceList = responseData;
      }

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addActivityHeaderData(
    var data,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/activity-plan/add-recommendar/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Recommended_By': data['Recommended_By(DOCTOR)'],
          'Breed_Version_Id': data['Breed_Version_Id'],
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getVaccinationHeader(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/activity-plan/vaccination-header/');
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

      List tempList = [];
      for (var data in responseData) {
        tempList.add(data['Recommended_By']);
      }

      var doctorListData = [
        ...{...tempList}
      ];

      _vaccinationDoctorsList = doctorListData;
      _vaccinationHeader = responseData;

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addVaccinationHeaderData(
    var data,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/activity-plan/vaccination-header/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Recommended_By': data['Recommended_By(DOCTOR)'],
          'Breed_Version_Id': data['Breed_Version_Id'],
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getVaccinationPlan(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}breedversion-info/vaccinationplan-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        List temp = [];

        for (int i = 0; i < responseData.length; i++) {
          temp.add({
            'Vaccination_Id': responseData[i]['Vaccination_Id'],
            'Vaccination_Code': responseData[i]['Vaccination_Code'],
            'Vaccination_Plan': responseData[i]['Vaccination_Plan'],
            'Breed_Version_Id': responseData[i]
                ['Breed_Version_Id__Breed_Version'],
            'Is_Selected': false,
          });
        }
        _vaccinationPlan = temp;
        // print(responseData);
      }

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getMedicationHeader(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/activity-plan/medication-header/');
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
      List tempList = [];
      for (var data in responseData) {
        tempList.add(data['Recommended_By']);
      }

      var doctorListData = [
        ...{...tempList}
      ];

      _medicationDoctorsList = doctorListData;
      _medicationHeader = responseData;

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addMedicationHeaderData(
    var data,
    var token,
  ) async {
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/activity-plan/medication-header/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Recommended_By': data['Recommended_By(DOCTOR)'],
          'Breed_Version_Id': data['Breed_Version_Id'],
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addMedicationPlan(
    var data,
    var token,
  ) async {
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/activity-plan/add-medication-plan/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Medication_Plan': data['Medication_Plan'],
          'Medication_Header': data['Medication_Header'],
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }
}
