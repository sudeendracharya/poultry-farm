import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/infrastructure/screens/warehouse_details_screen.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';

import 'package:poultry_login_signup/widgets/administration_search_widget.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/add_warehouse_details.dart';

class WareHouseManagementPage extends StatefulWidget {
  WareHouseManagementPage({Key? key}) : super(key: key);

  @override
  _WareHouseManagementPageState createState() =>
      _WareHouseManagementPageState();
}

class _WareHouseManagementPageState extends State<WareHouseManagementPage> {
  List firmList = [];

  List plantList = [];

  var firmId;

  var plantId;

  List wareHouseDetailsList = [];

  var _plantId;

  var _firmId;

  var _storedPlantId;

  List list = [];

  @override
  void initState() {
    super.initState();

    getFirmData().then((value) {
      fechplantList(firmId);
      // fechWareHouseList(_storedPlantId);
    });
  }

  var query = '';

  Future<void> getFirmData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('FirmAndPlantDetails')) {
      return;
    }
    final extratedUserData =
        json.decode(prefs.getString('FirmAndPlantDetails')!)
            as Map<String, dynamic>;

    firmId = extratedUserData['FirmId'];
    // _storedPlantId = extratedUserData['PlantId'];
  }

  // Future<void> getFirmData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('FirmAndPlantDetails')) {
  //     return;
  //   }
  //   final extratedUserData =
  //       json.decode(prefs.getString('FirmAndPlantDetails')!)
  //           as Map<String, dynamic>;

  //   _firmId = extratedUserData['FirmId'];
  // }

  void fechplantList(int id) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getPlantDetails(
            token,
            id,
          )
          .then((value1) {});
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
          .then((value1) {
        temp.clear();
      });
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
    });
  }

  void refresh(int data) {
    getFirmData().then((value) {
      fechWareHouseList(_storedPlantId);
    });
  }

  List temp = [];
  void selectedIds(Map<String, dynamic> data) {
    if (data['Selected'] == true) {
      temp.add(data['Id']);
    } else {
      temp.remove(data['Id']);
    }
  }

  void deleteWareHouse(List wareHouseIds) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .deleteWareHouseDetails(
        wareHouseIds,
        token,
      )
          .then((value1) {
        if (value1 == 204 || value1 == 203) {
          temp.clear();
          refresh(100);
          successSnackbar('Successfully deleted the warehouse');
        } else {
          temp.clear();
          refresh(100);
          failureSnackbar(
              'Something went wrong unable to delete the warehouse');
        }
      });
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
    });
  }

  void searchBook(String query) {
    final searchOutput = wareHouseDetailsList.where((details) {
      final wareHouseCode = details['WareHouse_Code'];
      final wareHouseName = details['WareHouse_Name'].toString().toLowerCase();
      final searchName = query.toLowerCase();

      return wareHouseCode.contains(searchName) ||
          wareHouseName.contains(searchName);
    }).toList();

    setState(() {
      this.query = query;
      list = searchOutput;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var halfWidth = size.width / 2;
    firmList = Provider.of<InfrastructureApis>(
      context,
    ).firmDetails;
    plantList = Provider.of<InfrastructureApis>(
      context,
    ).plantDetails;
    wareHouseDetailsList = Provider.of<InfrastructureApis>(
      context,
    ).warehouseDetails;
    if (query == '') {
      list = wareHouseDetailsList;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Warehouse Management',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
              ),
            ),
            Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Container(
                          width: 253,
                          child: AdministrationSearchWidget(
                              search: (value) {},
                              reFresh: (value) {},
                              text: query,
                              onChanged: searchBook,
                              hintText: 'Warehouse Name'),
                        ),
                        const SizedBox(width: 10),
                        // Container(
                        //   width: 350,
                        //   child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       const Text('Firm Name'),
                        //       Container(
                        //         width: 250,
                        //         child: Padding(
                        //           padding: const EdgeInsets.symmetric(
                        //               horizontal: 12, vertical: 6),
                        //           child: DropdownButtonHideUnderline(
                        //             child: DropdownButton(
                        //               value: firmId,
                        //               items: firmList
                        //                   .map<DropdownMenuItem<String>>((e) {
                        //                 return DropdownMenuItem(
                        //                   child: Text(e['Firm_Name']),
                        //                   value: e['Firm_Name'],
                        //                   onTap: () {
                        //                     fechplantList(e['Firm_Id']);
                        //                     plantId = null;
                        //                   },
                        //                 );
                        //               }).toList(),
                        //               hint: const Text('Choose Firm Name'),
                        //               onChanged: (value) {
                        //                 setState(() {
                        //                   firmId = value as String;
                        //                 });
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(width: 35),
                        Container(
                          width: 380,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Plant Name',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 250,
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, bottom: 2),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: plantId,
                                      items: plantList
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem(
                                          value: e['Plant_Name'],
                                          onTap: () {
                                            fechWareHouseList(e['Plant_Id']);
                                            _plantId = e['Plant_Id'];
                                          },
                                          child: Text(e['Plant_Name']),
                                        );
                                      }).toList(),
                                      hint: const Text('Choose plant Name'),
                                      onChanged: (value) {
                                        setState(() {
                                          plantId = value as String;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: size.width * 0.8,
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      showGlobalDrawer(
                          context: context,
                          builder: (ctx) => AddWareHouseDetails(
                                update: refresh,
                              ),
                          direction: AxisDirection.right);
                    },
                    icon: const Icon(Icons.add),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      deleteWareHouse(temp);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height / 2.52,
                  child: InteractiveViewer(
                    alignPanAxis: true,
                    constrained: false,
                    // panEnabled: false,
                    scaleEnabled: false,
                    child: DataTable(
                        showCheckboxColumn: true,
                        columnSpacing: width <= 1200
                            ? MediaQuery.of(context).size.width * 0.0520
                            : MediaQuery.of(context).size.width * 0.0520,
                        headingTextStyle: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                        columns: const <DataColumn>[
                          DataColumn(
                              label: Text(
                            'Warehouse Id',
                            textAlign: TextAlign.left,
                          )),
                          DataColumn(label: Text('Warehouse Name')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Sections')),
                          DataColumn(label: Text('Lines')),
                          DataColumn(label: Text('Sub Categories')),
                        ],
                        rows: <DataRow>[
                          for (var data in list)
                            DataRow(
                              selected: data['Selected'] ?? false,
                              onSelectChanged: (value) {
                                setState(() {
                                  data['Selected'] = value;
                                  if (value == true) {
                                    selectedIds({
                                      'Selected': true,
                                      'Id': data['WareHouse_Id']
                                    });
                                  } else {
                                    selectedIds({
                                      'Selected': false,
                                      'Id': data['WareHouse_Id']
                                    });
                                  }
                                });
                              },
                              cells: <DataCell>[
                                DataCell(TextButton(
                                    onPressed: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();

                                      final userData = json.encode(
                                        {
                                          'WareHouseId': data['WareHouse_Id'],
                                          // 'WareHouseName':
                                          //     data['WareHouse_Name'],
                                          // 'Category': data[
                                          //     'WareHouse_Category_Id__WareHouse_Category_Name'],
                                          // 'Sections': data[
                                          //     'warehouse_section__WareHouse_Section_Code'],
                                          // 'Lines': data[
                                          //     'warehouse_section__WareHouse_Section_Number_Of_Lines'],
                                          // 'SubCategory': data[
                                          //     'WareHouse_Sub_Category_Id__WareHouse_Sub_Category_Name'],
                                          // 'WareHouseCode':
                                          //     data['WareHouse_Code'],
                                          // 'PlantName': data[
                                          //     'WareHouse_Plant_Id__Plant_Name'],
                                          // 'WareHouseDescription':
                                          //     data['Description'],
                                          // 'WareHouseCategoryDescription': data[
                                          //     'WareHouse_Category_Id__Description'],
                                          // 'WareHouseSubCategoryDescription': data[
                                          //     'WareHouse_Sub_Category_Id__Description'],
                                          // 'WareHouseCategoryId': data[
                                          //     'WareHouse_Category_Id__WareHouse_Category_Id'],
                                          // 'WareHouseSubCategoryId': data[
                                          //     'WareHouse_Sub_Category_Id__WareHouse_Sub_Category_Id'],
                                          // 'PlantId': _plantId,
                                        },
                                      );
                                      prefs.setString(
                                          'WareHouseDetails', userData);
                                      Get.toNamed(
                                          WareHouseDetailsScreen.routeName);
                                    },
                                    child: Text(
                                        data['WareHouse_Code'].toString()))),
                                DataCell(Text(data['WareHouse_Name'])),
                                DataCell(Text(data[
                                    'WareHouse_Category_Id__WareHouse_Category_Name'])),

                                data['warehouse_section__WareHouse_Section_Code'] ==
                                        null
                                    ? const DataCell(Text(''))
                                    : DataCell(Text(data[
                                            'warehouse_section__WareHouse_Section_Code']
                                        .toString())),
                                data['warehouse_section__WareHouse_Section_Number_Of_Lines'] ==
                                        null
                                    ? const DataCell(Text(''))
                                    : DataCell(Text(data[
                                            'warehouse_section__WareHouse_Section_Number_Of_Lines']
                                        .toString())),
                                DataCell(Text(data[
                                    'WareHouse_Sub_Category_Id__WareHouse_Sub_Category_Name'])),

                                // DataCell(
                                //   // TextButton(
                                //   //   onPressed: () async {
                                //   //     final prefs =
                                //   //         await SharedPreferences
                                //   //             .getInstance();
                                //   //     // final userData = json.encode(
                                //   //     //   {
                                //   //     //     'plantName': _plantName,
                                //   //     //     'batchName':
                                //   //     //         data['Batch_Code'],
                                //   //     //     'grading': data['Grading'],
                                //   //     //     'productionRate':
                                //   //     //         data['Production_Rate'],
                                //   //     //     'feedConsumptionRate': data[
                                //   //     //         'Feed_Consumption_Rate'],
                                //   //     //     'mortalityRate':
                                //   //     //         data['Mortality_Rate'],
                                //   //     //     'wareHouseCode':
                                //   //     //         data['WareHouse_Code']
                                //   //     //   },
                                //   //     // );
                                //   //     // prefs.setString(
                                //   //     //     'batchDetails', userData);

                                //   //   },
                                //   //   child:
                                //   // ),
                                // ),
                              ],
                            ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
