// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:poultry_login_signup/colors.dart';
// import 'package:poultry_login_signup/providers/apicalls.dart';
// import 'package:poultry_login_signup/breed_info/providers/breed_info_apicalls.dart';
// import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
// import 'package:poultry_login_signup/widgets/modular_widgets.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../main.dart';
// import '../../planning/providers/activity_plan_apis.dart';
// import '../providers/batch_plan_apis.dart';

// class AddBatchPlanDetailsDialog extends StatefulWidget {
//   AddBatchPlanDetailsDialog(
//       {Key? key,
//       required this.reFresh,
//       required this.id,
//       required this.editData})
//       : super(key: key);

//   final ValueChanged<int> reFresh;
//   final String id;
//   final Map<String, dynamic> editData;

//   @override
//   _AddBatchPlanDetailsDialogState createState() =>
//       _AddBatchPlanDetailsDialogState();
// }

// class _AddBatchPlanDetailsDialogState extends State<AddBatchPlanDetailsDialog>
//     with SingleTickerProviderStateMixin {
//   final GlobalKey<FormState> _formKey = GlobalKey();

//   var activityId;

//   EdgeInsetsGeometry getPadding() {
//     return const EdgeInsets.only(left: 8.0);
//   }

//   late AnimationController controller;
//   late Animation<Offset> offset;

//   var itemId;
//   var batchId;
//   var wareHouseId;
//   List wareHouseDetails = [];
//   var breedName;
//   List plantDetails = [];
//   var plantName;
//   List birdAgeGroup = [];
//   var birdName;

//   List breedInfo = [];
//   List activityHeaderData = [];
//   var ActivityId;
//   List medicationHeaderData = [];
//   var medicationId;
//   List vaccinationHeaderData = [];
//   var vaccinationId;
//   List breedVersion = [];
//   var breedVersionId;

//   TextEditingController dateController = TextEditingController();
//   TextEditingController hatchDateController = TextEditingController();

//   Map<String, dynamic> batchPlanDetails = {};

//   TextEditingController batchCodeController = TextEditingController();
//   TextEditingController receivedQuantityController = TextEditingController();

//   bool batchCodeValidation = true;
//   bool receivedQuantityValidation = true;
//   bool plantIdValidation = true;
//   bool birdAgeIdValidation = true;
//   bool wareHouseIdValidation = true;
//   bool breedIdValidation = true;
//   bool breedVersionIdValidation = true;
//   bool activityPlanIdValidation = true;
//   bool medicationPlanIdValidation = true;
//   bool vaccinationPlanIdValidation = true;
//   bool requiredDateOfDeliveryValidation = true;
//   bool hatchDateValidation = true;

//   String receivedQuantityValidationMessage = '';
//   String batchCodeValidationMessage = '';
//   String plantIdValidationMessage = '';
//   String birdAgeIdValidationMessage = '';
//   String wareHouseIdValidationMessage = '';
//   String breedIdValidationMessage = '';
//   String breedVersionIdValidationMessage = '';
//   String activityPlanIdValidationMessage = '';
//   String medicationPlanIdValidationMessage = '';
//   String vaccinationPlanIdValidationMessage = '';
//   String hatchDateValidationMessage = '';

//   String requiredDateOfDeliveryValidationMessage = '';

//   bool validate() {
//     if (batchCodeController.text == '') {
//       batchCodeValidationMessage = 'Batch code cannot be empty';
//       batchCodeValidation = false;
//     } else {
//       batchCodeValidation = true;
//     }
//     if (receivedQuantityController.text == '') {
//       receivedQuantityValidationMessage = 'Received quantity cannot be empty';
//       receivedQuantityValidation = false;
//     } else {
//       receivedQuantityValidation = true;
//     }

//     if (dateController.text == '') {
//       requiredDateOfDeliveryValidationMessage = 'Select the Receipt Date';
//       requiredDateOfDeliveryValidation = false;
//     } else {
//       requiredDateOfDeliveryValidation = true;
//     }

//     if (hatchDateController.text == '') {
//       hatchDateValidationMessage = 'Select the Hatch Date';
//       hatchDateValidation = false;
//     } else {
//       hatchDateValidation = true;
//     }

