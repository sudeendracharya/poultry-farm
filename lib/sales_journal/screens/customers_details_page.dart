import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../screens/global_app_bar.dart';
import '../../styles.dart';
import '../providers/journal_api.dart';
import '../widgets/add_sales_journal.dart';
import 'sales_details_page.dart';

class CustomerDetailsPage extends StatefulWidget {
  CustomerDetailsPage({Key? key}) : super(key: key);

  static const routeName = '/CustomerDetailsPage';

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  String query = '';

  var customerId;

  var customerName;

  Map individualCustomerInfo = {};
  int defaultRowsPerPage = 5;
  List journalDetails = [];

  var customer;

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

  @override
  void initState() {
    var id = Get.arguments;
    fetchCustomerId().then((value) {
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<JournalApi>(context, listen: false)
              .getIndividualCustomersInfo(customerId, token);
          Provider.of<JournalApi>(context, listen: false)
              .getCustomerSalesJournalInfo(customer, token);
        }
      });
    });

    super.initState();
  }

  List list = [];

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<JournalApi>(context, listen: false)
            .getCustomerSalesJournalInfo(customer, token);
      }
    });
  }

  void updateCheckBox(int data) {
    setState(() {});
  }

  Future<void> fetchCustomerId() async {
    var pref = await SharedPreferences.getInstance();
    if (pref.containsKey('Customer_Id')) {
      var extratedData = json.decode(pref.getString('Customer_Id')!);

      customerId = extratedData['Customer_Id'];
      customer = extratedData['Customer'];
    }
  }

  TextStyle styleData() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
    );
  }

  TextStyle headingStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    );
  }

  TextStyle dataStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
    );
  }

  Container getHeadingContainer(var data) {
    return Container(
      width: 250,
      height: 25,
      child: Text(
        data,
        style: headingStyle(),
      ),
    );
  }

  Container getDataContainer(var data) {
    return Container(
      width: 200,
      height: 25,
      child: Text(
        data,
        style: dataStyle(),
      ),
    );
  }

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
              // update(100);
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

  List selectedSaleCodes = [];

  @override
  Widget build(BuildContext context) {
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    final size = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width;
    individualCustomerInfo =
        Provider.of<JournalApi>(context).individualCustomerInfoData;
    journalDetails = Provider.of<JournalApi>(context).journalInfo;

    return Scaffold(
      appBar: GlobalAppBar(firmName: query, appbar: AppBar()),
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0, left: 43),
        child: SingleChildScrollView(
          child: individualCustomerInfo.isEmpty
              ? const SizedBox()
              : Column(
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child:
                              Text('Customers List', style: breadCrumpsStyle),
                        ),
                        const Icon(
                          Icons.arrow_back_ios_new,
                          size: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            // Get.offNamed(FirmsPage.routeName);
                          },
                          child:
                              Text('Customer Details', style: breadCrumpsStyle),
                        ),
                        // const Icon(
                        //   Icons.arrow_back_ios_new,
                        //   size: 15,
                        // ),
                        // TextButton(
                        //   onPressed: () {},
                        //   child: _firmName == null
                        //       ? const SizedBox()
                        //       : Text(_firmName, style: breadCrumpsStyle),
                        // ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            individualCustomerInfo['Individual_Customer_Name'],
                            style:
                                // style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
                                GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 36),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 30),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Customer Details',
                          style: styleData(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0, top: 14),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                getHeadingContainer('Permanent Account Number'),
                                const SizedBox(
                                  width: 49,
                                ),
                                getDataContainer(
                                  individualCustomerInfo[
                                      'Customer__Permanent_Account_Number'],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Country'),
                                const SizedBox(
                                  width: 49,
                                ),
                                getDataContainer(
                                  individualCustomerInfo['Customer__Country'],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('State'),
                                const SizedBox(
                                  width: 49,
                                ),
                                getDataContainer(
                                  individualCustomerInfo['Customer__State'],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('City'),
                                const SizedBox(
                                  width: 49,
                                ),
                                getDataContainer(
                                  individualCustomerInfo['Customer__City'],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Street'),
                                const SizedBox(
                                  width: 49,
                                ),
                                getDataContainer(
                                  individualCustomerInfo['Customer__Street'],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Pincode'),
                                const SizedBox(
                                  width: 49,
                                ),
                                getDataContainer(
                                  individualCustomerInfo['Customer__Pincode']
                                      .toString(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Contact Number'),
                                const SizedBox(
                                  width: 49,
                                ),
                                getDataContainer(
                                  individualCustomerInfo[
                                          'Customer__Contact_Number']
                                      .toString(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Email Id'),
                                const SizedBox(
                                  width: 49,
                                ),
                                getDataContainer(
                                  individualCustomerInfo['Email_Id'],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            'Customer Sales',
                            style: ProjectStyles.contentHeaderStyle()
                                .copyWith(fontSize: 26),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 20.0),
                          //   child: Container(
                          //     width: 253,
                          //     child: AdministrationSearchWidget(
                          //         search: (value) {},
                          //         reFresh: (value) {},
                          //         text: query,
                          //         onChanged: searchBook,
                          //         hintText: 'Search'),
                          //   ),
                          // ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // extratedSalesPermissions['Create'] == true
                                //     ?
                                IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) => AddSalesJournal(
                                              name: individualCustomerInfo[
                                                  'Individual_Customer_Name'],
                                              id: individualCustomerInfo[
                                                      'Customer']
                                                  .toString(),
                                              customerType: 'Individual',
                                              editData: {},
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
                                // extratedSalesPermissions['Delete'] == true
                                //     ?
                                // IconButton(
                                //   onPressed: delete,
                                //   icon: const Icon(Icons.delete),
                                // )
                                // : const SizedBox(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              width: size.width * 0.3,
                              child: PaginatedDataTable(
                                source: MySearchData(
                                    query == '' ? journalDetails : list,
                                    updateCheckBox),
                                arrowHeadColor: ProjectColors.themecolor,

                                columns: [
                                  DataColumn(
                                      label: Text('Sale Code',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Date',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
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
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
        ),
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
          DataCell(
            Text(
              DateFormat('dd-MM-yyyy')
                  .format(DateTime.parse(data[index]['Despatch_Date'])),
            ),
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
