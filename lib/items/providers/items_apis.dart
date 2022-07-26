import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';

import '../../main.dart';

class ItemApis with ChangeNotifier {
  var _token;

  Map<String, dynamic> _individualProductData = {};

  List _productList = [];

  List _productException = [];

  List itemSubCategoryAllData = [];

  ItemApis([this._token]);

  List _itemcategory = [];

  List _itemSubCategory = [];

  List _itemDetails = [];
  List _itemMapping = [];
  List _inventoryItems = [];
  List _inventoryAdjustment = [];
  List _mortality = [];

  List _productDetails = [];

  Map<String, dynamic> get individualProductData {
    return _individualProductData;
  }

  List get productList {
    return _productList;
  }

  List get itemSubCategoryAllDataList {
    return itemSubCategoryAllData;
  }

  List get productException {
    return _productException;
  }

  List get productDetails {
    return _productDetails;
  }

  List get itemcategory {
    return _itemcategory;
  }

  List get itemSubCategory {
    return _itemSubCategory;
  }

  List get itemDetails {
    return _itemDetails;
  }

  List get itemMapping {
    return _itemMapping;
  }

  List get inventoryItems {
    return _inventoryItems;
  }

  List get inventoryAdjustment {
    return _inventoryAdjustment;
  }

  List get mortality {
    return _mortality;
  }

