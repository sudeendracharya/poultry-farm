import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/sales_journal/providers/journal_api.dart';
import 'package:poultry_login_signup/sales_journal/widgets/add_sales_journal.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../../providers/apicalls.dart';
import '../../screens/global_app_bar.dart';
import '../../screens/main_dash_board.dart';
import '../../styles.dart';

class SalesDetailsPage extends StatefulWidget {
  SalesDetailsPage({Key? key, required this.id}) : super(key: key);

  final int id;

  static const routeName = '/SalesDetailsPage';

  @override
  State<SalesDetailsPage> createState() => _SalesDetailsPageState();
}

class _SalesDetailsPageState extends State<SalesDetailsPage> {
  var query = '';

  var saleId;

  Map<String, dynamic> salesDetails = {};

  var _firmName;

  var _firmCode;

  var _contactNumber;

  var _pan;

  var _permanentContactNumber;

  var _firmId;

  bool _isLoading = true;

  var _email;
  var _alternateContactNumber;

  var selected = false;

  var count = 0;

  List temp = [];

  var _productId;

  void updateCheckBox(int data) {}

  void update(int data) {
    getProductData().then((value) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<JournalApi>(context, listen: false)
            .getIndividualCustomerSalesJournalInfo(saleId, token);
      });
    });
  }

  Future<void> getProductData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('Sale_Id')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('Sale_Id')!) as Map<String, dynamic>;
    saleId = extratedUserData['Sale_Id'];
    print(saleId);
  }

  void reRun() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // productId = Get.arguments;

    getProductData().then((value) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<JournalApi>(context, listen: false)
            .getIndividualCustomerSalesJournalInfo(saleId, token);
      });
    });

    super.initState();
  }

  // void getUserRoles(int data) {
  //   Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
  //     var token = Provider.of<Apicalls>(context, listen: false).token;
  //     Provider.of<AdminApis>(context, listen: false).getUserRoles(token);
  //   });
  // }

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
      width: 350,
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

  int defaultRowsPerPage = 5;
  List selectedSaleCodes = [];

  @override
  Widget build(BuildContext context) {
    salesDetails = Provider.of<JournalApi>(context).individualSalesData;
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    final width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // Get.offNamed(ProductManagementPage.routeName, arguments: 0);

        return true;
      },
      child: Scaffold(
        appBar: GlobalAppBar(firmName: query, appbar: AppBar()),
        body: Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 43),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.offNamed(MainDashBoardScreen.routeName);
                      },
                      child: Text('Dashboard', style: breadCrumpsStyle),
                    ),
                    const Icon(
                      Icons.arrow_back_ios_new,
                      size: 15,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('Sales', style: breadCrumpsStyle),
                    ),
                    const Icon(
                      Icons.arrow_back_ios_new,
                      size: 15,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: salesDetails.isEmpty
                          ? const SizedBox()
                          : Text(salesDetails['sale']['Sale_Code'],
                              style: breadCrumpsStyle),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      salesDetails.isEmpty
                          ? const SizedBox()
                          : Text(
                              salesDetails['sale']['Sale_Code'],
                              style:
                                  // style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
                                  GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 36),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(right: 143),
                        child: TextButton(
                          onPressed: () {
                            showGlobalDrawer(
                                context: context,
                                builder: (ctx) => AddSalesJournal(
                                    name: '',
                                    id: '',
                                    customerType: '',
                                    reFresh: update,
                                    editData: salesDetails),
                                direction: AxisDirection.right);
                          },
                          child: Row(
                            children: [
                              // Text(
                              //   'Edit Detail',
                              //   style: GoogleFonts.roboto(
                              //     textStyle: const TextStyle(
                              //         fontWeight: FontWeight.w700,
                              //         fontSize: 18,
                              //         decoration: TextDecoration.underline,
                              //         color: Colors.black),
                              //   ),
                              // ),
                              // const Icon(
                              //   Icons.arrow_drop_down_outlined,
                              //   size: 25,
                              //   color: Colors.black,
                              // )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, top: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Sale Details',
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
                            getHeadingContainer('Sale Code'),
                            const SizedBox(
                              width: 55,
                            ),
                            salesDetails.isEmpty
                                ? const SizedBox()
                                : getDataContainer(salesDetails['sale']
                                        ['Sale_Code']
                                    .toString()),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 15,
                        // ),
                        // Row(
                        //   children: [
                        //     getHeadingContainer('Customer Name'),
                        //     const SizedBox(
                        //       width: 55,
                        //     ),
                        //     salesDetails.isEmpty
                        //         ? const SizedBox()
                        //         : getDataContainer(
                        //             salesDetails['Customer_Id__Customer_Name']),
                        //   ],
                        // ),

                        Row(
                          children: [
                            getHeadingContainer('Shipped Date'),
                            const SizedBox(
                              width: 55,
                            ),
                            salesDetails.isEmpty
                                ? const SizedBox()
                                : getDataContainer(
                                    DateFormat('dd-MM-yyyy').format(
                                        DateTime.parse(salesDetails['sale']
                                            ['Despatch_Date'])),
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
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
                                'Product List',
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
                                width: MediaQuery.of(context).size.width * 0.5,
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // extratedSalesPermissions['Create'] == true
                                    //     ?
                                    // IconButton(
                                    //   onPressed: () {
                                    //     // showGlobalDrawer(
                                    //     //     context: context,
                                    //     //     builder: (ctx) => AddSalesJournal(
                                    //     //           name: individualCustomerInfo[
                                    //     //               'Individual_Customer_Name'],
                                    //     //           id: individualCustomerInfo[
                                    //     //                   'Customer']
                                    //     //               .toString(),
                                    //     //           customerType: 'Individual',
                                    //     //           editData: {},
                                    //     //           reFresh: update,
                                    //     //         ),
                                    //     //     direction: AxisDirection.right);
                                    //   },
                                    //   icon: const Icon(Icons.add),
                                    // ),
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
                                  width: size.width * 0.5,
                                  child: PaginatedDataTable(
                                    source: MySearchData(
                                        salesDetails['sale_items'] ?? [],
                                        updateCheckBox),
                                    arrowHeadColor: ProjectColors.themecolor,

                                    columns: [
                                      DataColumn(
                                          label: Text('Warehouse',
                                              style: ProjectStyles
                                                  .paginatedHeaderStyle())),
                                      DataColumn(
                                          label: Text('Batch ',
                                              style: ProjectStyles
                                                  .paginatedHeaderStyle())),
                                      DataColumn(
                                          label: Text('Product',
                                              style: ProjectStyles
                                                  .paginatedHeaderStyle())),
                                      DataColumn(
                                          label: Text('Quantity',
                                              style: ProjectStyles
                                                  .paginatedHeaderStyle())),
                                      DataColumn(
                                          label: Text('Price',
                                              style: ProjectStyles
                                                  .paginatedHeaderStyle())),
                                      DataColumn(
                                          label: Text('CW Quantity',
                                              style: ProjectStyles
                                                  .paginatedHeaderStyle())),
                                      DataColumn(
                                          label: Text('Unit',
                                              style: ProjectStyles
                                                  .paginatedHeaderStyle())),
                                      DataColumn(
                                          label: Text('CW Unit',
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
        // onSelectChanged: (value) {
        //   data[index]['Is_Selected'] = value;
        //   reFresh(100);
        //   if (selectedSaleCodes.isEmpty) {
        //     selectedSaleCodes.add(data[index]['Sale_Id']);
        //   } else {
        //     if (value == true) {
        //       selectedSaleCodes.add(data[index]['Sale_Id']);
        //     } else {
        //       selectedSaleCodes.remove(data[index]['Sale_Id']);
        //     }
        //   }
        //   // print(selectedSaleCodes);
        // },
        // selected: data[index]['Is_Selected'],
        cells: [
          DataCell(Text(data[index]['WareHouse_Id'].toString())),
          DataCell(Text(data[index]['Batch_Plan_Id'].toString())),
          DataCell(Text(data[index]['Product_Id'].toString())),
          DataCell(Text(data[index]['Quantity'].toString())),
          DataCell(Text(data[index]['Price'].toString())),
          DataCell(Text(data[index]['CW_Quantity'].toString())),
          DataCell(Text(data[index]['Unit'].toString())),
          DataCell(Text(data[index]['CW_Unit'].toString())),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
