import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Apicalls with ChangeNotifier {
  var _token;
  var _userName;
  var _expiryDate;
  var _errorMessage;

  static var plantData;
  List _plantDetails = [];

  List _batchList = [];

  Map<String, dynamic> _batchDetailsData = {};

  List _signupException = [];

  List _standardUnitList = [];

  List _standardBirdGradeList = [];

  List _standardEggGradeList = [];

  List get standardEggGradeList {
    return _standardEggGradeList;
  }

  List get standardUnitList {
    return _standardUnitList;
  }

  List get standardBirdGradeList {
    return _standardBirdGradeList;
  }

  List get signupException {
    return _signupException;
  }

  List get plantDetails {
    return _plantDetails;
  }

  List get batchDetails {
    return _batchList;
  }

  Map<String, dynamic> get batchDetailsData {
    return _batchDetailsData;
  }

  bool get isAuth {
    return token != null;
  }

  get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userName {
    return _userName ?? '';
  }

  String get errorMessage {
    return _errorMessage;
  }

  Future<int> authenticate(
    String email,
    String password,
  ) async {
    final url = Uri.parse('${baseUrl}api/v1/rest-auth/login/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode(
          {
            "username": email.toString(),
            "password": password.toString(),
          },
        ),
      );

      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());
      forbidden(response);
      final responseData = json.decode(response.body);

      if (response.statusCode == 400) {
        // _errorMessage = responseData['non_field_errors'][0];
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        _signupException.clear();
        responseData.forEach((key, value) {
          _signupException.add({'Key': key, 'Value': value});
        });
        notifyListeners();
        return response.statusCode;
        // throw HttpException(responseData['error']['message']);
      }
      _token = responseData['key'];
      // _userId = responseData['agent']['uId'];
      _expiryDate = DateTime.now().add(
        const Duration(days: 60),
      );
      //_autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userName': email.toString(),
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);

      return response.statusCode;
    } catch (error) {
      EasyLoading.dismiss();
      exceptionDialog(error.toString());
      rethrow;
    }
  }

  Future<int> getUserPermissions(var token) async {
    final url = Uri.parse('${baseUrl}users/user-role-permission-list/');
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
        final responseData = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('Firms')) {
          prefs.remove('Firms');
        }
        if (prefs.containsKey('Plants')) {
          prefs.remove('Plants');
        }

        if (prefs.containsKey('Sales')) {
          prefs.remove('Sales');
        }
        if (prefs.containsKey('Sections')) {
          prefs.remove('Sections');
        }
        if (prefs.containsKey('Add_Batch')) {
          prefs.remove('Add_Batch');
        }

        if (prefs.containsKey('Transfer_In')) {
          prefs.remove('Transfer_In');
        }
        if (prefs.containsKey('Transfer_Out')) {
          prefs.remove('Transfer_Out');
        }
        if (prefs.containsKey('WareHouses')) {
          prefs.remove('WareHouses');
        }
        if (prefs.containsKey('Activity_Log')) {
          prefs.remove('Activity_Log');
        }
        if (prefs.containsKey('Batch_Planning')) {
          prefs.remove('Batch_Planning');
        }
        if (prefs.containsKey('Medication_Log')) {
          prefs.remove('Medication_Log');
        }
        if (prefs.containsKey('Breed')) {
          prefs.remove('Breed');
        }
        if (prefs.containsKey('Activity_Plan')) {
          prefs.remove('Activity_Plan');
        }
        if (prefs.containsKey('Breed_Version')) {
          prefs.remove('Breed_Version');
        }
        if (prefs.containsKey('Medication_Plan')) {
          prefs.remove('Medication_Plan');
        }
        if (prefs.containsKey('Vaccination_Plan')) {
          prefs.remove('Vaccination_Plan');
        }
        if (prefs.containsKey('Bird_Age_Grouping')) {
          prefs.remove('Bird_Age_Grouping');
        }
        if (prefs.containsKey('Vaccination_Log')) {
          prefs.remove('Vaccination_Log');
        }
        if (prefs.containsKey('Log_Daily_Batches')) {
          prefs.remove('Log_Daily_Batches');
        }
        if (prefs.containsKey('Product_Management')) {
          prefs.remove('Product_Management');
        }
        if (prefs.containsKey('Mortality')) {
          prefs.remove('Mortality');
        }
        if (prefs.containsKey('Egg_Grading')) {
          prefs.remove('Egg_Grading');
        }
        if (prefs.containsKey('Bird_Grading')) {
          prefs.remove('Bird_Grading');
        }
        if (prefs.containsKey('Egg_Collection')) {
          prefs.remove('Egg_Collection');
        }
        if (prefs.containsKey('Inventory_Adjustment_Journal')) {
          prefs.remove('Inventory_Adjustment_Journal');
        }
        if (prefs.containsKey('Role_Name')) {
          prefs.remove('Role_Name');
        }
        if (prefs.containsKey('Roles')) {
          prefs.remove('Roles');
        }
        if (prefs.containsKey('Users')) {
          prefs.remove('Users');
        }
        if (prefs.containsKey('User_Name')) {
          prefs.remove('User_Name');
        }
        final userName = json.encode(
          {
            'User_Name': {
              'User_Name': responseData[0]['username'],
            },
          },
        );
        prefs.setString('User_Name', userName);
        final users = json.encode(
          {
            'Users': responseData[0]['Role_Id__Role_Permission'][0]['Users'],
          },
        );
        prefs.setString('Users', users);
        final roles = json.encode(
          {
            'Roles': responseData[0]['Role_Id__Role_Permission'][0]['Roles'],
            //  {
            //   "Id": "Roles",
            //   "Edit": true,
            //   "View": true,
            //   "Create": true,
            //   "Delete": true
            // },
          },
        );
        prefs.setString('Roles', roles);
        final roleName = json.encode(
          {
            'Role_Name': {
              'Role_Name': responseData[0]['Role_Id__Role_Name'],
            },
          },
        );
        prefs.setString('Role_Name', roleName);
        final firms = json.encode(
          {
            'Firms': responseData[0]['Role_Id__Role_Permission'][0]['Firms'],
          },
        );
        prefs.setString('Firms', firms);
        final plants = json.encode(
          {
            'Plants': responseData[0]['Role_Id__Role_Permission'][0]['Plants'],
          },
        );
        prefs.setString('Plants', plants);

        final sales = json.encode(
          {
            'Sales': responseData[0]['Role_Id__Role_Permission'][0]['Sales'],
          },
        );
        prefs.setString('Sales', sales);
        final sections = json.encode(
          {
            'Sections': responseData[0]['Role_Id__Role_Permission'][0]
                ['Sections'],
          },
        );
        prefs.setString('Sections', sections);

        final addBatch = json.encode(
          {
            'Add_Batch': responseData[0]['Role_Id__Role_Permission'][0]
                ['Add_Batch'],
          },
        );
        prefs.setString('Add_Batch', addBatch);

        final transferIn = json.encode(
          {
            'Transfer_In': responseData[0]['Role_Id__Role_Permission'][0]
                ['Transfers']['Transfer_In'],
          },
        );
        prefs.setString('Transfer_In', transferIn);
        final transferOut = json.encode(
          {
            'Transfer_Out': responseData[0]['Role_Id__Role_Permission'][0]
                ['Transfers']['Transfer_Out'],
          },
        );
        prefs.setString('Transfer_Out', transferOut);

        final wareHouses = json.encode(
          {
            'WareHouses': responseData[0]['Role_Id__Role_Permission'][0]
                ['WareHouses'],
          },
        );
        prefs.setString('WareHouses', wareHouses);

        final activityLog = json.encode(
          {
            'Activity_Log': responseData[0]['Role_Id__Role_Permission'][0]
                ['Activity_Log'],
          },
        );
        prefs.setString('Activity_Log', activityLog);

        final batchPlanning = json.encode(
          {
            'Batch_Planning': responseData[0]['Role_Id__Role_Permission'][0]
                ['Batch_Planning'],
          },
        );
        prefs.setString('Batch_Planning', batchPlanning);

        final medicationLog = json.encode(
          {
            'Medication_Log': responseData[0]['Role_Id__Role_Permission'][0]
                ['Medication_Log'],
          },
        );
        prefs.setString('Medication_Log', medicationLog);

        final breed = json.encode(
          {
            'Breed': responseData[0]['Role_Id__Role_Permission'][0]
                ['Reference_Data']['Breed'],
          },
        );
        prefs.setString('Breed', breed);

        final activityPlan = json.encode(
          {
            'Activity_Plan': responseData[0]['Role_Id__Role_Permission'][0]
                ['Reference_Data']['Activity_Plan'],
          },
        );
        prefs.setString('Activity_Plan', activityPlan);

        final breedVersion = json.encode(
          {
            'Breed_Version': responseData[0]['Role_Id__Role_Permission'][0]
                ['Reference_Data']['Breed_Version'],
          },
        );
        prefs.setString('Breed_Version', breedVersion);

        final medicationPlan = json.encode(
          {
            'Medication_Plan': responseData[0]['Role_Id__Role_Permission'][0]
                ['Reference_Data']['Medication_Plan'],
          },
        );
        prefs.setString('Medication_Plan', medicationPlan);

        final vaccinationPlan = json.encode(
          {
            'Vaccination_Plan': responseData[0]['Role_Id__Role_Permission'][0]
                ['Reference_Data']['Vaccination_Plan'],
          },
        );
        prefs.setString('Vaccination_Plan', vaccinationPlan);

        final birdAgeGrouping = json.encode(
          {
            'Bird_Age_Grouping': responseData[0]['Role_Id__Role_Permission'][0]
                ['Reference_Data']['Bird_Age_Grouping'],
          },
        );
        prefs.setString('Bird_Age_Grouping', birdAgeGrouping);

        final vaccinationLog = json.encode(
          {
            'Vaccination_Log': responseData[0]['Role_Id__Role_Permission'][0]
                ['Vaccination_Log'],
          },
        );
        prefs.setString('Vaccination_Log', vaccinationLog);

        final logDailyBatches = json.encode(
          {
            'Log_Daily_Batches': responseData[0]['Role_Id__Role_Permission'][0]
                ['Log_Daily_Batches'],
          },
        );
        prefs.setString('Log_Daily_Batches', logDailyBatches);

        final productManagement = json.encode(
          {
            'Product_Management': responseData[0]['Role_Id__Role_Permission'][0]
                ['Product_Management'],
          },
        );
        prefs.setString('Product_Management', productManagement);

        final mortality = json.encode(
          {
            'Mortality': responseData[0]['Role_Id__Role_Permission'][0]
                ['Inventory_Adjustment']['Mortality'],
          },
        );
        prefs.setString('Mortality', mortality);

        final eggGrading = json.encode(
          {
            'Egg_Grading': responseData[0]['Role_Id__Role_Permission'][0]
                ['Inventory_Adjustment']['Egg_Grading'],
          },
        );
        prefs.setString('Egg_Grading', eggGrading);

        final birdGrading = json.encode(
          {
            'Bird_Grading': responseData[0]['Role_Id__Role_Permission'][0]
                ['Inventory_Adjustment']['Bird_Grading'],
          },
        );
        prefs.setString('Bird_Grading', birdGrading);

        final eggCollection = json.encode(
          {
            'Egg_Collection': responseData[0]['Role_Id__Role_Permission'][0]
                ['Inventory_Adjustment']['Egg_Collection'],
          },
        );
        prefs.setString('Egg_Collection', eggCollection);

        final inventoryAdjustmentJournal = json.encode(
          {
            'Inventory_Adjustment_Journal': responseData[0]
                    ['Role_Id__Role_Permission'][0]['Inventory_Adjustment']
                ['Inventory_Adjustment_Journal'],
          },
        );
        prefs.setString(
            'Inventory_Adjustment_Journal', inventoryAdjustmentJournal);
      }

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        _signupException.clear();
        responseData.forEach((key, value) {
          _signupException.add({'Key': key, 'Value': value});
        });
        notifyListeners();
        return response.statusCode;
      }

      //_autoLogOut();
      notifyListeners();

      return response.statusCode;
    } catch (error) {
      rethrow;
    }
  }

  Future<int> authenticateTest(
    String email,
    String password,
  ) async {
    final url = Uri.parse('${baseUrl}api/v1/rest-auth/login/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode(
          {
            "username": email.toString(),
            "password": password.toString(),
          },
        ),
      );

      return response.statusCode;
    } catch (error) {
      EasyLoading.dismiss();
      exceptionDialog(error.toString());
      rethrow;
    }
  }

  Future<int> signUp(Map<String, String> data) async {
    final url = Uri.parse('${baseUrl}api/v1/rest-auth/registration/');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        // headers: {
        //   "Content-Type": "application/json",
        //   //"Authorization": token,
        // },
        body: json.encode({
          'username': data['username'],
          'email': data['email'],
          'first_name': data['First_Name'],
          'last_name': data['Last_Name'],
          'Permissions': data['Permissions'],
          'Role': data['Roles'],
          'mobile_number': data['Mobile_Number'],
          'password1': data['password1'],
          'password2': data['password2'],
        }),
      );
      forbidden(response);
      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['error'] != null) {
          throw HttpException(responseData['error']['message']);
        }
        // _token = responseData['key'];
        // // _userId = responseData['agent']['uId'];
        // _expiryDate = DateTime.now().add(
        //   const Duration(days: 60),
        // );
        // notifyListeners();
        // final prefs = await SharedPreferences.getInstance();
        // final userData = json.encode(
        //   {
        //     'token': _token,
        //     // 'userId': _userId,
        //     'expiryDate': _expiryDate.toIso8601String(),
        //   },
        // );
        // prefs.setString('userData', userData);
      } else if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        _signupException.clear();
        responseData.forEach((key, value) {
          _signupException.add({'Key': key, 'Value': value});
        });
        Get.dialog(Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Container(
                width: 300,
                height: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: _signupException.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Text(_signupException[index]['Key']),
                          Text(_signupException[index]['Value'][0]),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ));
        notifyListeners();
      }

      //_autoLogOut();

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());

      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    final url = Uri.parse('${baseUrl}users/user-info-list/');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        // headers: {
        //   "Content-Type": "application/json",
        //   //"Authorization": token,
        // },
      );
      forbidden(response);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        return {'StatusCode': response.statusCode, 'Id': responseData['id']};
      }

      // print(response.statusCode);
      // print(response.body);

      // final responseData = json.decode(response.body);

      // if (responseData['error'] != null) {
      //   throw HttpException(responseData['error']['message']);
      // }
      // _token = responseData['key'];
      // // _userId = responseData['agent']['uId'];
      // _expiryDate = DateTime.now().add(
      //   const Duration(days: 60),
      // );
      // //_autoLogOut();
      // notifyListeners();
      // final prefs = await SharedPreferences.getInstance();
      // final userData = json.encode(
      //   {
      //     'token': _token,
      //     // 'userId': _userId,
      //     'expiryDate': _expiryDate.toIso8601String(),
      //   },
      // );
      // prefs.setString('userData', userData);

      return {
        'StatusCode': response.statusCode,
      };
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> signUpTest(Map<String, String> data) async {
    final url = Uri.parse('${baseUrl}api/v1/rest-auth/registration/');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        // headers: {
        //   "Content-Type": "application/json",
        //   //"Authorization": token,
        // },
        body: json.encode({
          'username': data['username'],
          'email': data['email'],
          'password1': data['password1'],
          'password2': data['password2'],
        }),
      );
      // final responseData = json.decode(response.body);

      // if (responseData['error'] != null) {
      //   throw HttpException(responseData['error']['message']);
      // }
      // _token = responseData['key'];
      // // _userId = responseData['agent']['uId'];
      // _expiryDate = DateTime.now().add(
      //   const Duration(days: 60),
      // );
      // //_autoLogOut();
      // notifyListeners();
      // final prefs = await SharedPreferences.getInstance();
      // final userData = json.encode(
      //   {
      //     'token': _token,
      //     // 'userId': _userId,
      //     'expiryDate': _expiryDate.toIso8601String(),
      //   },
      // );
      // prefs.setString('userData', userData);

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> sendFCMDeviceModel(var data, var token) async {
    final url = Uri.parse('${baseUrl}users/fcm-list/');
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
      // print(response.statusCode);
      // print(response.body);
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> resetPassword(var data) async {
    final url = Uri.parse('${baseUrl}rest-auth/password/reset/');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode({'email': data}),
      );
      forbidden(response);
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> resetPasswordDetails(var data) async {
    final url = Uri.parse('$baseUrl/rest-auth/password/reset/confirm/');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode({
          'new_password1': data['Password'],
          'new_password2': data['Repeat_Password'],
          'uid': data['Uid'],
          'token': data['Token']
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

  Future<int> logOut(var token) async {
    final url = Uri.parse('${baseUrl}api/v1/rest-auth/logout/');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      forbidden(response);
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    // logout();
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extratedUserData['expiryDate'].toString());

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    if (extratedUserData["token"] == null) {
      return false;
    }
    _token = extratedUserData["token"];
    _userName = extratedUserData["userName"];
    _expiryDate = expiryDate;

    notifyListeners();
    // _autoLogOut();
    return true;
  }

  Future<void> logoutLocally() async {
    _token = null;
    _userName = null;
    _expiryDate = null;
    // if (_authTimer != null) {
    //   _authTimer.cancel();
    //   _authTimer = null;
    // }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<int> getInventory(var token, var firmName) async {
    final url = Uri.parse('$baseUrl/infrastructure/plant/$firmName');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );
      forbidden(response);
      var responseData = json.decode(response.body);
      _plantDetails = responseData;

      notifyListeners();

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getInventoryBatch(var token, var plantName) async {
    final url = Uri.parse('$baseUrl/activity-plan/batch-list/');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );
      forbidden(response);
      var responseData = json.decode(response.body);
      _batchList = responseData;

      notifyListeners();

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getInventoryBatchDetails(var token, var batchName) async {
    final url = Uri.parse('$baseUrl/breed-info/breed-detail/$batchName/');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );
      forbidden(response);
      var responseData = json.decode(response.body);
      _batchDetailsData = responseData;

      notifyListeners();

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getStandardUnitValues(var token) async {
    final url = Uri.parse('${baseUrl}standard-values/standardunit-list/');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );
      forbidden(response);
      // print(response.statusCode);
      // print(response.body);

      var responseData = json.decode(response.body);
      _standardUnitList = responseData;

      notifyListeners();

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getStandardBirdGradeList(var token) async {
    final url = Uri.parse('${baseUrl}standard-values/birdgrade-list/');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );
      // print(response.statusCode);
      // print(      forbidden(response);response.body);
      forbidden(response);
      var responseData = json.decode(response.body);
      _standardBirdGradeList = responseData;

      notifyListeners();

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getStandardEggGradeList(var token) async {
    final url = Uri.parse('${baseUrl}standard-values/egggrade-list/');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      var responseData = json.decode(response.body);
      _standardEggGradeList = responseData;
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
