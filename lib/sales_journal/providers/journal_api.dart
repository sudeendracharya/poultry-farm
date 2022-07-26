import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:poultry_login_signup/main.dart';

class JournalApi with ChangeNotifier {
  List _journalInfo = [];

  Map<String, dynamic> _individualSalesData = {};

  List _salesException = [];

  List customersInfo = [];

  List companiesInfo = [];

  List customerSearchResult = [];

  List companySearchResult = [];

  Map<String, dynamic> individualCustomerInfo = {};

  Map<String, dynamic> individualCompanyInfo = {};

  List companySalesList = [];

  Map<String, dynamic> _individualCompanySalesData = {};

  List inventoryAdjustmentList = [];

  List individualVendorsInfo = [];

  List companyVendors = [];

  Map<String, dynamic> get individualCompanyInfoData {
    return individualCompanyInfo;
  }

  Map<String, dynamic> get individualSalesData {
    return _individualSalesData;
  }

  Map<String, dynamic> get individualCompanySalesDataList {
    return _individualCompanySalesData;
  }

  List get customerSearchResultData {
    return customerSearchResult;
  }

  List get companyVendorsData {
    return companyVendors;
  }

  List get inventoryAdjustmentListData {
    return inventoryAdjustmentList;
  }

  List get individualVendorsInfoData {
    return individualVendorsInfo;
  }

  List get companySalesListData {
    return companySalesList;
  }

  Map<String, dynamic> get individualCustomerInfoData {
    return individualCustomerInfo;
  }

  List get companySearchResultData {
    return companySearchResult;
  }

  List get journalInfo {
    return _journalInfo;
  }

  List get companiesInfoList {
    return companiesInfo;
  }

  List get customersInfoList {
    return customersInfo;
  }

  List get salesException {
    return _salesException;
  }

