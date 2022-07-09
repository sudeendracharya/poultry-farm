import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/sales_journal/screens/customers_details_page.dart';
import 'package:poultry_login_signup/sales_journal/widgets/add_customer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../providers/journal_api.dart';

class CustomersPage extends StatefulWidget {
  CustomersPage({Key? key}) : super(key: key);

  static const routeName = '/CustomersPage';
  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  String query = '';

  List list = [];

  void update(int data) {
    selectedCustomersInfo.clear();
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<JournalApi>(context, listen: false).getCustomersInfo(token);
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
    getPermission().then((value) {
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<JournalApi>(context, listen: false)
              .getCustomersInfo(token);
        }
      });
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  int defaultRowsPerPage = 5;
  List customersInfo = [];

  void delete() {
    if (selectedCustomersInfo.isEmpty) {
      alertSnackBar('Select the checkbox first');
    } else {
      List temp = [];
      for (var data in selectedCustomersInfo) {
        temp.add(data['Customer_Id']);
      }
      print(temp);
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<JournalApi>(context, listen: false)
              .deleteCustomerInfo(temp, token)
              .then((value) {
            if (value == 204) {
              update(100);
              successSnackbar('Successfully deleted the data');
            } else {
              failureSnackbar(
                  'Unable to delete the data something went wrong ');
            }
          });
        }
      });
    }
  }

  var extratedSalesPermissions;

  Future<void> getPermission() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('Sales')) {
      extratedSalesPermissions = {
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
        json.decode(prefs.getString('Sales')!) as Map<String, dynamic>;
    // print(extratedUserData);

    extratedSalesPermissions = extratedUserData['Sales'];
    // print(extratedSalesPermissions);
  }

  void searchBook(String query) {
    final searchOutput = customersInfo.where((details) {
      final customerName = details['Customer_Name'];

      final searchName = query;

      return customerName.contains(searchName);
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
    customersInfo = Provider.of<JournalApi>(context).customersInfoList;
    return
        // loading == true
        //     ? const Center(
        //         child: Text('Loading'),
        //       )
        //     : extratedSalesPermissions['View'] == false
        //         ? const Center(
        //             child: Text('You don\'t have access to view the content'),
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
            'Individual Customers',
            style: ProjectStyles.contentHeaderStyle().copyWith(fontSize: 26),
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
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // extratedSalesPermissions['Create'] == true
                //     ?
                IconButton(
                  onPressed: () {
                    showGlobalDrawer(
                        context: context,
                        builder: (ctx) => AddCustomer(
                              customerType: 'Individual',
                              editData: {},
                              update: update,
                            ),
                        direction: AxisDirection.right);
                  },
                  icon: const Icon(Icons.add),
                ),
                // : const SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                selectedCustomersInfo.length == 1
                    ? IconButton(
                        onPressed: () {
                          showGlobalDrawer(
                              context: context,
                              builder: (ctx) => AddCustomer(
                                    customerType: 'Individual',
                                    editData: selectedCustomersInfo[0],
                                    update: update,
                                  ),
                              direction: AxisDirection.right);
                        },
                        icon: const Icon(Icons.edit),
                      )
                    : const SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                // extratedSalesPermissions['Delete'] == true
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
              width: size.width * 0.8,
              child: PaginatedDataTable(
                source: MySearchData(
                    query == '' ? customersInfo : list, updateCheckBox),
                arrowHeadColor: ProjectColors.themecolor,

                columns: [
                  DataColumn(
                      label: Text('Customer Name',
                          style: ProjectStyles.paginatedHeaderStyle())),
                  DataColumn(
                      label: Text('Customer PAN',
                          style: ProjectStyles.paginatedHeaderStyle())),
                  DataColumn(
                      label: Text('Country',
                          style: ProjectStyles.paginatedHeaderStyle())),
                  DataColumn(
                      label: Text('State',
                          style: ProjectStyles.paginatedHeaderStyle())),
                  DataColumn(
                      label: Text('City',
                          style: ProjectStyles.paginatedHeaderStyle())),
                  DataColumn(
                      label: Text('Street',
                          style: ProjectStyles.paginatedHeaderStyle())),
                  DataColumn(
                      label: Text('Pincode',
                          style: ProjectStyles.paginatedHeaderStyle())),
                  DataColumn(
                      label: Text('Contact Number',
                          style: ProjectStyles.paginatedHeaderStyle())),
                  DataColumn(
                      label: Text('Email Id',
                          style: ProjectStyles.paginatedHeaderStyle())),
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

List selectedCustomersInfo = [];

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
          if (selectedCustomersInfo.isEmpty) {
            selectedCustomersInfo.add(data[index]);
          } else {
            if (value == true) {
              selectedCustomersInfo.add(data[index]);
            } else {
              selectedCustomersInfo.remove(data[index]);
            }
          }
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(TextButton(
              onPressed: () async {
                var pref = await SharedPreferences.getInstance();

                if (pref.containsKey('Customer_Id')) {
                  pref.remove('Customer_Id');
                }
                var userData =
                    json.encode({'Customer_Id': data[index]['Customer_Id']});

                pref.setString('Customer_Id', userData);
                Get.toNamed(CustomerDetailsPage.routeName,
                    arguments: data[index]['Customer_Id']);
              },
              child: Text(data[index]['Customer_Name']))),
          DataCell(Text(data[index]['Customer_Permanent_Account_Number'])),
          // DataCell(
          //   Text(
          //     DateFormat('dd-MM-yyyy')
          //         .format(DateTime.parse(data[index]['Shipped_Date'])),
          //   ),
          // ),
          DataCell(Text(data[index]['Country'].toString())),
          DataCell(Text(data[index]['State'].toString())),
          DataCell(Text(data[index]['City'].toString())),
          DataCell(Text(data[index]['Street'])),
          DataCell(Text(data[index]['Pincode'].toString())),
          DataCell(Text(data[index]['Contact_Number'].toString())),
          DataCell(Text(data[index]['Email_Id'])),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