  Future<int> getItemCategory(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url =
        Uri.parse('${baseUrl}product-management/product-category-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
      );
      forbidden(response);
      print(response.statusCode);
      print('Item Category ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "Product_Category_Id": data['Product_Category_Id'],
            "Product_Category_Name": data['Product_Category_Name'],
            'Is_Selected': false,
          });
        }

        _itemcategory = temp;
        notifyListeners();
      }

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProductDetails(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}product-management/product-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());
      forbidden(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        List temp = [];

        for (int i = 0; i < responseData.length; i++) {
          temp.add({
            'Product_Id': responseData[i]['Product_Id'],
            'Product_Code': responseData[i]['Product_Code'],
            'Product_Category_Id': responseData[i]
                ['Product_Category_Id__Product_Category_Name'],
            'Product_Sub_Category_Id': responseData[i]
                ['Product_Sub_Category_Id__Product_Sub_Category_Name'],
            'Product_Name': responseData[i]['Product_Name'],
            'Unit_Of_Measure': responseData[i]['Unit_Of_Measure'],
            'Grade': responseData[i]['Grade'],
            'Stock_Keeping_Unit': responseData[i]['Stock_Keeping_Unit'],
            'Description': responseData[i]['Description'],
            'Batch_Request_For_Transfer': responseData[i]
                ['Batch_Request_For_Transfer'],
            'Batch_Request_Inventory_Adjustment': responseData[i]
                ['Batch_Request_Inventory_Adjustment'],
            'Batch_Request_For_Mortality': responseData[i]
                ['Batch_Request_For_Mortality'],
            'Batch_Request_For_Grading': responseData[i]
                ['Batch_Request_For_Grading'],
            'Is_Selected': false,
          });
        }
        _productDetails = temp;
        notifyListeners();
        return {
          'Status_Code': response.statusCode,
          'Body': responseData,
        };
      }

      notifyListeners();
      return {
        'Status_Code': response.statusCode,
        'Body': response.body,
      };
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getIndividualProductDetails(var token, var id) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}product-management/product-details/$id/');
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
      debugPrint('individual product ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        _individualProductData = responseData;
      }

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> addItemCategoryData(var data, var token) async {
    final url =
        Uri.parse('${baseUrl}product-management/product-category-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode({
          'Product_Category_Name': data['Product_Category_Name'],
        }),
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

  Future<int> getItemSubCategoryAllData(var token) async {
    final url =
        Uri.parse('${baseUrl}product-management/product-subcategory-alllist/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        // body: json.encode({
        //   'Product_Category_Name': data['Product_Category_Name'],
        // }),
      );
      forbidden(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "Product_Sub_Category_Id": data['Product_Sub_Category_Id'],
            "Product_Category_Id": data['Product_Category_Id'],
            "Product_Sub_Category_Name": data['Product_Sub_Category_Name'],
            'Is_Selected': false,
          });
        }

        itemSubCategoryAllData = temp;
        notifyListeners();
      }
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> editItemCategoryData(var id, var data, var token) async {
    final url =
        Uri.parse('${baseUrl}product-management/product-category-details/$id/');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      forbidden(response);
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> deleteItemCategoryData(var data, var token) async {
    final url =
        Uri.parse('${baseUrl}product-management/product-category-details/0/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token',
        },
        body: json.encode(data),
      );
      forbidden(response);
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getItemSubCategory(
    var token,
    var id,
  ) async {
    //log(data.toString());
    final url =
        Uri.parse('${baseUrl}product-management/product-subcategory-list/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      // print(response.statusCode);
      // print(response.body);

      var responseData = json.decode(response.body);
      // for (var data in responseData) {
      //   _firmDetails.add(data['Firm_Name']);
      // }
      _itemSubCategory = responseData;
      // log(responseData.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> editItemSubCategory(
    var data,
    var id,
    var token,
  ) async {
    //log(data.toString());
    final url = Uri.parse(
        '${baseUrl}product-management/product-subcategory-details/$id/');
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
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> deleteItemSubCategory(
    var data,
    var token,
  ) async {
    //log(data.toString());
    final url = Uri.parse(
        '${baseUrl}product-management/product-subcategory-details/0/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );
      forbidden(response);
      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getproductlist(
    var token,
    var id,
  ) async {
    // log(token);
    //log(data.toString());
    final url =
        Uri.parse('${baseUrl}product-management/productselect-list/$id/');
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

      var responseData = json.decode(response.body);
      // for (var data in responseData) {
      //   _firmDetails.add(data['Firm_Name']);
      // }
      _productList = responseData;
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> addItemSubCategoryData(
    var id,
    var data,
    var token,
  ) async {
    final url =
        Uri.parse('${baseUrl}product-management/product-subcategory-list/$id/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Product_Category_Id': data['Product_Category_Id'],
          'Product_Sub_Category_Name': data['Product_Sub_Category_Name'],
        }),
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

  Future<int> deleteProducts(var token, List ids) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}product-management/product-details/0/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(ids),
      );
      forbidden(response);
      // print(res forbidden(response);ponse.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getItemDetails(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}inventory-management/product-details/');
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
      _itemDetails = responseData;
      // log(responseData.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  void handleException(var response) {
    var responseData = json.decode(response.body) as Map<String, dynamic>;
    _productException.clear();
    responseData.forEach((key, value) {
      _productException.add({'Key': key, 'Value': value});
    });

    notifyListeners();
  }

  Future<int> addItemDetailsData(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}product-management/product-list/');
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
        handleException(response);
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> updateItemDetailsData(
    var data,
    var id,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}product-management/product-details/$id/');
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
      if (response.statusCode == 400) {
        handleException(response);
      }

      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getItemMapping(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}inventory-management/product-mapping/');
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
      _itemMapping = responseData;
      // log(responseData.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> getInventoryItems(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}inventory-management/inventory-view/');
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
      _inventoryItems = responseData;
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> addInventoryItems(
    var data,
    var token,
  ) async {
    final url = Uri.parse('${baseUrl}inventory-management/inventory-view/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Product_Id': data['Product_Id'],
          'Batch_Id': data['Batch_Id'],
          'Inventory_Code': data['Inventory_Code'],
          'Quantity': data['Quantity'],
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

  Future<int> getInventoryAdjustment(
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url =
        Uri.parse('${baseUrl}inventory-management/inventory-adjustment/');
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
      _inventoryAdjustment = responseData;
      // log(responseData.toString());
      notifyListeners();
      return response.statusCode;
    } catch (e) {
      EasyLoading.dismiss();
      exceptionDialog(e.toString());
      rethrow;
    }
  }

  Future<int> addInventoryAdjustmentData(
    var data,
    var token,
  ) async {
    final url =
        Uri.parse('${baseUrl}inventory-management/inventory-adjustment/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode({
          'Inventory_Id': data['Inventory_Id'],
          'Product_Id': data['Product_Id'],
          'Batch_Id': data['Batch_Id'],
          'Ware_House_Id': data['Ware_House_Id'],
          'Inventory_Adjustment_Date': data['Inventory_Adjustment_Date'],
          'CW_Unit': data['CW_Unit'],
          'CW_Quantity': data['CW_Quantity'],
          'Description': data['Inventory_Adjustment_Description'],
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
}
