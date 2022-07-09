// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:poultry_login_signup/providers/activity_plan/activity_plan_apis.dart';
// import 'package:poultry_login_signup/providers/apicalls.dart';
// import 'package:poultry_login_signup/providers/batch_plan/batch_plan_apis.dart';
// import 'package:poultry_login_signup/providers/breed_info/breed_info_apicalls.dart';
// import 'package:poultry_login_signup/providers/infrastructure/infrastructure_apicalls.dart';
// import 'package:provider/provider.dart';

// import '../failure_dialog.dart';
// import '../success_dialog.dart';

// class AddBatchPlanDetails extends StatefulWidget {
//   AddBatchPlanDetails({Key? key}) : super(key: key);
//   static const routeName = '/AddBatchPlanDetails';
//   @override
//   _AddBatchPlanDetailsState createState() => _AddBatchPlanDetailsState();
// }

// class _AddBatchPlanDetailsState extends State<AddBatchPlanDetails> {
//   final GlobalKey<FormState> _formKey = GlobalKey();

//   EdgeInsetsGeometry getPadding() {
//     return const EdgeInsets.only(left: 8.0);
//   }

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

//   Map<String, dynamic> batchPlanDetails = {
//     'Plant_Id': null,
//     'Ware_House_Id': null,
//     'Breed_Id': null,
//     'Bird_Age_Id'
//         'Activity_Id': null,
//     'Medication_Plan_Id': null,
//     'Vaccination_Plan_Id': null,
//     'Batch_Code': null,
//   };

//   void initState() {
//     super.initState();
//     Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
//       var token = Provider.of<Apicalls>(context, listen: false).token;
//       Provider.of<InfrastructureApis>(context, listen: false)
//           .getWarehouseDetails(token)
//           .then((value1) {});
//       // Provider.of<InfrastructureApis>(context, listen: false)
//       //     .getPlantDetails(token)
//       //     .then((value1) {});
//       Provider.of<BreedInfoApis>(context, listen: false)
//           .getBreedInfo(token)
//           .then((value1) {});
//       Provider.of<BreedInfoApis>(context, listen: false)
//           .getBirdAgeGroup(token)
//           .then((value1) {});
//       Provider.of<ActivityApis>(context, listen: false)
//           .getMedicationHeader(token)
//           .then((value1) {});
//       Provider.of<ActivityApis>(context, listen: false)
//           .getActivityHeader(token)
//           .then((value1) {});

//       Provider.of<ActivityApis>(context, listen: false)
//           .getVaccinationHeader(token)
//           .then((value1) {});
//     });

//     Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
//       var token = Provider.of<Apicalls>(context, listen: false).token;
//     });
//   }

//   void save() {
//     var isValid = _formKey.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
//     _formKey.currentState!.save();