//     if (batchCodeValidation == true &&
//         receivedQuantityValidation == true &&
//         requiredDateOfDeliveryValidation == true &&
//         hatchDateValidation == true) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   void _hatchDatePicker() {
//     showDatePicker(
//       builder: (context, child) {
//         return Theme(
//             data: Theme.of(context).copyWith(
//               colorScheme: ColorScheme.light(
//                 primary: ProjectColors.themecolor, // header background color
//                 onPrimary: Colors.black, // header text color
//                 onSurface: Colors.green, // body text color
//               ),
//               textButtonTheme: TextButtonThemeData(
//                 style: TextButton.styleFrom(
//                   primary: Colors.red, // button text color
//                 ),
//               ),
//             ),
//             child: child!);
//       },
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2021),
//       lastDate: DateTime(2025),
//     ).then((pickedDate) {
//       if (pickedDate == null) {
//         return;
//       }
//       // _startDate = pickedDate.millisecondsSinceEpoch;
//       hatchDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
//       batchPlanDetails['Hatch_Date'] =
//           DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);

//       setState(() {});
//     });
//   }

//   void _datePicker() {
//     showDatePicker(
//       builder: (context, child) {
//         return Theme(
//             data: Theme.of(context).copyWith(
//               colorScheme: ColorScheme.light(
//                 primary: ProjectColors.themecolor, // header background color
//                 onPrimary: Colors.black, // header text color
//                 onSurface: Colors.green, // body text color
//               ),
//               textButtonTheme: TextButtonThemeData(
//                 style: TextButton.styleFrom(
//                   primary: Colors.red, // button text color
//                 ),
//               ),
//             ),
//             child: child!);
//       },
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2021),
//       lastDate: DateTime(2025),
//     ).then((pickedDate) {
//       if (pickedDate == null) {
//         return;
//       }
//       // _startDate = pickedDate.millisecondsSinceEpoch;
//       dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
//       batchPlanDetails['Receipt_Date'] =
//           DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);

//       setState(() {});
//     });
//   }

//   Future<void> getPlantDetails() async {
//     var prefs = await SharedPreferences.getInstance();

//     if (prefs.containsKey('FirmAndPlantDetails')) {
//       var extratedData = json.decode(prefs.getString('FirmAndPlantDetails')!)
//           as Map<String, dynamic>;

//       await Provider.of<Apicalls>(context, listen: false)
//           .tryAutoLogin()
//           .then((value) async {
//         var token = Provider.of<Apicalls>(context, listen: false).token;
//         await Provider.of<InfrastructureApis>(context, listen: false)
//             .getPlantDetails(token, extratedData['PlantId'])
//             .then((value1) {
//           // setState(() {
//           //   firmSelected = true;
//           //   selectedFirmName = e['Firm_Name'];
//           //   selectedFirmId = e['Firm_Id'];
//           // });
//         });
//       });
//     }
//   }

//   Future<String> fetchCredientials() async {
//     bool data =
//         await Provider.of<Apicalls>(context, listen: false).tryAutoLogin();

//     if (data != false) {
//       var token = Provider.of<Apicalls>(context, listen: false).token;

//       return token;
//     } else {
//       return '';
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 450));
//     //scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.linear);
//     offset = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
//         .animate(controller);

//     controller.addListener(() {
//       setState(() {});
//     });

//     getPlantDetails();
//     fetchCredientials().then((token) {
//       if (token != '') {
//         Provider.of<BreedInfoApis>(context, listen: false)
//             .getBreedversionInfo(token);
//       }
//     });

//     if (widget.editData.isNotEmpty) {
//       batchCodeController.text = widget.editData['Batch_Code'];
//       batchPlanDetails['Batch_Code'] = widget.editData['Batch_Code'];
//       receivedQuantityController.text =
//           widget.editData['Received_Quantity'].toString();
//       batchPlanDetails['Received_Quantity'] =
//           widget.editData['Received_Quantity'];
//       hatchDateController.text = widget.editData['Hatch_Date'];
//       batchPlanDetails['Hatch_Date'] = widget.editData['Hatch_Date'];
//       dateController.text = widget.editData['Receipt_Date'];
//       batchPlanDetails['Receipt_Date'] = widget.editData['Receipt_Date'];
//     }

