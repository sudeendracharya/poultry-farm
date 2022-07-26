import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../items/providers/items_apis.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../transfer_journal/providers/transfer_journal_apis.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/inventory_api.dart';

class AddDailyBatch extends StatefulWidget {
  AddDailyBatch({Key? key, required this.reFresh, required this.editData})
      : super(key: key);
  final ValueChanged<int> reFresh;
  final Map<String, dynamic> editData;

  @override
  State<AddDailyBatch> createState() => _AddDailyBatchState();
}

class _AddDailyBatchState extends State<AddDailyBatch>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var activityId;

  var collectionStatusId;

  var IsClearedSelected;

  List batchPlanDetails = [];

  bool batchPlanValidation = true;

  String batchPlanValidationMessage = '';

  TextEditingController weightUnitController = TextEditingController();

  TextEditingController totalFeedConsumptionController =
      TextEditingController();

  bool totalFeedConsumptionCodeValidation = true;

  String totalFeedConsumptionValidationMessage = '';

  TextEditingController itemCategoryController = TextEditingController();

  bool itemCategoryNameValidation = true;

  String itemCategoryNameValidationMessage = '';

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

  TextEditingController FeedConsumptionUnitController = TextEditingController();

  bool feedConsumptionUnitValidation = true;

  String feedConsumptionUnitValidationMessage = '';

  var plantId;

  var standardUnitId;

  List standardUnitlist = [];

  var feedConsumptionUnitId;

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  late AnimationController controller;
  late Animation<Offset> offset;

  var batchId;
  var wareHouseId;
  List wareHouseDetails = [];
  List plantDetails = [];

  List itemCategoryDetails = [];

  TextEditingController dateController = TextEditingController();
  TextEditingController shippingDateController = TextEditingController();
  TextEditingController eggGradingCodeController = TextEditingController();
  TextEditingController ABWController = TextEditingController();
  TextEditingController cwQuantityController = TextEditingController();
  TextEditingController cwUnitController = TextEditingController();
  TextEditingController requiredQuantityController = TextEditingController();

  Map<String, dynamic> dailyBatch = {
    'Received_Date': '',
    'Shipped_Date': '',
  };

  bool eggGradingCodeValidation = true;
  bool requiredQuantityValidation = true;
  bool ABWValidation = true;
  bool cwQuantityValidation = true;
  bool wareHouseIdValidation = true;
  bool breedIdValidation = true;
  bool cwUnitValidation = true;
  bool weightUnitValidation = true;
  bool IsClearedValidation = true;
  bool vaccinationPlanIdValidation = true;
  bool requiredDateOfDeliveryValidation = true;
  bool shippingDateValidation = true;

  String requiredQuantityValidationMessage = '';
  String eggGradingCodeValidationMessage = '';
  String ABWValidationMessage = '';
  String cwQuantityValidationMessage = '';
  String wareHouseIdValidationMessage = '';
  String breedIdValidationMessage = '';
  String cwUnitValidationMessage = '';
  String weightunitValidationMessage = '';
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

    if (totalFeedConsumptionController.text == '') {
      totalFeedConsumptionValidationMessage =
          'Feed consumption cannot be empty';
      totalFeedConsumptionCodeValidation = false;
    } else {
      totalFeedConsumptionCodeValidation = true;
    }
    // if (itemCategoryId == null) {
    //   itemCategoryNameValidationMessage = 'item category cannot be null';
    //   itemCategoryNameValidation = false;
    // } else {
    //   itemCategoryNameValidation = true;
    // }

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
    // if (productId == null) {
    //   itemValidationMessage = 'Product name cannot be null';
    //   itemValidation = false;
    // } else {
    //   itemValidation = true;
    // }
    if (ABWController.text == '') {
      ABWValidationMessage = 'Quantity cannot be null';
      ABWValidation = false;
    } else {
      ABWValidation = true;
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
    // if (weightUnitController.text == '') {
    //   weightunitValidationMessage = 'Unit cannot be null';
    //   weightUnitValidation = false;
    // } else {
    //   weightUnitValidation = true;
    // }
    // if (IsClearedSelected == null) {
    //   IsClearedValidationMessage = 'Select is cleared';
    //   IsClearedValidation = false;
    // } else {
    //   IsClearedValidation = true;
    // }

    // if (shippingDateController.text == '') {
    //   shippingDateValidationMessage = 'Select Grading date';
    //   shippingDateValidation = false;
    // } else {
    //   shippingDateValidation = true;
    // }

    if (itemValidation == true &&
        batchPlanValidation == true &&
        itemCategoryNameValidation == true &&
        totalFeedConsumptionCodeValidation == true &&
        ABWValidation == true &&
        wareHouseIdValidation == true &&
        weightUnitValidation == true &&
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
        dailyBatch['Received_Date'] =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);
      } else {
        dailyBatch['Shipped_Date'] =
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
    clearInventoryBatchException(context);
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
      shippingDateController.text = widget.editData['Shipped_Date'];
      dailyBatch['Shipped_Date'] = widget.editData['Shipped_Date'];
      ABWController.text = widget.editData['Transfer_Quantity'].toString();
      dailyBatch['Transfer_Quantity'] = widget.editData['Transfer_Quantity'];
      // cwQuantityController.text = widget.editData['CW_Quantity'].toString();
      // transferOut['CW_Quantity'] = widget.editData['CW_Quantity'];
      // cwUnitController.text = widget.editData['CW_Unit'];
      // transferOut['CW_Unit'] = widget.editData['CW_Unit'];
      weightUnitController.text = widget.editData['Remarks'].toString();
      dailyBatch['Remarks'] = widget.editData['Remarks'];
      // itemController.text = widget.editData['Item'];
      // transferOut['Item'] = widget.editData['Item'];
      // itemCategoryController.text = widget.editData['Customer_Name'];
      // transferOut['Customer_Name'] = widget.editData['Customer_Name'];
      totalFeedConsumptionController.text = widget.editData['Transfer_Code'];
      dailyBatch['Transfer_Code'] = widget.editData['Transfer_Code'];
      // statusController.text = widget.editData['Rate'].toString();
      // transferOut['Rate'] = widget.editData['Rate'];
    }

    Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      var firmId = await getFirmData();
      if (firmId != '') {
        Provider.of<InfrastructureApis>(context, listen: false)
            .getPlantDetails(
              token,
              firmId,
            )
            .then((value1) {});
      }

      // var platId = await fetchPlant();
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getWarehouseDetails(platId, token)
      //     .then((value1) {});
      Provider.of<InventoryApi>(context, listen: false).getBatch(token);
      Provider.of<Apicalls>(context, listen: false)
          .getStandardUnitValues(token);
      // Provider.of<ItemApis>(context, listen: false)
      //     .getItemCategory(token)
      //     .then((value1) {});
    });

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
    });
  }

  void fechWareHouseList(int id) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseDetailsForAll(
            id,
            token,
          )
          .then((value1) {});
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
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

    // print(dailyBatch.toString());

    if (widget.editData.isNotEmpty) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<TransferJournalApi>(context, listen: false)
            .updateTransferOutJournal(
                dailyBatch, widget.editData['Transfer_Out_Id'], token)
            .then((value) {
          if (value == 202 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully updated daily batch');
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
        Provider.of<InventoryApi>(context, listen: false)
            .addDailyBatch(dailyBatch, token)
            .then((value) {
          if (value == 200 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully added daily batch');
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double formWidth = size.width * 0.25;
    plantDetails = Provider.of<InfrastructureApis>(
      context,
    ).plantDetails;
    wareHouseDetails = Provider.of<InfrastructureApis>(
      context,
    ).warehouseDetails;

    batchPlanDetails = Provider.of<InventoryApi>(context).batchDetails;
    standardUnitlist = Provider.of<Apicalls>(context).standardUnitList;

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
                        'Daily Batch',
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
                          'Add Daily Batch',
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
                          child: const Text('Plant'),
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
                                items: plantDetails
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Plant_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      dailyBatch['Plant_Id'] = e['Plant_Id'];
                                      fechWareHouseList(e['Plant_Id']);
                                      wareHouseId = null;
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Plant_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose Plant'),
                                onChanged: (value) {
                                  setState(() {
                                    plantId = value;
                                  });
                                },
                              ),
                            ),
                          ),
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
                                      dailyBatch['WareHouse_Id'] =
                                          e['WareHouse_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['WareHouse_Code']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose wareHouse'),
                                onChanged: (value) {
                                  setState(() {
                                    wareHouseId = value;
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
                                      dailyBatch['Batch_Plan_Id'] =
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
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Average Body Weight'),
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
                                  hintText: 'Enter average body weight',
                                  border: InputBorder.none),
                              controller: ABWController,
                              onSaved: (value) {
                                dailyBatch['Average_Body_Weight'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ABWValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, ABWValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Weight Unit'),
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
                                value: standardUnitId,
                                items: standardUnitlist
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Unit_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      dailyBatch['Weight_Unit'] = e['Unit_Id'];

                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Unit_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose Unit'),
                                onChanged: (value) {
                                  setState(() {
                                    standardUnitId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  weightUnitValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, weightunitValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Total Feed Consumption'),
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
                                  hintText: 'Enter total feed consumption',
                                  border: InputBorder.none),
                              controller: totalFeedConsumptionController,
                              onSaved: (value) {
                                dailyBatch['Total_Feed_Consumption'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  totalFeedConsumptionCodeValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, totalFeedConsumptionValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Feed Consumption Unit'),
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
                                value: feedConsumptionUnitId,
                                items: standardUnitlist
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Unit_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      dailyBatch['Feed_Consumption_Unit'] =
                                          e['Unit_Id'];

                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Unit_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose Unit'),
                                onChanged: (value) {
                                  setState(() {
                                    feedConsumptionUnitId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  feedConsumptionUnitValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, feedConsumptionUnitValidationMessage),
                  Consumer<InventoryApi>(builder: (context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.inventoryBatchExceptions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ModularWidgets.exceptionDesign(
                            MediaQuery.of(context).size,
                            value.inventoryBatchExceptions[index]);
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
