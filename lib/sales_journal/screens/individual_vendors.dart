import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/sales_journal/widgets/add_vendors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../providers/journal_api.dart';

class IndividualVendors extends StatefulWidget {
  IndividualVendors({Key? key}) : super(key: key);

  @override
  State<IndividualVendors> createState() => _IndividualVendorsState();
}

class _IndividualVendorsState extends State<IndividualVendors> {
  String query = '';

  List list = [];

  void update(int data) {
    selectedVendorInfo.clear();
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<JournalApi>(context, listen: false)
            .getIndividualVendorsInfo(token);
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
              .getIndividualVendorsInfo(token);
        }
      });
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  int defaultRowsPerPage = 5;
  List individualVendorsInfo = [];

  void delete() {
    if (selectedVendorInfo.isEmpty) {
      alertSnackBar('Select the checkbox first');
    } else {
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<JournalApi>(context, listen: false)
              .deleteIndividualVendorInfo(
                  selectedVendorInfo[0]['Vendor'], token)
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
    final searchOutput = individualVendorsInfo.where((details) {
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
    individualVendorsInfo =
        Provider.of<JournalApi>(context).individualVendorsInfo;
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
            'Individual Vendors',
            style: ProjectStyles.contentHeaderStyle().copyWith(fontSize: 22),
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
                        builder: (ctx) => AddVendors(
                              vendorType: 'Individual',
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
                selectedVendorInfo.isEmpty
                    ? const SizedBox()
                    : selectedVendorInfo.length == 1
                        ? IconButton(
                            onPressed: () {
                              showGlobalDrawer(
                                  context: context,
                                  builder: (ctx) => AddVendors(
                                        vendorType: 'Individual',
                                        editData: selectedVendorInfo[0],
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
                selectedVendorInfo.isEmpty
                    ? const SizedBox()
                    : selectedVendorInfo.length == 1
                        ? IconButton(
                            onPressed: () {
                              deleteAlert(delete);
                            },
                            icon: const Icon(Icons.delete),
                          )
                        : const SizedBox(),
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
                    query == '' ? individualVendorsInfo : list, updateCheckBox),
                arrowHeadColor: ProjectColors.themecolor,

                columns: [
                  DataColumn(
                      label: Text('Vendors Code',
                          style: ProjectStyles.paginatedHeaderStyle())),
                  DataColumn(
                      label: Text('Vendor Name',
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
                      label: Text('Zipcode',
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

List selectedVendorInfo = [];

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
          if (selectedVendorInfo.isEmpty) {
            selectedVendorInfo.add(data[index]);
          } else {
            if (value == true) {
              selectedVendorInfo.add(data[index]);
            } else {
              selectedVendorInfo.remove(data[index]);
            }
          }
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(Text(data[index]['Vendor__Vendor_Code'])),
          DataCell(Text(data[index]['Vendor__Vendor_Name'])),
          // DataCell(
          //   Text(
          //     DateFormat('dd-MM-yyyy')
          //         .format(DateTime.parse(data[index]['Shipped_Date'])),
          //   ),
          // ),
          DataCell(Text(data[index]['Vendor__Country'].toString())),
          DataCell(Text(data[index]['Vendor__State'].toString())),
          DataCell(Text(data[index]['Vendor__City'].toString())),
          DataCell(Text(data[index]['Vendor__Street'])),
          DataCell(Text(data[index]['Vendor__Zip_Code'].toString())),
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