//     Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
//       var token = Provider.of<Apicalls>(context, listen: false).token;
//       Provider.of<BatchApis>(context, listen: false)
//           .addBatchPlan(batchPlanDetails, token)
//           .then((value) {
//         if (value == 200 || value == 201) {
//           showDialog(
//               context: context,
//               builder: (ctx) => SuccessDialog(
//                   title: 'Success', subTitle: 'SuccessFully Added Batch Plan'));
//           _formKey.currentState!.reset();
//         } else {
//           showDialog(
//               context: context,
//               builder: (ctx) => FailureDialog(
//                   title: 'Failed',
//                   subTitle: 'Something Went Wrong Please Try Again'));
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     plantDetails = Provider.of<InfrastructureApis>(
//       context,
//     ).plantDetails;
//     wareHouseDetails = Provider.of<InfrastructureApis>(
//       context,
//     ).warehouseDetails;
//     breedInfo = Provider.of<BreedInfoApis>(context).breedInfo;
//     activityHeaderData = Provider.of<ActivityApis>(context).activityHeader;
//     medicationHeaderData = Provider.of<ActivityApis>(context).medicationHeader;
//     vaccinationHeaderData =
//         Provider.of<ActivityApis>(context).vaccinationHeader;
//     birdAgeGroup = Provider.of<BreedInfoApis>(
//       context,
//     ).birdAgeGroup;
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 85),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         'Batch Planning',
//                         style: GoogleFonts.roboto(
//                             textStyle: TextStyle(
//                                 color: Theme.of(context).backgroundColor,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 36)),
//                       )
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 36.0),
//                     child: Row(
//                       children: const [
//                         Text(
//                           'Add Batch Planning',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w700, fontSize: 18),
//                         )
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 440,
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: const Text('Plant Name'),
//                           ),
//                           Container(
//                             width: 440,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black26),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               child: DropdownButtonHideUnderline(
//                                 child: DropdownButton(
//                                   value: plantName,
//                                   items: plantDetails
//                                       .map<DropdownMenuItem<String>>((e) {
//                                     return DropdownMenuItem(
//                                       child: Text(e['WareHouse_Code']),
//                                       value: e['WareHouse_Code'],
//                                       onTap: () {
//                                         // firmId = e['Firm_Code'];
//                                         batchPlanDetails['Ware_House_Id'] =
//                                             e['WareHouse_Id'];
//                                       },
//                                     );
//                                   }).toList(),
//                                   hint: const Text('Choose plant Name'),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       plantName = value as String;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 440,
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: const Text('Bird Age Group'),
//                           ),
//                           Container(
//                             width: 440,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black26),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               child: DropdownButtonHideUnderline(
//                                 child: DropdownButton(
//                                   value: birdName,
//                                   items: birdAgeGroup
//                                       .map<DropdownMenuItem<String>>((e) {
//                                     return DropdownMenuItem(
//                                       child: Text(e['Name']),
//                                       value: e['Name'],
//                                       onTap: () {
//                                         // firmId = e['Firm_Code'];
//                                         batchPlanDetails['Ware_House_Id'] =
//                                             e['WareHouse_Id'];
//                                       },
//                                     );
//                                   }).toList(),
//                                   hint:
//                                       const Text('Please Choose wareHouse Id'),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       birdName = value as String;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 440,
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: const Text('Ware house Id'),
//                           ),
//                           Container(
//                             width: 440,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black26),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               child: DropdownButtonHideUnderline(
//                                 child: DropdownButton(
//                                   value: wareHouseId,
//                                   items: wareHouseDetails
//                                       .map<DropdownMenuItem<String>>((e) {
//                                     return DropdownMenuItem(
//                                       child: Text(e['WareHouse_Code']),
//                                       value: e['WareHouse_Code'],
//                                       onTap: () {
//                                         // firmId = e['Firm_Code'];
//                                         batchPlanDetails['Ware_House_Id'] =
//                                             e['WareHouse_Id'];
//                                       },
//                                     );
//                                   }).toList(),
//                                   hint:
//                                       const Text('Please Choose wareHouse Id'),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       wareHouseId = value as String;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 440,
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: const Text('Breed Name'),
//                           ),
//                           Container(
//                             width: 440,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black26),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               child: DropdownButtonHideUnderline(
//                                 child: DropdownButton(
//                                   value: breedName,
//                                   items: breedInfo
//                                       .map<DropdownMenuItem<String>>((e) {
//                                     return DropdownMenuItem(
//                                       child: Text(e['Breed_Name']),
//                                       value: e['Breed_Name'],
//                                       onTap: () {
//                                         // firmId = e['Firm_Code'];
//                                         batchPlanDetails['Breed_Id'] =
//                                             e['Breed_Id'].toString();
//                                       },
//                                     );
//                                   }).toList(),
//                                   hint: const Text('Please Choose Breed Id'),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       breedName = value as String;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 440,
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: const Text('Breed Version'),
//                           ),
//                           Container(
//                             width: 440,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black26),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               child: DropdownButtonHideUnderline(
//                                 child: DropdownButton(
//                                   value: breedName,
//                                   items: breedInfo
//                                       .map<DropdownMenuItem<String>>((e) {
//                                     return DropdownMenuItem(
//                                       child: Text(e['Breed_Name']),
//                                       value: e['Breed_Name'],
//                                       onTap: () {
//                                         // firmId = e['Firm_Code'];
//                                         batchPlanDetails['Breed_Id'] =
//                                             e['Breed_Id'].toString();
//                                       },
//                                     );
//                                   }).toList(),
//                                   hint:
//                                       const Text('Please Choose Breed version'),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       breedName = value as String;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 440,
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: const Text('Medication Plan'),
//                           ),
//                           Container(
//                             width: 440,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black26),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               child: DropdownButtonHideUnderline(
//                                 child: DropdownButton(
//                                   value: medicationId,
//                                   items: medicationHeaderData
//                                       .map<DropdownMenuItem<String>>((e) {
//                                     return DropdownMenuItem(
//                                       child: Text(e['Recommended_By']),
//                                       value: e['Recommended_By'],
//                                       onTap: () {
//                                         // firmId = e['Firm_Code'];
//                                         batchPlanDetails['Medication_Plan_Id'] =
//                                             e['Medication_Id'].toString();
//                                             'Medication_Plan_Id']);
//                                       },
//                                     );
//                                   }).toList(),
//                                   hint: const Text('Choose Medication name'),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       medicationId = value as String;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 440,
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: const Text('Vaccination Plan'),
//                           ),
//                           Container(
//                             width: 440,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black26),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               child: DropdownButtonHideUnderline(
//                                 child: DropdownButton(
//                                   value: vaccinationId,
//                                   items: vaccinationHeaderData
//                                       .map<DropdownMenuItem<String>>((e) {
//                                     return DropdownMenuItem(
//                                       child: Text(e['Recommended_By']),
//                                       value: e['Recommended_By'],
//                                       onTap: () {
//                                         // firmId = e['Firm_Code'];
//                                         batchPlanDetails[
//                                                 'Vaccination_Plan_Id'] =
//                                             e['Vaccination_Id'].toString();
//                                             'Vaccination_Plan_Id']);
//                                       },
//                                     );
//                                   }).toList(),
//                                   hint: const Text('Choose Vaccination Name'),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       vaccinationId = value as String;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 440,
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: const Text('Required Quantity'),
//                           ),
//                           Container(
//                             width: 440,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black26),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               child: TextFormField(
//                                 decoration: const InputDecoration(
//                                     labelText: 'Enter Required Quantity',
//                                     border: InputBorder.none),
//                                 validator: (value) {},
//                                 onSaved: (value) {
//                                   batchPlanDetails['Required_Quantity'] =
//                                       value!;
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 440,
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: const Text('Required Date Of Delivery'),
//                           ),
//                           Container(
//                             width: 440,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black26),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               child: TextFormField(
//                                 decoration: const InputDecoration(
//                                     labelText:
//                                         'Enter Required Date Of Delivery',
//                                     border: InputBorder.none),
//                                 validator: (value) {},
//                                 onSaved: (value) {
//                                   batchPlanDetails[
//                                       'Required_Date_Of_Delivery'] = value!;
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 440,
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: const Text('Description'),
//                           ),
//                           Container(
//                             width: 440,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black26),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               child: TextFormField(
//                                 decoration: const InputDecoration(
//                                     labelText: 'Description',
//                                     border: InputBorder.none),
//                                 validator: (value) {},
//                                 onSaved: (value) {
//                                   batchPlanDetails['Description'] = value!;
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 24.0),
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             width: 440,
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: const Text('Batch Code'),
//                           ),
//                           Container(
//                             width: 440,
//                             height: 36,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: Colors.white,
//                               border: Border.all(color: Colors.black26),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               child: TextFormField(
//                                 decoration: const InputDecoration(
//                                     labelText: 'Enter Batch Code',
//                                     border: InputBorder.none),
//                                 validator: (value) {},
//                                 onSaved: (value) {
//                                   batchPlanDetails['Batch_Code'] = value!;
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 25.0),
//                     child: ElevatedButton(
//                         onPressed: save, child: const Text('Save')),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
