// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:poultry_login_signup/providers/apicalls.dart';
// import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
// import 'package:poultry_login_signup/widgets/failure_dialog.dart';
// import 'package:poultry_login_signup/widgets/success_dialog.dart';
// import 'package:provider/provider.dart';

// import '../widgets/add_warehouse_section.dart';

// // import '/widgets/add_warehouse_section.dart';

// class WareHouseSectionScreen extends StatefulWidget {
//   WareHouseSectionScreen({Key? key}) : super(key: key);
//   static const routeName = '/WarehouseSection';

//   @override
//   _WareHouseSectionScreenState createState() => _WareHouseSectionScreenState();
// }

// class _WareHouseSectionScreenState extends State<WareHouseSectionScreen> {
//   List wareHouseSection = [];
//   @override
//   void initState() {
//     Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
//       var token = Provider.of<Apicalls>(context, listen: false).token;
//       Provider.of<InfrastructureApis>(context, listen: false)
//           .getWareHouseSectionDetails(01, token)
//           .then((value1) {});
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     wareHouseSection = Provider.of<InfrastructureApis>(
//       context,
//     ).warehouseSection;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ware House Section'),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Get.toNamed(
//                   AddWareHouseSection.routeName,
//                 );
//               },
//               icon: const Icon(Icons.add))
//         ],
//       ),
//       body: Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width / 2,
//           child: ListView.builder(
//             itemCount: wareHouseSection.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Card(
//                 elevation: 10,
//                 child: ListTile(
//                   title:
//                       Text(wareHouseSection[index]['WareHouse_Section_Code']),
//                   // subtitle: Text(wareHouseCategoryDetails[index]['Plant_Code']),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                           onPressed: () {
//                             // Navigator.of(context).pushNamed(
//                             //     AddWareHouseSection.routeName,
//                             //     arguments: wareHouseSection[index]);
//                             Get.toNamed(AddWareHouseSection.routeName,
//                                 arguments: wareHouseSection[index]);
//                           },
//                           icon: const Icon(Icons.edit)),
//                       IconButton(
//                           onPressed: () {
//                             Provider.of<Apicalls>(context, listen: false)
//                                 .tryAutoLogin()
//                                 .then((value) {
//                               var token =
//                                   Provider.of<Apicalls>(context, listen: false)
//                                       .token;
//                               Provider.of<InfrastructureApis>(context,
//                                       listen: false)
//                                   .deleteWareHouseSectionDetails(
//                                       wareHouseSection[index]
//                                           ['WareHouse_Section_Id'],
//                                       token)
//                                   .then((value) {
//                                 if (value == 200 || value == 201) {
//                                   showDialog(
//                                       context: context,
//                                       builder: (ctx) => SuccessDialog(
//                                           title: 'Success',
//                                           subTitle:
//                                               'SuccessFully Added Ware House Section Details'));
//                                 } else {
//                                   showDialog(
//                                       context: context,
//                                       builder: (ctx) => FailureDialog(
//                                           title: 'Failed',
//                                           subTitle:
//                                               'Something Went Wrong Please Try Again'));
//                                 }
//                               });
//                             });
//                           },
//                           icon: const Icon(Icons.delete)),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