//     controller.forward();
//     Provider.of<Apicalls>(context, listen: false)
//         .tryAutoLogin()
//         .then((value) async {
//       var token = Provider.of<Apicalls>(context, listen: false).token;
//       var plantId = await fetchPlant();
//       // Provider.of<InfrastructureApis>(context, listen: false)
//       //     .getWarehouseDetails(plantId, token)
//       //     .then((value1) {});
//       // Provider.of<InfrastructureApis>(context, listen: false)
//       //     .getPlantDetails(token)
//       //     .then((value1) {});
//       Provider.of<BreedInfoApis>(context, listen: false)
//           .getBreed(token)
//           .then((value1) {});
//       Provider.of<BreedInfoApis>(context, listen: false)
//           .getBreedversionInfo(token)
//           .then((value1) {});
//       Provider.of<BreedInfoApis>(context, listen: false)
//           .getBirdAgeGroup(token)
//           .then((value1) {});
//       Provider.of<ActivityApis>(context, listen: false)
//           .getMedicationPlanData(token)
//           .then((value1) {});

//       Provider.of<ActivityApis>(context, listen: false)
//           .getVaccinationPlan(token)
//           .then((value1) {});
//       Provider.of<ActivityApis>(context, listen: false)
//           .getActivityPlan(token)
//           .then((value1) {});
//     });

//     Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
//       var token = Provider.of<Apicalls>(context, listen: false).token;
//     });
//   }

//   var isValid = true;

//   void save() {
//     isValid = validate();
//     if (!isValid) {
//       setState(() {});
//       return;
//     }

//     _formKey.currentState!.save();
//     print(batchPlanDetails);

//     Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
//       var token = Provider.of<Apicalls>(context, listen: false).token;
//       Provider.of<BatchApis>(context, listen: false)
//           .updateBatchPlan(batchPlanDetails, widget.id, token)
//           .then((value) {
//         if (value == 202 || value == 201) {
//           widget.reFresh(100);
//           Get.back();
//           widget.editData.isEmpty
//               ? successSnackbar('Successfully added batch')
//               : successSnackbar('Successfully updated batch');

//           // var data = {
//           //   'Activity_Plan_Id': batchPlanDetails['Activity_Plan_Id'],
//           //   'Medication_Plan_Id': batchPlanDetails['Medication_Plan_Id'],
//           //   'Vaccination_Plan_Id': batchPlanDetails['Vaccination_Plan_Id'],
//           //   "Breed_Version_Id": batchPlanDetails['Breed_Version_Id'],
//           //   "Batch_Plan_Code": batchPlanDetails['Batch_Plan_Code'],
//           //   "Hatch_Date": batchPlanDetails['Hatch_Date'],
//           //   // "Batch_Plan_Id": batchPlanDetails['Batch_Plan_Id'],
//           // };

//           // Provider.of<BatchApis>(context, listen: false)
//           //     .addBatchPlanStepTwo(data, token)
//           //     .then((value) {
//           //   if (value == 200 || value == 201) {

