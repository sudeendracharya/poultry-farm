import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/items/screens/product_details.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../widgets/administration_search_widget.dart';
import '../providers/items_apis.dart';
import '../widgets/add_item_details_dialog.dart';

class ProductManagementSecondary extends StatefulWidget {
  ProductManagementSecondary({Key? key}) : super(key: key);

  static const routeName = '/ProductManagementSecondary';

  @override
  State<ProductManagementSecondary> createState() =>
      _ProductManagementSecondaryState();
}

class _ProductManagementSecondaryState
    extends State<ProductManagementSecondary> {
  ScrollController controller = ScrollController();

  String query = '';

  List productDetails = [];

  List list = [];

  bool plantSelected = false;

  var extratedPermissions;
  bool loading = true;

  @override
  void initState() {
    getPermission('Product_Management').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getProductDetails(token)
          .then((value) => null);
    });
    super.initState();
  }

  void fetchProducts() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getProductDetails(token)
          .then((value) => null);
    });
  }

  void deleteProducts(List ids) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .deleteProducts(token, ids)
          .then((value) {
        if (value == 204) {
          fetchProducts();
          successSnackbar('Successfully deleted the product');
        } else {
          failureSnackbar('something went wrong please try again');
          fetchProducts();
        }
      });
    });
  }

  List productDeleteList = [];

  void searchBook(String query) {
    final searchOutput = productDetails.where((details) {
      final birdName = details['Product_Name'].toString().toLowerCase();

      final searchName = query.toLowerCase();

      return birdName.contains(searchName);
    }).toList();

    setState(() {
      this.query = query;
      list = searchOutput;
    });
  }

  @override
  Widget build(BuildContext context) {
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    var width = MediaQuery.of(context).size.width;
    var halfWidth = MediaQuery.of(context).size.width / 2;
    productDetails = Provider.of<ItemApis>(context).productDetails;
    if (query == '') {
      list = productDetails;
    }
    final expansionHeaderTheme = Theme.of(context).textTheme.headline6;

    return loading == true
        ? const Center(
            child: Text('Loading'),
          )
        : extratedPermissions['View'] == false
            ? const SizedBox(
                child: Center(
                  child: Text('You don\'t have access to view this page'),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 45.0, top: 18),
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     TextButton(
                    //       onPressed: () {
                    //         Get.offNamed(SecondaryDashBoardScreen.routeName);
                    //       },
                    //       child: Text('Dashboard', style: breadCrumpsStyle),
                    //     ),
                    //     const Icon(
                    //       Icons.arrow_back_ios_new,
                    //       size: 15,
                    //     ),
                    //     TextButton(
                    //       onPressed: () {},
                    //       child: Text(
                    //         'Product Management',
                    //         style: GoogleFonts.roboto(
                    //             fontWeight: FontWeight.w500,
                    //             fontSize: 18,
                    //             color: const Color.fromRGBO(0, 0, 0, 0.5)),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 10),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Product Management',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Container(
                                    width: 253,
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   border: Border.all(),
                                    // ),
                                    child: AdministrationSearchWidget(
                                      search: (value) {},
                                      reFresh: (value) {},
                                      text: query,
                                      onChanged: searchBook,
                                      hintText: 'Search',
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 4.3,
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Row(
                                    children: [
                                      extratedPermissions['Create'] == true
                                          ? IconButton(
                                              onPressed: () {
                                                // showDialog(
                                                //     context: context,
                                                //     builder: (ctx) => AddFirmDetailsDialog());
                                                showGlobalDrawer(
                                                  context: context,
                                                  builder: (ctx) =>
                                                      AddItemDetailsDialog(),
                                                  direction:
                                                      AxisDirection.right,
                                                ).then((value) {
                                                  if (value == 'success') {
                                                    fetchProducts();
                                                  }
                                                });

                                                //     direction: );
                                              },
                                              icon: const Icon(Icons.add),
                                            )
                                          : const SizedBox(),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      extratedPermissions['Delete'] == true
                                          ? IconButton(
                                              onPressed: () {
                                                if (productDeleteList
                                                    .isNotEmpty) {
                                                  deleteProducts(
                                                      productDeleteList);
                                                }
                                              },
                                              icon: const Icon(Icons.delete),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        2.5,
                                    // decoration: BoxDecoration(border: Border.all()),
                                    child: InteractiveViewer(
                                      alignPanAxis: true,
                                      constrained: false,
                                      // panEnabled: false,
                                      scaleEnabled: false,
                                      child: DataTable(
                                          onSelectAll: (value) {},
                                          showCheckboxColumn: true,
                                          columnSpacing: 34,
                                          headingTextStyle: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                            ),
                                          ),
                                          columns: const <DataColumn>[
                                            DataColumn(
                                                label: Text(
                                              'Product Id',
                                              textAlign: TextAlign.left,
                                            )),
                                            DataColumn(
                                                label: Text('Product Name')),
                                            DataColumn(
                                                label: Text('Product type')),
                                            DataColumn(
                                                label:
                                                    Text('Product Sub type')),
                                            DataColumn(
                                                label: Text(
                                                    'Unit of Measurement')),
                                            DataColumn(
                                                label: Text('Description')),
                                          ],
                                          rows: productDetails.isEmpty
                                              ? []
                                              : <DataRow>[
                                                  for (var data in list)
                                                    DataRow(
                                                      key: UniqueKey(),
                                                      selected:
                                                          data['Is_Selected'],
                                                      onSelectChanged: (value) {
                                                        setState(() {
                                                          data['Is_Selected'] =
                                                              value!;
                                                          if (value == true) {
                                                            productDeleteList
                                                                .add(data[
                                                                    'Product_Id']);
                                                          } else {
                                                            productDeleteList
                                                                .remove(data[
                                                                    'Product_Id']);
                                                          }

                                                          // selectedFirmId = data['Firm_Id'];
                                                        });
                                                      },
                                                      cells: <DataCell>[
                                                        DataCell(
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              final prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();

                                                              if (prefs.containsKey(
                                                                  'Product_Id')) {
                                                                prefs.remove(
                                                                    'Product_Id');
                                                              }
                                                              final userData =
                                                                  json.encode(
                                                                {
                                                                  'Product_Id':
                                                                      data[
                                                                          'Product_Id'],
                                                                },
                                                              );
                                                              prefs.setString(
                                                                  'Product_Id',
                                                                  userData);

                                                              Get.toNamed(
                                                                  ProductDetailsPage
                                                                      .routeName,
                                                                  arguments: data[
                                                                      'Product_Id']);
                                                            },
                                                            child: Text(data[
                                                                    'Product_Code'] ??
                                                                'Product Code'),
                                                          ),
                                                        ),
                                                        // DataCell(Text(data['Firm_Name'])),
                                                        DataCell(Text(data[
                                                                'Product_Name'] ??
                                                            'Product Name')),
                                                        DataCell(
                                                          Text(
                                                            data[
                                                                'Product_Category_Id'],
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            data[
                                                                'Product_Sub_Category_Id'],
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(data[
                                                                  'Unit_Of_Measure'] ??
                                                              'Unit of Measurement'),
                                                        ),
                                                        DataCell(
                                                          Text(data[
                                                                  'Description'] ??
                                                              'Description'),
                                                        ),
                                                      ],
                                                    ),
                                                ]),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}
