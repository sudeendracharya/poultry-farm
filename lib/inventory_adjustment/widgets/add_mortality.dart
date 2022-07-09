import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../batch_plan/providers/batch_plan_apis.dart';
import '../../colors.dart';
import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../inventory/providers/inventory_api.dart';
import '../../items/providers/items_apis.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/inventory_adjustement_apis.dart';

class AddMortality extends StatefulWidget {
  AddMortality({Key? key, required this.reFresh, required this.editData})
      : super(key: key);
  final ValueChanged<int> reFresh;
  final Map<String, dynamic> editData;

  static const routeName = '/AddMortality';
  @override
  State<AddMortality> createState() => _AddMortalityState();
}

class _AddMortalityState extends State<AddMortality>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var activityId;

  var collectionStatusId;

  var IsClearedSelected;

  List batchPlanDetails = [];

  bool batchPlanValidation = true;

  String batchPlanValidationMessage = '';

  TextEditingController unitController = TextEditingController();

  TextEditingController recordCodeController = TextEditingController();

  List itemCategoryDetails = [];

  var wareHouseCategoryId;

  bool wareHouseCategoryValidation = true;

  var wareHouseCategoryValidationMessage = '';

  bool itemValidation = true;

  String itemValidationMessage = '';

  TextEditingController itemController = TextEditingController();

  bool itemSubCategoryNameValidation = true;

  String itemSubCategoryNameValidationMessage = '';

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

  List itemSubCategoryDetails = [];

  var itemSubCategoryId;

  List productlist = [];

  var productId;

  TextEditingController dateController = TextEditingController();
  TextEditingController gradingDateController = TextEditingController();
  TextEditingController eggGradingCodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController gradeFromController = TextEditingController();
  TextEditingController gradeToController = TextEditingController();
  TextEditingController requiredQuantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Map<String, dynamic> mortalityDetails = {
    'Batch_Id': '',
    'Date': '',
    'WareHouse_Id': '',
    'Record_Code': '',
    'Quantity': '',
    'Description': '',
    'Item': '',
    'Item_Category': '',
  };

  bool recordCodeValidation = true;
  bool requiredQuantityValidation = true;
  bool quantityValidation = true;
  bool gradeFromValidation = true;
  bool wareHouseIdValidation = true;
  bool breedIdValidation = true;
  bool gradeToValidation = true;
  bool unitValidation = true;
  bool IsClearedValidation = true;
  bool vaccinationPlanIdValidation = true;
  bool requiredDateOfDeliveryValidation = true;
  bool gradingDateValidation = true;

  String requiredQuantityValidationMessage = '';
  String recordCodeValidationMessage = '';
  String quantityValidationMessage = '';
  String gradeFromValidationMessage = '';
  String wareHouseIdValidationMessage = '';
  String breedIdValidationMessage = '';
  String gradeToValidationMessage = '';
  String unitValidationMessage = '';
  String IsClearedValidationMessage = '';
  String vaccinationPlanIdValidationMessage = '';
  String gradingDateValidationMessage = '';

  String requiredDateOfDeliveryValidationMessage = '';

  bool validate() {
    if (recordCodeController.text == '') {
      recordCodeValidationMessage = 'Record code cannot be empty';
      recordCodeValidation = false;
    } else {
      recordCodeValidation = true;
    }

    // if (productId == null) {
    //   itemValidationMessage = 'Item Name cannot be empty';
    //   itemValidation = false;
    // } else {
    //   itemValidation = true;
    // }
    // // if (requiredQuantityController.text == '') {
    //   requiredQuantityValidationMessage = 'Required quantity cannot be empty';
    //   requiredQuantityValidation = false;
    // } else {
    //   requiredQuantityValidation = true;
    // }
    if (quantityController.text.isNum != true) {
      quantityValidationMessage = 'Enter a valid quantity';
      quantityValidation = false;
    } else if (quantityController.text.length > 6) {
      quantityValidationMessage =
          'Quantity cannot be greater then 6 characters';
      quantityValidation = false;
    } else if (quantityController.text == '') {
      quantityValidationMessage = 'Quantity cannot be Empty';
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

    if (batchId == null) {
      batchPlanValidationMessage = 'Select batch plan';
      batchPlanValidation = false;
    } else {
      batchPlanValidation = true;
    }

    // if (wareHouseCategoryId == null) {
    //   wareHouseCategoryValidationMessage = 'Select Item category';
    //   wareHouseCategoryValidation = false;
    // } else {
    //   wareHouseCategoryValidation = true;
    // }

    // if (IsClearedSelected == null) {
    //   IsClearedValidationMessage = 'Select is cleared';
    //   IsClearedValidation = false;
    // } else {
    //   IsClearedValidation = true;
    // }

    if (gradingDateController.text == '') {
      gradingDateValidationMessage = 'Select date';
      gradingDateValidation = false;
    } else {
      gradingDateValidation = true;
    }

    if (recordCodeValidation == true &&
        // itemValidation == true &&
        quantityValidation == true &&
        wareHouseIdValidation == true &&
        // wareHouseCategoryValidation == true &&
        gradingDateValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  void _datePicker() {
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
      gradingDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      mortalityDetails['Date'] =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);

      setState(() {});
    });
  }

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
    if (widget.editData.isNotEmpty) {
      gradingDateController.text = widget.editData['Date'];
      mortalityDetails['Date'] = widget.editData['Date'];
      quantityController.text = widget.editData['Quantity'].toString();
      mortalityDetails['Quantity'] = widget.editData['Quantity'];
      recordCodeController.text = widget.editData['Record_Code'].toString();
      mortalityDetails['Record_Code'] = widget.editData['Record_Code'];
      itemController.text = widget.editData['Item'];
      mortalityDetails['Item'] = widget.editData['Item'];
      descriptionController.text = widget.editData['Description'].toString();
      mortalityDetails['Description'] = widget.editData['Description'];
    } else {
      recordCodeController.text = getRandom(4, 'MORT-');
    }

    Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      var plantId = await fetchPlant();
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseDetails(plantId, token)
          .then((value1) {});
      Provider.of<InventoryApi>(context, listen: false).getBatch(token);
      Provider.of<ItemApis>(context, listen: false)
          .getItemCategory(token)
          .then((value1) {});
    });
  }

  var isValid = true;

  void save() {
    isValid = validate();
    if (!isValid) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    print(mortalityDetails);

    if (widget.editData.isNotEmpty) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .updateMortality(
                mortalityDetails, widget.editData['Record_Id'], token)
            .then((value) {
          if (value == 202 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully updated Mortality');
          } else {
            failureSnackbar('Unable to update data something went wrong');
          }
        });
      });
    } else {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .addMortality(mortalityDetails, token)
            .then((value) {
          if (value == 200 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully added Mortality');
          } else {
            failureSnackbar('Unable to add data something went wrong');
          }
        });
      });
    }
  }

  void getProductSubCategory(var id) {
    print(id);
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getItemSubCategory(token, id)
          .then((value1) {});
    });
  }

  void getProductList(var id) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getproductlist(token, id)
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

    batchPlanDetails = Provider.of<InventoryApi>(context).batchDetails;
    itemCategoryDetails = Provider.of<ItemApis>(context).itemcategory;

    itemSubCategoryDetails = Provider.of<ItemApis>(context).itemSubCategory;
    productlist = Provider.of<ItemApis>(context).productList;

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
                        'Mortality',
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
                      children: [
                        widget.editData.isEmpty
                            ? const Text(
                                'Add Mortality',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              )
                            : const Text(
                                'Update Mortality',
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
                              controller: recordCodeController,
                              onSaved: (value) {
                                mortalityDetails['Record_Code'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  recordCodeValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, recordCodeValidationMessage),
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
                                      mortalityDetails['Batch_Id'] =
                                          e['Batch_Plan_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Batch_Plan_Code']),
                                  );
                                }).toList(),
                                hint: const Text('Please choose batch code'),
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
                        Row(
                          children: [
                            Container(
                              width: formWidth,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text('Date'),
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
                                  controller: gradingDateController,
                                  decoration: const InputDecoration(
                                      hintText: 'Choose date',
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
                                onPressed: _datePicker,
                                icon: Icon(
                                  Icons.date_range_outlined,
                                  color: ProjectColors.themecolor,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  gradingDateValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, gradingDateValidationMessage),
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
                                    child: Text(e['WareHouse_Code']),
                                    value: e['WareHouse_Code'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      mortalityDetails['WareHouse_Id'] =
                                          e['WareHouse_Id'];
                                      //print(warehouseCategory);
                                    },
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
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('Item'),
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
                  //                 hintText: 'Enter item',
                  //                 border: InputBorder.none),
                  //             controller: itemController,
                  //             onSaved: (value) {
                  //               mortalityDetails['Product_Id'] = value!;
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // itemValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, itemValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Product Category'),
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
                                value: wareHouseCategoryId,
                                items: itemCategoryDetails
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    child: Text(e['Product_Category_Name']),
                                    value: e['Product_Category_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      mortalityDetails['Product_Category_Id'] =
                                          e['Product_Category_Id'];
                                      getProductSubCategory(
                                          e['Product_Category_Id']);
                                      //print(warehouseCategory);
                                    },
                                  );
                                }).toList(),
                                hint: const Text('Please choose item category'),
                                onChanged: (value) {
                                  setState(() {
                                    wareHouseCategoryId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  wareHouseCategoryValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, wareHouseCategoryValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Product Sub Category'),
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
                                items: itemSubCategoryDetails
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    child: Text(e['Product_Sub_Category_Name']),
                                    value: e['Product_Sub_Category_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      getProductList(
                                          e['Product_Sub_Category_Id']);
                                      //print(warehouseCategory);
                                    },
                                  );
                                }).toList(),
                                hint: const Text(
                                    'Please choose product sub category'),
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
                  itemSubCategoryNameValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, itemSubCategoryNameValidationMessage),

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
                                items: productlist
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    child: Text(e['Product_Name']),
                                    value: e['Product_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      mortalityDetails['Product_Id'] =
                                          e['Product_Id'];
                                      //print(warehouseCategory);
                                    },
                                  );
                                }).toList(),
                                hint: const Text('Please choose product'),
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
                                  hintText: 'Enter Quantity',
                                  border: InputBorder.none),
                              controller: quantityController,
                              onSaved: (value) {
                                mortalityDetails['Quantity'] = value!;
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
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Description'),
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
                                  hintText: 'Enter description',
                                  border: InputBorder.none),
                              controller: descriptionController,
                              onSaved: (value) {
                                mortalityDetails['Description'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
