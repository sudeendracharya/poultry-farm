import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/inventory_adjustment/providers/inventory_adjustement_apis.dart';
import 'package:poultry_login_signup/inventory_adjustment/widgets/add_egg_grading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../batch_plan/providers/batch_plan_apis.dart';
import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';

class EggGrading extends StatefulWidget {
  EggGrading({Key? key}) : super(key: key);

  @override
  State<EggGrading> createState() => _EggGradingState();
}

class _EggGradingState extends State<EggGrading> {
  String query = '';

  List list = [];

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .getEggGrading(token)
            .then((value) {
          selectedEggGradingData.clear();
          finalSelectedEggGradinglist.clear();
        });
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
    getPermission('Egg_Grading').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .getEggGrading(token);
      }
    });
    super.initState();
  }

  int defaultRowsPerPage = 5;
  List eggGradingDetails = [];
  List finalSelectedEggGradinglist = [];

  void delete() {
    if (selectedEggGradingData.isEmpty) {
      alertSnackBar('Select the checkbox first');
    } else {
      for (var data in selectedEggGradingData) {
        finalSelectedEggGradinglist.add(
          data['Grading_Record_Id'],
        );
      }
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<InventoryAdjustemntApis>(context, listen: false)
              .deleteEggGrading(finalSelectedEggGradinglist, token)
              .then((value) {
            if (value == 204) {
              successSnackbar('Successfully deleted the data');
              update(100);
            } else {
              failureSnackbar('Unabel to edit the data something went wrong');
            }
          });
        }
      });
    }
  }

  void searchBook(String query) {
    final searchOutput = eggGradingDetails.where((details) {
      final batchCode = details['Batch_Id'].toString();

      final searchName = query;

      return batchCode.contains(searchName);
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
    eggGradingDetails =
        Provider.of<InventoryAdjustemntApis>(context).eggGradingList;
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
                      'Egg Grading',
                      style: ProjectStyles.contentHeaderStyle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
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
                                        builder: (ctx) => AddEggGrading(
                                              reFresh: update,
                                              editData: const {},
                                            ),
                                        direction: AxisDirection.right);
                                  },
                                  icon: const Icon(Icons.add),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          extratedPermissions['Edit'] == false
                              ? const SizedBox()
                              : selectedEggGradingData.length == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showGlobalDrawer(
                                            context: context,
                                            builder: (ctx) => AddEggGrading(
                                                  reFresh: update,
                                                  editData:
                                                      selectedEggGradingData[0],
                                                ),
                                            direction: AxisDirection.right);
                                      },
                                      icon: const Icon(Icons.edit),
                                    )
                                  : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          extratedPermissions['Delete'] == true
                              ? IconButton(
                                  onPressed: delete,
                                  icon: const Icon(Icons.delete),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        width: size.width * 0.7,
                        child: PaginatedDataTable(
                          source: MySearchData(
                              query == '' ? eggGradingDetails : list,
                              updateCheckBox),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: [
                            // DataColumn(
                            //     label: Text('Grading Record Code',
                            //         style: ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Batch Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Grading Date',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('WareHouse Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Location',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Grade From',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Grade To',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Unit',
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
                          columnSpacing: 30,
                          //  horizontalMargin: 10,
                          rowsPerPage: defaultRowsPerPage,
                          showCheckboxColumn: true,
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

List selectedEggGradingData = [];

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
          if (selectedEggGradingData.isEmpty) {
            selectedEggGradingData.add(data[index]);
          } else {
            if (value == true) {
              selectedEggGradingData.add(data[index]);
            } else {
              selectedEggGradingData.remove(data[index]);
            }
          }
          // print(selectedEggGradingData);
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(
            Text(
              data[index]['Batch_Id'].toString(),
            ),
          ),
          DataCell(
            Text(
              DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(data[index]['Grading_Date'])),
            ),
          ),
          DataCell(
            Text(
              data[index]['WareHouse_Id'].toString(),
            ),
          ),
          DataCell(
            Text(
              data[index]['Location'].toString(),
            ),
          ),
          DataCell(
            Text(
              data[index]['From'].toString(),
            ),
          ),
          DataCell(
            Text(
              data[index]['To'].toString(),
            ),
          ),
          DataCell(
            Text(
              data[index]['Unit'].toString(),
            ),
          ),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
