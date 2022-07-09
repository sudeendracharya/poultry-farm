import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';

class AddWareHouseSubCategory extends StatefulWidget {
  AddWareHouseSubCategory({Key? key}) : super(key: key);
  static const routeName = '/AddWarehouseSubCategory';

  @override
  _AddWareHouseSubCategoryState createState() =>
      _AddWareHouseSubCategoryState();
}

class _AddWareHouseSubCategoryState extends State<AddWareHouseSubCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  List warehouseCategory = [];

  var warehouseId;
  var wareHouseCategoryName = '';
  var isLoading = true;
  TextEditingController controller = TextEditingController();

  Map<String, dynamic> wareHouseSubCategory = {
    'WareHouse_Category_Id': '',
    'WareHouse_Sub_Category_Name': '',
    'Description': '',
  };

  @override
  void initState() {
    super.initState();

    if (wareHouseSubCategory['WareHouse_Category_Id'] == '') {
      getWareHouseCategoryName();
    }

    // Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   Provider.of<InfrastructureApis>(context, listen: false)
    //       .getWarehouseCategory(token)
    //       .then((value1) {});
    // });
  }

  void getWareHouseCategoryName() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('CategoryName')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('CategoryName')!) as Map<String, dynamic>;
    wareHouseSubCategory['WareHouse_Category_Id'] = extratedUserData['id'];
    controller.text = extratedUserData['name'];

    setState(() {
      isLoading = false;
    });
  }

  Future<void> save() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    // print(wareHouseSubCategory);

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .addWareHouseSubCategory(wareHouseSubCategory, token)
            .then((value) {
          if (value == 200 || value == 201) {
            showDialog(
                context: context,
                builder: (ctx) => SuccessDialog(
                    title: 'Success',
                    subTitle:
                        'SuccessFully Added Ware House Sub-Category Details'));
            _formKey.currentState!.reset();
          } else {
            showDialog(
                context: context,
                builder: (ctx) => FailureDialog(
                    title: 'Failed',
                    subTitle: 'Something Went Wrong Please Try Again'));
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // warehouseCategory = Provider.of<InfrastructureApis>(
    //   context,
    // ).warehouseCategory;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add WareHouse SubCategory Details'),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  children: [
                    SizedBox(
                      width: 700,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Ware house category Name'),
                          // Container(
                          //   width: 400,
                          //   child: TextFormField(
                          //     onSaved: (value) {
                          //       wareHouseSubCategory['WareHouse_Category_Id'] =
                          //           value!;
                          //     },
                          //   ),
                          // ),
                          // Container(
                          //   width: 385,
                          //   child: DropdownButton(
                          //     value: warehouseId,
                          //     items: warehouseCategory
                          //         .map<DropdownMenuItem<String>>((e) {
                          //       return DropdownMenuItem(
                          //         child: Text(e['WareHouse_Category_Name']),
                          //         value: e['WareHouse_Category_Name'],
                          //         onTap: () {
                          //           // firmId = e['Firm_Code'];
                          //           wareHouseSubCategory['WareHouse_Category_Id'] =
                          //               e['WareHouse_Category_Id'];
                          //           //print(warehouseCategory);
                          //         },
                          //       );
                          //     }).toList(),
                          //     hint: const Text('Please Choose firm Id'),
                          //     onChanged: (value) {
                          //       setState(() {
                          //         warehouseId = value as String;
                          //       });
                          //     },
                          //   ),
                          // ),

                          SizedBox(
                            width: 400,
                            child: TextFormField(
                              controller: controller,
                              enabled: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Ware house Sub category Name'),
                          SizedBox(
                            width: 400,
                            child: TextFormField(
                              onSaved: (value) {
                                wareHouseSubCategory[
                                    'WareHouse_Sub_Category_Name'] = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: ElevatedButton(
                        onPressed: save,
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
