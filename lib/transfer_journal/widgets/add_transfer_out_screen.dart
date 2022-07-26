import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/transfer_journal/providers/transfer_journal_apis.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../inventory/providers/inventory_api.dart';
import '../../items/providers/items_apis.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../widgets/modular_widgets.dart';

class AddTransferOutScreen extends StatefulWidget {
  AddTransferOutScreen(
      {Key? key, required this.reFresh, required this.editData})
      : super(key: key);
  final ValueChanged<int> reFresh;
  final Map<String, dynamic> editData;

  @override
  State<AddTransferOutScreen> createState() => _AddTransferOutScreenState();
}

class _AddTransferOutScreenState extends State<AddTransferOutScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var activityId;

  var collectionStatusId;

  var IsClearedSelected;

  List batchPlanDetails = [];

  bool batchPlanValidation = true;

  String batchPlanValidationMessage = '';

  TextEditingController remarksController = TextEditingController();

  TextEditingController transferCodeController = TextEditingController();

  bool transferCodeValidation = true;

  String transferCodeValidationMessage = '';

  TextEditingController itemCategoryController = TextEditingController();

  bool itemCategoryNameValidation = true;
  bool itemSubCategoryNameValidation = true;

  String itemCategoryNameValidationMessage = '';
  String itemSubCategoryNameValidationMessage = '';

  TextEditingController statusController = TextEditingController();

  bool statusValidation = true;

  String statusValidationMessage = '';

  TextEditingController itemController = TextEditingController();

  bool itemValidation = true;

  String itemValidationMessage = '';

  var warehouseToCategoryId;

  bool warehouseToValidation = true;

  String warehouseToValidationMessage = '';

  TextEditingController receivedDateController = TextEditingController();

  bool receivedDateValidation = true;

  String receivedDateValidationMessage = '';

  bool collectionStatusValidation = true;

  String collectionStatusValidationMessage = '';

  var _shippedDate;

  var _receivedDate;

  var itemCategoryId;

  List itemSubCategoryDetails = [];

  var itemSubCategoryId;

  List productlist = [];

  var productId;

  bool plantIdValidation = true;

  String plantIdValidationMessage = '';

  var plantId;

  List plantList = [];

  bool firmIdValidation = true;

  String firmIdValidationMessage = '';

  var firmId;

  List firmsList = [];

  var toWareHouseId;

  var toPlantId;

  var toFirmId;

  bool unitValidation = true;

  String unitValidationMessage = '';

  var unitId;

  List unitDetails = [];

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  late AnimationController controller;
  late Animation<Offset> offset;

  var batchId;
  var wareHouseId;
  List wareHouseDetails = [];

  List itemCategoryDetails = [];

  TextEditingController dateController = TextEditingController();
  TextEditingController shippingDateController = TextEditingController();
  TextEditingController eggGradingCodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController cwQuantityController = TextEditingController();
  TextEditingController cwUnitController = TextEditingController();
  TextEditingController requiredQuantityController = TextEditingController();

  Map<String, dynamic> transferOut = {
    'Received_Date': '',
    'Shipped_Date': '',
  };

  bool eggGradingCodeValidation = true;
  bool requiredQuantityValidation = true;
  bool quantityValidation = true;
  bool cwQuantityValidation = true;
  bool wareHouseIdValidation = true;
  bool breedIdValidation = true;
  bool cwUnitValidation = true;
  bool remarksValidation = true;
  bool IsClearedValidation = true;
  bool vaccinationPlanIdValidation = true;
  bool requiredDateOfDeliveryValidation = true;
  bool shippingDateValidation = true;

  String requiredQuantityValidationMessage = '';
  String eggGradingCodeValidationMessage = '';
  String quantityValidationMessage = '';
  String cwQuantityValidationMessage = '';
  String wareHouseIdValidationMessage = '';
  String breedIdValidationMessage = '';
  String cwUnitValidationMessage = '';
  String remarksValidationMessage = '';
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

    if (transferCodeController.text == '') {
      transferCodeValidationMessage = 'Transfer code be Empty';
      transferCodeValidation = false;
    } else {
      transferCodeValidation = true;
    }
    if (itemCategoryId == null) {
      itemCategoryNameValidationMessage = 'Select item category';
      itemCategoryNameValidation = false;
    } else {
      itemCategoryNameValidation = true;
    }
    if (itemSubCategoryId == null) {
      itemSubCategoryNameValidationMessage = 'Select item sub category';
      itemSubCategoryNameValidation = false;
    } else {
      itemSubCategoryNameValidation = true;
    }

    // if (collectionStatusId == '') {
    //   statusValidationMessage = 'rate cannot be null';
    //   statusValidation = false;
    // } else {
    //   statusValidation = true;
    // }
    if (batchId == null) {
      batchPlanValidationMessage = 'Select batch code';
      batchPlanValidation = false;
    } else {
      batchPlanValidation = true;
    }
    // if (warehouseToCategoryId == null) {
    //   warehouseToValidationMessage = 'Select item category';
    //   warehouseToValidation = false;
    // } else {
    //   warehouseToValidation = true;
    // }
    if (productId == null) {
      itemValidationMessage = 'Select product';
      itemValidation = false;
    } else {
      itemValidation = true;
    }
    if (quantityController.text == '') {
      quantityValidationMessage = 'Quantity cannot be empty';
      quantityValidation = false;
    } else {
      quantityValidation = true;
    }
    // if (cwQuantityController.text == '') {
    //   cwQuantityValidationMessage = 'CW Quantity cannot be null';
    //   cwQuantityValidation = false;
    // } else {
    //   cwQuantityValidation = true;
    // }
    if (wareHouseId == null) {
      wareHouseIdValidationMessage = 'Select the warehouse';
      wareHouseIdValidation = false;
    } else {
      wareHouseIdValidation = true;
    }

    // if (cwUnitController.text == '') {
    //   cwUnitValidationMessage = 'CW unit cannot be null';
    //   cwUnitValidation = false;
    // } else {
    //   cwUnitValidation = true;
    // }
    if (remarksController.text == '') {
      remarksValidationMessage = 'Remarks cannot be empty';
      remarksValidation = false;
    } else {
      remarksValidation = true;
    }
    // if (IsClearedSelected == null) {
    //   IsClearedValidationMessage = 'Select is cleared';
    //   IsClearedValidation = false;
    // } else {
    //   IsClearedValidation = true;
    // }

    if (shippingDateController.text == '') {
      shippingDateValidationMessage = 'Select shipping date';
      shippingDateValidation = false;
    } else {
      shippingDateValidation = true;
    }

    if (itemValidation == true &&
        batchPlanValidation == true &&
        itemCategoryNameValidation == true &&
        transferCodeValidation == true &&
        quantityValidation == true &&
        wareHouseIdValidation == true &&
        remarksValidation == true &&
        shippingDateValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  void _datePicker(TextEditingController controller, int value) {
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
      controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      if (value == 1) {
        transferOut['Received_Date'] =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);
      } else {
        transferOut['Dispatch_Date'] =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);
      }

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
    clearTransferException(context);
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
      shippingDateController.text = widget.editData['Dispatch_Date'];
      transferOut['Shipped_Date'] = widget.editData['Dispatch_Date'];
      quantityController.text = widget.editData['Transfer_Quantity'].toString();
      transferOut['Transfer_Quantity'] = widget.editData['Transfer_Quantity'];
      firmId = widget.editData['From_Firm_Name'];
      getPlantList(widget.editData['From_Firm_Id']);
      plantId = widget.editData['From_Plant_Name'];
      getWarehouseDetails(widget.editData['From_Plant_Id']);
      wareHouseId = widget.editData['From_WareHouse_Name'];
      transferOut['WareHouse_Id_From'] = widget.editData['WareHouse_Id'];
      batchId = widget.editData['Batch_Plan_Code'];
      transferOut['Batch_Plan_Id'] = widget.editData['Batch_Plan_Id'];
      remarksController.text = widget.editData['Remarks'].toString();
      transferOut['Remarks'] = widget.editData['Remarks'];
      itemCategoryId = widget.editData['Product_Category_Name'];
      getProductSubCategory(widget.editData['Product_Category_Id']);
      itemSubCategoryId = widget.editData['Product_Sub_Category_Name'];
      getProductList(widget.editData['Product_Sub_Category_Id']);
      productId = widget.editData['Product_Name'];
      transferOut['Product'] = widget.editData['Product_Id'];
      transferCodeController.text = widget.editData['Transfer_Out_Code'];
      transferOut['Transfer_Out_Code'] = widget.editData['Transfer_Out_Code'];
      unitId = widget.editData['Unit_Name'];
      transferOut['Unit_Id'] = widget.editData['Unit_Id'];
      toFirmId = widget.editData['To_Firm_Name'];
      getPlantList(widget.editData['To_Firm_Id']);
      toPlantId = widget.editData['To_Plant_Name'];
      getWarehouseDetails(widget.editData['To_Plant_Id']);
      toWareHouseId = widget.editData['To_WareHouse_Name'];
      transferOut['WareHouse_Id_To'] = widget.editData['WareHouse_Id_To'];
    } else {
      transferCodeController.text = getRandom(4, 'T-');
    }

    getFirmList();

    Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      var platId = await fetchPlant();
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getWarehouseDetails(platId, token)
      //     .then((value1) {});
      Provider.of<InventoryApi>(context, listen: false).getBatch(token);
      Provider.of<Apicalls>(context, listen: false)
          .getStandardUnitValues(token);
      Provider.of<ItemApis>(context, listen: false)
          .getItemCategory(token)
          .then((value1) {});
    });

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
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

    if (widget.editData.isNotEmpty) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<TransferJournalApi>(context, listen: false)
            .updateTransferOutJournal(
                transferOut, widget.editData['Transfer_Out_Id'], token)
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
        Provider.of<TransferJournalApi>(context, listen: false)
            .addTransferOutJournal(transferOut, token)
            .then((value) {
          if (value == 200 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully added transfer out data');
          } else {
            failureSnackbar('Unable to add data something went wrong');
          }
        });
      });
    }
  }

  void getProductSubCategory(var id) {
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double formWidth = size.width * 0.25;
    unitDetails = Provider.of<Apicalls>(context).standardUnitList;
    wareHouseDetails = Provider.of<InfrastructureApis>(
      context,
    ).warehouseDetails;
    // print(wareHouseDetails);
    firmsList = Provider.of<InfrastructureApis>(context).firmDetails;
    plantList = Provider.of<InfrastructureApis>(context).plantDetails;
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
                        'Transfer Out',
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
                          'Add Transfer Out',
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
                          child: const Text('Transfer Code'),
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
                                  hintText: 'Enter transfer code',
                                  border: InputBorder.none),
                              controller: transferCodeController,
                              onSaved: (value) {
                                transferOut['Transfer_Out_Code'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  transferCodeValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, transferCodeValidationMessage),

                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Text(
                      'From',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                          child: const Text('Firm Name'),
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
                                value: firmId,
                                items: firmsList
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Firm_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      plantId = null;
                                      getPlantList(e['Firm_Id']);
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Firm_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Select'),
                                onChanged: (value) {
                                  setState(() {
                                    firmId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  firmIdValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, firmIdValidationMessage),
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
                                      // firmId = e['Firm_Code'];
                                      wareHouseId = null;
                                      getWarehouseDetails(e['Plant_Id']);
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Plant_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Select'),
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
                          child: const Text('Warehouse'),
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
                                      transferOut['WareHouse_Id_From'] =
                                          e['WareHouse_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['WareHouse_Code']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose wareHouse'),
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
                                      transferOut['Batch_Plan_Id'] =
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
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('To Warehouse'),
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
                  //               value: warehouseToCategoryId,
                  //               items: wareHouseDetails
                  //                   .map<DropdownMenuItem<String>>((e) {
                  //                 return DropdownMenuItem(
                  //                   child: Text(e['WareHouse_Code']),
                  //                   value: e['WareHouse_Code'],
                  //                   onTap: () {
                  //                     // firmId = e['Firm_Code'];
                  //                     transferOut['To_Warehouse_Id'] =
                  //                         e['WareHouse_Id'];
                  //                     //print(warehouseCategory);
                  //                   },
                  //                 );
                  //               }).toList(),
                  //               hint: const Text('Please Choose to  wareHouse'),
                  //               onChanged: (value) {
                  //                 setState(() {
                  //                   warehouseToCategoryId = value as String;
                  //                 });
                  //               },
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // warehouseToValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, warehouseToValidationMessage),

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
                                onPressed: () =>
                                    _datePicker(shippingDateController, 2),
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
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Container(
                  //             width: formWidth,
                  //             padding: const EdgeInsets.only(bottom: 12),
                  //             child: const Text('Received Date'),
                  //           ),
                  //         ],
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Container(
                  //             width: size.width * 0.23,
                  //             height: 36,
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(8),
                  //               color: Colors.white,
                  //               border: Border.all(color: Colors.black26),
                  //             ),
                  //             child: Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 12, vertical: 6),
                  //               child: TextFormField(
                  //                 controller: receivedDateController,
                  //                 decoration: const InputDecoration(
                  //                     hintText: 'Choose Received date',
                  //                     border: InputBorder.none),
                  //                 enabled: false,
                  //                 // onSaved: (value) {
                  //                 //   batchPlanDetails[
                  //                 //       'Required_Date_Of_Delivery'] = value!;
                  //                 // },
                  //               ),
                  //             ),
                  //           ),
                  //           IconButton(
                  //               onPressed: () =>
                  //                   _datePicker(receivedDateController, 1),
                  //               icon: Icon(
                  //                 Icons.date_range_outlined,
                  //                 color: ProjectColors.themecolor,
                  //               ))
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // receivedDateValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, receivedDateValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Item Category'),
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
                                      getProductSubCategory(
                                          e['Product_Category_Id']);
                                    },
                                    child: Text(e['Product_Category_Name']),
                                  );
                                }).toList(),
                                hint: const Text(
                                    'Please choose product category'),
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
                  itemCategoryNameValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, itemCategoryNameValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Item sub Category'),
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
                                    value: e['Product_Sub_Category_Name'],
                                    onTap: () {
                                      getProductList(
                                          e['Product_Sub_Category_Id']);
                                    },
                                    child: Text(e['Product_Sub_Category_Name']),
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
                                    value: e['Product_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      transferOut['Product'] = e['Product_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Product_Name']),
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
                          child: const Text('Transfer Quantity'),
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
                                  hintText: 'Enter transfer quantity',
                                  border: InputBorder.none),
                              controller: quantityController,
                              onSaved: (value) {
                                transferOut['Transfer_Quantity'] = value!;
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
                          child: const Text('Unit'),
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
                                value: unitId,
                                items: unitDetails
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Unit_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      transferOut['Unit_Id'] = e['Unit_Id'];

                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Unit_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Select'),
                                onChanged: (value) {
                                  setState(() {
                                    unitId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  unitValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, unitValidationMessage),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('CW Quantity'),
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
                  //                 hintText: 'Enter cw quantity',
                  //                 border: InputBorder.none),
                  //             controller: cwQuantityController,
                  //             onSaved: (value) {
                  //               transferOut['CW_Quantity'] = value!;
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // cwQuantityValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, cwQuantityValidationMessage),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('CW Unit'),
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
                  //                 hintText: 'Enter cw unit',
                  //                 border: InputBorder.none),
                  //             controller: cwUnitController,
                  //             onSaved: (value) {
                  //               transferOut['CW_Unit'] = value!;
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // cwUnitValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, cwUnitValidationMessage),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('Status'),
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
                  //               value: collectionStatusId,
                  //               items: ['Pending', 'Complete']
                  //                   .map<DropdownMenuItem<String>>((e) {
                  //                 return DropdownMenuItem(
                  //                   child: Text(e),
                  //                   value: e,
                  //                   onTap: () {
                  //                     // firmId = e['Firm_Code'];
                  //                     transferOut['Status'] = e;
                  //                     //print(warehouseCategory);
                  //                   },
                  //                 );
                  //               }).toList(),
                  //               hint:
                  //                   const Text('Please Choose Transfer Status'),
                  //               onChanged: (value) {
                  //                 setState(() {
                  //                   collectionStatusId = value as String;
                  //                 });
                  //               },
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // statusValidation == true
                  //     ? const SizedBox()
                  //     : ModularWidgets.validationDesign(
                  //         size, statusValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Remarks'),
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
                                  hintText: 'Enter Remarks',
                                  border: InputBorder.none),
                              controller: remarksController,
                              onSaved: (value) {
                                transferOut['Remarks'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  remarksValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, remarksValidationMessage),

                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Text(
                      'To',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                          child: const Text('Firm Name'),
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
                                value: toFirmId,
                                items: firmsList
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Firm_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      toPlantId = null;
                                      getPlantList(e['Firm_Id']);
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Firm_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Select'),
                                onChanged: (value) {
                                  setState(() {
                                    toFirmId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  firmIdValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, firmIdValidationMessage),
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
                                value: toPlantId,
                                items: plantList
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Plant_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      toWareHouseId = null;
                                      getWarehouseDetails(e['Plant_Id']);
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Plant_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Select'),
                                onChanged: (value) {
                                  setState(() {
                                    toPlantId = value as String;
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
                          child: const Text('Warehouse'),
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
                                value: toWareHouseId,
                                items: wareHouseDetails
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['WareHouse_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      transferOut['WareHouse_Id_To'] =
                                          e['WareHouse_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['WareHouse_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose Warehouse'),
                                onChanged: (value) {
                                  setState(() {
                                    toWareHouseId = value as String;
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
                  Consumer<TransferJournalApi>(
                      builder: (context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.transferException.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ModularWidgets.exceptionDesign(
                            MediaQuery.of(context).size,
                            value.transferException[index]);
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