//           //   }
//           // });
//         } else {
//           failureSnackbar('Unable to add data something went wrong');
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     double formWidth = size.width * 0.25;
//     // plantDetails = Provider.of<InfrastructureApis>(
//     //   context,
//     // ).plantDetails;
//     // wareHouseDetails = Provider.of<InfrastructureApis>(
//     //   context,
//     // ).warehouseDetails;
//     // breedInfo = Provider.of<BreedInfoApis>(context).breedInfo;
//     // breedVersion = Provider.of<BreedInfoApis>(context).breedVersion;
//     // activityHeaderData = Provider.of<ActivityApis>(context).activityPlan;
//     // medicationHeaderData = Provider.of<ActivityApis>(context).medicationPlan;
//     // vaccinationHeaderData = Provider.of<ActivityApis>(context).vaccinationPlan;
//     // birdAgeGroup = Provider.of<BreedInfoApis>(
//     //   context,
//     // ).birdAgeGroup;
//     return Container(
//       width: size.width * 0.3,
//       height: MediaQuery.of(context).size.height,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.white,
//         border: Border.all(color: Colors.black26),
//       ),
//       child: Drawer(
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 20, left: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       widget.editData.isEmpty
//                           ? Text(
//                               'Add Batch',
//                               style: GoogleFonts.roboto(
//                                   textStyle: TextStyle(
//                                       color: Theme.of(context).backgroundColor,
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 36)),
//                             )
//                           : Text(
//                               'Update Batch',
//                               style: GoogleFonts.roboto(
//                                   textStyle: TextStyle(
//                                       color: Theme.of(context).backgroundColor,
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 36)),
//                             )
//                     ],
//                   ),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 36.0),
//                   //   child: Row(
//                   //     mainAxisAlignment: MainAxisAlignment.start,
//                   //     children: const [
//                   //       Text(
//                   //         'Add Batch',
//                   //         style: TextStyle(
//                   //             fontWeight: FontWeight.w700, fontSize: 18),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: formWidth,
//                           padding: const EdgeInsets.only(bottom: 12),
//                           child: const Text('Batch Code'),
//                         ),
//                         Container(
//                           width: formWidth,
//                           height: 36,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: Colors.white,
//                             border: Border.all(color: Colors.black26),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 6),
//                             child: TextFormField(
//                               decoration: const InputDecoration(
//                                   hintText: 'Enter Batch Code',
//                                   border: InputBorder.none),
//                               controller: batchCodeController,
//                               onSaved: (value) {
//                                 batchPlanDetails['Batch_Code'] = value!;
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   batchCodeValidation == true
//                       ? const SizedBox()
//                       : ModularWidgets.validationDesign(
//                           size, batchCodeValidationMessage),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 24.0),
//                   //   child: Column(
//                   //     // mainAxisSize: MainAxisSize.min,
//                   //     mainAxisAlignment: MainAxisAlignment.start,

