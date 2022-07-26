import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/batch_plan/providers/batch_plan_apis.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../inventory/providers/inventory_api.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/inventory_adjustement_apis.dart';

class AddEggGrading extends StatefulWidget {
  AddEggGrading({Key? key, required this.reFresh, required this.editData})
      : super(key: key);
  final ValueChanged<int> reFresh;
  final Map<String, dynamic> editData;
  @override
  State<AddEggGrading> createState() => _AddEggGradingState();
}

class _AddEggGradingState extends State<AddEggGrading>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var activityId;

  var collectionStatusId;

  var IsClearedSelected;

  List batchPlanDetails = [];

  bool batchPlanValidation = true;

  String batchPlanValidationMessage = '';

  TextEditingController unitController = TextEditingController();

  List standardUnitList = [];
  var standardUnitId;

  List eggGradingList = [];
  var eggGradingId;

  var eggGradingToId;

  var plantId;

  List plantList = [];
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
  TextEditingController locationController = TextEditingController();
  TextEditingController gradeFromController = TextEditingController();
  TextEditingController gradeToController = TextEditingController();
  TextEditingController requiredQuantityController = TextEditingController();

  Map<String, dynamic> eggGradingDetails = {
    'Batch_Id': '',
    'Grading_Date': '',
    'WareHouse_Id': '',
    'Location': '',
    'From': '',
    'To': '',
    'Unit': '',
  };

  bool eggGradingCodeValidation = true;
  bool requiredQuantityValidation = true;
  bool gradeValidation = true;
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
  String gradeValidationMessage = '';
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

    if (locationController.text == '') {
      gradeValidationMessage = 'Location cannot be null';
      gradeValidation = false;
    } else {
      gradeValidation = true;
    }
    if (eggGradingId == null) {
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

    if (eggGradingToId == null) {
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
        gradeValidation == true &&
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
      gradingDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      eggGradingDetails['Grading_Date'] =
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
    clearInventoryAdjustmentException(context);

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
      gradingDateController.text = widget.editData['Grading_Date'];
      eggGradingDetails['Grading_Date'] = widget.editData['Grading_Date'];
      locationController.text = widget.editData['Location'];
      eggGradingDetails['Location'] = widget.editData['Location'];
      gradeFromController.text = widget.editData['From'];
      eggGradingDetails['From'] = widget.editData['From'];
      gradeToController.text = widget.editData['To'];
      eggGradingDetails['To'] = widget.editData['To'];
      unitController.text = widget.editData['Unit'].toString();
      eggGradingDetails['Unit'] = widget.editData['Unit'];
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
      Provider.of<Apicalls>(context, listen: false)
          .getStandardEggGradeList(token);
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
    print(eggGradingDetails);

    if (widget.editData.isNotEmpty) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .updateEggGrading(
                eggGradingDetails, widget.editData['Grading_Record_Id'], token)
            .then((value) {
          if (value == 202 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully updated Egg Grading');
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
            .addEggGrading(eggGradingDetails, token)
            .then((value) {
          if (value == 200 || value == 201) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully added Egg Grading');
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
    plantDetails = Provider.of<InfrastructureApis>(
      context,
    ).plantDetails;
    wareHouseDetails = Provider.of<InfrastructureApis>(
      context,
    ).warehouseDetails;

    batchPlanDetails = Provider.of<InventoryApi>(context).batchDetails;
    eggGradingList = Provider.of<Apicalls>(context).standardEggGradeList;
    standardUnitList = Provider.of<Apicalls>(context).standardUnitList;
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
                        'Egg Grading',
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
                          'Add Egg Grading',
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
                  //         child: const Text('Egg Grading Code'),
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
                  //                 hintText: 'Enter egg grading code',
                  //                 border: InputBorder.none),
                  //             controller: eggGradingCodeController,
                  //             onSaved: (value) {
                  //               eggGradingDetails['Grading_Record_Id'] = value!;
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
                                    value: e['Batch_Plan_Code'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      eggGradingDetails['Batch_Plan_Id'] =
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
                              child: const Text('Grading Date'),
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
                                      hintText: 'Choose grading date',
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
                          child: const Text('Plant Id'),
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
                                      fechWareHouseList(e['Plant_Id'], context);
                                      wareHouseId = null;
                                    },
                                    child: Text(e['Plant_Name']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose plant Name'),
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
                                    value: e['WareHouse_Code'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      eggGradingDetails['WareHouse_Id'] =
                                          e['WareHouse_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['WareHouse_Code']),
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
                          child: const Text('Location'),
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
                                  hintText: 'Enter Location',
                                  border: InputBorder.none),
                              controller: locationController,
                              onSaved: (value) {
                                eggGradingDetails['Location'] = value!;
                              },
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
                                value: eggGradingId,
                                items: eggGradingList
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Egg_Grade'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      eggGradingDetails['From'] =
                                          e['Egg_Grade_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Egg_Grade']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose Grade From'),
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
                                value: eggGradingToId,
                                items: eggGradingList
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Egg_Grade'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      eggGradingDetails['To'] =
                                          e['Egg_Grade_Id'];
                                      //print(warehouseCategory);
                                    },
                                    child: Text(e['Egg_Grade']),
                                  );
                                }).toList(),
                                hint: const Text('Please Choose Grade To'),
                                onChanged: (value) {
                                  setState(() {
                                    eggGradingToId = value as String;
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
                                items: standardUnitList
                                    .map<DropdownMenuItem<String>>((e) {
                                  return DropdownMenuItem(
                                    value: e['Unit_Name'],
                                    onTap: () {
                                      // firmId = e['Firm_Code'];
                                      eggGradingDetails['Unit_Id'] =
                                          e['Unit_Id'];
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
                            value.inventoryAdjustemntExceptions[index]);
                      },
                    );
                  }),
                  ModularWidgets.globalAddDetailsDialog(size, save),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
