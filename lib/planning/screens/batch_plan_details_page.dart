import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/batch_plan/providers/batch_plan_apis.dart';
import 'package:poultry_login_signup/batch_plan/widgets/edit_batch_plan_details_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/apicalls.dart';
import '../../screens/global_app_bar.dart';
import '../../screens/main_drawer_screen.dart';
import '../../screens/operations_screen.dart';
import '../../screens/secondary_dashboard_screen.dart';
import '../providers/activity_plan_apis.dart';

class BatchPlanDetailsPage extends StatefulWidget {
  BatchPlanDetailsPage({Key? key}) : super(key: key);

  static const routeName = '/BatchPlanDetailsPage';

  @override
  State<BatchPlanDetailsPage> createState() => _BatchPlanDetailsPageState();
}

class _BatchPlanDetailsPageState extends State<BatchPlanDetailsPage> {
  var query = '';
  ScrollController controller = ScrollController();

  String _batchPlanId = '';

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
    getPermission();
    getActivityId().then((value) {
      if (_batchPlanId != '') {
        fetchCredientials().then((token) {
          if (token != '') {
            Provider.of<BatchApis>(context, listen: false)
                .getIndividualBatchPlan(
              _batchPlanId,
              token,
            );
          }
        });
      }
    });

    super.initState();
  }

  var extratedBatchPlanningPermissions;

  Future<void> getPermission() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('Batch_Planning')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('Batch_Planning')!) as Map<String, dynamic>;

    extratedBatchPlanningPermissions = extratedUserData['Batch_Planning'];
    // print(extratedBatchPlanningPermissions);
  }

  Future<void> getActivityId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('Batch_Plan_Id')) {
      var extratedData = json.decode(prefs.getString('Batch_Plan_Id')!)
          as Map<String, dynamic>;

      _batchPlanId = extratedData['Batch_Plan_Id'].toString();
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

  Map<String, dynamic> _batchPlanDetails = {};
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

  void update(int value) {
    getActivityId().then((value) {
      if (_batchPlanId != '') {
        fetchCredientials().then((token) {
          if (token != '') {
            Provider.of<BatchApis>(context, listen: false)
                .getIndividualBatchPlan(
              _batchPlanId,
              token,
            );
          }
        });
      }
    });
  }

  var requiredDate;
  var hatchDate;

  @override
  Widget build(BuildContext context) {
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    _batchPlanDetails = Provider.of<BatchApis>(context).individualBatchPlan;

    if (_batchPlanDetails.isNotEmpty) {
      requiredDate = DateFormat("dd-MM-yyyy").format(
          DateTime.parse(_batchPlanDetails['Required_Date_Of_Delivery']));
      hatchDate = DateFormat("dd-MM-yyyy")
          .format(DateTime.parse(_batchPlanDetails['Hatch_Date']));
    }

    return Scaffold(
      drawer: MainDrawer(controller: controller),
      appBar: GlobalAppBar(firmName: query, appbar: AppBar()),
      body: Padding(
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
                      Get.offNamed(OperationsScreen.routeName);
                    },
                    child: Text('Operations', style: breadCrumpsStyle),
                  ),
                  const Icon(
                    Icons.arrow_back_ios_new,
                    size: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offNamed(OperationsScreen.routeName, arguments: 0);
                    },
                    child: Text(
                      'Planning',
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
                      _batchPlanDetails.isEmpty
                          ? ''
                          : _batchPlanDetails['Batch_Plan_Code'],
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
                  _batchPlanDetails.isEmpty
                      ? const SizedBox()
                      : Text(
                          _batchPlanDetails['Batch_Plan_Code'],
                          style:
                              // style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
                              GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 36),
                          ),
                        ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 143),
                  //   child: TextButton(
                  //     onPressed: () {
                  //       showGlobalDrawer(
                  //           context: context,
                  //           builder: (ctx) => EditBatchPlanDetails(
                  //                 reFresh: update,
                  //                 activityId: _batchPlanDetails[
                  //                     'Activity_Id__Activity_Code'],
                  //                 batchCode: _batchPlanDetails['Batch_Code'],
                  //                 birdAgeId:
                  //                     _batchPlanDetails['Bird_Age_Id__Name'],
                  //                 breedId:
                  //                     _batchPlanDetails['Breed_Id__Breed_Name'],
                  //                 breedVersionId:
                  //                     _batchPlanDetails['Breed_Version'],
                  //                 description: _batchPlanDetails[
                  //                     'Activity_Id__Activity_Code'],
                  //                 medicationPlanId: _batchPlanDetails[
                  //                     'Medication_Plan_Id__Medication_Code'],
                  //                 requiredDateOfDelivery: _batchPlanDetails[
                  //                     'Required_Date_Of_Delivery'],
                  //                 requiredQuantity:
                  //                     _batchPlanDetails['Required_Quantity']
                  //                         .toString(),
                  //                 vaccinationPlanId: _batchPlanDetails[
                  //                     'Vaccination_Plan_Id__Vaccination_Code'],
                  //                 wareHouseId: _batchPlanDetails[
                  //                     'WareHouse_Id__WareHouse_Code'],
                  //                 batchPlanId: _batchPlanDetails['Batch_Plan_Id'],
                  //                 hatchDate: _batchPlanDetails['Hatch_Date'],
                  //               ),
                  //           direction: AxisDirection.right);
                  //     },
                  //     child: Row(
                  //       children: [
                  //         Text(
                  //           'Edit Detail',
                  //           style: GoogleFonts.roboto(
                  //             textStyle: const TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 18,
                  //                 color: Colors.black),
                  //           ),
                  //         ),
                  //         const Icon(
                  //           Icons.arrow_drop_down_outlined,
                  //           size: 25,
                  //           color: Colors.black,
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 42),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Batch Details',
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
                          getHeadingContainer('Batch Code'),
                          const SizedBox(
                            width: 49,
                          ),
                          _batchPlanDetails.isEmpty
                              ? const SizedBox()
                              : getDataContainer(
                                  _batchPlanDetails['Batch_Plan_Code']
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
                          _batchPlanDetails.isEmpty
                              ? const SizedBox()
                              : getDataContainer(_batchPlanDetails[
                                      'Ware_House_Id__WareHouse_Code']
                                  .toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 42),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Breed Details',
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
                          getHeadingContainer('Breed Name'),
                          const SizedBox(
                            width: 49,
                          ),
                          _batchPlanDetails.isEmpty
                              ? const SizedBox()
                              : getDataContainer(
                                  _batchPlanDetails['Breed_Id__Breed_Name']
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
                          _batchPlanDetails.isEmpty
                              ? const SizedBox()
                              : getDataContainer(
                                  _batchPlanDetails['Breed_Version']
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
                          _batchPlanDetails.isEmpty
                              ? const SizedBox()
                              : getDataContainer(
                                  _batchPlanDetails['Bird_Age_Id__Name']
                                      .toString()),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          getHeadingContainer('Activity Code'),
                          const SizedBox(
                            width: 49,
                          ),
                          _batchPlanDetails.isEmpty
                              ? const SizedBox()
                              : getDataContainer(_batchPlanDetails[
                                      'Activity_Plan_Id__Activity_Code']
                                  .toString()),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          getHeadingContainer('Medication Code'),
                          const SizedBox(
                            width: 49,
                          ),
                          _batchPlanDetails.isEmpty
                              ? const SizedBox()
                              : Text(_batchPlanDetails[
                                      'Medication_Plan_Id__Medication_Code']
                                  .toString()),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          getHeadingContainer('Vaccination Code'),
                          const SizedBox(
                            width: 49,
                          ),
                          _batchPlanDetails.isEmpty
                              ? const SizedBox()
                              : Text(_batchPlanDetails[
                                      'Vaccination_Plan_Id__Vaccination_Code']
                                  .toString()),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          getHeadingContainer('Required Quantity'),
                          const SizedBox(
                            width: 49,
                          ),
                          _batchPlanDetails.isEmpty
                              ? const SizedBox()
                              : Text(_batchPlanDetails['Required_Quantity']
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
                          _batchPlanDetails.isEmpty
                              ? const SizedBox()
                              : Text(hatchDate ?? ''),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          getHeadingContainer('Required Date Of Delivery'),
                          const SizedBox(
                            width: 49,
                          ),
                          _batchPlanDetails.isEmpty
                              ? const SizedBox()
                              : Text(requiredDate ?? ''),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
