import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/exception_handle.dart';

class AdminApis with ChangeNotifier {
  List _userRoles = [];
  List _users = [];
  // var baseUrl = 'https://poultryfarmapp.herokuapp.com/';

  Map<String, dynamic> _individualUserRoles = {};

  List get users {
    return _users;
  }

  List get userRoles {
    return _userRoles;
  }

  Map<String, dynamic> get individualUserRoles {
    return _individualUserRoles;
  }

  Future<int> getUserRoles(
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse('${baseUrl}users/user-roles-list/');
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
        // for (var data in responseData) {
        //   _firmDetails.add(data['Firm_Name']);
        // }
        _userRoles = responseData;
      }

      // debugPrint(response.statusCode);
      // debugPrint(response.body);
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getIndividualUserRoles(
    var token,
    var id,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse('${baseUrl}users/user-roles-details/$id/');
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
        // for (var data in responseData) {
        //   _firmDetails.add(data['Firm_Name']);
        // }
        Map<String, dynamic> temp = {
          'Role_Id': responseData['Role_Id'],
          'Role_Name': responseData['Role_Name'],
          'Role_Permission': responseData['Role_Permission'][0],
          'Description': responseData['Description'],
        };
        _individualUserRoles = temp;
      }

      // debugPrint(response.statusCode);
      debugPrint(response.body.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> addUserRoles(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}users/user-roles-list/');
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
        ExceptionHandle handle = ExceptionHandle();
        handle.handleException(response);
      }
      // debugPrint(response.statusCode);
      // debugPrint(response.body);

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> updateUserRoles(
    var data,
    var token,
    var id,
  ) async {
    final url = Uri.parse('${baseUrl}users/user-roles-details/$id/');
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
        ExceptionHandle handle = ExceptionHandle();
        handle.handleException(response);
      }

      // debugPrint(response.statusCode);
      // debugPrint(response.body);

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> editUserRoles(
    var data,
    var id,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}api/v1/users/roles-edit/$id');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Role_Name': data['Role_Name'],
          'Role_Description': data['Role_Description'],
          'Role_Permissions': data['Role_Permission'],
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

  Future<int> getSingleUserRole(
    var token,
    var id,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse('${baseUrl}api/v1/users/roles-edit/$id');
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
      _userRoles = responseData;
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> deleteSingleUserRole(
    var token,
    var id,
  ) async {
    // log(data.toString());
    final url = Uri.parse('${baseUrl}api/v1/users/roles-edit/$id');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> addUser(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}users/user-list/');
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
      // debugPrint(response.statusCode);
      // debugPrint(response.body);

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateUser(var data, var token, var id) async {
    final url = Uri.parse('${baseUrl}users/user-details/$id/');
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
      // debugPrint(response.statusCode);
      // debugPrint('update user ${response.body}');
      if (response.statusCode == 202 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        return {
          'Status_Code': response.statusCode,
          'Body': responseData,
        };
      } else {
        return {
          'Status_Code': response.statusCode,
          'Body': {},
        };
      }
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getUsers(
    var token,
  ) async {
    // log(token);

    final url = Uri.parse('${baseUrl}users/user-list/');
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
      debugPrint('User ${response.body}');

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];

        for (var data in responseData) {
          temp.add({
            "id": data['id'],
            "Role_Id": data['Role_Id'],
            "Role_Id__Role_Name": data['Role_Id__Role_Name'],
            "email": data['email'],
            "First_Name": data['First_Name'],
            "Last_Name": data['Last_Name'],
            "Mobile_Number": data['Mobile_Number'],
            "created": data['created'],
            "Joining_Date": data['Joining_Date'],
            "is_active": data['is_active'],
            "username": data['username'],
            "had_Access": data['had_Access'],
            'Is_Selected': false,
          });
        }

        _users = temp;
      }

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> editUser(
    var data,
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}api/v1/users/list-edit/$id');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'User_Role_Name': data['User_Role_Name'],
          'User_Name': data['User_Name'],
          'User_Phone_Number': data['User_Phone_Number'],
          'User_Email': data['User_Email'],
          'User_Permissions': data['User_Permissions'],
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

  Future<int> deleteUser(
    var id,
    var token,
  ) async {
    // log(token);

    final url = Uri.parse('${baseUrl}api/v1/users/list-edit/$id');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }
}
