import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfrastructureApis with ChangeNotifier {
  var token;

  Map<String, dynamic> _individualWareHouseDetails = {};

  List _firmException = [];

  List _plantException = [];

  List _wareHouseException = [];

  List _plantLists = [];

  List _WareHouseLists = [];

  List _WareHouseSectionLists = [];

  List infrastructureException = [];
  InfrastructureApis([this.token]);
  List _firmDetails = [];
  List _plantDetails = [];
  List _warehouseDetails = [];
  List _warehouseCategory = [];
  List _warehouseSection = [];
  List _warehouseSectionLine = [];
  List _displayWarehouseCategory = [];
  List _displayWarehouseSubCategory = [];

  List _warehouseSubCategory = [];
  var baseUrl = 'https://poultryfarmapp.herokuapp.com/';

  List _singleFirmDetails = [];
  Map<String, dynamic> get individualWareHouseDetails {
    return _individualWareHouseDetails;
  }

  List get infrastructureExceptionData {
    return infrastructureException;
  }

  List get singleFirmDetails {
    return _singleFirmDetails;
  }

  List get wareHouseSectionLists {
    return _WareHouseSectionLists;
  }

  List get wareHouseLists {
    return _WareHouseLists;
  }

  List get plantLists {
    return _plantLists;
  }

  List get wareHouseException {
    return _wareHouseException;
  }

  List get firmException {
    return _firmException;
  }

  List get plantException {
    return _plantException;
  }

  List get firmDetails {
    return _firmDetails;
  }

  List get warehouseCategory {
    return _warehouseCategory;
  }

  List get warehouseSubCategory {
    return _warehouseSubCategory;
  }

  List get plantDetails {
    return _plantDetails;
  }

  List get warehouseDetails {
    return _warehouseDetails;
  }

  List get warehouseSection {
    return _warehouseSection;
  }

  List get warehouseSectionLine {
    return _warehouseSectionLine;
  }

  List get displayWarehouseCategory {
    return _displayWarehouseCategory;
  }

  List get displayWarehouseSubCategory {
    return _displayWarehouseSubCategory;
  }

  Future<Map<String, dynamic>> addFirmDetails(
    var data,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse('${baseUrl}administration/firm-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Firm_Code': data['Firm_Code'],
          'Firm_Name': data['Firm_Name'],
          'Email_Id': data['Email_Id'],
          'Permanent_Account_Number': data['Permanent_Account_Number'],
          'Firm_Contact_Number': data['Firm_Contact_Number'],
          'Firm_Alternate_Contact_Number':
              data['Firm_Alternate_Contact_Number'],
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        return {
          'StatusCode': response.statusCode,
          'FirmId': responseData['Firm_Id'],
          'FirmCode': responseData['Firm_Code'],
          'FirmName': responseData['Firm_Name'],
        };
      } else if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        _firmException.clear();
        responseData.forEach((key, value) {
          _firmException.add(value);
        });
        notifyListeners();
      }
      return {
        'StatusCode': response.statusCode,
        'FirmId': '',
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<int> editFirmDetails(
    var data,
    var id,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse('${baseUrl}administration/firm-details/$id/');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Firm_Code': data['Firm_Code'],
          'Firm_Name': data['Firm_Name'],
          'Email_Id': data['Email_Id'],
          'Permanent_Account_Number': data['Permanent_Account_Number'],
          'Firm_Contact_Number': data['Firm_Contact_Number'],
          'Firm_Alternate_Contact_Number':
              data['Firm_Alternate_Contact_Number'],
        }),
      );
      if (response.statusCode == 202) {
        var responseData = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();

        final userData = json.encode(
          {
            'firmId': responseData['Firm_Id'],
            'firmName': responseData['Firm_Name'],
            'firmCode': responseData['Firm_Code'],
            'email': responseData['Email_Id'],
            'pan': responseData['Permanent_Account_Number'],
            'contactNumber': responseData['Firm_Contact_Number'],
            'alternateContactNumber':
                responseData['Firm_Alternate_Contact_Number']
          },
        );
        prefs.setString('FirmDetails', userData);
      } else if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        _firmException.clear();
        responseData.forEach((key, value) {
          _firmException.add(value);
        });

        notifyListeners();
      }

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }
  //

  Future<int> getFirmDetails(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}administration/firm-list/');
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

      var responseData = json.decode(response.body);
      // for (var data in responseData) {
      //   _firmDetails.add(data['Firm_Name']);
      // }
      Map<String, dynamic> firmDetails = {
        'Firm_Id': '',
        'Firm_Code': '',
        'Firm_Name': '',
        'Email_Id': '',
        'Permanent_Account_Number': '',
        'Firm_Contact_Number': '',
        'Firm_Alternate_Contact_Number': '',
        'plant_detail__Plant_Name': '',
        'Is_Selected': false,
      };
      List temp = [];

      for (var data in responseData) {
        temp.add({
          'Firm_Id': data['Firm_Id'],
          'Firm_Code': data['Firm_Code'],
          'Firm_Name': data['Firm_Name'],
          'Email_Id': data['Email_Id'],
          'Permanent_Account_Number': data['Permanent_Account_Number'],
          'Firm_Contact_Number': data['Firm_Contact_Number'],
          'Firm_Alternate_Contact_Number':
              data['Firm_Alternate_Contact_Number'],
          'plant_detail__Plant_Name__count':
              data['plant_detail__Plant_Name__count'].toString(),
          'Is_Selected': false,
        });
      }
      // temp.add({'Firm_Id': 0, 'Firm_Name': 'Add New Firm'});
      _firmDetails = temp;

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getSingleFirmDetails(
    var id,
    var token,
  ) async {
    log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}administration/firm-details/$id/');
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
      Map<String, dynamic> firmDetails = {
        'Firm_Id': '',
        'Firm_Code': '',
        'Firm_Name': '',
        'Email_Id': '',
        'Permanent_Account_Number': '',
        'Firm_Contact_Number': '',
        'Firm_Alternate_Contact_Number': '',
        'plant_detail__Plant_Name': '',
        'Is_Selected': false,
      };
      List temp = [];

      temp.add({
        'Firm_Id': responseData['Firm_Id'],
        'Firm_Code': responseData['Firm_Code'],
        'Firm_Name': responseData['Firm_Name'],
        'Email_Id': responseData['Email_Id'],
        'Permanent_Account_Number': responseData['Permanent_Account_Number'],
        'Firm_Contact_Number': responseData['Firm_Contact_Number'],
        'Firm_Alternate_Contact_Number':
            responseData['Firm_Alternate_Contact_Number'],
        'plant_detail__Plant_Name__count':
            responseData['plant_detail__Plant_Name__count'].toString(),
        'Is_Selected': false,
      });

      _singleFirmDetails = temp;

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteFirmDetails(
    var id,
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}administration/firm-details/$id/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // for (var data in responseData) {
      //   _firmDetails.add(data['Firm_Name']);
      // }

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getPlantDetails(var token, var firmId) async {
    //log(data.toString());
    // print('object');
    // final url1 = Uri.parse(
    //     'https://mobilenallimenu.herokuapp.com/restrant/menu-details/1/');
    final url = Uri.parse('${baseUrl}plant-management/plant-list/$firmId/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      print(response.statusCode);
      print('plants ${response.body}');

      var responseData = json.decode(response.body);

      List temp = [];

      for (var data in responseData) {
        temp.add({
          'Firm_Id': data['Firm_Id'],
          'Plant_Id': data['Plant_Id'],
          'Plant_Code': data['Plant_Code'],
          'Plant_Name': data['Plant_Name'],
          'Plant_Address_Line_1': data['Plant_Address_Line_1'],
          'Plant_Address_Line_2': data['Plant_Address_Line_2'],
          'Plant_Country': data['Plant_Country'],
          'Plant_District': data['Plant_District'],
          'Plant_State': data['Plant_State'],
          'Plant_Pincode': data['Plant_Pincode'],
          'Selected': false,
        });
      }

      _plantDetails = temp;
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getPlantlist(var token, var data) async {
    final url =
        Uri.parse('https://poultryfarmapp.herokuapp.com/permisson/fetch-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      // print(response.statusCode);
      // print('plants List ${response.body}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _plantLists = responseData;
      }
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getWareHouselist(var token, var data) async {
    // print(data);
    final url = Uri.parse('${baseUrl}permisson/fetch-Warehouse-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      // print(response.statusCode);
      // print('WareHouse List ${response.body}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _WareHouseLists = responseData;
      }
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getWareHouseSectionList(var token, var data) async {
    // print(data);
    final url = Uri.parse('${baseUrl}permisson/fetch-Warehouse-section-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      // print(response.statusCode);
      // print('WareHouse Section List ${response.body}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _WareHouseSectionLists = responseData;
      }
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addPlantDetails(
    var data,
    var firmId,
    var token,
  ) async {
    print(data);
    final url = Uri.parse('${baseUrl}plant-management/plant-list/$firmId/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Firm_Id': firmId,
          'Plant_Code': data['Plant_Code'],
          'Plant_Name': data['Plant_Name'],
          'Plant_Address_Line_1': data['Plant_Address_Line_1'],
          'Plant_Address_Line_2': data['Plant_Address_Line_2'] ?? '',
          'Plant_Country': data['Plant_Country'],
          'Plant_District': data['Plant_District'],
          'Plant_State': data['Plant_State'],
          'Plant_Pincode': int.parse(data['Plant_Pincode'])
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return {
          'StatusCode': response.statusCode,
          'PlantCode': responseData['Plant_Code'],
          'PlantName': responseData['Plant_Name'],
        };
      } else if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        _plantException.clear();
        responseData.forEach((key, value) {
          _plantException.add(value);
        });

        notifyListeners();
      }
      return {
        'StatusCode': response.statusCode,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<int> editPlantDetails(
    var data,
    var id,
    var token,
  ) async {
    print(data.toString());
    final url = Uri.parse('${baseUrl}plant-management/plant-details/$id/');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Firm_Name': data['Firm_Name'],
          'Plant_Code': data['Plant_Code'],
          'Plant_Name': data['Plant_Name'],
          'Plant_Address_Line_1': data['Plant_Address_Line_1'],
          'Plant_Address_Line_2': data['Plant_Address_Line_2'],
          'Plant_Country': data['Plant_Country'],
          'Plant_District': data['Plant_District'],
          'Plant_State': data['Plant_State'],
          'Plant_Pincode': int.parse(data['Plant_Pincode'])
        }),
      );

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        _plantException.clear();

        responseData.forEach((key, value) {
          _plantException.add(value);
        });

        notifyListeners();
      }

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deletePlantDetails(
    var id,
    var token,
  ) async {
    log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}plant-management/plant-details/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({'Plant_Ids': id}),
      );

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  void handleException(var response) {
    var responseData = json.decode(response.body) as Map<String, dynamic>;
    infrastructureException.clear();
    responseData.forEach((key, value) {
      infrastructureException.add({
        'Key': key,
        'Value': value[0],
      });
    });
    notifyListeners();
  }

  Future<Map<String, dynamic>> addWareHouseCategory(
    var data,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url =
        Uri.parse('${baseUrl}plant-management/warehouse-category-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'WareHouse_Category_Name': data['WareHouse_Category_Name'],
          'Description': data['Description'],
        }),
      );

      if (response.statusCode == 400) {
        handleException(response);
      }

      var responseData = json.decode(response.body);
      return {
        'Status_Code': response.statusCode,
        'Response_Body': responseData,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<int> editWareHouseCategory(
    var data,
    var id,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url =
        Uri.parse('${baseUrl}plant-management/warehouse-category-details/$id/');
    try {
      final response = await http.patch(
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

  Future<int> deleteWareHouseCategory(
    var data,
    var token,
  ) async {
    // log(token);

    final url =
        Uri.parse('${baseUrl}plant-management/warehouse-category-details/0/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
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

  Future<int> getWarehouseCategory(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url =
        Uri.parse('${baseUrl}plant-management/warehouse-category-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // List categoryList = [];
      // List categoryListData = [];

      print(response.body);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "WareHouse_Category_Id": data['WareHouse_Category_Id'],
            "WareHouse_Category_Name": data['WareHouse_Category_Name'],
            "warehouse_sub_category__count":
                data['warehouse_sub_category__count'],
            'Description': data['Description'],
            'Is_Selected': false,
          });
        }
        _warehouseCategory = temp;
        notifyListeners();
      }

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> loadWarehouseCategoryAndSubCategory(
    var token,
  ) async {
    log(token);
    //log(data.toString());
    final url =
        Uri.parse('${baseUrl}plant-management/warehouse-subcategory-alllist/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // List categoryList = [];
      // List categoryListData = [];
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "WareHouse_Sub_Category_Id": data['WareHouse_Sub_Category_Id'],
            "WareHouse_Sub_Category_Name": data['WareHouse_Sub_Category_Name'],
            "Description": data['Description'],
            'Is_Selected': false,
          });
        }
        _displayWarehouseSubCategory = temp;
        notifyListeners();
      }

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addWareHouseSubCategory(
    var data,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse(
        '${baseUrl}plant-management/warehouse-subcategory-list/${data['WareHouse_Category_Id']}/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'WareHouse_Category_Id': data['WareHouse_Category_Id'],
          'WareHouse_Sub_Category_Name': data['WareHouse_Sub_Category_Name'],
          'Description': data['Description'],
        }),
      );

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getWarehouseSubCategory(
    var id,
    var token,
  ) async {
    log(id.toString());
    //log(data.toString());
    final url =
        Uri.parse('${baseUrl}plant-management/warehouse-subcategory-list/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      var responseData = json.decode(response.body);

      _warehouseSubCategory = responseData;
      log(_warehouseSubCategory.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteWarehouseSubCategory(
    var data,
    var token,
  ) async {
    final url = Uri.parse(
        '${baseUrl}plant-management/warehouse-subcategory-details/0/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> editWareHouseSubCategory(
    var data,
    var id,
    var token,
  ) async {
    // log(token);
    // log(data.toString());
    final url = Uri.parse(
        '${baseUrl}plant-management/warehouse-subcategory-details/$id/');
    try {
      final response = await http.patch(
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

  Future<List> getWarehouseSubCategoryForDisplay(
    int id,
    var token,
  ) async {
    // log(id.toString());
    //log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/api/v1/infrastructure/load_warehouse_sub_categories/$id');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      var responseData = json.decode(response.body);

      _warehouseSubCategory = responseData;
      log(_warehouseSubCategory.toString());
      // notifyListeners();
      return responseData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addWareHouseDetails(
    var data,
    var token,
  ) async {
    final url = Uri.parse(
        '${baseUrl}plant-management/warehouse-list/${data['Plant_Id']}/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          // 'Firm_Id': data['Firm_Id'],
          'WareHouse_Plant_Id': data['Plant_Id'],
          'Description': data['Description'],
          'WareHouse_Category_Id': data['WareHouse_Category_Id'],
          'WareHouse_Sub_Category_Id': data['WareHouse_Sub_Category_Id'],
          'WareHouse_Name': data['WareHouse_Name'],
          'WareHouse_Code': data['WareHouse_Code'],
        }),
      );

      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 201 || response.statusCode == 202) {
        var responseData = json.decode(response.body);

        return {
          'Status_Code': response.statusCode,
          'WareHouse_Code': responseData['WareHouse_Code'],
          'WareHouse_Name': responseData['WareHouse_Name'],
          'WareHouse_Id': responseData['WareHouse_Id'],
        };
      } else if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        _wareHouseException.clear();
        responseData.forEach((key, value) {
          _wareHouseException.add(value);
        });

        notifyListeners();
      }
      return {'Status_Code': response.statusCode, 'WareHouse_Code': ''};
    } catch (e) {
      rethrow;
    }
  }

  Future<int> fetchIndividualWareHouseDetails(
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}plant-management/warehouse-details/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      print(response.statusCode);
      print('individual warehouse ${response.body}');

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _individualWareHouseDetails = responseData;
        notifyListeners();
      }

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> editWareHouseDetails(
    var data,
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}plant-management/warehouse-details/$id/');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          "WareHouse_Id": id.toString(),
          'WareHouse_Plant_Id': data['Plant_Id'],
          'WareHouse_Category_Id': data['WareHouse_Category_Id'],
          'WareHouse_Sub_Category_Id': data['WareHouse_Sub_Category_Id'],
          'WareHouse_Plant_Name': data['WareHouse_Plant_Name'],
          'WareHouse_Code': data['WareHouse_Code'],
          'Description': data['Description'],
        }),
      );

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        _wareHouseException.clear();

        responseData.forEach((key, value) {
          _wareHouseException.add(value);
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

  Future<int> deleteWareHouseDetails(
    var data,
    var token,
  ) async {
    // log(token);

    final url = Uri.parse('${baseUrl}plant-management/warehouse-details/1/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getWarehouseDetailsForAll(
    var plantId,
    var token,
  ) async {
    log(plantId.toString());
    //log(data.toString());
    final url =
        Uri.parse('${baseUrl}plant-management/warehouse-list/$plantId/');
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
      var responseData = json.decode(response.body);

      List temp = [];
      for (var data in responseData) {
        temp.add({
          'WareHouse_Id': data['WareHouse_Id'],
          'WareHouse_Code': data['WareHouse_Code'],
          'WareHouse_Name': data['WareHouse_Name'],
          'WareHouse_Category_Id__WareHouse_Category_Name':
              data['WareHouse_Category_Id__WareHouse_Category_Name'],
          'WareHouse_Sub_Category_Id__WareHouse_Sub_Category_Name':
              data['WareHouse_Sub_Category_Id__WareHouse_Sub_Category_Name'],
          'WareHouse_Plant_Id__Plant_Name':
              data['WareHouse_Plant_Id__Plant_Name'],
          'warehouse_section__WareHouse_Section_Code':
              data['warehouse_section__WareHouse_Section_Id__count'] ?? 0,
          'warehouse_section__WareHouse_Section_Number_Of_Lines': data[
                  'warehouse_section__WareHouse_Section_Number_Of_Lines__sum'] ??
              0,
          'WareHouse_Category_Id__WareHouse_Category_Id':
              data['WareHouse_Category_Id__WareHouse_Category_Id'],
          'WareHouse_Sub_Category_Id__Description':
              data['WareHouse_Sub_Category_Id__Description'],
          'Description': data['Description'],
          'WareHouse_Category_Id__Description':
              data['WareHouse_Category_Id__Description'],
          'WareHouse_Sub_Category_Id__WareHouse_Sub_Category_Id':
              data['WareHouse_Sub_Category_Id__WareHouse_Sub_Category_Id'],
          'Selected': false,
        });
      }

      _warehouseDetails = temp;
      // log(_warehouseDetails.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getWarehouseDetails(
    var id,
    var token,
  ) async {
    //log(id.toString());
    //log(data.toString());
    final url = Uri.parse('${baseUrl}plant-management/warehouse-list/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      var responseData = json.decode(response.body);

      _warehouseDetails = responseData;
      // log(_warehouseDetails.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addWareHouseSectionDetails(
    var id,
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}plant-management/section-list/$id/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      // print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> editWareHouseSectionCodes(
    var data,
    var token,
  ) async {
    // log(token);
    List temp = [];
    for (var data in data) {
      temp.add({
        'WareHouse_Section_Code': data['NewSection'],
        'WareHouse_Section_Id': data['Section_Id'],
      });
    }
    final url = Uri.parse('${baseUrl}plant-management/section-details/1/');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(temp),
      );

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> editWareHouseSectionLineDetails(
    var data,
    var token,
  ) async {
    // log(token);

    final url = Uri.parse('${baseUrl}plant-management/section-line-details/1/');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteWareHouseSectionDetails(
    var ids,
    var token,
  ) async {
    // log(token);
//
    final url = Uri.parse('${baseUrl}plant-management/section-details/1/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(ids),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getWareHouseSectionDetails(
    var id,
    var token,
  ) async {
    //log(id.toString());
    //log(data.toString());
    final url = Uri.parse('${baseUrl}plant-management/section-details/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // print('section details ${response.statusCode}');
      print(response.body);

      var responseData = json.decode(response.body);

      List tempList = [];
      List sectionCodes = [];
      List sectionIds = [];
      List sectionNames = [];

      List finalDataList = [];

      for (int i = 0; i < responseData.length; i++) {
        sectionCodes.add(responseData[i]['WareHouse_Section_Code']);
        sectionNames.add(responseData[i]['Section_Name'] ?? 'No Name$i');
        sectionIds.add(responseData[i]['WareHouse_Section_Id']);
        tempList.add({
          'isSelected': false,
          'WareHouse_Section_Id': responseData[i]['WareHouse_Section_Id'],
          'WareHouse_Section_Code': responseData[i]['WareHouse_Section_Code'],
          'WareHouse_Section_Number_Of_Lines': responseData[i]
              ['WareHouse_Section_Number_Of_Lines'],
          'Section_Name': responseData[i]['Section_Name'],
          'warehouse_section_line__WareHouse_Section_Line_Number_Of_Boxes':
              responseData[i][
                  'warehouse_section_line__WareHouse_Section_Line_Number_Of_Boxes'],
          'warehouse_section_line__WareHouse_Section_Line_Maximum_Box_Capacity':
              responseData[i][
                  'warehouse_section_line__WareHouse_Section_Line_Maximum_Box_Capacity'],
          'warehouse_section_line__WareHouse_Section_Line_Box_Length':
              responseData[i]
                  ['warehouse_section_line__WareHouse_Section_Line_Box_Length'],
          'warehouse_section_line__WareHouse_Section_Line_Box_Breadth':
              responseData[i][
                  'warehouse_section_line__WareHouse_Section_Line_Box_Breadth'],
          'warehouse_section_line__WareHouse_Section_Line_Box_Height':
              responseData[i]
                  ['warehouse_section_line__WareHouse_Section_Line_Box_Height'],
          'warehouse_section_line__WareHouse_Section_Line_Code': responseData[i]
              ['warehouse_section_line__WareHouse_Section_Line_Code'],
          'warehouse_section_line__WareHouse_Section_Line_Id': responseData[i]
              ['warehouse_section_line__WareHouse_Section_Line_Id'],
        });
      }

      List result = [
        ...{...sectionCodes}
      ];

      List finalSectionNames = [
        ...{...sectionNames}
      ];

      List finalSectionIds = [
        ...{...sectionIds}
      ];

      for (int i = 0; i < result.length; i++) {
        List temp = [];
        List sectionLineCodes = [];
        for (int j = 0; j < tempList.length; j++) {
          if (result[i] == tempList[j]['WareHouse_Section_Code']) {
            temp.add(tempList[j]);
            sectionLineCodes.add(tempList[j]
                ['warehouse_section_line__WareHouse_Section_Line_Code']);
          }
        }
        finalDataList.add({
          'WareHouse_Section_Id': finalSectionIds[i],
          'WareHouse_Section_Code': result[i],
          'Section_Name': finalSectionNames[i],
          'Section_Details': temp,
          'sectionLineCodes': sectionLineCodes,
        });
      }

      _warehouseSection = finalDataList;
      // print(_warehouseSection);
      // log(_warehouseSection.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getWareHouseSectionLineDetails(
    var token,
  ) async {
    //log(id.toString());
    //log(data.toString());
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/api/v1/infrastructure/warehouse_section_line_details/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      var responseData = json.decode(response.body);

      _warehouseSectionLine = responseData;
      // log(_warehouseSectionLine.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addWareHouseSectionLineDetails(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}plant-management/section-line-list/1/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data['WareHouse_Section_Line_Details']),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateWareHouseSectionLineDetails(
    var data,
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse(
        'https://poultryfarmerp.herokuapp.com/api/v1/infrastructure/warehouse_section_line_details-edit/$id/');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'WareHouse_Section_Id': data['WareHouse_Section_Id'],
          'WareHouse_Section_Line_Code': data['WareHouse_Section_Line_Code'],
          'WareHouse_Section_Line_Number_Of_Boxes':
              data['WareHouse_Section_Line_Number_Of_Boxes'],
          'WareHouse_Section_Line_Box_Length':
              data['WareHouse_Section_Line_Box_Length'],
          'WareHouse_Section_Line_Box_Breadth':
              data['WareHouse_Section_Line_Box_Breadth'],
          'WareHouse_Section_Line_Box_Height':
              data['WareHouse_Section_Line_Box_Height'],
        }),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteWareHouseSectionLineDetails(
    var id,
    var token,
  ) async {
    // log(token);

    final url = Uri.parse('${baseUrl}plant-management/section-line-details/1/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(id),
      );

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }
}
