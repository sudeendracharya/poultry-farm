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
                          source: MySearchData(query == '' ? users : list,
                              updateCheckBox, context, approve),
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
  MySearchData(this.data, this.reFresh, this.context, this.approve);
  final ValueChanged<Map<String, dynamic>> approve;

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
          data[index]['had_Access'] == false
              ? DataCell(
                  ElevatedButton(
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
