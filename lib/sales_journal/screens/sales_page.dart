import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/sales_journal/providers/journal_api.dart';
import 'package:poultry_login_signup/sales_journal/screens/sales_details_page.dart';
import 'package:poultry_login_signup/sales_journal/widgets/add_sales_journal.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../batch_plan/providers/batch_plan_apis.dart';
import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';

class CustomerSalesPage extends StatefulWidget {
  CustomerSalesPage({Key? key}) : super(key: key);

  static const routeName = '/SalesPage';

  @override
  State<CustomerSalesPage> createState() => _CustomerSalesPageState();
}

class _CustomerSalesPageState extends State<CustomerSalesPage> {
  String query = '';

  List list = [];

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<JournalApi>(context, listen: false)
            .getCustomerSalesJournalInfo('', token);
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
              .getCustomerSalesJournalInfo('', token);
        }
      });
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  int defaultRowsPerPage = 5;
  List journalDetails = [];

  void delete() {
    if (selectedSaleCodes.isEmpty) {
      alertSnackBar('Select the checkbox first');
    } else {
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<JournalApi>(context, listen: false)
              .deleteSalesJournalInfo(selectedSaleCodes, token)
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
    final searchOutput = journalDetails.where((details) {
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
    journalDetails = Provider.of<JournalApi>(context).journalInfo;
    return loading == true
        ? const Center(
            child: Text('Loading'),
          )
        : extratedSalesPermissions['View'] == false
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
                      'Individual Customer Sales',
                      style: ProjectStyles.contentHeaderStyle()
                          .copyWith(fontSize: 26),
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
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          extratedSalesPermissions['Create'] == true
                              ? IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) => AddSalesJournal(
                                              name: '',
                                              id: '',
                                              customerType: '',
                                              editData: {},
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
                          extratedSalesPermissions['Delete'] == true
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
                        width: size.width * 0.6,
                        child: PaginatedDataTable(
                          source: MySearchData(
                              query == '' ? journalDetails : list,
                              updateCheckBox),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: [
                            DataColumn(
                                label: Text('Sale Code',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Customer Name',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Date',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Warehouse Name',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Sold/Sale Item',
                                    style:
                                        ProjectStyles.paginatedHeaderStyle())),
                            DataColumn(
                                label: Text('Quantity',
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

List selectedSaleCodes = [];

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
          if (selectedSaleCodes.isEmpty) {
            selectedSaleCodes.add(data[index]['Sale_Id']);
          } else {
            if (value == true) {
              selectedSaleCodes.add(data[index]['Sale_Id']);
            } else {
              selectedSaleCodes.remove(data[index]['Sale_Id']);
            }
          }
          // print(selectedSaleCodes);
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                if (prefs.containsKey('Sale_Id')) {
                  prefs.remove('Sale_Id');
                }
                final userData = json.encode(
                  {
                    'Sale_Id': data[index]['Sale_Id'],
                  },
                );
                prefs.setString('Sale_Id', userData);

                Get.toNamed(SalesDetailsPage.routeName);
              },
              child: Text(data[index]['Sale_Code']))),
          DataCell(Text(data[index]['Customer_Name'])),
          DataCell(
            Text(
              DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(data[index]['Shipped_Date'])),
            ),
          ),
          DataCell(Text(data[index]['WareHouse_Code'].toString())),
          DataCell(Text(data[index]['Item'].toString())),
          DataCell(Text(data[index]['Quantity'].toString())),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
