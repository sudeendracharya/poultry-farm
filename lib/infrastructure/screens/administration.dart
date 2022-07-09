import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';

import 'package:poultry_login_signup/widgets/administration_search_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/add_firm_details_dialog.dart';
import 'firm_details_page.dart';

class AdministrationPage extends StatefulWidget {
  AdministrationPage({Key? key}) : super(key: key);

  @override
  _AdministrationPageState createState() => _AdministrationPageState();
}

class _AdministrationPageState extends State<AdministrationPage> {
  List firmDetails = [];
  var selected = false;

  var selectedFirmId;

  var _firmId;

  List list = [];
  @override
  void initState() {
    getPermission();
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getFirmDetails(token)
          .then((value1) {});
    });
    // getFirmData().then((value) {
    //   Provider.of<Apicalls>(context, listen: false)
    //       .tryAutoLogin()
    //       .then((value) {
    //     var token = Provider.of<Apicalls>(context, listen: false).token;
    //     Provider.of<InfrastructureApis>(context, listen: false)
    //         .getSingleFirmDetails(_firmId, token)
    //         .then((value1) {});
    //   });
    // });

    super.initState();
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

    _firmId = extratedUserData['FirmId'];
  }

  void delete() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .deleteFirmDetails(selectedFirmId, token)
          .then((value1) {
        if (value1 == 204) {
          Provider.of<InfrastructureApis>(context, listen: false)
              .getFirmDetails(token)
              .then((value1) {});
        } else {}
      });
    });
  }

  void update(int data) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getFirmDetails(token)
          .then((value1) {});
    });
  }

  void searchBook(String query) {
    final searchOutput = firmDetails.where((customer) {
      final firmName = customer['Firm_Name'];

      final searchName = query.toLowerCase();

      return firmName.contains(searchName);
    }).toList();

    setState(() {
      this.query = query;
      list = searchOutput;
    });
  }

  List extratedPermissions = [];

  Future<void> getPermission() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('Firms')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('Firms')!) as Map<String, dynamic>;
    // print(extratedUserData);

    extratedPermissions = extratedUserData['Firms'];
  }

  @override
  Widget build(BuildContext context) {
    firmDetails = Provider.of<InfrastructureApis>(context).firmDetails;
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var halfWidth = MediaQuery.of(context).size.width / 2;
    if (query == '') {
      list = firmDetails;
    }
    // if (list.isNotEmpty) {
    //   if (extratedPermissions.isNotEmpty) {
    //     list.forEach((element) {

    //     });
    //   }
    // }
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Firms',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    width: 253,
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10),
                    //   border: Border.all(),
                    // ),
                    child: AdministrationSearchWidget(
                        search: (value) {},
                        reFresh: (value) {},
                        text: query,
                        onChanged: searchBook,
                        hintText: 'Search'),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.28,
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            // showDialog(
                            //     context: context,
                            //     builder: (ctx) => AddFirmDetailsDialog());
                            showGlobalDrawer(
                                context: context,
                                builder: (ctx) => AddFirmDetailsDialog(
                                      reFresh: update,
                                    ),
                                direction: AxisDirection.right);
                          },
                          icon: const Icon(Icons.add),
                        ),
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        // IconButton(
                        //   onPressed: () {
                        //     Get.toNamed(FirmDetailsPage.routeName);
                        //   },
                        //   icon: const Icon(Icons.edit),
                        // ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {
                            delete();
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  // decoration: BoxDecoration(border: Border.all()),
                  child: InteractiveViewer(
                    alignPanAxis: true,
                    constrained: false,
                    // panEnabled: false,
                    scaleEnabled: false,
                    child: DataTable(
                        onSelectAll: (value) {},
                        showCheckboxColumn: true,
                        columnSpacing: width <= 770 ? 45 : width * 0.09765625,
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
                            'Firm Name',
                            textAlign: TextAlign.left,
                          )),
                          DataColumn(label: Text('Plants')),
                          // DataColumn(label: Text('Users')),
                          // DataColumn(label: Text('Permissions')),
                        ],
                        rows: firmDetails.isEmpty
                            ? []
                            : <DataRow>[
                                for (var data in list)
                                  DataRow(
                                    key: UniqueKey(),
                                    selected: data['Is_Selected'],
                                    onSelectChanged: (value) {
                                      setState(() {
                                        data['Is_Selected'] = value!;
                                        selectedFirmId = data['Firm_Id'];
                                      });
                                    },
                                    cells: <DataCell>[
                                      DataCell(
                                        TextButton(
                                          onPressed: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            final userData = json.encode(
                                              {
                                                'firmId': data['Firm_Id'],
                                                'firmName': data['Firm_Name'],
                                                'firmCode': data['Firm_Code'],
                                                'email': data['Email_Id'],
                                                'pan': data[
                                                    'Permanent_Account_Number'],
                                                'contactNumber':
                                                    data['Firm_Contact_Number'],
                                                'alternateContactNumber': data[
                                                    'Firm_Alternate_Contact_Number']
                                              },
                                            );
                                            prefs.setString(
                                                'FirmDetails', userData);
                                            Get.offNamed(
                                                FirmDetailsPage.routeName,
                                                arguments: data['Firm_Id']);
                                          },
                                          child: Text(
                                            data['Firm_Name'].toString(),
                                          ),
                                        ),
                                      ),
                                      // DataCell(Text(data['Firm_Name'])),
                                      DataCell(Text(
                                        data['plant_detail__Plant_Name__count']
                                            .toString(),
                                      )),
                                      // const DataCell(
                                      //   Text('Users'),
                                      // ),
                                      // const DataCell(
                                      //   Text('Permissions'),
                                      // ),
                                    ],
                                  ),
                              ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class FirmDataSource extends DataGridSource {
//   FirmDataSource({required this.firmData});
//   List<DataGridRow> _dataGridRow = [];
//   List firmData = [];
//   var selected = false;

//   void updateDataGridRow() {
//     _dataGridRow = firmData
//         .map<DataGridRow>((e) => DataGridRow(cells: [
//               DataGridCell<int>(columnName: 'Selected', value: ),
//               DataGridCell<int>(columnName: 'Firm_Id', value: e['']),
//               DataGridCell<String>(columnName: 'Firm_Name', value: e['']),
//               DataGridCell<int>(columnName: 'Phone_Number', value: e['']),
//               DataGridCell(columnName: 'Plants', value: e['']),
//               DataGridCell(columnName: 'Batches', value: e[''])
//             ]))
//         .toList();
//   }

//   @override
//   List<DataGridRow> get rows => _dataGridRow;
//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {}
// }
