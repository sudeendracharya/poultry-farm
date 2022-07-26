import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/admin/providers/admin_apis.dart';
import 'package:poultry_login_signup/admin/screens/admin.dart';
import 'package:poultry_login_signup/admin/screens/roles_details_page.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../widgets/add_user_roles.dart';

class UserRoles extends StatefulWidget {
  const UserRoles({Key? key}) : super(key: key);
  static const routeName = '/UserRoles';

  @override
  _UserRolesState createState() => _UserRolesState();
}

class _UserRolesState extends State<UserRoles> {
  String query = '';

  List list = [];

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<AdminApis>(context, listen: false).getUserRoles(token);
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
    getPermission('Roles').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<AdminApis>(context, listen: false).getUserRoles(token);
      }
    });
    super.initState();
  }

  int defaultRowsPerPage = 5;
  List userRoles = [];

  void delete() {
    if (selectedBatchCodes.isEmpty) {
      alertSnackBar('Select the checkbox first');
    } else {
      fetchCredientials().then((token) {
        if (token != '') {
          // Provider.of<BatchApis>(context, listen: false)
          //     .deleteBatchPlanStepOne(selectedBatchCodes, token);
        }
      });
    }
  }

  void searchBook(String query) {
    final searchOutput = userRoles.where((details) {
      final roleName = details['Role_Name'].toString().toLowerCase();

      final searchName = query.toLowerCase();

      return roleName.contains(searchName);
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
    userRoles = Provider.of<AdminApis>(context).userRoles;
    return loading == true
        ? const Center(
            child: Text('Loading'),
          )
        : extratedPermissions['View'] == false
            ? const Center(
                child: Text('You don\'t have access to view the content'),
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
                      'Roles',
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
                            hintText: 'Role Name'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          extratedPermissions['View'] == true
                              ? IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) => AddUserRoles(
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
                        width: size.width * 0.3,
                        child: PaginatedDataTable(
                          source: MySearchData(query == '' ? userRoles : list,
                              updateCheckBox, context),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: [
                            DataColumn(
                                label: Text('Role Name',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Description',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            // DataColumn(
                            //     label: Text('Activity Code',
                            //         style: ProjectStyles.paginatedHeaderStyle())),
                            // DataColumn(
                            //     label: Text('Vaccination Code',
                            //         style: ProjectStyles.paginatedHeaderStyle())),
                            // DataColumn(
                            //     label: Text('Medication Code',
                            //         style: ProjectStyles.paginatedHeaderStyle())),
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
  final BuildContext context;
  MySearchData(this.data, this.reFresh, this.context);

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(
        // onSelectChanged: (value) {
        //   data[index]['Is_Selected'] = value;
        //   reFresh(100);
        //   if (selectedBatchCodes.isEmpty) {
        //     selectedBatchCodes.add(data[index]['Batch_Plan_Id']);
        //   } else {
        //     if (value == true) {
        //       selectedBatchCodes.add(data[index]['Batch_Plan_Id']);
        //     } else {
        //       selectedBatchCodes.remove(data[index]['Batch_Plan_Id']);
        //     }
        //   }
        //   print(selectedBatchCodes);
        // },
        // selected: data[index]['Is_Selected'],
        cells: [
          DataCell(TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                if (prefs.containsKey('Role_Id')) {
                  prefs.remove('Role_Id');
                }
                final userData = json.encode(
                  {
                    'Role_Id': data[index]['Role_Id'],
                  },
                );
                prefs.setString('Role_Id', userData);
                Provider.of<AdminApis>(context, listen: false)
                    .individualUserRoles
                    .clear();
                Get.toNamed(RolesDetailsPage.routeName);
              },
              child: Text(data[index]['Role_Name']))),
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
