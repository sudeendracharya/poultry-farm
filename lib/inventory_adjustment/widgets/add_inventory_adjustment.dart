import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../inventory/providers/inventory_api.dart';
import '../../items/providers/items_apis.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../sales_journal/providers/journal_api.dart';
import '../../widgets/modular_widgets.dart';

class AddInventoryAdjustmentJournal extends StatefulWidget {
  AddInventoryAdjustmentJournal(
      {Key? key, required this.reFresh, required this.editData})
      : super(key: key);
  final ValueChanged<int> reFresh;
  final Map<String, dynamic> editData;

  @override
  State<AddInventoryAdjustmentJournal> createState() =>
      _AddInventoryAdjustmentJournalState();
}

class _AddInventoryAdjustmentJournalState
    extends State<AddInventoryAdjustmentJournal>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var activityId;

  var collectionStatusId;

  var IsClearedSelected;

  List batchPlanDetails = [];

  bool batchPlanValidation = true;

  String batchPlanValidationMessage = '';

  TextEditingController unitController = TextEditingController();

  TextEditingController inventoryAdjustmentCodeController =
      TextEditingController();

  bool adjustmentNumberValidation = true;

  String adjustmentNumberValidationMessage = '';

  TextEditingController customerNameController = TextEditingController();

  bool customerNameValidation = true;

  String customerNameValidationMessage = '';

  TextEditingController rateController = TextEditingController();

  bool rateValidation = true;

  String rateValidationMessage = '';

  TextEditingController itemController = TextEditingController();

  bool itemValidation = true;

  String itemValidationMessage = '';

  var itemCategoryId;

  bool itemCategoryValidation = true;

  String itemCategoryValidationMessage = '';

  List firmsList = [];

  List plantList = [];
  var firmId;
  var plantId;

  String firmIdValidationMessage = '';

  bool firmIdValidation = true;

  bool plantIdValidation = true;

  String plantIdValidationMessage = '';

  List itemSubCategory = [];
  var itemSubCategoryId;

  List productList = [];
  var productId;

  String itemSubCategoryValidationMessage = '';

  bool itemSubCategoryValidation = true;

  bool productValidation = true;

  String productValidationMessage = '';

  var unitId;

  List unitDetails = [];

  var cwUnitId;

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
  List itemCategoryDetails = [];

  TextEditingController dateController = TextEditingController();
  TextEditingController shippingDateController = TextEditingController();
  TextEditingController eggGradingCodeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cwQuantityController = TextEditingController();
  TextEditingController cwUnitController = TextEditingController();
  TextEditingController requiredQuantityController = TextEditingController();

  Map<String, dynamic> inventoryAdjustment = {};

  bool eggGradingCodeValidation = true;
  bool requiredQuantityValidation = true;
  bool descriptionValidation = true;
  bool cwQuantityValidation = true;
  bool wareHouseIdValidation = true;
  bool breedIdValidation = true;
  bool cwUnitValidation = true;
  bool unitValidation = true;
  bool IsClearedValidation = true;
  bool vaccinationPlanIdValidation = true;
  bool requiredDateOfDeliveryValidation = true;
  bool shippingDateValidation = true;

  String requiredQuantityValidationMessage = '';
  String eggGradingCodeValidationMessage = '';
  String descriptionValidationMessage = '';
  String cwQuantityValidationMessage = '';
  String wareHouseIdValidationMessage = '';
  String breedIdValidationMessage = '';
  String cwUnitValidationMessage = '';
  String unitValidationMessage = '';
  String IsClearedValidationMessage = '';
  String vaccinationPlanIdValidationMessage = '';
  String shippingDateValidationMessage = '';

  String requiredDateOfDeliveryValidationMessage = '';

  bool validate() {
    // if (eggGradingCodeController.text == '') {
    //   eggGradingCodeValidationMessage = 'Grading code cannot be empty';
    //   eggGradingCodeValidation = false;
    // } else {
    //   eggGradingCodeValidation = true;
    // }
    // // if (requiredQuantityController.text == '') {
    //   requiredQuantityValidationMessage = 'Required quantity cannot be empty';
    //   requiredQuantityValidation = false;
    // } else {
    //   requiredQuantityValidation = true;
    // }

    if (inventoryAdjustmentCodeController.text == '') {
      adjustmentNumberValidationMessage = 'Adjustment code cannot be null';
      adjustmentNumberValidation = false;
    } else {
      adjustmentNumberValidation = true;
    }
    // if (customerNameController.text == '') {
    //   customerNameValidationMessage = 'Customer name cannot be null';
    //   customerNameValidation = false;
    // } else {
    //   customerNameValidation = true;
    // }

    // if (rateController.text == '') {
    //   rateValidationMessage = 'rate cannot be null';
    //   rateValidation = false;
    // } else {
    //   rateValidation = true;
    // }
    if (batchId == null) {
      batchPlanValidationMessage = 'Select batch code';
      batchPlanValidation = false;
    } else {
      batchPlanValidation = true;
    }
    if (itemCategoryId == null) {
      itemCategoryValidationMessage = 'Select Product category';
      itemCategoryValidation = false;
    } else {
      itemCategoryValidation = true;
    }
    if (productId == null) {
      itemValidationMessage = 'Select product';
      itemValidation = false;
    } else {
      itemValidation = true;
    }
    if (descriptionController.text.length > 30) {
      descriptionValidationMessage =
          'Description cannot be greater then 30 characters';
      descriptionValidation = false;
    } else if (descriptionController.text == '') {
      descriptionValidationMessage = 'Description cannot be empty';
      descriptionValidation = false;
    } else {
      descriptionValidation = true;
    }
    if (cwQuantityController.text.isNum != true) {
      cwQuantityValidationMessage = 'Enter a valid CW Quantity';
      cwQuantityValidation = false;
    } else if (cwQuantityController.text.length > 6) {
      cwQuantityValidationMessage =
          'CW Quantity cannot be greater then 6 characters';
      cwQuantityValidation = false;
    } else if (cwQuantityController.text == '') {
      cwQuantityValidationMessage = 'CW Quantity cannot be null';
      cwQuantityValidation = false;
    } else {
      cwQuantityValidation = true;
    }
    if (wareHouseId == null) {
      wareHouseIdValidationMessage = 'Select the warehouse';
      wareHouseIdValidation = false;
    } else {
      wareHouseIdValidation = true;
    }

    if (cwUnitId == null) {
      cwUnitValidationMessage = 'Select CW unit';
      cwUnitValidation = false;
    } else {
      cwUnitValidation = true;
    }
    // if (unitId == null) {
    //   unitValidationMessage = 'Unit cannot be null';
    //   unitValidation = false;
    // } else {
    //   unitValidation = true;
    // }
    // if (IsClearedSelected == null) {
    //   IsClearedValidationMessage = 'Select is cleared';
    //   IsClearedValidation = false;
    // } else {
    //   IsClearedValidation = true;
    // }

    if (shippingDateController.text == '') {
      shippingDateValidationMessage = 'Select date';
      shippingDateValidation = false;
    } else {
      shippingDateValidation = true;
    }

    if (itemValidation == true &&
        itemCategoryValidation == true &&
        batchPlanValidation == true &&
        rateValidation == true &&
        customerNameValidation == true &&
        adjustmentNumberValidation == true &&
        eggGradingCodeValidation == true &&
        cwQuantityValidation == true &&
        wareHouseIdValidation == true &&
        cwUnitValidation == true &&
        shippingDateValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getFirmList() async {
    await Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      await Provider.of<InfrastructureApis>(context, listen: false)
          .getFirmDetails(token)
          .then((value1) {});
    });
  }

  Future<void> getPlantList(var id) async {
    await Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      await Provider.of<InfrastructureApis>(context, listen: false)
          .getPlantDetails(token, id)
          .then((value1) {
        // setState(() {
        //   firmSelected = true;
        //   selectedFirmName = e['Firm_Name'];
        //   selectedFirmId = e['Firm_Id'];
        // });
      });
    });
  }

  Future<void> getWarehouseDetails(var id) async {
    await Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseDetails(id, token)
          .then((value1) {});
    });
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
      shippingDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      inventoryAdjustment['Date'] = DateFormat("yyyy-MM-dd").format(pickedDate);

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
    clearSalesException(context);

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
      inventoryAdjustmentCodeController.text =
          widget.editData['Inventory_Adjustment_Code'];
      inventoryAdjustment['Inventory_Adjustment_Code'] =
          widget.editData['Inventory_Adjustment_Code'];
      wareHouseId = widget.editData['WareHouse_Id__WareHouse_Code'];
      inventoryAdjustment['WareHouse_Id'] = widget.editData['WareHouse_Id'];
      batchId = widget.editData['Batch_Plan_Id__Batch_Plan_Code'];
      inventoryAdjustment['Batch_Plan_Id'] = widget.editData['Batch_Plan_Id'];
      shippingDateController.text = widget.editData['Date'];
      inventoryAdjustment['Date'] = widget.editData['Date'];

      cwQuantityController.text = widget.editData['CW_Quantity'].toString();
      inventoryAdjustment['CW_Quantity'] = widget.editData['CW_Quantity'];
      cwUnitId = widget.editData['CW_Unit__Unit_Name'];
      inventoryAdjustment['CW_Unit'] = widget.editData['CW_Unit'];
      descriptionController.text = widget.editData['Description'];
      itemCategoryId = widget
          .editData['Product_Id__Product_Category_Id__Product_Category_Name'];
      inventoryAdjustment['Product_Category_Id'] =
          widget.editData['Product_Id__Product_Category_Id'];
      getItemSubCategory(widget.editData['Product_Id__Product_Category_Id']);
      itemSubCategoryId = widget.editData[
          'Product_Id__Product_Sub_Category_Id__Product_Sub_Category_Name'];
      inventoryAdjustment['Item_Sub_Category'] =
          widget.editData['Product_Id__Product_Sub_Category_Id'];
      getProducts(widget.editData['Product_Id__Product_Sub_Category_Id']);
      inventoryAdjustment['Product_Id'] = widget.editData['Product_Id'];
      productId = widget.editData['Product_Id__Product_Name'];
    } else {
      inventoryAdjustmentCodeController.text = getRandom(4, 'IA-');
    }

    Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      var firmId = await getFirmData();
      if (firmId != '') {
        fechplantList(firmId, context);
      }

      Provider.of<InventoryApi>(context, listen: false).getBatch(token);

      Provider.of<ItemApis>(context, listen: false)
          .getItemCategory(token)
          .then((value1) {});
      Provider.of<Apicalls>(context, listen: false)
          .getStandardUnitValues(token);
    });

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
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

  void getProducts(var subCategoryId) {
    fetchCredientials().then((token) {
      Provider.of<ItemApis>(context, listen: false)
          .getproductlist(token, subCategoryId);
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
    print(inventoryAdjustment.toString());

    if (widget.editData.isNotEmpty) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<JournalApi>(context, listen: false)
            .updateInventoryAdjustmentJournalInfo(
                widget.editData['Inventory_Adjustment_Id'],
                inventoryAdjustment,
                token)
            .then((value) {
          if (value == 202 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully updated sales data');
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
        Provider.of<JournalApi>(context, listen: false)
            .addInventoryAdjustmentJournalInfo(inventoryAdjustment, token)
            .then((value) {
          if (value == 200 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully added sales data');
          } else {
            failureSnackbar('Unable to add data something went wrong');
          }
        });
      });
    }
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
    firmsList = Provider.of<InfrastructureApis>(context).firmDetails;
    plantList = Provider.of<InfrastructureApis>(context).plantDetails;
    itemSubCategory = Provider.of<ItemApis>(context).itemSubCategory;
    productList = Provider.of<ItemApis>(context).productList;
    unitDetails = Provider.of<Apicalls>(context).standardUnitList;
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
                        'Inventory Adjustment Journal',
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontWeight: FontWeight.w700,
                          fontSize: size.width * 0.02,
                        )),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 36.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'Add Inventory Adjustment Journal',
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
                          child: const Text('Adjustment Number'),
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
                                  hintText: 'Enter adjustment number',
                                  border: InputBorder.none),
                              controller: inventoryAdjustmentCodeController,
                              onSaved: (value) {
                                inventoryAdjustment[
                                    'Inventory_Adjustment_Code'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  adjustmentNumberValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, adjustmentNumberValidationMessage),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('Customer Name'),
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
                  //               hintText: 'Enter Customer name',
                  //               border: InputBorder.none,
                  //             ),
                  //             controller: customerNameController,
                  //             onSaved: (value) {
                  //               salesJournal['Customer_Name'] = value!;
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // customerNameValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, customerNameValidationMessage),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('Rate'),
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
                  //                 hintText: 'Enter rate',
                  //                 border: InputBorder.none),
                  //             controller: rateController,
                  //             onSaved: (value) {
                  //               salesJournal['Rate'] = value!;
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // rateValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, rateValidationMessage),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('Firm Name'),
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
                  //           child: DropdownButtonHideUnderline(
                  //             child: DropdownButton(
                  //               value: firmId,
                  //               items: firmsList
                  //                   .map<DropdownMenuItem<String>>((e) {
                  //                 return DropdownMenuItem(
                  //                   value: e['Firm_Name'],
                  //                   onTap: () {
                  //                     // firmId = e['Firm_Code'];
                  //                     getPlantList(e['Firm_Id']);
                  //                     //print(warehouseCategory);
                  //                   },
                  //                   child: Text(e['Firm_Name']),
                  //                 );
                  //               }).toList(),
                  //               hint: const Text('Please Choose Firm Name'),
                  //               onChanged: (value) {
                  //                 setState(() {
                  //                   firmId = value as String;
                  //                 });
                  //               },
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // firmIdValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, firmIdValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Plant Name'),
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
                                value: plantId,
                                items: plantList
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Plant_Name'],
                                    onTap: () {
                                      getWarehouseDetails(e['Plant_Id']);
                                    },
                                    child: Text(e['Plant_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose Plant Name'),
                                onChanged: (value) {
                                  setState(() {
                                    plantId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  plantIdValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, plantIdValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Ware house Code'),
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
                                    value: e['WareHouse_Code'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      inventoryAdjustment['WareHouse_Id'] =
                                          e['WareHouse_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['WareHouse_Code']),
                                  );
                                }).toList(),
                                hint:
                                    const Text('Please Choose wareHouse code'),
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
                  //         child: const Text('Batch Code'),
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
                  //           child: DropdownButtonHideUnderline(
                  //             child: DropdownButton(
                  //               value: batchId,
                  //               items: batchPlanDetails
                  //                   .map<DropdownMenuItem<String>>((e) {
                  //                 return DropdownMenuItem(
                  //                   child: Text(e['Batch_Code']),
                  //                   value: e['Batch_Code'],
                  //                   onTap: () {
                  //                     // firmId = e['Firm_Code'];
                  //                     salesJournal['Batch_Id'] = e['Batch_Id'];
                  //                     //print(warehouseCategory);
                  //                   },
                  //                 );
                  //               }).toList(),
                  //               hint: const Text('Please choose batch code'),
                  //               onChanged: (value) {
                  //                 setState(() {
                  //                   batchId = value as String;
                  //                 });
                  //               },
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // batchPlanValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, batchPlanValidationMessage),
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
                                      inventoryAdjustment['Batch_Plan_Id'] =
                                          e['Batch_Plan_Id'];
                                      // firmId = e['Firm_Code'];
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
                              child: const Text('Shipped Date'),
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
                                  controller: shippingDateController,
                                  decoration: const InputDecoration(
                                      hintText: 'Choose Shipped date',
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
                  shippingDateValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, shippingDateValidationMessage),
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
                                value: itemCategoryId,
                                items: itemCategoryDetails
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Product_Category_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      inventoryAdjustment[
                                              'Product_Category_Id'] =
                                          e['Product_Category_Id'];

                                      getItemSubCategory(
                                          e['Product_Category_Id']);
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Product_Category_Name']),
                                  );
                                }).toList(),
                                hint: const Text(
                                    'Please Choose Product Category'),
                                onChanged: (value) {
                                  setState(() {
                                    itemCategoryId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemCategoryValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, itemCategoryValidationMessage),
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
                                items: itemSubCategory
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Product_Sub_Category_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      inventoryAdjustment['Item_Sub_Category'] =
                                          e['Product_Sub_Category_Id'];

                                      getProducts(e['Product_Sub_Category_Id']);
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Product_Sub_Category_Name']),
                                  );
                                }).toList(),
                                hint: const Text(
                                    'Please Choose Product Sub Category'),
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
                                      inventoryAdjustment['Product_Id'] =
                                          e['Product_Id'];

                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Product_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose product'),
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
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('Quantity'),
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
                  //                 hintText: 'Enter Quantity',
                  //                 border: InputBorder.none),
                  //             controller: quantityController,
                  //             onSaved: (value) {
                  //               salesJournal['Quantity'] = value!;
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // quantityValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, quantityValidationMessage),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('Unit'),
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
                  //           child: DropdownButtonHideUnderline(
                  //             child: DropdownButton(
                  //               value: unitId,
                  //               items: unitDetails
                  //                   .map<DropdownMenuItem<String>>((e) {
                  //                 return DropdownMenuItem(
                  //                   child: Text(e['Unit_Name']),
                  //                   value: e['Unit_Name'],
                  //                   onTap: () {
                  //                     // firmId = e['Firm_Code'];
                  //                     salesJournal['Quantity_Unit'] =
                  //                         e['Unit_Id'];

                  //                     //print(warehouseCategory);
                  //                   },
                  //                 );
                  //               }).toList(),
                  //               hint: const Text('Please Choose Unit'),
                  //               onChanged: (value) {
                  //                 setState(() {
                  //                   unitId = value as String;
                  //                 });
                  //               },
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // unitValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, unitValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('CW Quantity'),
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
                                  hintText: 'Enter cw quantity',
                                  border: InputBorder.none),
                              controller: cwQuantityController,
                              onSaved: (value) {
                                inventoryAdjustment['CW_Quantity'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  cwQuantityValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, cwQuantityValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('CW Unit'),
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
                                value: cwUnitId,
                                items: unitDetails
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Unit_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      inventoryAdjustment['CW_Unit'] =
                                          e['Unit_Id'];

                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Unit_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose Unit'),
                                onChanged: (value) {
                                  setState(() {
                                    cwUnitId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  cwUnitValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, cwUnitValidationMessage),
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
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: TextFormField(
                              maxLines: 5,
                              decoration: const InputDecoration(
                                  hintText: 'Enter Description',
                                  border: InputBorder.none),
                              controller: descriptionController,
                              onSaved: (value) {
                                inventoryAdjustment['Description'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  descriptionValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, descriptionValidationMessage),
                  Consumer<JournalApi>(builder: (context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.salesException.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ModularWidgets.exceptionDesign(
                            MediaQuery.of(context).size,
                            value.salesException[index]);
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
