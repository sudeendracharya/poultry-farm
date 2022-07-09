import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/inventory_adjustment/widgets/add_egg_collection.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../batch_plan/providers/batch_plan_apis.dart';
import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../providers/inventory_adjustement_apis.dart';

class EggCollection extends StatefulWidget {
  EggCollection({Key? key}) : super(key: key);

  @override
  State<EggCollection> createState() => _EggCollectionState();
}

class _EggCollectionState extends State<EggCollection> {
  String query = '';

  List list = [];

  void update(int data) {
    selectedEggCollectionIds.clear();
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .getEggCollection(token);
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
    getPermission('Egg_Collection').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .getEggCollection(token);
      }
    });
    super.initState();
  }

  int defaultRowsPerPage = 5;
  List eggCollectionDetails = [];

  void delete() {
    if (selectedEggCollectionIds.isEmpty) {
      alertSnackBar('Select the checkbox first');
    } else {
      List temp = [];
      for (var data in selectedEggCollectionIds) {
        temp.add(data['Egg_Collection_Id']);
      }
      // print(temp);
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<InventoryAdjustemntApis>(context, listen: false)
              .deleteEggCollection(temp, token)
              .then((value) {
            if (value == 204) {
              update(100);
              successSnackbar('Successfully deleted the data');
            } else {
              failureSnackbar('Unable to delete the data please try again');
            }
          });
        }
      });
    }
  }

  void searchBook(String query) {
    final searchOutput = eggCollectionDetails.where((details) {
      final batchCode = details['WareHouse_Id'].toString();

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
    eggCollectionDetails =
        Provider.of<InventoryAdjustemntApis>(context).eggCollectionDetails;
    return loading == true
        ? const SizedBox()
        : extratedPermissions['View'] == false
            ? SizedBox(
                width: width,
                height: size.height * 0.5,
                child: viewPermissionDenied(),
              )
            : Container(
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 34,
                    ),
                    Text(
                      'Egg Collection',
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
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          extratedPermissions['Create'] == true
                              ? IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) => AddEggCollection(
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
                              : selectedEggCollectionIds.length == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showGlobalDrawer(
                                            context: context,
                                            builder: (ctx) => AddEggCollection(
                                                  reFresh: update,
                                                  editData:
                                                      selectedEggCollectionIds[
                                                          0],
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
                        width: size.width * 0.9,
                        child: PaginatedDataTable(
                          source: MySearchData(
                              query == '' ? eggCollectionDetails : list,
                              updateCheckBox),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: [
                            // DataColumn(
                            //     label: Text('Egg Collection Code',
                            //         style: ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Record Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Product',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('WareHouse Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Batch Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Grade',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Quantity',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Collection Date',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Average Weight(grams)',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Collection Status',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Is Cleared',
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

List selectedEggCollectionIds = [];

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
          if (selectedEggCollectionIds.isEmpty) {
            selectedEggCollectionIds.add(data[index]);
          } else {
            if (value == true) {
              selectedEggCollectionIds.add(data[index]);
            } else {
              selectedEggCollectionIds.remove(data[index]);
            }
          }
          // print(selectedEggCollectionIds);
        },
        selected: data[index]['Is_Selected'],
        cells: [
          // DataCell(TextButton(
          //     onPressed: () async {
          //       final prefs = await SharedPreferences.getInstance();
          //       if (prefs.containsKey('Egg_Collection_Id')) {
          //         prefs.remove('Egg_Collection_Id');
          //       }
          //       final userData = json.encode(
          //         {
          //           'Egg_Collection_Id': data[index]['Egg_Collection_Id'],
          //         },
          //       );
          //       prefs.setString('Egg_Collection_Id', userData);

          //       // Get.toNamed(BatchPlanDetailsPage.routeName);
          //     },
          //     child: Text(data[index]['Egg_Collection_Id'].toString()))),
          DataCell(Text(data[index]['Egg_Collection_Code'].toString())),
          DataCell(Text(data[index]['Product_Id__Product_Name'].toString())),
          DataCell(
              Text(data[index]['WareHouse_Id__WareHouse_Name'].toString())),
          DataCell(Text(data[index]['Batch_Plan_Code'].toString())),
          DataCell(Text(data[index]['Egg_Grade_Id__Egg_Grade'].toString())),
          DataCell(Text(data[index]['Quantity'].toString())),
          DataCell(
            Text(
              DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(data[index]['Collection_Date'])),
            ),
          ),
          DataCell(Text(data[index]['Average_Weight'].toString())),
          DataCell(Row(
            children: [
              data[index]['Collection_Status'] == 'Pending'
                  ? const CircleAvatar(
                      radius: 4,
                      // width: 10,
                      // height: 10,
                      backgroundColor: Colors.red,
                    )
                  : const CircleAvatar(
                      radius: 4,
                      // width: 10,
                      // height: 10,
                      backgroundColor: Colors.green,
                    ),
              const SizedBox(
                width: 5,
              ),
              Text(data[index]['Collection_Status'].toString()),
            ],
          )),
          DataCell(Text(data[index]['Is_Cleared'].toString())),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
