import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/batch_plan/providers/batch_plan_apis.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:poultry_login_signup/items/providers/items_apis.dart';
import 'package:provider/provider.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';

class AddInventoryAdjustment extends StatefulWidget {
  AddInventoryAdjustment({Key? key}) : super(key: key);
  static const routeName = '/AddInventoryAdjustment';

  @override
  _AddInventoryAdjustmentState createState() => _AddInventoryAdjustmentState();
}

class _AddInventoryAdjustmentState extends State<AddInventoryAdjustment> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var itemId;
  var batchId;
  var wareHouseId;
  var inventoryId;
  var myFormatData = DateFormat('dd-MM-yyyy');
  var sendFormatData = DateFormat('yyyy-MM-dd');
  TextEditingController _txtFormCtrl = TextEditingController();

  Map<String, dynamic> inventoryAdjustment = {
    'Inventory_Id': '',
    'Product_Id': '',
    'Batch_Id': '',
    'Ware_House_Id': '',
    'Inventory_Adjustment_Date': '',
    'CW_Unit': '',
    'CW_Quantity': '',
    'Inventory_Adjustment_Description': '',
  };

  List itemDetails = [];
  List batchPlanData = [];
  List batchPlanMapData = [];
  List warehouseDetails = [];
  List inventory = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getItemDetails(token)
          .then((value1) {});
      var plantId = await fetchPlant();
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseDetails(plantId, token)
          .then((value1) {});
      Provider.of<BatchApis>(context, listen: false)
          .getBatchPlanMapping(token)
          .then((value1) {});
      Provider.of<ItemApis>(context, listen: false)
          .getInventoryItems(token)
          .then((value1) {});
    });

    super.initState();
  }

  void _inventoryAdjustmentDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2016),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        inventoryAdjustment['Inventory_Adjustment_Date'] =
            sendFormatData.format(pickedDate);
        // print(inventoryAdjustment['Inventory_Adjustment_Date']);
        _txtFormCtrl.text = myFormatData.format(pickedDate);
      });
    });
  }

  void save() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    print(inventoryAdjustment);

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .addInventoryAdjustmentData(inventoryAdjustment, token)
          .then((value) {
        if (value == 200 || value == 201) {
          showDialog(
              context: context,
              builder: (ctx) => SuccessDialog(
                  title: 'Success',
                  subTitle: 'SuccessFully Added Inventory Adjustment Data'));
        } else {
          showDialog(
              context: context,
              builder: (ctx) => FailureDialog(
                  title: 'Failed',
                  subTitle: 'Something Went Wrong Please Try Again'));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    itemDetails = Provider.of<ItemApis>(context).itemDetails;
    batchPlanMapData = Provider.of<BatchApis>(
      context,
    ).batchPlanMapping;
    warehouseDetails = Provider.of<InfrastructureApis>(
      context,
    ).warehouseDetails;
    inventory = Provider.of<ItemApis>(context).inventoryItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Inventory Adjustments'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Choose Inventory Code'),
                    Container(
                      width: 400,
                      child: DropdownButton(
                        value: inventoryId,
                        items: inventory.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            child: Text(e['Inventory_Code']),
                            value: e['Inventory_Code'],
                            onTap: () {
                              inventoryAdjustment['Inventory_Id'] =
                                  e['Inventory_Id'];
                            },
                          );
                        }).toList(),
                        hint: Container(
                            width: 350,
                            child: const Text('Please Choose Inventory Code')),
                        onChanged: (value) {
                          setState(() {
                            inventoryId = value as String?;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Choose Category Name'),
                    Container(
                      width: 400,
                      child: DropdownButton(
                        value: itemId,
                        items: itemDetails.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            child: Text(e['Product_Name']),
                            value: e['Product_Name'],
                            onTap: () {
                              inventoryAdjustment['Product_Id'] =
                                  e['Product_Id'];
                            },
                          );
                        }).toList(),
                        hint: Container(
                            width: 350,
                            child: const Text('Please Choose category Name')),
                        onChanged: (value) {
                          setState(() {
                            itemId = value as String?;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Choose batch Name'),
                    Container(
                      width: 400,
                      child: DropdownButton(
                        value: batchId,
                        items:
                            batchPlanMapData.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            child: Text(e['Bird_Age_Name']),
                            value: e['Bird_Age_Name'],
                            onTap: () {
                              inventoryAdjustment['Batch_Id'] =
                                  e['Batch_Plan_Id'];
                            },
                          );
                        }).toList(),
                        hint: Container(
                            width: 350,
                            child: const Text('Please Choose Bird Age Name')),
                        onChanged: (value) {
                          setState(() {
                            batchId = value as String?;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Choose WareHouse Code'),
                    Container(
                      width: 400,
                      child: DropdownButton(
                        value: wareHouseId,
                        items:
                            warehouseDetails.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            child: Text(e['WareHouse_Code']),
                            value: e['WareHouse_Code'],
                            onTap: () {
                              inventoryAdjustment['Ware_House_Id'] =
                                  int.parse(e['WareHouse_Id'].toString());
                            },
                          );
                        }).toList(),
                        hint: Container(
                            width: 350,
                            child: const Text('Please Choose Bird Age Name')),
                        onChanged: (value) {
                          setState(() {
                            wareHouseId = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Expanded(child: Text('Inventory Adjustment Date')),
                    Container(
                      width: 300,
                      child: TextFormField(
                        enabled: false,
                        controller: _txtFormCtrl,
                        // onSaved: (value) {
                        //   inventoryAdjustment['Inventory_Adjustemnt_Date'] =
                        //       value!;
                        // },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: _inventoryAdjustmentDate,
                        child: const Text('Pick Date'))
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('CW Unit'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          inventoryAdjustment['CW_Unit'] = int.parse(value!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('CW Quantity: '),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          inventoryAdjustment['CW_Quantity'] =
                              int.parse(value!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: Text('Inventory Adjustment Description:')),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          inventoryAdjustment[
                              'Inventory_Adjustment_Description'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child:
                    ElevatedButton(onPressed: save, child: const Text('Save')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
