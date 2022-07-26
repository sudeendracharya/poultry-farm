import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/admin/providers/admin_apis.dart';
import 'package:poultry_login_signup/admin/widgets/add_user.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../rps_customer_painter.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);
  static const routeName = '/User';

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  String query = '';

  List list = [];

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<AdminApis>(context, listen: false)
            .getUsers(token)
            .then((value) {
          selectedUsers.clear();
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
    getPermission('Users').then((value) {
      extratedPermissions = value;

      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<AdminApis>(context, listen: false).getUsers(token);
      }
    });
    super.initState();
  }

  final Map<String, String> _authData = {
    'username': '',
    'email': '',
    'First_Name': '',
    'Last_Name': '',
    'Mobile_Number': '',
    'Roles': 'Admin',
    'password1': '',
    'password2': '',
    'Permissions': '',
  };

  double _dialogWidth = 609;

  double _dialogHeight = 337;

  void approve(Map<String, dynamic> data) {
    debugPrint(data.toString());
    fetchCredientials().then((token) {
      if (token != '') {
        EasyLoading.show();
        Provider.of<AdminApis>(context, listen: false)
            .updateUser(data, token, data['id'])
            .then((value) {
          if (value['Status_Code'] == 202) {
            Provider.of<Apicalls>(context, listen: false).signUp({
              'username': value['Body']['username'],
              'email': value['Body']['email'],
              'First_Name': value['Body']['First_Name'],
              'Last_Name': value['Body']['Last_Name'],
              'Mobile_Number': value['Body']['Mobile_Number'].toString(),
              'Roles': value['Body']['Role_Id'].toString(),
              'password1': value['Body']['password'],
              'password2': value['Body']['password'],
            }).then((value) {
              EasyLoading.dismiss();
              if (value == 201 || value == 200) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        insetPadding: const EdgeInsets.all(0),
                        content: Container(
                          width: 520,
                          height: _dialogHeight,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                bottom: _dialogHeight * 0.1,
                                child: CustomPaint(
                                  size: Size(
                                      _dialogWidth,
                                      (_dialogWidth * 0.5833333333333334)
                                          .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                  painter: RPSCustomPainter(),
                                ),
                              ),
                              Positioned(
                                bottom: _dialogHeight * 0.55,
                                child: Container(
                                  width: 55,
                                  height: 55,
                                  child: Image.asset('assets/images/email.png'),
                                ),
                              ),
                              Positioned(
                                  child: Text(
                                'Verify your email address',
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Color.fromRGBO(68, 68, 68, 1),
                                  ),
                                ),
                              )),
                              Positioned(
                                  bottom: _dialogHeight * 0.3,
                                  child: Container(
                                    width: _dialogWidth * 0.7,
                                    height: 48,
                                    child: Text(
                                      'An verification mail is sent to ${data['email']}',
                                      style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color.fromRGBO(68, 68, 68, 1),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    }).then((value) {
                  update(100);
                });

                // html.window.open('http://localhost:58731/#/', '_self');
              } else {
                Provider.of<AdminApis>(context, listen: false).updateUser({
                  "had_Access": false,
                }, token, data['id']);
                if (value != 400) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('SignUp Failed'),
                      content:
                          const Text('Something Went Wrong Please try Again'),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('ok'),
                        )
                      ],
                    ),
                  );
                }
              }
            });
          }
        });
      }
    });
  }

  int defaultRowsPerPage = 5;
  List users = [];

  void delete() {
    if (selectedUsers.isEmpty) {
      alertSnackBar('Select the checkbox first');
    } else {
      fetchCredientials().then((token) {
        if (token != '') {
          selectedUsers.clear();
          // Provider.of<BatchApis>(context, listen: false)
          //     .deleteBatchPlanStepOne(selectedBatchCodes, token);
        }
      });
    }
  }

  void searchBook(String query) {
    final searchOutput = users.where((details) {
      final userName = details['username'];

      final searchName = query;

      return userName.contains(searchName);
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
    users = Provider.of<AdminApis>(context).users;
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
                      'Users',
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
                            hintText: 'User Name'),
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
                                        builder: (ctx) => AddUser(
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
                          extratedPermissions['Edit'] == true
                              ? selectedUsers.length == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showGlobalDrawer(
                                            context: context,
                                            builder: (ctx) => AddUser(
                                                  editData: selectedUsers[0],
                                                  reFresh: update,
                                                ),
                                            direction: AxisDirection.right);
                                      },
                                      icon: const Icon(Icons.edit),
                                    )
                                  : const SizedBox()
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
                        width: size.width * 0.7,
                        child: PaginatedDataTable(
                          source: MySearchData(
                              query == '' ? users : list,
                              updateCheckBox,
                              context,
                              approve,
                              extratedPermissions['Approve']),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: [
                            DataColumn(
                                label: Text('User Name',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('First Name',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Last Name',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Email',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),

                            DataColumn(
                                label: Text('Role',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Joining Date',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Access',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Action',
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
                          onSelectAll: (value) {
                            if (value == false) {
                              selectedUsers.clear();
                              for (var data in users) {
                                data['Is_Selected'] = false;
                              }
                              setState(() {});
                            } else {
                              for (var data in users) {
                                data['Is_Selected'] = true;
                              }
                              setState(() {});
                            }
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

List selectedUsers = [];

class MySearchData extends DataTableSource {
  final List<dynamic> data;
  final ValueChanged<int> reFresh;
  final BuildContext context;
  MySearchData(
      this.data, this.reFresh, this.context, this.approve, this.checkApprove);
  final ValueChanged<Map<String, dynamic>> approve;
  final bool checkApprove;
  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(
        onSelectChanged: (value) {
          data[index]['Is_Selected'] = value;
          reFresh(100);
          if (selectedUsers.isEmpty) {
            selectedUsers.add(data[index]);
          } else {
            if (value == true) {
              selectedUsers.add(data[index]);
            } else {
              selectedUsers.remove(data[index]);
            }
          }
          // print(selectedUsers);
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(Text(data[index]['username'])),
          DataCell(Text(data[index]['First_Name'])),
          DataCell(Text(data[index]['Last_Name'])),
          DataCell(Text(data[index]['email'])),
          DataCell(Text(data[index]['Role_Id__Role_Name'].toString())),
          DataCell(Text(
            DateFormat('dd-MM-yyyy').format(
              DateTime.parse(
                data[index]['Joining_Date'],
              ),
            ),
          )),
          DataCell(Text(data[index]['had_Access'].toString())),
          checkApprove == false
              ? const DataCell(SizedBox())
              : data[index]['had_Access'] == false
                  ? DataCell(
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ProjectColors.themecolor)),
                        onPressed: () {
                          approve({
                            "id": data[index]['id'],
                            // "password": data[index]['password'],
                            // "last_login": data[index]['last_login'],
                            "email": data[index]['email'],
                            // "First_Name": data[index]['First_Name'],
                            // "Last_Name": data[index]['Last_Name'],
                            // "Mobile_Number": data[index]['Mobile_Number'],
                            // "created": data[index]['created'],
                            // "Joining_Date": data[index]['Joining_Date'],
                            // "is_active": data[index]['is_active'],
                            // "username": data[index]['username'],
                            "had_Access": true,
                            // "Role_Id": data[index]['Role_Id'],
                          });
                        },
                        child: const Text('Approve'),
                      ),
                    )
                  : const DataCell(SizedBox())
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}

var dta = [
  {
    "username": "Kiran",
    "Role_Id": 3,
    "Role_Id__Role_Name": "Employee",
    "Role_Id__Role_Permission": [
      {
        "Firms": [
          {
            "Id": 15,
            "Edit": false,
            "View": true,
            "Create": true,
            "Delete": false
          }
        ],
        "Roles": {
          "Id": "Roles",
          "Edit": true,
          "View": true,
          "Create": true,
          "Delete": false
        },
        "Sales": {
          "Id": "Sales",
          "Edit": false,
          "View": true,
          "Create": false,
          "Delete": false
        },
        "Users": {
          "Id": "Users",
          "Edit": true,
          "View": true,
          "Create": true,
          "Delete": true,
          "Approve": true
        },
        "Plants": [
          {
            "Id": 14,
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          {
            "Id": 15,
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          }
        ],
        "Sections": [
          {
            "Id": 11,
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          {
            "Id": 12,
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          {
            "Id": 14,
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          {
            "Id": 15,
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          }
        ],
        "Add_Batch": {
          "Id": "Add Batch",
          "Edit": false,
          "View": true,
          "Create": false,
          "Delete": false
        },
        "Transfers": {
          "Transfer_In": {
            "Id": "Transfer In",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          "Transfer_Out": {
            "Id": "Transfer Out",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          }
        },
        "WareHouses": [
          {
            "Id": 20,
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          {
            "Id": 21,
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          {
            "Id": 22,
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          {
            "Id": 23,
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          {
            "Id": 25,
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          }
        ],
        "Activity_Log": {
          "Id": "Activity Log",
          "Edit": false,
          "View": true,
          "Create": false,
          "Delete": false
        },
        "Batch_Planning": {
          "Id": "Batch Planning",
          "Edit": false,
          "View": true,
          "Create": false,
          "Delete": false
        },
        "Medication_Log": {
          "Id": "Medication Log",
          "Edit": false,
          "View": true,
          "Create": false,
          "Delete": false
        },
        "Reference_Data": {
          "Breed": {
            "Id": "Breed",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          "Activity_Plan": {
            "Id": "Activity Plan",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          "Breed_Version": {
            "Id": "Breed Version",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          "Medication_Plan": {
            "Id": "Medication Plan",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          "Vaccination_Plan": {
            "Id": "Vaccination Plan",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          "Bird_Age_Grouping": {
            "Id": "Bird Age Grouping",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          }
        },
        "Vaccination_Log": {
          "Id": "vaccination Log",
          "Edit": false,
          "View": true,
          "Create": false,
          "Delete": false
        },
        "Log_Daily_Batches": {
          "Id": "Log Daily Batches",
          "Edit": false,
          "View": true,
          "Create": false,
          "Delete": false
        },
        "Product_Management": {
          "Id": "Product Management",
          "Edit": false,
          "View": true,
          "Create": false,
          "Delete": false
        },
        "Inventory_Adjustment": {
          "Mortality": {
            "Id": "Mortality",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          "Egg_Grading": {
            "Id": "Egg Grading",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          "Bird_Grading": {
            "Id": "Bird Grading",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          "Egg_Collection": {
            "Id": "Egg Collection",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          },
          "Inventory_Adjustment_Journal": {
            "Id": "Inventory Adjustment Journal",
            "Edit": false,
            "View": true,
            "Create": false,
            "Delete": false
          }
        }
      }
    ]
  }
];
