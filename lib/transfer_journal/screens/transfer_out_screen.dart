import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/transfer_journal/providers/transfer_journal_apis.dart';
import 'package:poultry_login_signup/transfer_journal/widgets/add_transfer_out_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';

class TransferOutScreen extends StatefulWidget {
  TransferOutScreen({Key? key}) : super(key: key);

  @override
  State<TransferOutScreen> createState() => _TransferOutScreenState();
}

class _TransferOutScreenState extends State<TransferOutScreen> {
  String query = '';

  List list = [];

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<TransferJournalApi>(context, listen: false)
            .getTransferOutJournal(token)
            .then((value) {
          selectedTransferOutCodes.clear();
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

  bool loading = true;

  @override
  void initState() {
    selectedTransferOutCodes.clear();
    getPermission().then((value) {
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<TransferJournalApi>(context, listen: false)
            .getTransferOutJournal(token);
      }
    });
    super.initState();
  }

  int defaultRowsPerPage = 5;
  List transferOutDetails = [];
  List temp = [];

  void delete() {
    if (selectedTransferOutCodes.isEmpty) {
      alertSnackBar('Select the checkbox first');
    } else {
      for (var data in selectedTransferOutCodes) {
        temp.add(data['Transfer_Out_Id']);
      }
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<TransferJournalApi>(context, listen: false)
              .deleteTransferOutJournal(temp, token)
              .then((value) {
            if (value == 204) {
              update(100);
              successSnackbar('successfully deleted the data');
              selectedTransferOutCodes.clear();
            } else {
              selectedTransferOutCodes.clear();
              update(100);
              failureSnackbar('Something went wrong unable to delete the data');
            }
          });
        }
      });
    }
  }

  void searchBook(String query) {
    final searchOutput = transferOutDetails.where((details) {
      final batchCode = details['Transfer_Out_Code'].toString().toLowerCase();

      final searchName = query;

      return batchCode.contains(searchName);
    }).toList();

    setState(() {
      this.query = query;
      list = searchOutput;
    });
  }

  var extratedTransferOutPermissions;

  Future<void> getPermission() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('Transfer_Out')) {
      extratedTransferOutPermissions = {
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
        json.decode(prefs.getString('Transfer_Out')!) as Map<String, dynamic>;

    extratedTransferOutPermissions = extratedUserData['Transfer_Out'];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    transferOutDetails =
        Provider.of<TransferJournalApi>(context).transferOutJournalData;
    return loading == true
        ? const SizedBox()
        : extratedTransferOutPermissions['View'] == false
            ? Container(
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
                      'Transfer Out',
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
                            hintText: 'Transfer Code'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          extratedTransferOutPermissions['Create'] == true
                              ? IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) => AddTransferOutScreen(
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
                          extratedTransferOutPermissions['Edit'] == false
                              ? const SizedBox()
                              : selectedTransferOutCodes.length == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showGlobalDrawer(
                                            context: context,
                                            builder: (ctx) =>
                                                AddTransferOutScreen(
                                                  editData:
                                                      selectedTransferOutCodes[
                                                          0],
                                                  reFresh: update,
                                                ),
                                            direction: AxisDirection.right);
                                      },
                                      icon: const Icon(Icons.edit),
                                    )
                                  : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          extratedTransferOutPermissions['Delete'] == false
                              ? const SizedBox()
                              : IconButton(
                                  onPressed: delete,
                                  icon: const Icon(Icons.delete),
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        width: size.width * 0.8,
                        child: PaginatedDataTable(
                          source: MySearchData(
                              query == '' ? transferOutDetails : list,
                              updateCheckBox),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: [
                            DataColumn(
                                label: Text('Transfer Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Shipped date',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Product',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Transfer Quantity',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('From Warehouse',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('To Warehouse',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Batchplan Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Transfer Status',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Remarks',
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

List selectedTransferOutCodes = [];

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
          if (selectedTransferOutCodes.isEmpty) {
            selectedTransferOutCodes.add(data[index]);
          } else {
            if (value == true) {
              selectedTransferOutCodes.add(data[index]);
            } else {
              selectedTransferOutCodes.remove(data[index]);
            }
          }
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(Text(data[index]['Transfer_Out_Code'])),
          DataCell(
            Text(
              data[index]['Dispatch_Date'] == null
                  ? ''
                  : DateFormat('dd-MM-yyyy')
                      .format(DateTime.parse(data[index]['Dispatch_Date'])),
            ),
          ),
          DataCell(Text(data[index]['Product_Name'].toString())),
          DataCell(Text(data[index]['Transfer_Quantity'].toString())),
          DataCell(Text(data[index]['From_WareHouse_Name'].toString())),
          DataCell(Text(data[index]['To_WareHouse_Name'].toString())),
          DataCell(Text(data[index]['Batch_Plan_Code'].toString())),
          DataCell(Text(data[index]['Transfer_Status'].toString())),
          DataCell(Text(data[index]['Remarks'].toString())),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
