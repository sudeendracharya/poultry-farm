import 'dart:convert';
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';

class BreedInfoApis with ChangeNotifier {
  var _token;

  List _breedException = [];

  BreedInfoApis([this._token]);
  List _breedInfo = [];

  List _breedVersion = [];

  List _birdAgeGroup = [];
  List _birdReferenceDetail = [];

  List get breedInfo {
    return _breedInfo;
  }

  List get breedException {
    return _breedException;
  }

  List get breedVersion {
    return _breedVersion;
  }

  List get birdAgeGroup {
    return _birdAgeGroup;
  }

  List get birdReferenceDetail {
    return _birdReferenceDetail;
  }

  var baseUrl = 'https://poultryfarmapp.herokuapp.com/';

  Future<int> getBreed(
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse('${baseUrl}breedversion-info/breedinfo-list/');
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

        for (var data in responseData) {
          temp.add({
            'Breed_Id': data['Breed_Id'],
            'Breed_Name': data['Breed_Name'],
            'Vendor': data['Vendor'],
            'Is_Selected': false,
          });
        }

        _breedInfo = temp;
        // log(responseData.toString());
      }

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getBreedversionInfo(
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse('${baseUrl}breedversion-info/breedversion-list/');
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
        for (var data in responseData) {
          temp.add({
            'Breed_Version_Id': data['Breed_Version_Id'],
            'Breed_Version': data['Breed_Version'],
            'Reference_Data': data['Reference_Data'],
            'Breed_Id': data['Breed_Id'],
            'Is_Selected': false,
          });
        }

        _breedVersion = temp;
        // print('breed version ${responseData.toString()}');
      }
      // print(response.statusCode);

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addBreed(
    var data,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse('${baseUrl}breedversion-info/breedinfo-list/');
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
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        _breedException.clear();
        responseData.forEach((key, value) {
          _breedException.add(value);
        });

        notifyListeners();
      }
      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateBreed(
    var data,
    var id,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse('${baseUrl}breedversion-info/breedinfo-details/$id/');
    try {
      final response = await http.put(
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

  Future<int> deleteBreeds(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}breedversion-info/breedinfo-details/0/');
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

  void handleException(var response) {
    var responseData = json.decode(response.body) as Map<String, dynamic>;
    _breedException.clear();
    responseData.forEach((key, value) {
      _breedException.add(value);
    });

    notifyListeners();
  }

  Future<int> addBreedVersionDetails(var data, var token) async {
    // log(token);
    final url = Uri.parse('${baseUrl}breedversion-info/breedversion-list/');
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

    //-------Send request
  }

  Future<int> deleteVersionDetails(var data, var token) async {
    final url =
        Uri.parse('${baseUrl}breedversion-info/breedversion-details/0/');
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

    //-------Send request
  }

  Future<int> updateBreedVersionDetails(var data, var id, var token) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}breedversion-info/breedversion-details/$id/');
    try {
      final response = await http.put(
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

    //-------Send request
  }

  Future<int> getBirdAgeGroup(
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse('${baseUrl}breedversion-info/birdagegroup-list/');
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

        for (var data in responseData) {
          temp.add({
            'Bird_Age_Id': data['Bird_Age_Id'],
            'Breed_Id': data['Breed_Id'],
            'Name': data['Name'],
            'Start_Week': data['Start_Week'],
            'End_Week': data['End_Week'],
            'Is_Selected': false,
          });
        }
        _birdAgeGroup = temp;
        // print(responseData.toString());
      }

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addBirdAgeGroup(
    var data,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse('${baseUrl}breedversion-info/birdagegroup-list/');
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

  Future<int> deleteBirdAgeGroup(
    var data,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url =
        Uri.parse('${baseUrl}breedversion-info/birdagegroup-details/0/');
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

  Future<int> updateBirdAgeGroup(
    var data,
    var id,
    var token,
  ) async {
    final url =
        Uri.parse('${baseUrl}breedversion-info/birdagegroup-details/$id/');
    try {
      final response = await http.put(
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

  Future<int> getBirdReferenceData(
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/breed-info/breed-reference-detail/');
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
      _birdReferenceDetail = responseData;
      log(responseData.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addBreedReferenceData(
    var data,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/breed-info/breed-reference-detail/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Breed_Version_Id': data['Breed_Version_Id'],
          'Day': data['Day'],
          'Body_Weight': data['Body_Weight'],
          'Feed_Consumption': data['Feed_Consumption'],
          'Egg_Production_Rate': data['Egg_Production_Rate'],
          'Mortality': data['Mortality'],
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }
}
