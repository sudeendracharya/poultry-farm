import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/inventory_adjustment/providers/inventory_adjustement_apis.dart';
import 'package:poultry_login_signup/screens/production_dashboard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../inventory/providers/inventory_api.dart';
import '../../items/providers/items_apis.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../widgets/modular_widgets.dart';

class AddEggCollection extends StatefulWidget {
  AddEggCollection({Key? key, required this.reFresh, required this.editData})
      : super(key: key);

  final ValueChanged<int> reFresh;
  final Map<String, dynamic> editData;

  @override
  State<AddEggCollection> createState() => _AddEggCollectionState();
}

class _AddEggCollectionState extends State<AddEggCollection>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var activityId;

  var collectionStatusId;

  var IsClearedSelected;

  var eggGradingId;

  List eggGradingList = [];

  TextEditingController collectionCodeController = TextEditingController();

  String collectionCodeValidationMessage = '';

  bool collectionCodeValidation = true;

  var productId;

  bool itemValidation = true;

  String itemValidationMessage = '';

  bool itemSubCategoryValidation = true;

  String itemSubCategoryValidationMessage = '';

  var itemSubCategoryId;

  List itemSubCategory = [];

  List productList = [];

  String batchPlanValidationMessage = '';

  bool batchPlanValidation = true;

  List batchPlanDetails = [];

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  late AnimationController controller;
  late Animation<Offset> offset;

  var itemId;
  var batchId;
  var wareHouseId;
  List wareHouseDetails = [];
  var breedName;
  List plantDetails = [];
  var plantName;
  List birdAgeGroup = [];
  var birdName;

  List breedInfo = [];
  List activityHeaderData = [];
  var ActivityId;
  List medicationHeaderData = [];
  var medicationId;
  List vaccinationHeaderData = [];
  var vaccinationId;
  List breedVersion = [];
  var breedVersionId;

  TextEditingController dateController = TextEditingController();
  TextEditingController collectionDateController = TextEditingController();
  TextEditingController eggCollectionCodeController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController averageWeightController = TextEditingController();
  TextEditingController requiredQuantityController = TextEditingController();

  Map<String, dynamic> eggCollectionDetails = {
    'Egg_Collection_Id': '',
    'WareHouse_Id': '',
    'Grade': '',
    'Quantity': '',
    'Collection_Date': '',
    'Average_Weight': '',
    'Collection_Status': '',
    'Is_Cleared': '',
  };

  bool eggCollectionCodeValidation = true;
  bool requiredQuantityValidation = true;
  bool gradeValidation = true;
  bool quantityValidation = true;
  bool wareHouseIdValidation = true;
  bool breedIdValidation = true;
  bool averageWeightValidation = true;
  bool collectionStatusValidation = true;
  bool IsClearedValidation = true;
  bool vaccinationPlanIdValidation = true;
  bool requiredDateOfDeliveryValidation = true;
  bool collectionDateValidation = true;

  String requiredQuantityValidationMessage = '';
  String eggCollectionCodeValidationMessage = '';
  String gradeValidationMessage = '';
  String quantityValidationMessage = '';
  String wareHouseIdValidationMessage = '';
  String breedIdValidationMessage = '';
  String averageWeightValidationMessage = '';
  String collectionStatusValidationMessage = '';
  String IsClearedValidationMessage = '';
  String vaccinationPlanIdValidationMessage = '';
  String collectionDateValidationMessage = '';

  String requiredDateOfDeliveryValidationMessage = '';

  bool validate() {
    // if (eggCollectionCodeController.text == '') {
    //   eggCollectionCodeValidationMessage = 'Collection code cannot be empty';
    //   eggCollectionCodeValidation = false;
    // } else {
    //   eggCollectionCodeValidation = true;
    // }
    // if (requiredQuantityController.text == '') {
    //   requiredQuantityValidationMessage = 'Required quantity cannot be empty';
    //   requiredQuantityValidation = false;
    // } else {
    //   requiredQuantityValidation = true;
    // }
    if (itemSubCategoryId == null) {
      itemSubCategoryValidationMessage = 'Product sub category cannot be empty';
      itemSubCategoryValidation = false;
    } else {
      itemSubCategoryValidation = true;
    }
    if (productId == null) {
      itemValidationMessage = 'Product cannot be empty';
      itemValidation = false;
    } else {
      itemValidation = true;
    }
    if (collectionCodeController.text == '') {
      collectionCodeValidationMessage = 'Collection Code cannot be empty';
      collectionCodeValidation = false;
    } else {
      collectionCodeValidation = true;
    }
    if (eggGradingId == null) {
      gradeValidationMessage = 'Enter Grade';
      gradeValidation = false;
    } else {
      gradeValidation = true;
    }
    if (quantityController.text == '') {
      quantityValidationMessage = 'Enter quantity';
      quantityValidation = false;
    } else {
      quantityValidation = true;
    }
    if (wareHouseId == null) {
      wareHouseIdValidationMessage = 'Select the warehouse';
      wareHouseIdValidation = false;
    } else {
      wareHouseIdValidation = true;
    }
    if (averageWeightController.text.isNum != true) {
      averageWeightValidationMessage = 'Enter a valid average weight';
      averageWeightValidation = false;
    } else if (averageWeightController.text.length > 6) {
      averageWeightValidationMessage =
          'Average weight cannot be greter then 5 characters';
      averageWeightValidation = false;
    } else if (averageWeightController.text == '') {
      averageWeightValidationMessage = 'Average weight cannot be empty';
      averageWeightValidation = false;
    } else {
      averageWeightValidation = true;
    }
    if (collectionStatusId == null) {
      collectionStatusValidationMessage = 'Select the collection status';
      collectionStatusValidation = false;
    } else {
      collectionStatusValidation = true;
    }
    if (IsClearedSelected == null) {
      IsClearedValidationMessage = 'Is cleared cannot be empty';
      IsClearedValidation = false;
    } else {
      IsClearedValidation = true;
    }

    if (collectionDateController.text == '') {
      collectionDateValidationMessage = 'Select collection date';
      collectionDateValidation = false;
    } else {
      collectionDateValidation = true;
    }

    if (eggCollectionCodeValidation == true &&
        itemSubCategoryValidation == true &&
        itemValidation == true &&
        collectionCodeValidation == true &&
        gradeValidation == true &&
        quantityValidation == true &&
        wareHouseIdValidation == true &&
        averageWeightValidation == true &&
        collectionStatusValidation == true &&
        IsClearedValidation == true &&
        collectionDateValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  void _hatchDatePicker() {
    showDatePicker(
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ProjectColors.themecolor, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.green, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.red, // button text color
                ),
              ),
            ),
            child: child!);
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      // _startDate = pickedDate.millisecondsSinceEpoch;
      collectionDateController.text =
          DateFormat('dd-MM-yyyy').format(pickedDate);
      eggCollectionDetails['Collection_Date'] =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);

      setState(() {});
    });
  }

  // void _datePicker() {
  //   showDatePicker(
  //     builder: (context, child) {
  //       return Theme(
  //           data: Theme.of(context).copyWith(
  //             colorScheme: ColorScheme.light(
  //               primary: ProjectColors.themecolor, // header background color
  //               onPrimary: Colors.black, // header text color
  //               onSurface: Colors.green, // body text color
  //             ),
  //             textButtonTheme: TextButtonThemeData(
  //               style: TextButton.styleFrom(
  //                 primary: Colors.red, // button text color
  //               ),
  //             ),
  //           ),
  //           child: child!);
  //     },
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2021),
  //     lastDate: DateTime(2025),
  //   ).then((pickedDate) {
  //     if (pickedDate == null) {
  //       return;
  //     }
  //     // _startDate = pickedDate.millisecondsSinceEpoch;
  //     dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
  //     eggGradingDetails['Required_Date_Of_Delivery'] =
  //         DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);

  //     setState(() {});
  //   });
  // }

  Future<String> fetchCredientials() async {
    bool data =
        await Provider.of<Apicalls>(context, listen: false).tryAutoLogin();

    if (data != false) {
      var token = Provider.of<Apicalls>(context, listen: false).token;

      return token;
    } else {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    //scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.linear);
    offset = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
        .animate(controller);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
    getItemSubCategory(2);
    Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      var plantId = await fetchPlant();
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseDetails(plantId, token)
          .then((value1) {});
      Provider.of<Apicalls>(context, listen: false)
          .getStandardEggGradeList(token);
      Provider.of<InventoryApi>(context, listen: false).getBatch(token);
    });
    if (widget.editData.isNotEmpty) {
      collectionDateController.text = widget.editData['Collection_Date'];
      eggCollectionDetails['Collection_Date'] =
          widget.editData['Collection_Date'];
      quantityController.text = widget.editData['Quantity'].toString();
      eggCollectionDetails['Quantity'] = widget.editData['Quantity'];
      averageWeightController.text =
          widget.editData['Average_Weight'].toString();
      eggCollectionDetails['Average_Weight'] =
          widget.editData['Average_Weight'];
      requiredQuantityController.text = widget.editData['Quantity'].toString();
      eggCollectionDetails['Quantity'] = widget.editData['Quantity'];
      IsClearedSelected = widget.editData['Is_Cleared'];
      eggCollectionDetails['Is_Cleared'] = widget.editData['Is_Cleared'];
      collectionStatusId = widget.editData['Collection_Status'];
      eggCollectionDetails['Collection_Status'] =
          widget.editData['Collection_Status'];
      collectionCodeController.text = widget.editData['Egg_Collection_Code'];
      eggCollectionDetails['Egg_Collection_Code'] =
          widget.editData['Egg_Collection_Code'];
      wareHouseId = widget.editData['WareHouse_Id__WareHouse_Name'];
      eggCollectionDetails['WareHouse_Id'] = widget.editData['WareHouse_Id'];
      batchId = widget.editData['Batch_Plan_Code'] == ''
          ? null
          : widget.editData['Batch_Plan_Code'];
      eggGradingId = widget.editData['Egg_Grade_Id__Egg_Grade'];
      eggCollectionDetails['Egg_Grade_Id'] = widget.editData['Egg_Grade_Id'];
      productId = widget.editData['Product_Id__Product_Name'];
      eggCollectionDetails['Product_Id'] = widget.editData['Product_Id'];
      itemSubCategoryId = widget.editData[
          'Product_Id__Product_Sub_Category_Id__Product_Sub_Category_Name'];
      getProducts(widget.editData['Product_Id__Product_Sub_Category_Id']);
    } else {
      collectionCodeController.text = getRandom(4, 'PSTK-');
    }
  }

  var isValid = true;

  void save() {
    isValid = validate();
    if (!isValid) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    // print(eggGradingDetails);

    if (widget.editData.isNotEmpty) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .updateEggCollection(eggCollectionDetails,
                widget.editData['Egg_Collection_Id'], token)
            .then((value) {
          if (value == 202 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully updated the Egg Collection data');
          } else {
            failureSnackbar(
                'Unable to update the egg collection data something went wrong');
          }
        });
      });
    } else {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .addEggCollection(eggCollectionDetails, token)
            .then((value) {
          if (value == 200 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully added egg collection data');
          } else {
            failureSnackbar('Unable to add data something went wrong');
          }
        });
      });
    }
  }

  void getProducts(var subCategoryId) {
    fetchCredientials().then((token) {
      Provider.of<ItemApis>(context, listen: false)
          .getproductlist(token, subCategoryId);
    });
  }

  void getItemSubCategory(var id) {
    Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;

      Provider.of<ItemApis>(context, listen: false)
          .getItemSubCategory(token, id)
          .then((value1) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double formWidth = size.width * 0.25;

    wareHouseDetails = Provider.of<InfrastructureApis>(
      context,
    ).warehouseDetails;
    eggGradingList = Provider.of<Apicalls>(context).standardEggGradeList;
    itemSubCategory = Provider.of<ItemApis>(context).itemSubCategory;
    productList = Provider.of<ItemApis>(context).productList;
    batchPlanDetails = Provider.of<InventoryApi>(context).batchDetails;

    return Container(
      width: size.width * 0.3,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      child: Drawer(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Egg Collection',
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                color: Theme.of(context).backgroundColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 36)),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 36.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'Add Egg Collection',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Record Code'),
                        ),
                        Container(
                          width: formWidth,
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
                                  hintText: 'Enter Record Code',
                                  border: InputBorder.none),
                              controller: collectionCodeController,
                              onSaved: (value) {
                                eggCollectionDetails['Egg_Collection_Code'] =
                                    value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  collectionCodeValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, collectionCodeValidationMessage),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('Egg Collection Code'),
                  //       ),
                  //       Container(
                  //         width: formWidth,
                  //         height: 36,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(8),
                  //           color: Colors.white,
                  //           border: Border.all(color: Colors.black26),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 12, vertical: 6),
                  //           child: TextFormField(
                  //             decoration: const InputDecoration(
                  //                 hintText: 'Enter egg collection code',
                  //                 border: InputBorder.none),
                  //             controller: eggCollectionCodeController,
                  //             onSaved: (value) {
                  //               eggGradingDetails['Egg_Collection_Id'] = value!;
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // eggCollectionCodeValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, eggCollectionCodeValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Ware house Id'),
                        ),
                        Container(
                          width: formWidth,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: wareHouseId,
                                items: wareHouseDetails
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['WareHouse_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      eggCollectionDetails['WareHouse_Id'] =
                                          e['WareHouse_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['WareHouse_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose wareHouse Id'),
                                onChanged: (value) {
                                  setState(() {
                                    wareHouseId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  wareHouseIdValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, wareHouseIdValidationMessage),

                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Item Sub Category'),
                        ),
                        Container(
                          width: formWidth,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: itemSubCategoryId,
                                items: itemSubCategory
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Product_Sub_Category_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      // salesJournal['Item_Sub_Category'] =
                                      //     e['Product_Sub_Category_Id'];

                                      getProducts(e['Product_Sub_Category_Id']);
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Product_Sub_Category_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Select'),
                                onChanged: (value) {
                                  setState(() {
                                    itemSubCategoryId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemSubCategoryValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, itemSubCategoryValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Product'),
                        ),
                        Container(
                          width: formWidth,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: productId,
                                items: productList
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Product_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      eggCollectionDetails['Product_Id'] =
                                          e['Product_Id'];
                                      // unitId =
                                      //     e['Unit_Of_Measure__Unit_Name'];
                                      // salesJournal['Quantity_Unit'] =
                                      //     e['Unit_Of_Measure__Unit_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Product_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Select'),
                                onChanged: (value) {
                                  setState(() {
                                    productId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, itemValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Batch Code'),
                        ),
                        Container(
                          width: formWidth,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: batchId,
                                items: batchPlanDetails
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Batch_Plan_Code'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      eggCollectionDetails['Batch_Plan_Code'] =
                                          e['Batch_Plan_Code'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Batch_Plan_Code']),
                                  );
                                }).toList(),
                                hint: const Text('Select'),
                                onChanged: (value) {
                                  setState(() {
                                    batchId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  batchPlanValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, batchPlanValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Grade'),
                        ),
                        Container(
                          width: formWidth,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: eggGradingId,
                                items: eggGradingList
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Egg_Grade'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      eggCollectionDetails['Egg_Grade_Id'] =
                                          e['Egg_Grade_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Egg_Grade']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose Grade'),
                                onChanged: (value) {
                                  setState(() {
                                    eggGradingId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  gradeValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, gradeValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Quantity'),
                        ),
                        Container(
                          width: formWidth,
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
                                  hintText: 'Enter quantity',
                                  border: InputBorder.none),
                              controller: quantityController,
                              onSaved: (value) {
                                eggCollectionDetails['Quantity'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  quantityValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, quantityValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: formWidth,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text('Collection Date'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: size.width * 0.23,
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
                                  controller: collectionDateController,
                                  decoration: const InputDecoration(
                                      hintText: 'Choose collection date',
                                      border: InputBorder.none),
                                  enabled: false,
                                  // onSaved: (value) {
                                  //   batchPlanDetails[
                                  //       'Required_Date_Of_Delivery'] = value!;
                                  // },
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: _hatchDatePicker,
                                icon: Icon(
                                  Icons.date_range_outlined,
                                  color: ProjectColors.themecolor,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  collectionDateValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, collectionDateValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Average Weight (grams)'),
                        ),
                        Container(
                          width: formWidth,
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
                                  hintText: 'Enter average weight',
                                  border: InputBorder.none),
                              controller: averageWeightController,
                              onSaved: (value) {
                                eggCollectionDetails['Average_Weight'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  averageWeightValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, averageWeightValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Collection Status'),
                        ),
                        Container(
                          width: formWidth,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: collectionStatusId,
                                items: ['Pending', 'Complete']
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      eggCollectionDetails[
                                          'Collection_Status'] = e;
                                      //print(warehouseCategory);
                                    },
                                  );
                                }).toList(),
                                hint: const Text(
                                    'Please Choose Collection Status'),
                                onChanged: (value) {
                                  setState(() {
                                    collectionStatusId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  collectionStatusValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, collectionStatusValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Is Cleared'),
                        ),
                        Container(
                          width: formWidth,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: IsClearedSelected,
                                items: ['Yes', 'No']
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      eggCollectionDetails['Is_Cleared'] = e;
                                      //print(warehouseCategory);
                                    },
                                  );
                                }).toList(),
                                hint:
                                    const Text('Please Choose Cleared Status'),
                                onChanged: (value) {
                                  setState(() {
                                    IsClearedSelected = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IsClearedValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, IsClearedValidationMessage),

                  Consumer<InventoryAdjustemntApis>(
                      builder: (context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.inventoryAdjustemntExceptions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ModularWidgets.exceptionDesign(
                            MediaQuery.of(context).size,
                            value.inventoryAdjustemntExceptions[index][0]);
                      },
                    );
                  }),
                  widget.editData.isEmpty
                      ? ModularWidgets.globalAddDetailsDialog(size, save)
                      : ModularWidgets.globalUpdateDetailsDialog(size, save),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
