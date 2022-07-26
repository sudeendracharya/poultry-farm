import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:poultry_login_signup/infrastructure/widgets/addwarehouse_sub_category_dialog.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../providers/infrastructure_apicalls.dart';

class WarehouseSubCategoryScreenDetails extends StatefulWidget {
  WarehouseSubCategoryScreenDetails({Key? key}) : super(key: key);

  @override
  State<WarehouseSubCategoryScreenDetails> createState() =>
      _WarehouseSubCategoryScreenDetailsState();
}

class _WarehouseSubCategoryScreenDetailsState
    extends State<WarehouseSubCategoryScreenDetails> {
  @override
  void initState() {
    super.initState();
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .loadWarehouseCategoryAndSubCategory(token)
          .then((value1) {});
    });
  }

  var query = '';

  List list = [];

  void updateCheckBox(int data) {
    setState(() {});
  }

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<InfrastructureApis>(context, listen: false)
            .loadWarehouseCategoryAndSubCategory(token)
            .then((value1) {
          selectedSubCategory.clear();
        });
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

  List warehouseSubCategory = [];
  List selectedActivityIds = [];
  var extratedPermissions;
  bool loading = true;

  int defaultRowsPerPage = 3;

  void delete() {
    if (selectedSubCategory.isEmpty) {
      alertSnackBar('Please select the checkbox to delete');
    } else {
      List temp = [];
      for (var data in selectedSubCategory) {
        temp.add(data['WareHouse_Sub_Category_Id']);
      }
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<InfrastructureApis>(context, listen: false)
              .deleteWarehouseSubCategory(temp, token)
              .then((value) {
            if (value == 204) {
              successSnackbar('Successfully deleted the data');
              update(100);
              selectedSubCategory.clear();
            } else {
              update(100);
              selectedSubCategory.clear();
              failureSnackbar('Unable to delete the data Something went wrong');
            }
          });
        }
      });
    }
  }

  void searchBook(String query) {
    final searchOutput = warehouseSubCategory.where((details) {
      final breedVendor =
          details['WareHouse_Sub_Category_Name'].toString().toLowerCase();
      final searchName = query.toLowerCase();

      return breedVendor.contains(searchName);
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
    warehouseSubCategory =
        Provider.of<InfrastructureApis>(context).displayWarehouseSubCategory;
    List batchDetails = [];

    return
        // loading == true
        //     ? const Center(
        //         child: Text('Loading'),
        //       )
        //     : extratedPermissions['View'] == false
        //         ? SizedBox(
        //             height: size.height * 0.5,
        //             child: const Center(
        //                 child: Text('You don\'t have access to view this page')),
        //           )
        //         :
        SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 34,
          ),
          Text(
            'WareHouse Sub Category',
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
                  hintText: 'Sub Category Name'),
            ),
          ),
          Container(
            width: size.width * 0.35,
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // extratedPermissions['Create'] == true
                //     ?
                IconButton(
                  onPressed: () {
                    showGlobalDrawer(
                        context: context,
                        builder: (ctx) => AddWareHouseSubCategoryDialog(
                              reFresh: update,
                            ),
                        direction: AxisDirection.right);
                  },
                  icon: const Icon(Icons.add),
                ),
                // : const SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                // extratedPermissions['Edit'] == true
                //     ?
                selectedSubCategory.length == 1
                    ? IconButton(
                        onPressed: () {
                          showGlobalDrawer(
                            context: context,
                            builder: (ctx) => AddWareHouseSubCategoryDialog(
                              reFresh: update,
                              description: selectedSubCategory[0]
                                  ['Description'],
                              subcategoryName: selectedSubCategory[0]
                                  ['WareHouse_Sub_Category_Name'],
                              warehouseSubCategoryId: selectedSubCategory[0]
                                  ['WareHouse_Sub_Category_Id'],
                            ),
                            direction: AxisDirection.right,
                          );
                        },
                        icon: const Icon(Icons.edit),
                      )
                    : const SizedBox(),
                // : const SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                // extratedPermissions['Delete'] == true
                //     ?
                IconButton(
                  onPressed: delete,
                  icon: const Icon(Icons.delete),
                )
                // : const SizedBox(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              width: size.width * 0.35,
              child: PaginatedDataTable(
                arrowHeadColor: ProjectColors.themecolor,

                source: MySearchBreedData(
                    query == '' ? warehouseSubCategory : list, updateCheckBox),

                columns: const [
                  DataColumn(
                      label: Text('Sub Category Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Description',
                          style: TextStyle(fontWeight: FontWeight.bold))),
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

List selectedSubCategory = [];

class MySearchBreedData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<int> reFresh;

  MySearchBreedData(this.data, this.reFresh);

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(
        onSelectChanged: (value) {
          data[index]['Is_Selected'] = value;

          if (selectedSubCategory.isEmpty) {
            selectedSubCategory.add(data[index]);
          } else {
            if (value == true) {
              selectedSubCategory.add(data[index]);
            } else {
              selectedSubCategory.remove(data[index]);
            }
          }
          reFresh(100);
          // print('selected breeds $selectedBreeds');
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(Text(data[index]['WareHouse_Sub_Category_Name'].toString())),
          DataCell(
            Text(data[index]['Description'].toString()),
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
