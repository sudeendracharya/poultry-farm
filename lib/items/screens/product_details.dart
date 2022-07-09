import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/items/screens/product_management.dart';
import 'package:poultry_login_signup/items/widgets/edit_product_details_dialog.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/items/providers/items_apis.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../admin/providers/admin_apis.dart';
import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../main.dart';
import '../../screens/global_app_bar.dart';
import '../../screens/main_dash_board.dart';
import '../../search_widget.dart';

class ProductDetailsPage extends StatefulWidget {
  ProductDetailsPage({Key? key}) : super(key: key);
  static const routeName = '/ItemDetails';

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  var query = '';

  var productId;

  Map<String, dynamic> productDetails = {};

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

  var extratedPermissions;
  bool loading = true;

  void update(int data) {
    getProductData().then((value) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<ItemApis>(context, listen: false)
            .getIndividualProductDetails(token, productId);
      });
    });
  }

  Future<void> getProductData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('Product_Id')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('Product_Id')!) as Map<String, dynamic>;
    productId = extratedUserData['Product_Id'];
  }

  void reRun() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // productId = Get.arguments;
    getPermission('Product_Management').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });

    getProductData().then((value) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<ItemApis>(context, listen: false)
            .getIndividualProductDetails(token, productId);
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
    productDetails = Provider.of<ItemApis>(context).individualProductData;
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(ProductManagementPage.routeName, arguments: 0);
        return true;
      },
      child: Scaffold(
        appBar: GlobalAppBar(query: query, appbar: AppBar()),
        body: loading == true
            ? const Center(
                child: Text('Loading'),
              )
            : Padding(
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
                            child: Text('Product Management',
                                style: breadCrumpsStyle),
                          ),
                          const Icon(
                            Icons.arrow_back_ios_new,
                            size: 15,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: productDetails.isEmpty
                                ? const SizedBox()
                                : Text(productDetails['Product_Code'],
                                    style: breadCrumpsStyle),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            productDetails.isEmpty
                                ? const SizedBox()
                                : Text(
                                    productDetails['Product_Code'],
                                    style:
                                        // style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
                                        GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 36),
                                    ),
                                  ),
                            extratedPermissions['Edit'] == true
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 143),
                                    child: TextButton(
                                      onPressed: () {
                                        showGlobalDrawer(
                                            context: context,
                                            builder: (ctx) =>
                                                EditProductDetails(
                                                  barchRequestInventoryAdjustment:
                                                      productDetails[
                                                          'Batch_Request_Inventory_Adjustment'],
                                                  batchRequestForGrading:
                                                      productDetails[
                                                          'Batch_Request_For_Grading'],
                                                  batchRequestForMortality:
                                                      productDetails[
                                                          'Batch_Request_For_Mortality'],
                                                  batchRequestForTransfer:
                                                      productDetails[
                                                          'Batch_Request_For_Transfer'],
                                                  description: productDetails[
                                                      'Description'],
                                                  grade:
                                                      productDetails['Grade'],
                                                  productCategoryId: productDetails[
                                                      'Product_Category_Id__Product_Category_Name'],
                                                  productCode: productDetails[
                                                      'Product_Code'],
                                                  productId: productDetails[
                                                      'Product_Id'],
                                                  productName: productDetails[
                                                      'Product_Name'],
                                                  productSubCategoryId:
                                                      productDetails[
                                                          'Product_Sub_Category_Id__Product_Sub_Category_Name'],
                                                  reFresh: update,
                                                  stockKeepingUnit: productDetails[
                                                          'Stock_Keeping_Unit']
                                                      .toString(),
                                                  unitOfMeasure: productDetails[
                                                      'Unit_Of_Measure'],
                                                ),
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
                                                  decoration:
                                                      TextDecoration.underline,
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
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 30),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Product Details',
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
                                  getHeadingContainer('Product Code'),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                  productDetails.isEmpty
                                      ? const SizedBox()
                                      : getDataContainer(
                                          productDetails['Product_Code']
                                              .toString()),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  getHeadingContainer('Product Name'),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                  productDetails.isEmpty
                                      ? const SizedBox()
                                      : getDataContainer(
                                          productDetails['Product_Name']),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  getHeadingContainer('Product Type '),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                  productDetails.isEmpty
                                      ? const SizedBox()
                                      : getDataContainer(productDetails[
                                          'Product_Category_Id__Product_Category_Name']),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  getHeadingContainer('Product Sub Type'),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                  productDetails.isEmpty
                                      ? const SizedBox()
                                      : getDataContainer(
                                          productDetails[
                                              'Product_Sub_Category_Id__Product_Sub_Category_Name'],
                                        ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  getHeadingContainer(
                                      'Unit of Measurement/SKU'),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                  productDetails.isEmpty
                                      ? const SizedBox()
                                      : getDataContainer(
                                          productDetails['Unit_Of_Measure']),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  getHeadingContainer('Product Description'),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                  productDetails.isEmpty
                                      ? const SizedBox()
                                      : getDataContainer(
                                          productDetails['Description']),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  getHeadingContainer(
                                      'Required batch number for transfer'),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                  productDetails.isEmpty
                                      ? const SizedBox()
                                      : getDataContainer(productDetails[
                                          'Batch_Request_For_Transfer']),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  getHeadingContainer(
                                      'Required batch number for inventory adjustment'),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                  productDetails.isEmpty
                                      ? const SizedBox()
                                      : getDataContainer(productDetails[
                                          'Batch_Request_Inventory_Adjustment']),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  getHeadingContainer(
                                      'Required batch number for inventory mortality'),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                  productDetails.isEmpty
                                      ? const SizedBox()
                                      : getDataContainer(productDetails[
                                          'Batch_Request_For_Mortality']),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  getHeadingContainer(
                                      'Required batch number for grading'),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                  productDetails.isEmpty
                                      ? const SizedBox()
                                      : getDataContainer(productDetails[
                                          'Batch_Request_For_Grading']),
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