  Future<int> getCustomerSalesJournalInfo(
    var id,
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}sale-data/customer-sale-list/$id/');
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
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            'Sale_Id': data['Sale_Id'],
            'Sale_Code': data['Sale_Code'],
            'Customer_Id': data['Customer_Id'],
            'Despatch_Date': data['Despatch_Date'],
            'Is_Selected': false,
          });
        }
        _journalInfo = temp;
        // print(responseData.toString());
      }

      // for (var data in responseData) {
      //   _firmDetails.add(data['Firm_Name']);
      // }

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> getCompanySalesJournalInfo(
    var id,
    var token,
  ) async {
    // log(token);
    //log(data.toString());
    final url = Uri.parse('${baseUrl}sale-data/customer-sale-list/$id/');
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
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            'Sale_Id': data['Sale_Id'],
            'Sale_Code': data['Sale_Code'],
            'Despatch_Date': data['Despatch_Date'],
            'Is_Selected': false,
          });
        }
        companySalesList = temp;
        // print(responseData.toString());
      }

      // for (var data in responseData) {
      //   _firmDetails.add(data['Firm_Name']);
      // }

      notifyListeners();
      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  void handleException(var response) {
    var responseData = json.decode(response.body) as Map<String, dynamic>;
    _salesException.clear();
    responseData.forEach((key, value) {
      _salesException.add({
        'Key': key,
        'Value': value,
      });
    });
    notifyListeners();
  }

  Future<int> addCustomerSalesJournalInfo(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}sale-data/customer-sale-list/0/');
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

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> addCompanySalesJournalInfo(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}sale-data/company-sale-list/0/');
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

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> getInventoryAdjustmentJournalInfo(
    var token,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}inventory-operations/inventoryadjustment-list/');
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
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "Inventory_Adjustment_Id": data['Inventory_Adjustment_Id'],
            "Inventory_Adjustment_Code": data['Inventory_Adjustment_Code'],
            "Batch_Plan_Id": data['Batch_Plan_Id'],
            "Batch_Plan_Id__Batch_Plan_Code":
                data['Batch_Plan_Id__Batch_Plan_Code'],
            'Product_Id__Product_Category_Id':
                data['Product_Id__Product_Category_Id'],
            'Product_Id__Product_Category_Id__Product_Category_Name':
                data['Product_Id__Product_Category_Id__Product_Category_Name'],
            'Product_Id__Product_Sub_Category_Id':
                data['Product_Id__Product_Sub_Category_Id'],
            'Product_Id__Product_Sub_Category_Id__Product_Sub_Category_Name': data[
                'Product_Id__Product_Sub_Category_Id__Product_Sub_Category_Name'],
            "Product_Id": data['Product_Id'],
            "Product_Id__Product_Name": data['Product_Id__Product_Name'],
            "WareHouse_Id": data['WareHouse_Id'],
            "WareHouse_Id__WareHouse_Code":
                data['WareHouse_Id__WareHouse_Code'],
            "Date": data['Date'],
            "CW_Unit": data['CW_Unit'],
            "CW_Unit__Unit_Name": data['CW_Unit__Unit_Name'],
            "CW_Quantity": data['CW_Quantity'],
            "Description": data['Description'],
            'Is_Selected': false,
          });
        }

        inventoryAdjustmentList = temp;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        handleException(response);
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> addInventoryAdjustmentJournalInfo(
    var data,
    var token,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}inventory-operations/inventoryadjustment-list/');
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

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> updateInventoryAdjustmentJournalInfo(
    var id,
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse(
        '${baseUrl}inventory-operations/inventoryadjustment-details/$id/');
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

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> deleteInventoryAdjustmentJournalInfo(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse(
        '${baseUrl}inventory-operations/inventoryadjustment-details/0/');
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
      if (response.statusCode == 400) {
        handleException(response);
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> addCustomerInfo(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}customer/customer-list/Individual/');
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

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> addIndividualVendorsInfo(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}vendor/vendor-list/Individual/');
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

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> addCompanyInfo(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}customer/customer-list/Company/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      print(response.body);
      forbidden(response);
      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> addVendorCompanyInfo(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}vendor/vendor-list/Company/');
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
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> updateCompanyInfo(
    var id,
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}customer/customer-details/Company/$id/');
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
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> updateVendorCompanyInfo(
    var id,
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}vendor/vendor-details/Company/$id/');
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
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> updateCustomerInfo(
    var id,
    var data,
    var token,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}customer/customer-details/Individual/$id/');
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

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> updateVendorInfo(
    var id,
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}vendor/vendor-details/Individual/$id/');
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

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> getCustomersInfo(var token, var type) async {
    // log(token);
    final url = Uri.parse('${baseUrl}customer/customer-list/$type/');
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
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "Customer_Id": data['Customer'],
            "Individual_Customer_Id": data['Individual_Customer_Id'],
            "Customer_Name": data['Individual_Customer_Name'],
            "Customer_Type": data['Customer__Customer_Type'],
            "Customer_Permanent_Account_Number":
                data['Customer__Permanent_Account_Number'],
            "Country": data['Customer__Country'],
            "State": data['Customer__State'],
            "City": data['Customer__City'],
            "Street": data['Customer__Street'],
            "Pincode": data['Customer__Pincode'],
            "Contact_Number": data['Customer__Contact_Number'],
            "Email_Id": data['Email_Id'],
            'Is_Selected': false,
          });
        }
        customersInfo = temp;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> getIndividualVendorsInfo(
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}vendor/vendor-list/Individual/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "Vendor": data['Vendor'],
            "Individual_Vendor_Id": data['Individual_Vendor_Id'],
            "Vendor__Vendor_Code": data['Vendor__Vendor_Code'],
            "Vendor__Vendor_Name": data['Vendor__Vendor_Name'],
            "Vendor__Country": data['Vendor__Country'],
            "Vendor__State": data['Vendor__State'],
            "Vendor__Street": data['Vendor__Street'],
            "Vendor__City": data['Vendor__City'],
            "Vendor__Zip_Code": data['Vendor__Zip_Code'],
            "Contact_Number": data['Contact_Number'],
            "Email_Id": data['Email_Id'],
            'Is_Selected': false,
          });
        }
        individualVendorsInfo = temp;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> getIndividualCustomersInfo(
    var id,
    var token,
  ) async {
    print(id);
    // log(token);
    final url =
        Uri.parse('${baseUrl}customer/customer-details/Individual/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      print(response.statusCode);
      print(' Individual customer details ${response.body}');

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        individualCustomerInfo = responseData;

        notifyListeners();
      }

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> getIndividualCompanyInfo(
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}customer/customer-details/Company/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      forbidden(response);
      print(response.statusCode);
      print('Individual Company Body ${response.body}');

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        individualCompanyInfo = responseData;

        notifyListeners();
      }

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> getCompaniesInfo(
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}customer/customer-list/Company/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "Company_Id": data['Customer'] ?? '',
            'Individual_Company_Id': data['Company_Id'] ?? '',
            "Company_Name": data['Company_Name'] ?? '',
            "Company_Type": data['Customer__Customer_Type'] ?? '',
            "Company_Permanent_Account_Number":
                data['Customer__Permanent_Account_Number'] ?? '',
            "Country": data['Customer__Country'] ?? '',
            "State": data['Customer__State'] ?? '',
            "City": data['Customer__City'] ?? '',
            "Street": data['Customer__Street'] ?? '',
            "Pincode": data['Customer__Pincode'] ?? '',
            "Contact_Person_Name": data['Contact_Person_Name'] ?? '',
            "Contact_Person_Designation":
                data['Contact_Person_Designation'] ?? '',
            "Contact_Number": data['Customer__Contact_Number'] ?? '',
            'Is_Selected': false,
          });
        }
        companiesInfo = temp;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> getCompanyVendorsInfo(
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}vendor/vendor-list/Company/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List temp = [];
        for (var data in responseData) {
          temp.add({
            "Vendor": data['Vendor'],
            "Company_Vendor_Id": data['Company_Vendor_Id'],
            "Vendor__Vendor_Code": data['Vendor__Vendor_Code'],
            "Vendor__Vendor_Name": data['Vendor__Vendor_Name'],
            "Vendor__Country": data['Vendor__Country'],
            "Vendor__State": data['Vendor__State'],
            "Vendor__Street": data['Vendor__Street'],
            "Vendor__City": data['Vendor__City'],
            "Vendor__Zip_Code": data['Vendor__Zip_Code'],
            "Company_Email_Id": data['Company_Email_Id'],
            "Contact_Person_Name": data['Contact_Person_Name'],
            "Designation": data['Designation'],
            "Contact_Number": data['Contact_Number'],
            "Contact_Email_Id": data['Contact_Email_Id'],
            'Is_Selected': false,
          });
        }
        companyVendors = temp;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> searchCustomerInfo(
    var name,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse(
        '${baseUrl}customer/searchcustomer/?search=${name.toString()}');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        customerSearchResult = responseData;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> searchCompanyInfo(
    var name,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse(
        '${baseUrl}customer/searchcompany/?search=${name.toString()}');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        companySearchResult = responseData;
        notifyListeners();
      }

      if (response.statusCode == 400) {
        handleException(response);
      }

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  // Future<int> updateCustomerInfo(
  //   var data,
  //   var token,
  // ) async {
  //   // log(token);
  //   final url = Uri.parse('${baseUrl}sale-data/sale-list/');
  //   try {
  //     final response = await http.patch(
  //       url,
  //       headers: <String, String>{
  //         "Content-Type": "application/json; charset=UTF-8",
  //         "Authorization": 'Token $token'
  //       },
  //       body: json.encode(data),
  //     );

  //     if (response.statusCode == 400) {
  //       handleException(response);
  //     }

  //     // print(response.statusCode);
  //     // print(response.body);

  //     return response.statusCode;
  //   } catch (e) {
  //
  //  failureSnackbar(e.toString());
  // rethrow;
  //   }
  // }

  Future<int> deleteCustomerInfo(
    var id,
    var token,
  ) async {
    // log(token);
    final url =
        Uri.parse('${baseUrl}customer/customer-details/Individual/$id/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      if (response.statusCode == 400) {
        handleException(response);
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> deleteIndividualVendorInfo(
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}vendor/vendor-details/Individual/$id/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        // body: json.encode(id),
      );
      forbidden(response);
      if (response.statusCode == 400) {
        handleException(response);
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> deleteCompaniesInfo(
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}customer/customer-details/Company/$id/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      forbidden(response);
      if (response.statusCode == 400) {
        handleException(response);
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> deleteCompanyVendorsInfo(
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}vendor/vendor-details/Company/$id/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        // body: json.encode(id),
      );
      forbidden(response);
      if (response.statusCode == 400) {
        handleException(response);
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> deleteSalesJournalInfo(
    var data,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}sale-data/sale-details/0/');
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
      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> updateCustomerSalesJournalInfo(
    var data,
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}sale-data/customer-sale-list/$id/');
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
        handleException(response);
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> updateCompanySalesJournalInfo(
    var data,
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}sale-data/company-sale-list/$id/');
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
        handleException(response);
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> getIndividualCustomerSalesJournalInfo(
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}sale-data/customer-sale-details/$id/');
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
        _individualSalesData = responseData;
        notifyListeners();
      }

      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }

  Future<int> getIndividualCompanySalesJournalInfo(
    var id,
    var token,
  ) async {
    // log(token);
    final url = Uri.parse('${baseUrl}sale-data/customer-sale-details/$id/');
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
        _individualCompanySalesData = responseData;
        notifyListeners();
      }

      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());

      return response.statusCode;
    } catch (e) {
      failureSnackbar(e.toString());
      rethrow;
    }
  }
}
