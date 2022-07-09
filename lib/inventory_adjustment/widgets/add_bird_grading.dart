import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../inventory/providers/inventory_api.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/inventory_adjustement_apis.dart';

class AddBirdGrading extends StatefulWidget {
  AddBirdGrading({Key? key, required this.reFresh, required this.editData})
      : super(key: key);
  final ValueChanged<int> reFresh;
  final Map<String, dynamic> editData;
  @override
  State<AddBirdGrading> createState() => _AddBirdGradingState();
}

class _AddBirdGradingState extends State<AddBirdGrading>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var activityId;

  var collectionStatusId;

  var IsClearedSelected;

  List batchPlanDetails = [];

  bool batchPlanValidation = true;

  String batchPlanValidationMessage = '';

  TextEditingController unitController = TextEditingController();

  List birdGradeList = [];
  var birdGradeId;

  var birdGradeToId;

  List standardUnitlist = [];
  var standardUnitId;

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
  TextEditingController gradingDateController = TextEditingController();
  TextEditingController eggGradingCodeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController gradeFromController = TextEditingController();
  TextEditingController gradeToController = TextEditingController();
  TextEditingController requiredQuantityController = TextEditingController();

  Map<String, dynamic> birdGradingDetails = {
    'Batch_Id': '',
    'Date': '',
    'WareHouse_Id': '',
    'Qty': '',
    'From': '',
    'To': '',
    'Unit': '',
  };

  bool eggGradingCodeValidation = true;
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
  String eggGradingCodeValidationMessage = '';
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

    if (quantityController.text == '') {
      quantityValidationMessage = 'Quantity cannot be null';
      quantityValidation = false;
    } else {
      quantityValidation = true;
    }
    if (birdGradeId == null) {
      gradeFromValidationMessage = 'Grade from cannot be null';
      gradeFromValidation = false;
    } else {
      gradeFromValidation = true;
    }
    if (wareHouseId == null) {
      wareHouseIdValidationMessage = 'Select the warehouse';
      wareHouseIdValidation = false;
    } else {
      wareHouseIdValidation = true;
    }

    if (birdGradeToId == null) {
      gradeToValidationMessage = 'Grade to cannot be null';
      gradeToValidation = false;
    } else {
      gradeToValidation = true;
    }
    if (standardUnitId == null) {
      unitValidationMessage = 'Unit cannot be null';
      unitValidation = false;
    } else {
      unitValidation = true;
    }
    // if (IsClearedSelected == null) {
    //   IsClearedValidationMessage = 'Select is cleared';
    //   IsClearedValidation = false;
    // } else {
    //   IsClearedValidation = true;
    // }

    if (gradingDateController.text == '') {
      gradingDateValidationMessage = 'Select Grading date';
      gradingDateValidation = false;
    } else {
      gradingDateValidation = true;
    }

    if (eggGradingCodeValidation == true &&
        quantityValidation == true &&
        gradeFromValidation == true &&
        wareHouseIdValidation == true &&
        gradeToValidation == true &&
        unitValidation == true &&
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
      birdGradingDetails['Date'] =
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
    if (widget.editData.isNotEmpty) {
      gradingDateController.text = widget.editData['Date'].toString();
      birdGradingDetails['Date'] = widget.editData['Date'];
      quantityController.text = widget.editData['Qty'].toString();
      birdGradingDetails['Qty'] = widget.editData['Qty'];
      gradeFromController.text = widget.editData['From'].toString();
      birdGradingDetails['From'] = widget.editData['From'];
      gradeToController.text = widget.editData['To'].toString();
      birdGradingDetails['To'] = widget.editData['To'].toString();
      unitController.text = widget.editData['Unit'].toString();
      birdGradingDetails['Unit'] = widget.editData['Unit'];
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
      Provider.of<Apicalls>(context, listen: false)
          .getStandardBirdGradeList(token);
      Provider.of<Apicalls>(context, listen: false)
          .getStandardUnitValues(token);
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
    log(birdGradingDetails.toString());

    if (widget.editData.isNotEmpty) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .updateBirdGrading(
                birdGradingDetails, widget.editData['Record_Id'], token)
            .then((value) {
          if (value == 202 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully updated Bird Grading');
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
            .addBirdGrading(birdGradingDetails, token)
            .then((value) {
          if (value == 200 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully added Bird Grading');
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
    birdGradeList = Provider.of<Apicalls>(context).standardBirdGradeList;
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
                        'Bird Grading',
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
                                'Add Bird Grading',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              )
                            : const Text(
                                'Update Bird Grading',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Container(
                  //         width: formWidth,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text('Record Code'),
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
                  //                 hintText: 'Enter record code',
                  //                 border: InputBorder.none),
                  //             controller: eggGradingCodeController,
                  //             onSaved: (value) {
                  //               eggGradingDetails['Record_Id'] = value!;
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  eggGradingCodeValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, eggGradingCodeValidationMessage),
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
                                    child: Text(e['Batch_Code']),
                                    value: e['Batch_Code'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      birdGradingDetails['Batch_Id'] =
                                          e['Batch_Id'];
                                      //print(warehouseCategory);
                                    },
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
                                      birdGradingDetails['WareHouse_Id'] =
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

                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Grade From'),
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
                                value: birdGradeId,
                                items: birdGradeList
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    child: Text(e['Bird_Grade']),
                                    value: e['Bird_Grade'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      birdGradingDetails['From'] =
                                          e['Bird_Grade_Id'];
                                      //print(warehouseCategory);
                                    },
                                  );
                                }).toList(),
                                hint: const Text('Please Choose Grade From'),
                                onChanged: (value) {
                                  setState(() {
                                    birdGradeId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  gradeFromValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, gradeFromValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: formWidth,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Grade To'),
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
                                value: birdGradeToId,
                                items: birdGradeList
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    child: Text(e['Bird_Grade']),
                                    value: e['Bird_Grade'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      birdGradingDetails['To'] =
                                          e['Bird_Grade_Id'];
                                      //print(warehouseCategory);
                                    },
                                  );
                                }).toList(),
                                hint: const Text('Please Choose Grade To'),
                                onChanged: (value) {
                                  setState(() {
                                    birdGradeToId = value as String;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  gradeToValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, gradeToValidationMessage),
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
                                birdGradingDetails['Qty'] = value!;
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
                                value: standardUnitId,
                                items: standardUnitlist
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    child: Text(e['Unit_Name']),
                                    value: e['Unit_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      birdGradingDetails['Unit_Id'] =
                                          e['Unit_Id'];
                                      //print(warehouseCategory);
                                    },
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
                  unitValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, unitValidationMessage),

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
