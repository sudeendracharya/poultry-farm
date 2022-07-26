import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/colors.dart';
import 'package:poultry_login_signup/inventory/providers/inventory_api.dart';
import 'package:poultry_login_signup/inventory/screens/inventory_screen.dart';
import 'package:poultry_login_signup/inventory/widgets/add_batch_screen.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/global_app_bar.dart';
import '../../screens/main_drawer_screen.dart';
import '../../screens/secondary_dashboard_screen.dart';

class InventoryBatchDetailScreen extends StatefulWidget {
  InventoryBatchDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/InventoryBatchDetailScreen';

  @override
  _InventoryBatchDetailScreenState createState() =>
      _InventoryBatchDetailScreenState();
}

class _InventoryBatchDetailScreenState
    extends State<InventoryBatchDetailScreen> {
  var query = '';

  var _plantName;

  var _batchName;

  var _grading;

  var _productionRate;

  var _feedConsumptionRate;

  var _mortalityRate;

  bool _isloading = true;

  var _wareHouseCode;

  Map<String, dynamic> batchDetailsData = {};

  var _batchPlanId;

  ScrollController controller = ScrollController();

  String? hatchDate;

  String? receiptDate;

  void update(int data) {
    getBatchData().then((value) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InventoryApi>(context, listen: false)
            .getSingleBatch(
              _batchPlanId,
              token,
            )
            .then((value1) {});
      });
    });
  }

  get breadCrumpsStyle => null;

  TextStyle headTextStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: Color.fromRGBO(0, 0, 0, 1),
      ),
    );
  }

  TextStyle paraTextStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Color.fromRGBO(68, 68, 68, 1),
      ),
    );
  }

  TextStyle paraDetailsTextStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Color.fromRGBO(68, 68, 68, 1),
      ),
    );
  }

  Future<void> getBatchData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('Batch_Plan_Id')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('Batch_Plan_Id')!) as Map<String, dynamic>;
    _batchPlanId = extratedUserData['Batch_Plan_Id'];
  }

  var extratedPermissions;
  bool loading = true;
  @override
  void initState() {
    getPermission('Add_Batch').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    getBatchData().then((value) {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InventoryApi>(context, listen: false)
            .getSingleBatch(
              _batchPlanId,
              token,
            )
            .then((value1) {});
      });
    });
    super.initState();
  }

  void reRun() {
    setState(() {
      _isloading = false;
    });
  }

  Container getHeadingContainer(var data) {
    return Container(
      width: 200,
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

  var requiredDateofDelivery;
  var expectedHatchDate;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    batchDetailsData = Provider.of<InventoryApi>(context).singleBatchDetails;
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    if (batchDetailsData.isNotEmpty) {
      requiredDateofDelivery = DateFormat("dd-MM-yyyy").format(
          DateTime.parse(batchDetailsData['Required_Date_Of_Delivery']));
      expectedHatchDate = DateFormat("dd-MM-yyyy")
          .format(DateTime.parse(batchDetailsData['Expected_Hatch_Date']));
      hatchDate = batchDetailsData['Hatch_Date'] == null
          ? null
          : DateFormat("dd-MM-yyyy")
              .format(DateTime.parse(batchDetailsData['Hatch_Date']));
      receiptDate = batchDetailsData['Receipt_Date'] == null
          ? null
          : DateFormat("dd-MM-yyyy")
              .format(DateTime.parse(batchDetailsData['Receipt_Date']));
    }
    return Scaffold(
      drawer: MainDrawer(controller: controller),
      appBar: GlobalAppBar(firmName: query, appbar: AppBar()),
      body: loading == true
          ? const Center(
              child: Text('Loading'),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 43, vertical: 18),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.offNamed(SecondaryDashBoardScreen.routeName);
                          },
                          child: Text('Dashboard', style: breadCrumpsStyle),
                        ),
                        const Icon(
                          Icons.arrow_back_ios_new,
                          size: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.offNamed(InventoryScreen.routeName,
                                arguments: 0);
                          },
                          child: Text('Inventory', style: breadCrumpsStyle),
                        ),
                        const Icon(
                          Icons.arrow_back_ios_new,
                          size: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.offNamed(InventoryScreen.routeName,
                                arguments: 1);
                          },
                          child: Text(
                            'Batch',
                            style: breadCrumpsStyle,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_back_ios_new,
                          size: 15,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            batchDetailsData.isEmpty
                                ? ''
                                : batchDetailsData['Batch_Plan_Code'],
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: const Color.fromRGBO(0, 0, 0, 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        batchDetailsData.isEmpty
                            ? const SizedBox()
                            : Text(
                                batchDetailsData['Batch_Plan_Code'],
                                style:
                                    // style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
                                    GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 36),
                                ),
                              ),
                        extratedPermissions['Edit'] == false
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(right: 143),
                                child: TextButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) => AddBatchScreen(
                                              reFresh: update,
                                              editData: batchDetailsData,
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
                              ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 42),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Batch Plan Details',
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
                                getHeadingContainer('Batch Plan Code'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : getDataContainer(
                                        batchDetailsData['Batch_Plan_Code']
                                            .toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Warehouse code'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : getDataContainer(batchDetailsData[
                                            'Ware_House_Id__WareHouse_Code']
                                        .toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Warehouse section'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : Container(
                                        height: 25,
                                        width: size.width * 0.6,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: batchDetailsData[
                                                  'WareHouse_Section_Id']
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Text(
                                              ' ${batchDetailsData['WareHouse_Section_Id'][index]}, ',
                                              style: dataStyle(),
                                            );
                                          },
                                        ),
                                      ),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Warehouse section Line'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : Container(
                                        height: 25,
                                        width: size.width * 0.7,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: batchDetailsData[
                                                  'WareHouse_Section_Line_Id']
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Text(
                                              ' ${batchDetailsData['WareHouse_Section_Line_Id'][index]}, ',
                                              style: dataStyle(),
                                            );
                                          },
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 30.0, top: 42),
                    //   child: Align(
                    //     alignment: Alignment.topLeft,
                    //     child: Text(
                    //       'Breed Details',
                    //       style: styleData(),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0, top: 14),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                getHeadingContainer('Breed Name'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : getDataContainer(
                                        batchDetailsData['Breed_Id__Breed_Name']
                                            .toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Breed Version'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : getDataContainer(
                                        batchDetailsData['Breed_Version']
                                            .toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Bird Age Group Name'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : getDataContainer(
                                        batchDetailsData['Bird_Age_Id__Name']
                                            .toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            // Row(
                            //   children: [
                            //     getHeadingContainer('Activity Code'),
                            //     const SizedBox(
                            //       width: 49,
                            //     ),
                            //     batchDetailsData.isEmpty
                            //         ? const SizedBox()
                            //         : getDataContainer(
                            //             batchDetailsData['Activity_Id__Activity_Code']
                            //                 .toString()),
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 14,
                            // ),
                            // Row(
                            //   children: [
                            //     getHeadingContainer('Medication Code'),
                            //     const SizedBox(
                            //       width: 49,
                            //     ),
                            //     batchDetailsData.isEmpty
                            //         ? const SizedBox()
                            //         : Text(batchDetailsData[
                            //                 'Medication_Plan_Id__Medication_Code']
                            //             .toString()),
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 14,
                            // ),
                            // Row(
                            //   children: [
                            //     getHeadingContainer('Vaccination Code'),
                            //     const SizedBox(
                            //       width: 49,
                            //     ),
                            //     batchDetailsData.isEmpty
                            //         ? const SizedBox()
                            //         : Text(batchDetailsData[
                            //                 'Vaccination_Plan_Id__Vaccination_Code']
                            //             .toString()),
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 14,
                            // ),
                            Row(
                              children: [
                                getHeadingContainer('Required Quantity'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : Text(batchDetailsData['Required_Quantity']
                                        .toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Expected Hatch Date'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : Text(expectedHatchDate ?? ''),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                getHeadingContainer(
                                    'Required Date of Delivery'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : Text(requiredDateofDelivery ?? ''),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Unit'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : Text(
                                        batchDetailsData['Unit_Id__Unit_Name']
                                            .toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Grade'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : Text(batchDetailsData[
                                            'Bird_Grade_Id__Bird_Grade']
                                        .toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: [
                                getHeadingContainer('Status'),
                                const SizedBox(
                                  width: 49,
                                ),
                                batchDetailsData.isEmpty
                                    ? const SizedBox()
                                    : Text(
                                        batchDetailsData['Status'].toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 42),
                      child: Row(
                        mainAxisAlignment:
                            batchDetailsData['Batch_Code'] == null
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Batch Details ',
                            style: styleData(),
                          ),
                          batchDetailsData['Batch_Code'] == null
                              ? IconButton(
                                  onPressed: () {
                                    // showGlobalDrawer(
                                    //     context: context,
                                    //     builder: (ctx) =>
                                    //         AddBatchPlanDetailsDialog(
                                    //           editData: {},
                                    //           id: _batchPlanId.toString(),
                                    //           reFresh: update,
                                    //         ),
                                    //     direction: AxisDirection.right);
                                  },
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: ProjectColors.themecolor,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(right: 143.0),
                                  child: TextButton(
                                    onPressed: () {
                                      // showGlobalDrawer(
                                      //     context: context,
                                      //     builder: (ctx) =>
                                      //         AddBatchPlanDetailsDialog(
                                      //           editData: batchDetailsData,
                                      //           id: _batchPlanId.toString(),
                                      //           reFresh: update,
                                      //         ),
                                      //     direction: AxisDirection.right);
                                    },
                                    child: Text(
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
                                  ),
                                )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    batchDetailsData['Batch_Code'] == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    getHeadingContainer('Batch Code'),
                                    const SizedBox(
                                      width: 49,
                                    ),
                                    batchDetailsData.isEmpty
                                        ? const SizedBox()
                                        : Text(batchDetailsData['Batch_Code']
                                            .toString()),
                                  ],
                                ),

                                // const SizedBox(
                                //   height: 14,
                                // ),
                                // Row(
                                //   children: [
                                //     getHeadingContainer('Breed Name'),
                                //     const SizedBox(
                                //       width: 49,
                                //     ),
                                //     batchDetailsData.isEmpty
                                //         ? const SizedBox()
                                //         : Text(batchDetailsData['Required_Quantity']
                                //             .toString()),
                                //   ],
                                // ),
                                // const SizedBox(
                                //   height: 14,
                                // ),
                                // Row(
                                //   children: [
                                //     getHeadingContainer('Breed Version'),
                                //     const SizedBox(
                                //       width: 49,
                                //     ),
                                //     batchDetailsData.isEmpty
                                //         ? const SizedBox()
                                //         : Text(batchDetailsData['Required_Quantity']
                                //             .toString()),
                                //   ],
                                // ),
                                const SizedBox(
                                  height: 14,
                                ),
                                Row(
                                  children: [
                                    getHeadingContainer('Received Quantity'),
                                    const SizedBox(
                                      width: 49,
                                    ),
                                    batchDetailsData.isEmpty
                                        ? const SizedBox()
                                        : Text(batchDetailsData[
                                                'Received_Quantity']
                                            .toString()),
                                  ],
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                Row(
                                  children: [
                                    getHeadingContainer('Hatch Date'),
                                    const SizedBox(
                                      width: 49,
                                    ),
                                    batchDetailsData.isEmpty
                                        ? const SizedBox()
                                        : Text(hatchDate.toString()),
                                  ],
                                ),
                                const SizedBox(
                                  height: 14,
                                ),
                                Row(
                                  children: [
                                    getHeadingContainer('Receipt Date'),
                                    const SizedBox(
                                      width: 49,
                                    ),
                                    batchDetailsData.isEmpty
                                        ? const SizedBox()
                                        : Text(receiptDate.toString()),
                                  ],
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
    );
  }
}