//                   //     children: [
//                   //       Container(
//                   //         width: formWidth,
//                   //         padding: const EdgeInsets.only(bottom: 12),
//                   //         child: const Text('Plant Name'),
//                   //       ),
//                   //       Container(
//                   //         width: formWidth,
//                   //         height: 36,
//                   //         decoration: BoxDecoration(
//                   //           borderRadius: BorderRadius.circular(8),
//                   //           color: Colors.white,
//                   //           border: Border.all(color: Colors.black26),
//                   //         ),
//                   //         child: Padding(
//                   //           padding: const EdgeInsets.symmetric(
//                   //               horizontal: 12, vertical: 6),
//                   //           child: DropdownButtonHideUnderline(
//                   //             child: DropdownButton(
//                   //               value: plantName,
//                   //               items: plantDetails
//                   //                   .map<DropdownMenuItem<String>>((e) {
//                   //                 return DropdownMenuItem(
//                   //                   child: Text(e['Plant_Name']),
//                   //                   value: e['Plant_Name'],
//                   //                   onTap: () {
//                   //                     // firmId = e['Firm_Code'];
//                   //                     batchPlanDetails['Plant_Id'] =
//                   //                         e['Plant_Id'];
//                   //                     //print(warehouseCategory);
//                   //                   },
//                   //                 );
//                   //               }).toList(),
//                   //               hint: const Text('Choose plant Name'),
//                   //               onChanged: (value) {
//                   //                 setState(() {
//                   //                   plantName = value as String;
//                   //                 });
//                   //               },
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   // plantIdValidation == true
//                   //     ? const SizedBox()
//                   //     : ModularWidgets.validationDesign(
//                   //         size, plantIdValidationMessage),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 24.0),
//                   //   child: Column(
//                   //     mainAxisAlignment: MainAxisAlignment.start,
//                   //     children: [
//                   //       Container(
//                   //         width: formWidth,
//                   //         padding: const EdgeInsets.only(bottom: 12),
//                   //         child: const Text('Bird Age Group'),
//                   //       ),
//                   //       Container(
//                   //         width: formWidth,
//                   //         height: 36,
//                   //         decoration: BoxDecoration(
//                   //           borderRadius: BorderRadius.circular(8),
//                   //           color: Colors.white,
//                   //           border: Border.all(color: Colors.black26),
//                   //         ),
//                   //         child: Padding(
//                   //           padding: const EdgeInsets.symmetric(
//                   //               horizontal: 12, vertical: 6),
//                   //           child: DropdownButtonHideUnderline(
//                   //             child: DropdownButton(
//                   //               value: birdName,
//                   //               items: birdAgeGroup
//                   //                   .map<DropdownMenuItem<String>>((e) {
//                   //                 return DropdownMenuItem(
//                   //                   child: Text(e['Name']),
//                   //                   value: e['Name'],
//                   //                   onTap: () {
//                   //                     // firmId = e['Firm_Code'];
//                   //                     batchPlanDetails['Bird_Age_Id'] =
//                   //                         e['Bird_Age_Id'];
//                   //                     //print(warehouseCategory);
//                   //                   },
//                   //                 );
//                   //               }).toList(),
//                   //               hint: const Text('Please Choose Bird Age ID'),
//                   //               onChanged: (value) {
//                   //                 setState(() {
//                   //                   birdName = value as String;
//                   //                 });
//                   //               },
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   // birdAgeIdValidation == true
//                   //     ? const SizedBox()
//                   //     : ModularWidgets.validationDesign(
//                   //         size, birdAgeIdValidationMessage),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 24.0),
//                   //   child: Column(
//                   //     mainAxisAlignment: MainAxisAlignment.start,
//                   //     children: [
//                   //       Container(
//                   //         width: formWidth,
//                   //         padding: const EdgeInsets.only(bottom: 12),
//                   //         child: const Text('Ware house Id'),
//                   //       ),
//                   //       Container(
//                   //         width: formWidth,
//                   //         height: 36,
//                   //         decoration: BoxDecoration(
//                   //           borderRadius: BorderRadius.circular(8),
//                   //           color: Colors.white,
//                   //           border: Border.all(color: Colors.black26),
//                   //         ),
//                   //         child: Padding(
//                   //           padding: const EdgeInsets.symmetric(
//                   //               horizontal: 12, vertical: 6),
//                   //           child: DropdownButtonHideUnderline(
//                   //             child: DropdownButton(
//                   //               value: wareHouseId,
//                   //               items: wareHouseDetails
//                   //                   .map<DropdownMenuItem<String>>((e) {
//                   //                 return DropdownMenuItem(
//                   //                   child: Text(e['WareHouse_Code']),
//                   //                   value: e['WareHouse_Code'],
//                   //                   onTap: () {
//                   //                     // firmId = e['Firm_Code'];
//                   //                     batchPlanDetails['Ware_House_Id'] =
//                   //                         e['WareHouse_Id'];
//                   //                     //print(warehouseCategory);
//                   //                   },
//                   //                 );
//                   //               }).toList(),
//                   //               hint: const Text('Please Choose wareHouse Id'),
//                   //               onChanged: (value) {
//                   //                 setState(() {
//                   //                   wareHouseId = value as String;
//                   //                 });
//                   //               },
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   // wareHouseIdValidation == true
//                   //     ? const SizedBox()
//                   //     : ModularWidgets.validationDesign(
//                   //         size, wareHouseIdValidationMessage),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 24.0),
//                   //   child: Column(
//                   //     mainAxisAlignment: MainAxisAlignment.start,
//                   //     children: [
//                   //       Container(
//                   //         width: formWidth,
//                   //         padding: const EdgeInsets.only(bottom: 12),
//                   //         child: const Text('Breed Name'),
//                   //       ),
//                   //       Container(
//                   //         width: formWidth,
//                   //         height: 36,
//                   //         decoration: BoxDecoration(
//                   //           borderRadius: BorderRadius.circular(8),
//                   //           color: Colors.white,
//                   //           border: Border.all(color: Colors.black26),
//                   //         ),
//                   //         child: Padding(
//                   //           padding: const EdgeInsets.symmetric(
//                   //               horizontal: 12, vertical: 6),
//                   //           child: DropdownButtonHideUnderline(
//                   //             child: DropdownButton(
//                   //               value: breedName,
//                   //               items: breedInfo
//                   //                   .map<DropdownMenuItem<String>>((e) {
//                   //                 return DropdownMenuItem(
//                   //                   child: Text(e['Breed_Name']),
//                   //                   value: e['Breed_Name'],
//                   //                   onTap: () {
//                   //                     // firmId = e['Firm_Code'];
//                   //                     batchPlanDetails['Breed_Id'] =
//                   //                         e['Breed_Id'].toString();
//                   //                   },
//                   //                 );
//                   //               }).toList(),
//                   //               hint: const Text('Please Choose Breed Id'),
//                   //               onChanged: (value) {
//                   //                 setState(() {
//                   //                   breedName = value as String;
//                   //                 });
//                   //               },
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   // breedIdValidation == true
//                   //     ? const SizedBox()
//                   //     : ModularWidgets.validationDesign(
//                   //         size, breedIdValidationMessage),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 24.0),
//                   //   child: Column(
//                   //     mainAxisAlignment: MainAxisAlignment.start,
//                   //     children: [
//                   //       Container(
//                   //         width: formWidth,
//                   //         padding: const EdgeInsets.only(bottom: 12),
//                   //         child: const Text('Breed Version'),
//                   //       ),
//                   //       Container(
//                   //         width: formWidth,
//                   //         height: 36,
//                   //         decoration: BoxDecoration(
//                   //           borderRadius: BorderRadius.circular(8),
//                   //           color: Colors.white,
//                   //           border: Border.all(color: Colors.black26),
//                   //         ),
//                   //         child: Padding(
//                   //           padding: const EdgeInsets.symmetric(
//                   //               horizontal: 12, vertical: 6),
//                   //           child: DropdownButtonHideUnderline(
//                   //             child: DropdownButton(
//                   //               value: breedVersionId,
//                   //               items: breedVersion
//                   //                   .map<DropdownMenuItem<String>>((e) {
//                   //                 return DropdownMenuItem(
//                   //                   child: Text(e['Breed_Version']),
//                   //                   value: e['Breed_Version'],
//                   //                   onTap: () {
//                   //                     // firmId = e['Firm_Code'];
//                   //                     batchPlanDetails['Breed_Version_Id'] =
//                   //                         e['Breed_Version_Id'].toString();
//                   //                   },
//                   //                 );
//                   //               }).toList(),
//                   //               hint: const Text('Please Choose Breed version'),
//                   //               onChanged: (value) {
//                   //                 setState(() {
//                   //                   breedVersionId = value as String;
//                   //                 });
//                   //               },
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   // breedVersionIdValidation == true
//                   //     ? const SizedBox()
//                   //     : ModularWidgets.validationDesign(
//                   //         size, breedVersionIdValidationMessage),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 24.0),
//                   //   child: Column(
//                   //     mainAxisAlignment: MainAxisAlignment.start,
//                   //     children: [
//                   //       Container(
//                   //         width: formWidth,
//                   //         padding: const EdgeInsets.only(bottom: 12),
//                   //         child: const Text('Activity Plan'),
//                   //       ),
//                   //       Container(
//                   //         width: formWidth,
//                   //         height: 36,
//                   //         decoration: BoxDecoration(
//                   //           borderRadius: BorderRadius.circular(8),
//                   //           color: Colors.white,
//                   //           border: Border.all(color: Colors.black26),
//                   //         ),
//                   //         child: Padding(
//                   //           padding: const EdgeInsets.symmetric(
//                   //               horizontal: 12, vertical: 6),
//                   //           child: DropdownButtonHideUnderline(
//                   //             child: DropdownButton(
//                   //               value: activityId,
//                   //               items: activityHeaderData
//                   //                   .map<DropdownMenuItem<String>>((e) {
//                   //                 return DropdownMenuItem(
//                   //                   child: Text(e['Activity_Code']),
//                   //                   value: e['Activity_Code'],
//                   //                   onTap: () {
//                   //                     // firmId = e['Firm_Code'];
//                   //                     batchPlanDetails['Activity_Plan_Id'] =
//                   //                         e['Activity_Id'].toString();
//                   //                   },
//                   //                 );
//                   //               }).toList(),
//                   //               hint: const Text('Choose Activity name'),
//                   //               onChanged: (value) {
//                   //                 setState(() {
//                   //                   activityId = value as String;
//                   //                 });
//                   //               },
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   // activityPlanIdValidation == true
//                   //     ? const SizedBox()
//                   //     : ModularWidgets.validationDesign(
//                   //         size, activityPlanIdValidationMessage),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 24.0),
//                   //   child: Column(
//                   //     mainAxisAlignment: MainAxisAlignment.start,
//                   //     children: [
//                   //       Container(
//                   //         width: formWidth,
//                   //         padding: const EdgeInsets.only(bottom: 12),
//                   //         child: const Text('Medication Plan'),
//                   //       ),
//                   //       Container(
//                   //         width: formWidth,
//                   //         height: 36,
//                   //         decoration: BoxDecoration(
//                   //           borderRadius: BorderRadius.circular(8),
//                   //           color: Colors.white,
//                   //           border: Border.all(color: Colors.black26),
//                   //         ),
//                   //         child: Padding(
//                   //           padding: const EdgeInsets.symmetric(
//                   //               horizontal: 12, vertical: 6),
//                   //           child: DropdownButtonHideUnderline(
//                   //             child: DropdownButton(
//                   //               value: medicationId,
//                   //               items: medicationHeaderData
//                   //                   .map<DropdownMenuItem<String>>((e) {
//                   //                 return DropdownMenuItem(
//                   //                   child: Text(e['Medication_Code']),
//                   //                   value: e['Medication_Code'],
//                   //                   onTap: () {
//                   //                     // firmId = e['Firm_Code'];
//                   //                     batchPlanDetails['Medication_Plan_Id'] =
//                   //                         e['Medication_Id'].toString();
//                   //                   },
//                   //                 );
//                   //               }).toList(),
//                   //               hint: const Text('Choose Medication name'),
//                   //               onChanged: (value) {
//                   //                 setState(() {
//                   //                   medicationId = value as String;
//                   //                 });
//                   //               },
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   // medicationPlanIdValidation == true
//                   //     ? const SizedBox()
//                   //     : ModularWidgets.validationDesign(
//                   //         size, medicationPlanIdValidationMessage),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 24.0),
//                   //   child: Column(
//                   //     mainAxisAlignment: MainAxisAlignment.start,
//                   //     children: [
//                   //       Container(
//                   //         width: formWidth,
//                   //         padding: const EdgeInsets.only(bottom: 12),
//                   //         child: const Text('Vaccination Plan'),
//                   //       ),
//                   //       Container(
//                   //         width: formWidth,
//                   //         height: 36,
//                   //         decoration: BoxDecoration(
//                   //           borderRadius: BorderRadius.circular(8),
//                   //           color: Colors.white,
//                   //           border: Border.all(color: Colors.black26),
//                   //         ),
//                   //         child: Padding(
//                   //           padding: const EdgeInsets.symmetric(
//                   //               horizontal: 12, vertical: 6),
//                   //           child: DropdownButtonHideUnderline(
//                   //             child: DropdownButton(
//                   //               value: vaccinationId,
//                   //               items: vaccinationHeaderData
//                   //                   .map<DropdownMenuItem<String>>((e) {
//                   //                 return DropdownMenuItem(
//                   //                   child: Text(e['Vaccination_Code']),
//                   //                   value: e['Vaccination_Code'],
//                   //                   onTap: () {
//                   //                     // firmId = e['Firm_Code'];
//                   //                     batchPlanDetails['Vaccination_Plan_Id'] =
//                   //                         e['Vaccination_Id'].toString();
//                   //                   },
//                   //                 );
//                   //               }).toList(),
//                   //               hint: const Text('Choose Vaccination Name'),
//                   //               onChanged: (value) {
//                   //                 setState(() {
//                   //                   vaccinationId = value as String;
//                   //                 });
//                   //               },
//                   //             ),
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   // vaccinationPlanIdValidation == true
//                   //     ? const SizedBox()
//                   //     : ModularWidgets.validationDesign(
//                   //         size, vaccinationPlanIdValidationMessage),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: formWidth,
//                           padding: const EdgeInsets.only(bottom: 12),
//                           child: const Text('Received Quantity'),
//                         ),
//                         Container(
//                           width: formWidth,
//                           height: 36,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: Colors.white,
//                             border: Border.all(color: Colors.black26),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 6),
//                             child: TextFormField(
//                               decoration: const InputDecoration(
//                                   hintText: 'Enter Received Quantity',
//                                   border: InputBorder.none),
//                               controller: receivedQuantityController,
//                               onSaved: (value) {
//                                 batchPlanDetails['Received_Quantity'] = value!;
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   receivedQuantityValidation == true
//                       ? const SizedBox()
//                       : ModularWidgets.validationDesign(
//                           size, receivedQuantityValidationMessage),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: formWidth,
//                               padding: const EdgeInsets.only(bottom: 12),
//                               child: const Text('Hatch Date'),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: size.width * 0.23,
//                               height: 36,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: Colors.white,
//                                 border: Border.all(color: Colors.black26),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 6),
//                                 child: TextFormField(
//                                   controller: hatchDateController,
//                                   decoration: const InputDecoration(
//                                       hintText: 'Choose hatch date',
//                                       border: InputBorder.none),
//                                   enabled: false,
//                                   // onSaved: (value) {
//                                   //   batchPlanDetails[
//                                   //       'Required_Date_Of_Delivery'] = value!;
//                                   // },
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                                 onPressed: _hatchDatePicker,
//                                 icon: Icon(
//                                   Icons.date_range_outlined,
//                                   color: ProjectColors.themecolor,
//                                 ))
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   hatchDateValidation == true
//                       ? const SizedBox()
//                       : ModularWidgets.validationDesign(
//                           size, hatchDateValidationMessage),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: formWidth,
//                               padding: const EdgeInsets.only(bottom: 12),
//                               child: const Text('Receipt Date'),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: size.width * 0.23,
//                               height: 36,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: Colors.white,
//                                 border: Border.all(color: Colors.black26),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 6),
//                                 child: TextFormField(
//                                   controller: dateController,
//                                   decoration: const InputDecoration(
//                                       hintText: 'Choose Receipt Date',
//                                       border: InputBorder.none),
//                                   enabled: false,
//                                   // onSaved: (value) {
//                                   //   batchPlanDetails[
//                                   //       'Required_Date_Of_Delivery'] = value!;
//                                   // },
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                                 onPressed: _datePicker,
//                                 icon: Icon(
//                                   Icons.date_range_outlined,
//                                   color: ProjectColors.themecolor,
//                                 ))
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   requiredDateOfDeliveryValidation == true
//                       ? const SizedBox()
//                       : ModularWidgets.validationDesign(
//                           size, requiredDateOfDeliveryValidationMessage),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(top: 24.0),
//                   //   child: Column(
//                   //     mainAxisAlignment: MainAxisAlignment.start,
//                   //     children: [
//                   //       Container(
//                   //         width: formWidth,
//                   //         padding: const EdgeInsets.only(bottom: 12),
//                   //         child: const Text('Description'),
//                   //       ),
//                   //       Container(
//                   //         width: formWidth,
//                   //         height: 80,
//                   //         decoration: BoxDecoration(
//                   //           borderRadius: BorderRadius.circular(8),
//                   //           color: Colors.white,
//                   //           border: Border.all(color: Colors.black26),
//                   //         ),
//                   //         child: Padding(
//                   //           padding: const EdgeInsets.symmetric(
//                   //               horizontal: 12, vertical: 6),
//                   //           child: TextFormField(
//                   //             decoration: const InputDecoration(
//                   //                 hintText: 'Description',
//                   //                 border: InputBorder.none),
//                   //             validator: (value) {},
//                   //             onSaved: (value) {
//                   //               batchPlanDetails['Description'] = value!;
//                   //             },
//                   //           ),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   Consumer<BatchApis>(builder: (context, value, child) {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: value.batchPlanException.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return ModularWidgets.exceptionDesign(
//                             MediaQuery.of(context).size,
//                             value.batchPlanException[index]);
//                       },
//                     );
//                   }),
//                   widget.editData.isEmpty
//                       ? ModularWidgets.globalAddDetailsDialog(size, save)
//                       : ModularWidgets.globalUpdateDetailsDialog(size, save),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
