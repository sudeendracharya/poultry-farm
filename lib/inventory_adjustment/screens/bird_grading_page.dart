import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/inventory_adjustment/widgets/add_bird_grading.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../providers/inventory_adjustement_apis.dart';

class BirdGrading extends StatefulWidget {
  BirdGrading({Key? key}) : super(key: key);
  static const routeName = '/BirdGrading';
  @override
  State<BirdGrading> createState() => _BirdGradingState();
}

class _BirdGradingState extends State<BirdGrading> {
  String query = '';

  List list = [];

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .getBirdGrading(token)
            .then((value) {
          selectedBirdGradingIds.clear();
          finalBirdGradingIdList.clear();
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
    getPermission('Bird_Grading').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<InventoryAdjustemntApis>(context, listen: false)
            .getBirdGrading(token);
      }
    });
    super.initState();
  }

  int defaultRowsPerPage = 5;
  List birdGradingDetails = [];
  List finalBirdGradingIdList = [];

  void delete() {
    if (selectedBirdGradingIds.isEmpty) {
      alertSnackBar('Select the checkbox first');
    } else {
      for (var data in selectedBirdGradingIds) {
        finalBirdGradingIdList.add(data['Record_Id']);
      }
      // print(finalBirdGradingIdList);
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<InventoryAdjustemntApis>(context, listen: false)
              .deleteBirdGrading(finalBirdGradingIdList, token)
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
    final searchOutput = birdGradingDetails.where((details) {
      // final batchCode = details['Batch_Code'];
      final breedName = details['Batch_Id'].toString();

      final searchName = query;

      return breedName.contains(searchName);
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
    birdGradingDetails =
        Provider.of<InventoryAdjustemntApis>(context).birdGradingData;
    return loading == true
        ? const SizedBox()
        : extratedPermissions['View'] == false
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
                      'Bird Grading',
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
                                        builder: (ctx) => AddBirdGrading(
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
                              : selectedBirdGradingIds.length == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showGlobalDrawer(
                                            context: context,
                                            builder: (ctx) => AddBirdGrading(
                                                  reFresh: update,
                                                  editData:
                                                      selectedBirdGradingIds[0],
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
                              query == '' ? birdGradingDetails : list,
                              updateCheckBox),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: [
                            // DataColumn(
                            //     label: Text('Egg Collection Code',
                            //         style: ProjectStyles.paginatedHeaderStyle())),

                            DataColumn(
                                label: Text('Batch Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Date',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('WareHouse Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),

                            DataColumn(
                                label: Text('From',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('To',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Quantity',
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

List selectedBirdGradingIds = [];

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
          if (selectedBirdGradingIds.isEmpty) {
            selectedBirdGradingIds.add(data[index]);
          } else {
            if (value == true) {
              selectedBirdGradingIds.add(data[index]);
            } else {
              selectedBirdGradingIds.remove(data[index]);
            }
          }
          // print(selectedBirdGradingIds);
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
          DataCell(Text(data[index]['Batch_Id'].toString())),
          DataCell(
            Text(
              DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(data[index]['Date'])),
            ),
          ),
          DataCell(Text(data[index]['WareHouse_Id'].toString())),
          DataCell(Text(data[index]['From'].toString())),

          DataCell(Text(data[index]['To'].toString())),
          DataCell(Text(data[index]['Qty'].toString())),
          DataCell(Text(data[index]['Unit'].toString())),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
