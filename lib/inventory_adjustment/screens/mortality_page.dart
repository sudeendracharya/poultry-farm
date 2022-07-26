import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../providers/inventory_adjustement_apis.dart';
import '../widgets/add_mortality.dart';

class Mortalitypage extends StatefulWidget {
  Mortalitypage({Key? key}) : super(key: key);

  @override
  State<Mortalitypage> createState() => _MortalitypageState();
}

class _MortalitypageState extends State<Mortalitypage> {
  String query = '';

  List list = [];

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .getMortality(token)
            .then((value) {
          finalSelectedMortalityIds.clear();
          selectedMortality.clear();
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
    getPermission('Mortality').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .getMortality(token);
      }
    });
    super.initState();
  }

  int defaultRowsPerPage = 5;
  List mortalityDetails = [];
  List finalSelectedMortalityIds = [];

  void delete() {
    if (selectedMortality.isEmpty) {
      alertSnackBar('Select the checkbox first');
    } else {
      for (var data in selectedMortality) {
        finalSelectedMortalityIds.add(data['Record_Id']);
      }
      // print(finalSelectedMortalityIds);
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<InventoryAdjustemntApis>(context, listen: false)
              .deleteMortality(finalSelectedMortalityIds, token)
              .then((value) {
            if (value == 204) {
              selectedMortality.clear();
              update(100);
              successSnackbar('Successfully deleted the data');
            } else {
              selectedMortality.clear();
              update(100);
              failureSnackbar('Unable to delete the data please try again');
            }
          });
        }
      });
    }
  }

  void searchBook(String query) {
    final searchOutput = mortalityDetails.where((details) {
      final batchCode = details['Record_Code'].toString().toLowerCase();

      final searchName = query.toLowerCase();

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
    mortalityDetails =
        Provider.of<InventoryAdjustemntApis>(context).mortalityListData;
    return loading == true
        ? const SizedBox()
        : extratedPermissions['View'] == false
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
                      'Mortality',
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
                            hintText: 'Record Code'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          extratedPermissions['Create'] == true
                              ? IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) => AddMortality(
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
                              : selectedMortality.length == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showGlobalDrawer(
                                            context: context,
                                            builder: (ctx) => AddMortality(
                                                  reFresh: update,
                                                  editData:
                                                      selectedMortality[0],
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
                        width: size.width * 0.8,
                        child: PaginatedDataTable(
                          source: MySearchData(
                              query == '' ? mortalityDetails : list,
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
                                label: Text('WareHouse Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),

                            DataColumn(
                                label: Text('Date',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Batch Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Item',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('item Category',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Quantity',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Description',
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

List selectedMortality = [];

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
          if (selectedMortality.isEmpty) {
            selectedMortality.add(data[index]);
          } else {
            if (value == true) {
              selectedMortality.add(data[index]);
            } else {
              selectedMortality.remove(data[index]);
            }
          }
          // print(selectedMortality);
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
          DataCell(Text(data[index]['Record_Code'].toString())),
          DataCell(Text(data[index]['WareHouse_Id'].toString())),
          DataCell(
            Text(
              DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(data[index]['Date'])),
            ),
          ),
          DataCell(Text(data[index]['Batch_Id'].toString())),
          DataCell(Text(data[index]['Item'].toString())),
          DataCell(Text(data[index]['Item_Category'].toString())),

          DataCell(Text(data[index]['Quantity'].toString())),
          DataCell(Text(data[index]['Description'].toString())),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
