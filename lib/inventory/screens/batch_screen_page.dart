import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/inventory/providers/inventory_api.dart';
import 'package:poultry_login_signup/inventory/screens/inventory_batch_details_page.dart';
import 'package:poultry_login_signup/inventory/widgets/add_batch_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';

class BatchScreenPage extends StatefulWidget {
  BatchScreenPage({Key? key}) : super(key: key);

  @override
  State<BatchScreenPage> createState() => _BatchScreenPageState();
}

class _BatchScreenPageState extends State<BatchScreenPage> {
  String query = '';

  List list = [];

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<InventoryApi>(context, listen: false).getBatch(token);
      }
    });
  }

  void updateCheckBox(int data) {
    setState(() {});
  }

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

  var extratedPermissions;
  bool loading = true;
  @override
  void initState() {
    getPermission('Add_Batch').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<InventoryApi>(context, listen: false).getBatch(token);
      }
    });
    super.initState();
  }

  int defaultRowsPerPage = 5;
  List batchDetails = [];

  void delete() {
    if (selectedBatchCodes.isEmpty) {
      alertSnackBar('Select the checkbox first');
    } else {
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<InventoryApi>(context, listen: false)
              .deleteBatch(selectedBatchCodes, token)
              .then((value) {
            if (value == 204) {
              successSnackbar('Succesfully deleted the data');
              update(100);
            } else {
              failureSnackbar('Something went wrong unable to delete the data');
            }
          });
        }
      });
    }
  }

  void searchBook(String query) {
    final searchOutput = batchDetails.where((details) {
      final batchCode = details['Batch_Code'];
      final breedName = details['Breed_Id'];

      final searchName = query;

      return batchCode.contains(searchName) || breedName.contains(searchName);
    }).toList();

    setState(() {
      this.query = query;
      list = searchOutput;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    batchDetails = Provider.of<InventoryApi>(context).batchDetails;
    return loading == true
        ? const SizedBox()
        : extratedPermissions['View'] == false
            ? SizedBox(
                width: width,
                height: size.height * 0.5,
                child: viewPermissionDenied(),
              )
            : SizedBox(
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 34,
                    ),
                    Text(
                      'Batch',
                      style: ProjectStyles.contentHeaderStyle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                        width: 253,
                        child: AdministrationSearchWidget(
                            search: (value) {},
                            reFresh: (value) {},
                            text: query,
                            onChanged: searchBook,
                            hintText: 'Search'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          extratedPermissions['Create'] == true
                              ? IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) => AddBatchScreen(
                                              editData: const {},
                                              reFresh: update,
                                            ),
                                        direction: AxisDirection.right);
                                  },
                                  icon: const Icon(Icons.add),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          // extratedPermissions['Delete'] == true
                          //     ? IconButton(
                          //         onPressed: delete,
                          //         icon: const Icon(Icons.delete),
                          //       )
                          //     : const SizedBox(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        width: size.width * 0.7,
                        child: PaginatedDataTable(
                          source: MySearchData(
                              query == '' ? batchDetails : list,
                              updateCheckBox),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: [
                            DataColumn(
                                label: Text('Batch Plan Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Breed Name',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            // DataColumn(
                            //     label: Text('Section Code',
                            //         style: ProjectStyles.paginatedHeaderStyle())),
                            // DataColumn(
                            //     label: Text('Line Code',
                            //         style: ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Activity Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            // DataColumn(
                            //     label: Text('Bird Age Group',
                            //         style: ProjectStyles.paginatedHeaderStyle())),
                            // DataColumn(
                            //     label: Text('Grade',
                            //         style: ProjectStyles.paginatedHeaderStyle())),
                            // DataColumn(
                            //     label: Text('Breed Name',
                            //         style: ProjectStyles.paginatedHeaderStyle())),
                            // DataColumn(
                            //     label: Text('Breed Version',
                            //         style: ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Medication Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Vaccination Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Status',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                          ],
                          onRowsPerPageChanged: (index) {
                            setState(() {
                              defaultRowsPerPage = index!;
                            });
                          },
                          availableRowsPerPage: const <int>[
                            3,
                            5,
                            10,
                            20,
                            40,
                            60,
                            80,
                          ],
                          columnSpacing: 20,
                          //  horizontalMargin: 10,
                          rowsPerPage: defaultRowsPerPage,
                          showCheckboxColumn: false,
                          // addEmptyRows: false,
                          checkboxHorizontalMargin: 30,
                          // onSelectAll: (value) {},
                          showFirstLastButtons: true,
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}

List selectedBatchCodes = [];

class MySearchData extends DataTableSource {
  final List<dynamic> data;
  final ValueChanged<int> reFresh;
  MySearchData(this.data, this.reFresh);

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(
        onSelectChanged: (value) {
          data[index]['Is_Selected'] = value;
          reFresh(100);
          if (selectedBatchCodes.isEmpty) {
            selectedBatchCodes.add(data[index]['Batch_Plan_Id']);
          } else {
            if (value == true) {
              selectedBatchCodes.add(data[index]['Batch_Plan_Id']);
            } else {
              selectedBatchCodes.remove(data[index]['Batch_Plan_Id']);
            }
          }
          // print(selectedBatchCodes.toSet());
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                if (prefs.containsKey('Batch_Plan_Id')) {
                  prefs.remove('Batch_Plan_Id');
                }
                final userData = json.encode(
                  {
                    'Batch_Plan_Id': data[index]['Batch_Plan_Id'],
                  },
                );
                prefs.setString('Batch_Plan_Id', userData);

                Get.toNamed(InventoryBatchDetailScreen.routeName);
              },
              child: Text(data[index]['Batch_Plan_Code'].toString()))),
          DataCell(Text(data[index]['Breed_Name'].toString())),
          DataCell(Text(data[index]['Activity_Code'].toString())),

          // DataCell(
          //   Text(
          //     DateFormat('dd-MM-yyyy')
          //         .format(DateTime.parse(data[index]['Hatch_Date'])),
          //   ),
          // ),

          // DataCell(Text(data[index]['Bird_Age_Id'].toString())),
          // DataCell(Text(data[index]['Grade'].toString())),
          // DataCell(Text(data[index]['Breed_Id'].toString())),
          // DataCell(Text(data[index]['Breed_Version_Id'].toString())),
          DataCell(Text(data[index]['Vaccination_Code'].toString())),
          DataCell(Text(data[index]['Medication_Code'].toString())),
          DataCell(Text(data[index]['Status'].toString())),
          // DataCell(
          //   Text(
          //     DateFormat('dd-MM-yyyy')
          //         .format(DateTime.parse(data[index]['Receipt_Date'])),
          //   ),
          // ),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
