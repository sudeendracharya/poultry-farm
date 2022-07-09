import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/batch_plan/providers/batch_plan_apis.dart';
import 'package:poultry_login_signup/batch_plan/widgets/add_batch_plan_details_dialog.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/planning/screens/batch_plan_details_page.dart';
import 'package:poultry_login_signup/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../../providers/apicalls.dart';
import '../../widgets/administration_search_widget.dart';

class BatchPlanningPage extends StatefulWidget {
  BatchPlanningPage({Key? key}) : super(key: key);

  @override
  State<BatchPlanningPage> createState() => _BatchPlanningPageState();
}

class _BatchPlanningPageState extends State<BatchPlanningPage> {
  String query = '';

  List list = [];

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BatchApis>(context, listen: false).getBatchPlan(token);
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

  bool loading = true;

  @override
  void initState() {
    getPermission();
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BatchApis>(context, listen: false).getBatchPlan(token);
      }
      reFresh();
    });

    super.initState();
  }

  void reFresh() {
    setState(() {
      loading = false;
    });
  }

  int defaultRowsPerPage = 5;
  List batchDetails = [];

  void delete() {
    if (selectedBatchCodes.isEmpty) {
      alertSnackBar('Select the checkbox first');
    } else {
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<BatchApis>(context, listen: false)
              .deleteBatchPlanStepOne(selectedBatchCodes, token);
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

  var extratedBatchPlanningPermissions;

  Future<void> getPermission() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('Batch_Planning')) {
      extratedBatchPlanningPermissions = {
        'Id': 'Transfer In',
        'Edit': false,
        'View': false,
        'Create': false,
        'Delete': false
      };
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('Batch_Planning')!) as Map<String, dynamic>;

    extratedBatchPlanningPermissions = extratedUserData['Batch_Planning'];
    // print(extratedBatchPlanningPermissions);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    batchDetails = Provider.of<BatchApis>(context).batchPlan;
    return loading == true
        ? const Center(
            child: Text('Loading'),
          )
        : extratedBatchPlanningPermissions['View'] == false
            ? const SizedBox(
                child: Center(
                  child: Text('You don\'t have access to view this page'),
                ),
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
                      'Batch Planning',
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
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          extratedBatchPlanningPermissions['Create'] == true
                              ? IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) =>
                                            AddBatchPlanDetailsDialog(
                                              editData: {},
                                              id: '',
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
                          // IconButton(
                          //   onPressed: delete,
                          //   icon: const Icon(Icons.delete),
                          // ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        width: size.width * 0.6,
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
                            DataColumn(
                                label: Text('Activity Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Vaccination Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Medication Code',
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
          print(selectedBatchCodes);
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

                Get.toNamed(BatchPlanDetailsPage.routeName);
              },
              child: Text(data[index]['Batch_Code']))),
          DataCell(Text(data[index]['Breed_Id'].toString())),
          DataCell(Text(data[index]['Activity_Code'].toString())),
          DataCell(Text(data[index]['Vaccination_Code'].toString())),
          DataCell(Text(data[index]['Medication_Code'].toString())),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
