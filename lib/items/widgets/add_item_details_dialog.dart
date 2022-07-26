import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/colors.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:provider/provider.dart';

import '../../providers/apicalls.dart';
import '../../items/providers/items_apis.dart';
import '../../styles.dart';
import '../../widgets/modular_widgets.dart';

class AddItemDetailsDialog extends StatefulWidget {
  AddItemDetailsDialog({Key? key, required this.refresh}) : super(key: key);
  final ValueChanged<int> refresh;
  @override
  State<AddItemDetailsDialog> createState() => _AddItemDetailsDialogState();
}

enum Transfer { yes, no }

enum InventoryAdjustment { yes, no }

class _AddItemDetailsDialogState extends State<AddItemDetailsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _productTypeFormKey = GlobalKey();
  final GlobalKey<FormState> _productSubTypeFormKey = GlobalKey();
  Transfer selectedTransfer = Transfer.yes;
  InventoryAdjustment selectedInventoryAdjustmentData = InventoryAdjustment.yes;
  var transferSelectedName;

  var selectedInventoryAdjustment;

  var selectedNumberForMortality;

  var selectedSKU;

  var selectedUnitOfMeasurement;

  var selectedBatchNumberForGrading;

  var selectedProductType;

  var selectedProductSubType;

  var productTypeError;

  List unitDetails = [];

  var selectedAllowedQuantityType;
  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var itemId;
  var subCatId;
  Map<String, dynamic> itemDetails = {
    'Product_Code': null,
    'Product_Category_Id': '',
    'Product_Sub_Category_Id': '',
    'Product_Name': '',
    'Unit_Of_Measure': '',
    'Grade': '',
    'Stock_Keeping_Unit': '',
    'Description': '',
    'Batch_Request_For_Transfer': '',
    'Batch_Request_Inventory_Adjustment': '',
  };

  Map<String, dynamic> productSubType = {
    'Product_Category_Id': '',
    'Product_Sub_Category_Name': '',
  };
  String _productType = '';

  List itemCategoryData = [];
  List itemSubCategoryData = [];

  TextEditingController productCodeController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController stockKeepingUnitController = TextEditingController();
  TextEditingController gradeController = TextEditingController();

  bool productCodeValidation = true;
  bool productCategoryValidation = true;
  bool productSubCategoryValidation = true;
  bool productNameValidation = true;
  bool unitOfMeasurementValidation = true;
  bool gradeValidation = true;
  bool stockKeepingUnitValidation = true;
  bool batchRequestForTransferValidation = true;
  bool batchRequestInventoryValidation = true;
  bool batchrequestMortalityValidation = true;
  bool batchRequestGradingValidation = true;

  String productCodeValidationMessage = '';
  String productCategoryValidationMessage = '';
  String productSubCategoryValidationMessage = '';
  String productNameValidationMessage = '';
  String unitOfMeasurementValidationMessage = '';
  String gradeValidationMessage = '';
  String stockKeepingUnitValidationMessage = '';
  String batchRequestForTransferValidationMessage = '';
  String batchRequestInventoryValidationMessage = '';
  String batchrequestMortalityValidationMessage = '';
  String batchRequestGradingValidationMessage = '';

  bool validate() {
    if (productCodeController.text.length > 15) {
      productCodeValidationMessage =
          'Product code cannot be Greater than 15 characters';
      productCodeValidation = false;
    } else if (productCodeController.text == '') {
      productCodeValidationMessage = 'Product code cannot be empty';
      productCodeValidation = false;
    } else {
      productCodeValidation = true;
    }

    if (productNameController.text.length > 15) {
      productNameValidationMessage =
          'Product name cannot be Greater than 15 characters';
      productNameValidation = false;
    } else if (productNameController.text == '') {
      productNameValidationMessage = 'Product name cannot be empty';
      productNameValidation = false;
    } else {
      productNameValidation = true;
    }
    if (stockKeepingUnitController.text.length > 15) {
      stockKeepingUnitValidationMessage =
          'Stock keeping unit cannot be greater than 15 characters';
      stockKeepingUnitValidation = false;
    } else if (stockKeepingUnitController.text == '') {
      stockKeepingUnitValidationMessage = 'Stock keeping unit cannot be empty';
      stockKeepingUnitValidation = false;
    } else {
      stockKeepingUnitValidation = true;
    }
    if (gradeController.text == '') {
      batchRequestGradingValidationMessage =
          'Please select required batch number for grading';
      gradeValidation = false;
    } else {
      gradeValidation = true;
    }
    if (transferSelectedName == null) {
      batchRequestForTransferValidationMessage =
          'please select request for transfer';
      batchRequestForTransferValidation = false;
    } else {
      batchRequestForTransferValidation = true;
    }
    if (selectedInventoryAdjustment == null) {
      batchRequestInventoryValidationMessage =
          'please select request for inventory';
      batchRequestInventoryValidation = false;
    } else {
      batchRequestInventoryValidation = true;
    }
    // if (selectedNumberForMortality == null) {
    //   batchrequestMortalityValidationMessage =
    //       'please select request for mortality';
    //   batchrequestMortalityValidation = false;
    // } else {
    //   batchrequestMortalityValidation = true;
    // }
    if (selectedUnitOfMeasurement == null) {
      unitOfMeasurementValidationMessage = 'please select unit of measurement';
      unitOfMeasurementValidation = false;
    } else {
      unitOfMeasurementValidation = true;
    }
    // if (selectedBatchNumberForGrading == null) {
    //   gradeValidationMessage = 'Grading cannot be empty';
    //   batchRequestGradingValidation = false;
    // } else {
    //   batchRequestGradingValidation = true;
    // }
    if (selectedProductType == null) {
      productCategoryValidationMessage = 'please select product type';
      productCategoryValidation = false;
    } else {
      productCategoryValidation = true;
    }
    if (selectedProductSubType == null) {
      productSubCategoryValidationMessage = 'please select product sub type';
      productSubCategoryValidation = false;
    } else {
      productSubCategoryValidation = true;
    }

    if (productCodeValidation == true &&
        productNameValidation == true &&
        stockKeepingUnitValidation == true &&
        // gradeValidation == true &&
        // batchRequestForTransferValidation == true &&
        // batchRequestInventoryValidation == true &&
        // batchrequestMortalityValidation == true &&
        unitOfMeasurementValidation == true &&
        batchRequestGradingValidation == true &&
        productCategoryValidation == true &&
        productSubCategoryValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    clearProductException(context);
    productCodeController.text = getRandom(4, 'Product-');
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getItemCategory(token)
          .then((value1) {});
      Provider.of<Apicalls>(context, listen: false)
          .getStandardUnitValues(token);
    });
    itemDetails['Batch_Request_Inventory_Adjustment'] = true;
    itemDetails['Batch_Request_For_Transfer'] = true;
    super.initState();
  }

  Future<void> getItemCategory() async {
    await Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getItemCategory(token)
          .then((value1) {});
    });
  }

  void getProductSubCategory(var id) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getItemSubCategory(token, id)
          .then((value1) {});
    });
  }

  bool _validate = true;

  void save() {
    _validate = validate();
    if (_validate != true) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .addItemDetailsData(itemDetails, token)
          .then((value) {
        if (value == 200 || value == 201) {
          // Navigator.of(context).pop('success');
          widget.refresh(100);
          Get.back(result: 'success');
          successSnackbar('Successfully added the product');
        } else {
          failureSnackbar('Unable to add the product ');
        }
      });
    });
  }

  bool plantCodeError = false;
  bool plantNameError = false;

  bool address1 = false;

  bool address2 = false;

  bool district = false;

  bool taluk = false;

  bool state = false;

  bool pincode = false;

  @override
  Widget build(BuildContext context) {
    itemCategoryData = Provider.of<ItemApis>(context).itemcategory;
    itemSubCategoryData = Provider.of<ItemApis>(context).itemSubCategory;
    unitDetails = Provider.of<Apicalls>(context).standardUnitList;
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: SizedBox(
      width: 500,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Product Details',
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  color: Theme.of(context).backgroundColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 36)),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 440,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text('Product Name'),
                            ),
                            Container(
                              width: 440,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(
                                    color: plantCodeError == false
                                        ? Colors.black26
                                        : const Color.fromRGBO(243, 60, 60, 1)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: plantCodeError == false
                                          ? 'Product Name'
                                          : '',
                                      border: InputBorder.none),
                                  controller: productNameController,
                                  onSaved: (value) {
                                    itemDetails['Product_Name'] = value!;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    productNameValidation == true
                        ? const SizedBox()
                        : ModularWidgets.validationDesign(
                            size, productNameValidationMessage),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 440,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text('Product code'),
                            ),
                            Container(
                              width: 440,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(
                                    color: plantCodeError == false
                                        ? Colors.black26
                                        : const Color.fromRGBO(243, 60, 60, 1)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: plantCodeError == false
                                          ? 'Product code'
                                          : '',
                                      border: InputBorder.none),
                                  controller: productCodeController,
                                  onSaved: (value) {
                                    itemDetails['Product_Code'] = value!;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    productCodeValidation == true
                        ? const SizedBox()
                        : ModularWidgets.validationDesign(
                            size, productCodeValidationMessage),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: 440,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Product Type'),
                              ),
                            ),
                            // Container(
                            //   width: 440,
                            //   height: 36,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(8),
                            //     color: Colors.white,
                            //     border: Border.all(
                            //         color: plantCodeError == false
                            //             ? Colors.black26
                            //             : const Color.fromRGBO(243, 60, 60, 1)),
                            //   ),
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 12, vertical: 6),
                            //     child: TextFormField(
                            //       decoration: InputDecoration(
                            //           hintText: plantCodeError == false
                            //               ? 'Product Type'
                            //               : '',
                            //           border: InputBorder.none),
                            //       validator: (value) {
                            //         if (value!.isEmpty) {
                            //           showError('PlantCode');
                            //           return '';
                            //         }
                            //       },
                            //       onSaved: (value) {
                            //         itemDetails['Product_Category'] = value!;
                            //       },
                            //     ),
                            //   ),
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 380,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: selectedProductType,
                                        items: itemCategoryData
                                            .map<DropdownMenuItem<String>>((e) {
                                          return DropdownMenuItem(
                                            value: e['Product_Category_Name'],
                                            onTap: () {
                                              itemDetails[
                                                      'Product_Category_Id'] =
                                                  e['Product_Category_Id'];

                                              getProductSubCategory(
                                                  e['Product_Category_Id']);
                                            },
                                            child: Text(
                                                e['Product_Category_Name']),
                                          );
                                        }).toList(),
                                        hint: const SizedBox(
                                            width: 330, child: Text('Select')),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedProductType =
                                                value as String?;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 18,
                                ),
                                IconButton(
                                  iconSize: 30,
                                  onPressed: () {
                                    Get.dialog(productTypeDialog(size))
                                        .then((value) {
                                      getItemCategory();
                                    });
                                  },
                                  icon: const Icon(Icons.add_circle_outline),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    productCategoryValidation == true
                        ? const SizedBox()
                        : ModularWidgets.validationDesign(
                            size, productCategoryValidationMessage),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: 440,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Product Sub type'),
                              ),
                            ),
                            // Container(
                            //   width: 440,
                            //   height: 36,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(8),
                            //     color: Colors.white,
                            //     border: Border.all(
                            //         color: plantCodeError == false
                            //             ? Colors.black26
                            //             : const Color.fromRGBO(243, 60, 60, 1)),
                            //   ),
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 12, vertical: 6),
                            //     child: TextFormField(
                            //       decoration: InputDecoration(
                            //           hintText: plantCodeError == false
                            //               ? 'Product Sub Type'
                            //               : '',
                            //           border: InputBorder.none),
                            //       validator: (value) {
                            //         if (value!.isEmpty) {
                            //           showError('PlantCode');
                            //           return '';
                            //         }
                            //       },
                            //       onSaved: (value) {
                            //         itemDetails['Product_Sub_Category'] =
                            //             value!;
                            //       },
                            //     ),
                            //   ),
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 380,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: selectedProductSubType,
                                        items: itemSubCategoryData
                                            .map<DropdownMenuItem<String>>((e) {
                                          return DropdownMenuItem(
                                            value:
                                                e['Product_Sub_Category_Name'],
                                            onTap: () {
                                              itemDetails[
                                                      'Product_Sub_Category_Id'] =
                                                  e['Product_Sub_Category_Id'];
                                            },
                                            child: Text(
                                                e['Product_Sub_Category_Name']),
                                          );
                                        }).toList(),
                                        hint: const SizedBox(
                                            width: 330, child: Text('Select')),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedProductSubType =
                                                value as String?;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 18,
                                ),
                                IconButton(
                                  iconSize: 30,
                                  onPressed: () {
                                    selectedProductType = null;
                                    Get.dialog(productSubTypeDialog(size));
                                  },
                                  icon: const Icon(Icons.add_circle_outline),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    productSubCategoryValidation == true
                        ? const SizedBox()
                        : ModularWidgets.validationDesign(
                            size, productSubCategoryValidationMessage),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 440,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text('Stock Keeping Unit'),
                            ),
                            Container(
                              width: 440,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: plantCodeError == false
                                          ? 'Stock keeping unit'
                                          : '',
                                      border: InputBorder.none),
                                  controller: stockKeepingUnitController,
                                  onSaved: (value) {
                                    itemDetails['Stock_Keeping_Unit'] = value!;
                                  },
                                ),
                              ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 5.0),
                              //   child: DropdownButtonHideUnderline(
                              //     child: DropdownButton(
                              //       value: selectedSKU,
                              //       items: [
                              //         'gram',
                              //         'kilogram',
                              //         'metric ton',
                              //         'pound',
                              //         'liter'
                              //       ].map<DropdownMenuItem<String>>((e) {
                              //         return DropdownMenuItem(
                              //           child: Text(e),
                              //           value: e,
                              //           onTap: () {
                              //             itemDetails['Stock_Keeping_Unit'] = e;
                              //           },
                              //         );
                              //       }).toList(),
                              //       hint: Container(
                              //         width: 404,
                              //         child: const Text('Select'),
                              //       ),
                              //       onChanged: (value) {
                              //         setState(() {
                              //           selectedSKU = value as String?;
                              //         });
                              //       },
                              //     ),
                              //   ),
                              // ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    stockKeepingUnitValidation == true
                        ? const SizedBox()
                        : ModularWidgets.validationDesign(
                            size, stockKeepingUnitValidationMessage),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 440,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text('Unit of Measurement'),
                            ),
                            Container(
                              width: 440,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: selectedUnitOfMeasurement,
                                    items: unitDetails
                                        .map<DropdownMenuItem<String>>((e) {
                                      return DropdownMenuItem(
                                        value: e['Unit_Name'],
                                        onTap: () {
                                          itemDetails['Unit_Of_Measure'] =
                                              e['Unit_Id'];
                                        },
                                        child: Text(e['Unit_Name']),
                                      );
                                    }).toList(),
                                    hint: const SizedBox(
                                        width: 404, child: Text('Select')),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedUnitOfMeasurement =
                                            value as String?;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    unitOfMeasurementValidation == true
                        ? const SizedBox()
                        : ModularWidgets.validationDesign(
                            size, unitOfMeasurementValidationMessage),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 24.0),
                    //   child: Align(
                    //     alignment: Alignment.topLeft,
                    //     child: Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Container(
                    //           width: 440,
                    //           padding: const EdgeInsets.only(bottom: 12),
                    //           child: const Text('Grade'),
                    //         ),
                    //         Container(
                    //           width: 440,
                    //           height: 36,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             color: Colors.white,
                    //             border: Border.all(
                    //                 color: plantCodeError == false
                    //                     ? Colors.black26
                    //                     : const Color.fromRGBO(243, 60, 60, 1)),
                    //           ),
                    //           child: Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 12, vertical: 6),
                    //             child: TextFormField(
                    //               decoration: InputDecoration(
                    //                   hintText: plantCodeError == false
                    //                       ? 'Grade'
                    //                       : '',
                    //                   border: InputBorder.none),
                    //               controller: gradeController,
                    //               onSaved: (value) {
                    //                 itemDetails['Grade'] = value!;
                    //               },
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // gradeValidation == true
                    //     ? const SizedBox()
                    //     : ModularWidgets.validationDesign(
                    //         size, gradeValidationMessage),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 440,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text('Allowed Quantity Type'),
                            ),
                            Container(
                              width: 440,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: selectedAllowedQuantityType,
                                    items: ['Number', 'Decimal']
                                        .map<DropdownMenuItem<String>>((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        onTap: () {
                                          itemDetails['Allowed_Quantity_Type'] =
                                              e;
                                        },
                                        child: Text(e),
                                      );
                                    }).toList(),
                                    hint: const SizedBox(
                                        width: 404, child: Text('Select')),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAllowedQuantityType =
                                            value as String?;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 440,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text(
                                  'Required Batch Number for Transfer'),
                            ),
                            Container(
                              width: 440,
                              height: 36,
                              child: Row(
                                children: [
                                  const SizedBox(width: 40, child: Text('Yes')),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Radio(
                                      activeColor: ProjectColors.themecolor,
                                      value: Transfer.yes,
                                      groupValue: selectedTransfer,
                                      onChanged: (value) {
                                        setState(() {
                                          itemDetails[
                                                  'Batch_Request_For_Transfer'] =
                                              true;
                                          selectedTransfer = value as Transfer;
                                        });
                                      })
                                ],
                              ),
                            ),
                            Container(
                              width: 440,
                              height: 36,
                              child: Row(
                                children: [
                                  const SizedBox(width: 40, child: Text('No')),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Radio(
                                      activeColor: ProjectColors.themecolor,
                                      value: Transfer.no,
                                      groupValue: selectedTransfer,
                                      onChanged: (value) {
                                        setState(() {
                                          itemDetails[
                                                  'Batch_Request_For_Transfer'] =
                                              false;
                                          selectedTransfer = value as Transfer;
                                        });
                                      })
                                ],
                              ),
                            ),
                            // Container(
                            //   width: 440,
                            //   height: 36,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(8),
                            //     color: Colors.white,
                            //     border: Border.all(color: Colors.black26),
                            //   ),
                            //   child: Padding(
                            //     padding:
                            //         const EdgeInsets.symmetric(horizontal: 5.0),
                            //     child: DropdownButtonHideUnderline(
                            //       child: DropdownButton(
                            //         value: transferSelectedName,
                            //         items: ['Yes', 'No']
                            //             .map<DropdownMenuItem<String>>((e) {
                            //           return DropdownMenuItem(
                            //             value: e,
                            //             onTap: () {
                            //               itemDetails[
                            //                   'Batch_Request_For_Transfer'] = e;
                            //             },
                            //             child: Text(e),
                            //           );
                            //         }).toList(),
                            //         hint: const SizedBox(
                            //             width: 404, child: Text('Select')),
                            //         onChanged: (value) {
                            //           setState(() {
                            //             transferSelectedName = value as String?;
                            //           });
                            //         },
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // batchRequestForTransferValidation == true
                    //     ? const SizedBox()
                    //     : ModularWidgets.validationDesign(
                    //         size, batchRequestForTransferValidationMessage),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 440,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text(
                                  'Required Batch Number for Inventory Adjustment'),
                            ),
                            Container(
                              width: 440,
                              height: 36,
                              child: Row(
                                children: [
                                  const SizedBox(width: 40, child: Text('Yes')),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Radio(
                                      activeColor: ProjectColors.themecolor,
                                      value: InventoryAdjustment.yes,
                                      groupValue:
                                          selectedInventoryAdjustmentData,
                                      onChanged: (value) {
                                        setState(() {
                                          itemDetails[
                                                  'Batch_Request_Inventory_Adjustment'] =
                                              true;
                                          selectedInventoryAdjustmentData =
                                              value as InventoryAdjustment;
                                        });
                                      })
                                ],
                              ),
                            ),
                            Container(
                              width: 440,
                              height: 36,
                              child: Row(
                                children: [
                                  const SizedBox(width: 40, child: Text('No')),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Radio(
                                      activeColor: ProjectColors.themecolor,
                                      value: InventoryAdjustment.no,
                                      groupValue:
                                          selectedInventoryAdjustmentData,
                                      onChanged: (value) {
                                        setState(() {
                                          itemDetails[
                                                  'Batch_Request_Inventory_Adjustment'] =
                                              false;
                                          selectedInventoryAdjustmentData =
                                              value as InventoryAdjustment;
                                        });
                                      })
                                ],
                              ),
                            ),
                            // Container(
                            //   width: 440,
                            //   height: 36,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(8),
                            //     color: Colors.white,
                            //     border: Border.all(color: Colors.black26),
                            //   ),
                            //   child: Padding(
                            //     padding:
                            //         const EdgeInsets.symmetric(horizontal: 5.0),
                            //     child: DropdownButtonHideUnderline(
                            //       child: DropdownButton(
                            //         value: selectedInventoryAdjustment,
                            //         items: ['Yes', 'No']
                            //             .map<DropdownMenuItem<String>>((e) {
                            //           return DropdownMenuItem(
                            //             value: e,
                            //             onTap: () {
                            //               itemDetails[
                            //                   'Batch_Request_Inventory_Adjustment'] = e;
                            //             },
                            //             child: Text(e),
                            //           );
                            //         }).toList(),
                            //         hint: const SizedBox(
                            //             width: 404, child: Text('Select')),
                            //         onChanged: (value) {
                            //           setState(() {
                            //             selectedInventoryAdjustment =
                            //                 value as String?;
                            //           });
                            //         },
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // batchRequestInventoryValidation == true
                    //     ? const SizedBox()
                    //     : ModularWidgets.validationDesign(
                    //         size, batchRequestInventoryValidationMessage),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 24.0),
                    //   child: Align(
                    //     alignment: Alignment.topLeft,
                    //     child: Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Container(
                    //           width: 440,
                    //           padding: const EdgeInsets.only(bottom: 12),
                    //           child: const Text(
                    //               'Required Batch Number for Mortality'),
                    //         ),
                    //         Container(
                    //           width: 440,
                    //           height: 36,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             color: Colors.white,
                    //             border: Border.all(color: Colors.black26),
                    //           ),
                    //           child: Padding(
                    //             padding:
                    //                 const EdgeInsets.symmetric(horizontal: 5.0),
                    //             child: DropdownButtonHideUnderline(
                    //               child: DropdownButton(
                    //                 value: selectedNumberForMortality,
                    //                 items: ['Yes', 'No']
                    //                     .map<DropdownMenuItem<String>>((e) {
                    //                   return DropdownMenuItem(
                    //                     child: Text(e),
                    //                     value: e,
                    //                     onTap: () {
                    //                       itemDetails[
                    //                           'Batch_Request_For_Mortality'] = e;
                    //                     },
                    //                   );
                    //                 }).toList(),
                    //                 hint: Container(
                    //                     width: 404,
                    //                     child: const Text('Select')),
                    //                 onChanged: (value) {
                    //                   setState(() {
                    //                     selectedNumberForMortality =
                    //                         value as String?;
                    //                   });
                    //                 },
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // batchrequestMortalityValidation == true
                    //     ? const SizedBox()
                    //     : ModularWidgets.validationDesign(
                    //         size, batchrequestMortalityValidationMessage),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 24.0),
                    //   child: Align(
                    //     alignment: Alignment.topLeft,
                    //     child: Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Container(
                    //           width: 440,
                    //           padding: const EdgeInsets.only(bottom: 12),
                    //           child: const Text(
                    //               'Required Batch Number for Grading'),
                    //         ),
                    //         Container(
                    //           width: 440,
                    //           height: 36,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             color: Colors.white,
                    //             border: Border.all(color: Colors.black26),
                    //           ),
                    //           child: Padding(
                    //             padding:
                    //                 const EdgeInsets.symmetric(horizontal: 5.0),
                    //             child: DropdownButtonHideUnderline(
                    //               child: DropdownButton(
                    //                 value: selectedBatchNumberForGrading,
                    //                 items: ['Yes', 'No']
                    //                     .map<DropdownMenuItem<String>>((e) {
                    //                   return DropdownMenuItem(
                    //                     child: Text(e),
                    //                     value: e,
                    //                     onTap: () {
                    //                       itemDetails[
                    //                           'Batch_Request_For_Grading'] = e;
                    //                     },
                    //                   );
                    //                 }).toList(),
                    //                 hint: Container(
                    //                     width: 404,
                    //                     child: const Text('Select')),
                    //                 onChanged: (value) {
                    //                   setState(() {
                    //                     selectedBatchNumberForGrading =
                    //                         value as String?;
                    //                   });
                    //                 },
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // batchRequestGradingValidation == true
                    //     ? const SizedBox()
                    //     : ModularWidgets.validationDesign(
                    //         size, batchRequestGradingValidationMessage),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 440,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text('Description'),
                            ),
                            Container(
                              width: 440,
                              height: 112,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(
                                    color: plantCodeError == false
                                        ? Colors.black26
                                        : const Color.fromRGBO(243, 60, 60, 1)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: plantCodeError == false
                                          ? 'Description(optional)'
                                          : '',
                                      border: InputBorder.none),
                                  onSaved: (value) {
                                    itemDetails['Description'] = value!;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer<ItemApis>(builder: (context, value, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.productException.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ModularWidgets.exceptionDesign(
                              MediaQuery.of(context).size,
                              value.productException[index]);
                        },
                      );
                    }),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25.0),
                            child: SizedBox(
                              width: 200,
                              height: 48,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color.fromRGBO(44, 96, 154, 1),
                                    ),
                                  ),
                                  onPressed: save,
                                  child: Text(
                                    'Add Details',
                                    style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Color.fromRGBO(255, 254, 254, 1),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          // : Padding(
                          //     padding: const EdgeInsets.symmetric(
                          //         vertical: 25.0),
                          //     child: SizedBox(
                          //       width: 200,
                          //       height: 48,
                          //       child: ElevatedButton(
                          //           style: ButtonStyle(
                          //             backgroundColor:
                          //                 MaterialStateProperty.all(
                          //               const Color.fromRGBO(
                          //                   44, 96, 154, 1),
                          //             ),
                          //           ),
                          //           onPressed: updateData,
                          //           child: Text(
                          //             'Update',
                          //             style: GoogleFonts.roboto(
                          //               textStyle: const TextStyle(
                          //                 fontWeight: FontWeight.w500,
                          //                 fontSize: 18,
                          //                 color: Color.fromRGBO(
                          //                     255, 254, 254, 1),
                          //               ),
                          //             ),
                          //           )),
                          //     ),
                          //   ),
                          const SizedBox(
                            width: 42,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 200,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromRGBO(44, 96, 154, 1),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: ProjectStyles.cancelStyle(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Dialog productTypeDialog(Size size) {
    return Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            width: size.width * 0.25,
            height: size.height * 0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Form(
                key: _productTypeFormKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: size.width * 0.2,
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Product Type',
                              style: GoogleFonts.roboto(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            width: size.width * 0.2,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(color: Colors.black26),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    hintText: 'Enter Product Type',
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '';
                                  }
                                },
                                onSaved: (value) {
                                  _productType = value!;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  ProjectColors.themecolor,
                                ),
                              ),
                              onPressed: () => submitProductType(size),
                              child: Text(
                                'submit',
                                style: GoogleFonts.roboto(color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> submitProductType(Size size) async {
    bool validate = _productTypeFormKey.currentState!.validate();
    if (validate != true) {
      return;
    }
    _productTypeFormKey.currentState!.save();
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<ItemApis>(context, listen: false).addItemCategoryData(
            {'Product_Category_Name': _productType}, token).then((value) {
          if (value == 200 || value == 201) {
            Get.back();
            // getItemCategory().then((value) {
            //   Get.dialog(productSubTypeDialog(size));
            // });

            Get.showSnackbar(const GetSnackBar(
              title: 'Success',
              message: 'Successfully added the product type ',
              duration: Duration(seconds: 2),
              forwardAnimationCurve: Curves.easeIn,
            ));
          }
        });
      }
    });
  }

  Future<void> submitProductSubType(Size size) async {
    bool validate = _productSubTypeFormKey.currentState!.validate();
    if (validate != true) {
      return;
    }
    _productSubTypeFormKey.currentState!.save();
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<ItemApis>(context, listen: false)
            .addItemSubCategoryData(
                productSubType['Product_Category_Id'], productSubType, token)
            .then((value) {
          if (value == 200 || value == 201) {
            Get.back();

            Get.showSnackbar(const GetSnackBar(
              title: 'Success',
              message: 'Successfully added the product type ',
              duration: Duration(seconds: 2),
              forwardAnimationCurve: Curves.easeIn,
            ));
          }
        });
      }
    });
  }

  Dialog productSubTypeDialog(Size size) {
    return Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            width: size.width * 0.3,
            height: size.height * 0.4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Form(
                key: _productSubTypeFormKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      width: size.width * 0.2,
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: const Text('Product Type'),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: size.width * 0.25,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          border:
                                              Border.all(color: Colors.black26),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              value: selectedProductType,
                                              items: itemCategoryData.map<
                                                      DropdownMenuItem<String>>(
                                                  (e) {
                                                return DropdownMenuItem(
                                                  value: e[
                                                      'Product_Category_Name'],
                                                  onTap: () {
                                                    productSubType[
                                                            'Product_Category_Id'] =
                                                        e['Product_Category_Id'];
                                                  },
                                                  child: Text(e[
                                                      'Product_Category_Name']),
                                                );
                                              }).toList(),
                                              hint: SizedBox(
                                                  width: size.width * 0.15,
                                                  child: const Text('Select')),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedProductType =
                                                      value as String?;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: size.width * 0.2,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text('Product Sub Type'),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: size.width * 0.2,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: 'Product Sub Type',
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '';
                                    }
                                  },
                                  onSaved: (value) {
                                    productSubType[
                                        'Product_Sub_Category_Name'] = value!;
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  ProjectColors.themecolor,
                                ),
                              ),
                              onPressed: () => submitProductSubType(size),
                              child: Text(
                                'submit',
                                style: GoogleFonts.roboto(color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
