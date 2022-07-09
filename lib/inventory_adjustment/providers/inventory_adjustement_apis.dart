import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class InventoryAdjustemntApis extends ChangeNotifier {
  var baseUrl = 'https://poultryfarmapp.herokuapp.com/';

  List _eggCollectionDetails = [];

  List _eggGradingList = [];

  List _mortalityListData = [];

  List _birdGradingData = [];

  List _inventoryAdjustemntExceptions = [];

  List get inventoryAdjustemntExceptions {
    return _inventoryAdjustemntExceptions;
  }

  List get mortalityListData {
    return _mortalityListData;
  }

  List get birdGradingData {
    return _birdGradingData;
  }

  List get eggCollectionDetails {
    return _eggCollectionDetails;
  }

  List get eggGradingList {
    return _eggGradingList;
  }

  Future<int> addEggCollection(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}egg-collection/eggcollection-list/');
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
        handleExceptions(response);
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getEggCollection(
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}egg-collection/eggcollection-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        List temp = [];
        for (var data in responseData) {
          temp.add(
            {
              "Egg_Collection_Id": data['Egg_Collection_Id'],
              'Product_Id__Product_Sub_Category_Id':
                  data['Product_Id__Product_Sub_Category_Id'],
              'Product_Id__Product_Sub_Category_Id__Product_Sub_Category_Name':
                  data[
                      'Product_Id__Product_Sub_Category_Id__Product_Sub_Category_Name'],
              "Egg_Collection_Code": data['Egg_Collection_Code'],
              "Product_Id__Product_Name": data['Product_Id__Product_Name'],
              "Product_Id": data['Product_Id'],
              "Batch_Plan_Code": data['Batch_Plan_Code'],
              "WareHouse_Id": data['WareHouse_Id'],
              "WareHouse_Id__WareHouse_Name":
                  data['WareHouse_Id__WareHouse_Name'],
              "Egg_Grade_Id": data['Egg_Grade_Id'],
              "Egg_Grade_Id__Egg_Grade": data['Egg_Grade_Id__Egg_Grade'],
              "Quantity": data['Quantity'],
              "Collection_Date": data['Collection_Date'],
              "Average_Weight": data['Average_Weight'],
              "Collection_Status": data['Collection_Status'],
              "Is_Cleared": data['Is_Cleared'],
              'Is_Selected': false,
            },
          );
        }
        _eggCollectionDetails = temp;
        notifyListeners();
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateEggCollection(
    var data,
    var id,
    var token,
  ) async {
    final url =
        Uri.parse('${baseUrl}egg-collection/eggcollection-details/$id/');
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
        handleExceptions(response);
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteEggCollection(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}egg-collection/eggcollection-details/0/');
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

  Future<int> addEggGrading(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}egg-collection/egg-list/grading/');
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
        handleExceptions(response);
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getEggGrading(
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}egg-collection/egg-list/grading/');
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

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "Grading_Record_Id": data['Grading_Record_Id'],
            "Batch_Id": data['Batch_Id__Batch_Code'],
            "Grading_Date": data['Grading_Date'],
            "WareHouse_Id": data['WareHouse_Id__WareHouse_Name'],
            "Location": data['Location'],
            "From": data['From'],
            "To": data['To'],
            "Unit": data['Unit'],
            "Is_Selected": false,
          });
        }
        _eggGradingList = temp;
        notifyListeners();
      }

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateEggGrading(
    var data,
    var id,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}egg-collection/egg-details/$id/grading/');
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
        handleExceptions(response);
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteEggGrading(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}egg-collection/egg-details/0/grading/');
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

  void handleExceptions(var response) {
    var responseData = json.decode(response.body) as Map<String, dynamic>;
    _inventoryAdjustemntExceptions.clear();
    responseData.forEach((key, value) {
      _inventoryAdjustemntExceptions.add(value);
    });
    notifyListeners();
  }

  Future<int> addBirdGrading(
    var data,
    var token,
  ) async {
    final url =
        Uri.parse('${baseUrl}inventory-operations/birdgrading-list/mapping/');
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
        handleExceptions(response);
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getBirdGrading(
    var token,
  ) async {
    final url =
        Uri.parse('${baseUrl}inventory-operations/birdgrading-list/mapping/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "Record_Id": data['Record_Id'],
            "Batch_Id": data['Batch_Id__Batch_Code'],
            "Date": data['Date'],
            "WareHouse_Id": data['WareHouse_Id__WareHouse_Name'],
            "From": data['From'],
            "To": data['To'],
            "Qty": data['Qty'],
            "Unit": data['Unit_Id__Unit_Name'],
            "Is_Selected": false,
          });
        }
        _birdGradingData = temp;
        notifyListeners();
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateBirdGrading(
    var data,
    var id,
    var token,
  ) async {
    final url = Uri.parse(
        '${baseUrl}inventory-operations/birdgrading-details/$id/mapping/');
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
        handleExceptions(response);
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteBirdGrading(
    var data,
    var token,
  ) async {
    final url = Uri.parse(
        '${baseUrl}inventory-operations/birdgrading-details/0/mapping/');
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

  Future<int> addMortality(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}inventory-operations/mortality-list/');
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
        handleExceptions(response);
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getMortality(
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}inventory-operations/mortality-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // print(response.statusCode);
      // print('mortality ${response.body}');

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "Record_Id": data['Record_Id'],
            "WareHouse_Id": data['WareHouse_Id__WareHouse_Name'],
            "Record_Code": data['Record_Code'],
            "Item": data['Product_Id__Product_Name'],
            "Item_Category": data['Product_Category_Id__Product_Category_Name'],
            "Date": data['Date'],
            "Batch_Id": data['Batch_Id__Batch_Code'],
            "Quantity": data['Quantity'],
            "Description": data['Description'],
            "Is_Selected": false,
          });
        }

        _mortalityListData = temp;
        notifyListeners();
      }
      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateMortality(
    var data,
    var id,
    var token,
  ) async {
    final url =
        Uri.parse('${baseUrl}inventory-operations/mortality-details/$id/');
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
        handleExceptions(response);
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteMortality(
    var data,
    var token,
  ) async {
    final url =
        Uri.parse('${baseUrl}inventory-operations/mortality-details/0/');
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
}
