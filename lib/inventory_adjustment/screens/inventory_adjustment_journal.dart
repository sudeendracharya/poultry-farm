import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:poultry_login_signup/inventory_adjustment/widgets/add_inventory_adjustment.dart';
import 'package:poultry_login_signup/items/widgets/add_inventory_adjustment.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../sales_journal/providers/journal_api.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';

class InventoryAdjustmentJournal extends StatefulWidget {
  InventoryAdjustmentJournal({Key? key}) : super(key: key);

  @override
  State<InventoryAdjustmentJournal> createState() =>
      _InventoryAdjustmentJournalState();
}

class _InventoryAdjustmentJournalState
    extends State<InventoryAdjustmentJournal> {
  var query = '';

  List list = [];

  void update(int data) {
    selectedInventoryAdjustmentData.clear();
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<JournalApi>(context, listen: false)
            .getInventoryAdjustmentJournalInfo(token);
      }
    });
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

  List inventoryAdjustmentList = [];
  List selectedActivityIds = [];
  bool loading = true;
  @override
  void initState() {
    getPermission('Inventory_Adjustment_Journal').then((value) {
      extratedinventoryAdjustmentPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<JournalApi>(context, listen: false)
            .getInventoryAdjustmentJournalInfo(token);
        // Provider.of<ActivityApis>(context, listen: false)
        //     .getActivityPlan(token);
      }
    });
    super.initState();
  }

  void updateCheckBox(int data) {
    setState(() {});
  }

  int defaultRowsPerPage = 5;

  void delete() {
    if (selectedInventoryAdjustmentData.isNotEmpty) {
      List temp = [];
      for (var data in selectedInventoryAdjustmentData) {
        temp.add(data['Inventory_Adjustment_Id']);
      }
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<JournalApi>(context, listen: false)
              .deleteInventoryAdjustmentJournalInfo(temp, token)
              .then((value) {
            if (value == 204) {
              successSnackbar('Successfully deleted the data');
              update(100);
            } else {
              failureSnackbar('Something went wrong unable to delete the data');
              update(100);
            }
          });
        }
      });
    } else {
      alertSnackBar('Please select the check box first');
    }
  }

  void searchBook(String query) {
    final searchOutput = inventoryAdjustmentList.where((details) {
      final activityCode = details['Activity_Code'];

      final searchName = query;

      return activityCode.contains(searchName);
    }).toList();

    setState(() {
      this.query = query;
      list = searchOutput;
    });
  }

  var extratedinventoryAdjustmentPermissions;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    inventoryAdjustmentList =
        Provider.of<JournalApi>(context).inventoryAdjustmentListData;

    List batchDetails = [];
    return loading == true
        ? const SizedBox()
        : extratedinventoryAdjustmentPermissions['View'] == false
            ? Container(
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
                      'Inventory Adjustment Journal',
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
                      width: size.width * 0.8,
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          extratedinventoryAdjustmentPermissions['Create'] ==
                                  true
                              ? IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) =>
                                            AddInventoryAdjustmentJournal(
                                              reFresh: update,
                                              editData: {},
                                            ),
                                        direction: AxisDirection.right);
                                  },
                                  icon: const Icon(Icons.add),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          selectedInventoryAdjustmentData.length == 1
                              ? IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) =>
                                            AddInventoryAdjustmentJournal(
                                              reFresh: update,
                                              editData:
                                                  selectedInventoryAdjustmentData[
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
                          extratedinventoryAdjustmentPermissions['Delete'] ==
                                  true
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
                        width: size.width * 0.8,
                        child: PaginatedDataTable(
                          source: MySearchData(
                              query == '' ? inventoryAdjustmentList : list,
                              updateCheckBox),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: const [
                            DataColumn(
                                label: Text('Adjustment Code',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Date',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Product',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Batch Plan Code',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('WareHouse Code',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Quantity',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Quantity Unit',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Description',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
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

List selectedInventoryAdjustmentData = [];

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
          if (selectedInventoryAdjustmentData.isEmpty) {
            selectedInventoryAdjustmentData.add(data[index]);
          } else {
            if (value == true) {
              selectedInventoryAdjustmentData.add(data[index]);
            } else {
              selectedInventoryAdjustmentData.remove(data[index]);
            }
          }
          // print(selectedActivityCodes);
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(Text(data[index]['Inventory_Adjustment_Code'] ?? '')),
          DataCell(Text(data[index]['Date'] ?? '')),
          DataCell(Text(data[index]['Product_Id__Product_Name'] ?? '')),
          DataCell(Text(data[index]['Batch_Plan_Id__Batch_Plan_Code'] ?? "")),
          DataCell(Text(data[index]['WareHouse_Id__WareHouse_Code'] ?? '')),
          DataCell(Text(data[index]['CW_Quantity'].toString())),
          DataCell(Text(data[index]['CW_Unit__Unit_Name'] ?? '')),
          DataCell(Text(data[index]['Description'] ?? '')),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  // void downloadExcelSheet(List activityDataList, var id) {
  //   final Workbook workbook = Workbook();
  //   final Worksheet sheet = workbook.worksheets[0];
  //   Range range = sheet.getRangeByName('A1');
  //   range.setText('Age in Days');
  //   range = sheet.getRangeByName('B1');
  //   range.setText('Activity');
  //   range = sheet.getRangeByName('C1');
  //   range.setText('Notification Days');

  //   List exportActivityList = [];

  //   for (var data in activityDataList) {
  //     exportActivityList.add([
  //       data['Age'],
  //       data['Activity_Name'],
  //       data['Notification_Prior_To_Activity'],
  //     ]);
  //   }

  //   for (int i = 0; i < exportActivityList.length; i++) {
  //     sheet.importList(exportActivityList[i], i + 2, 1, false);
  //   }
  //   final List<int> bytes = workbook.saveAsStream();

  //   // File file=File();

  //   // file.writeAsBytes(bytes);

  //   // _localFile.then((value) {
  //   //   final file = value;
  //   //   file.writeAsBytes(bytes);
  //   // });
  //   save(bytes, 'Activity$id.xlsx');

  //   // final blob = html.Blob([bytes], 'application/vnd.ms-excel');
  //   // final url = html.Url.createObjectUrlFromBlob(blob);
  //   // html.window.open(url, "_blank");
  //   // html.Url.revokeObjectUrl(url);
  //   workbook.dispose();
  // }

  // void save(Object bytes, String fileName) {
  //   js.context.callMethod("saveAs", <Object>[
  //     html.Blob(<Object>[bytes]),
  //     fileName
  //   ]);
  // }
}
