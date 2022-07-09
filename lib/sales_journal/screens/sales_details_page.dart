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

import '../../providers/apicalls.dart';
import '../../screens/global_app_bar.dart';
import '../../screens/main_dash_board.dart';

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

  @override
  Widget build(BuildContext context) {
    salesDetails = Provider.of<JournalApi>(context).individualSalesData;
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // Get.offNamed(ProductManagementPage.routeName, arguments: 0);

        return true;
      },
      child: Scaffold(
        appBar: GlobalAppBar(query: query, appbar: AppBar()),
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
                          : Text(salesDetails['Sale_Code'],
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
                              salesDetails['Sale_Code'],
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
                              Text(
                                'Edit Detail',
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                      color: Colors.black),
                                ),
                              ),
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
                                : getDataContainer(
                                    salesDetails['Sale_Code'].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('Customer Name'),
                            const SizedBox(
                              width: 55,
                            ),
                            salesDetails.isEmpty
                                ? const SizedBox()
                                : getDataContainer(
                                    salesDetails['Customer_Id__Customer_Name']),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('Rate '),
                            const SizedBox(
                              width: 55,
                            ),
                            salesDetails.isEmpty
                                ? const SizedBox()
                                : getDataContainer(
                                    salesDetails['Rate'].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('Warehouse Name'),
                            const SizedBox(
                              width: 55,
                            ),
                            salesDetails.isEmpty
                                ? const SizedBox()
                                : getDataContainer(
                                    salesDetails['WareHouse_Id__WareHouse_Name']
                                        .toString(),
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
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
                                        DateTime.parse(
                                            salesDetails['Shipped_Date'])),
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('Batch Code'),
                            const SizedBox(
                              width: 55,
                            ),
                            salesDetails.isEmpty
                                ? const SizedBox()
                                : getDataContainer(salesDetails[
                                        'Batch_Plan_Id__Batch_Plan_Code']
                                    .toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('Item'),
                            const SizedBox(
                              width: 55,
                            ),
                            salesDetails.isEmpty
                                ? const SizedBox()
                                : getDataContainer(
                                    salesDetails['Product_Id__Product_Name']),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('Item Category'),
                            const SizedBox(
                              width: 55,
                            ),
                            salesDetails.isEmpty
                                ? const SizedBox()
                                : getDataContainer(salesDetails[
                                        'Product_Category_Id__Product_Category_Name']
                                    .toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('Quantity'),
                            const SizedBox(
                              width: 55,
                            ),
                            salesDetails.isEmpty
                                ? const SizedBox()
                                : getDataContainer(
                                    salesDetails['Quantity'].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('Quantity Unit'),
                            const SizedBox(
                              width: 55,
                            ),
                            salesDetails.isEmpty
                                ? const SizedBox()
                                : getDataContainer(
                                    salesDetails['Quantity_Unit'].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('CW Quantity'),
                            const SizedBox(
                              width: 55,
                            ),
                            salesDetails.isEmpty
                                ? const SizedBox()
                                : getDataContainer(
                                    salesDetails['CW_Quantity'].toString()),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('CW Unit'),
                            const SizedBox(
                              width: 55,
                            ),
                            salesDetails.isEmpty
                                ? const SizedBox()
                                : getDataContainer(
                                    salesDetails['CW_Unit'].toString()),
                          ],
                        )
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
