import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../planning/providers/activity_plan_apis.dart';
import '../../screens/global_app_bar.dart';
import '../../screens/main_drawer_screen.dart';
import '../../screens/operations_screen.dart';
import '../../screens/secondary_dashboard_screen.dart';

class BatchPlanDetails extends StatefulWidget {
  BatchPlanDetails({Key? key}) : super(key: key);
  static const routeName = '/BatchPlanDetails';

  @override
  _BatchPlanDetailsState createState() => _BatchPlanDetailsState();
}

class _BatchPlanDetailsState extends State<BatchPlanDetails> {
  var query = '';
  ScrollController controller = ScrollController();

  String _activityId = '';

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
    getActivityId().then((value) {
      if (_activityId != '') {
        fetchCredientials().then((token) {
          if (token != '') {
            Provider.of<ActivityApis>(context, listen: false)
                .getSingleActivityPlan(token, _activityId);
          }
        });
      }
    });

    super.initState();
  }

  Future<void> getActivityId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('Activity_Id')) {
      var extratedData =
          json.decode(prefs.getString('Activity_Id')!) as Map<String, dynamic>;
      // print(extratedData);
      _activityId = extratedData['Activity_Id'].toString();
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

  Map<String, dynamic> _activityDetails = {};
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

  void update(int value) {}

  @override
  Widget build(BuildContext context) {
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    _activityDetails = Provider.of<ActivityApis>(context).singleActivityPlan;
    return Scaffold(
      drawer: MainDrawer(controller: controller),
      appBar: GlobalAppBar(query: query, appbar: AppBar()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 43, vertical: 18),
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
                    _activityId.toString(),
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: const Color.fromRGBO(0, 0, 0, 0.5)),
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
                _activityId == ''
                    ? const SizedBox()
                    : Text(
                        _activityId.toString(),
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
                      // showGlobalDrawer(
                      //     context: context,
                      //     builder: (ctx) => EditActivityPlanDialog(
                      //           reFresh: update,
                      //           activityId:
                      //               _activityDetails['Activity_Id'].toString(),
                      //           recommendedBy:
                      //               _activityDetails['Recommended_By']
                      //                   .toString(),
                      //           activityList: _activityDetails['Activity_Plan'],
                      //           breedVersion:
                      //               _activityDetails['Breed_Version_Id']
                      //                   .toString(),
                      //         ),
                      //     direction: AxisDirection.right);
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
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 42),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Activity Details',
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
                        getHeadingContainer('Activity Plan ID'),
                        const SizedBox(
                          width: 49,
                        ),
                        _activityDetails.isEmpty
                            ? const SizedBox()
                            : getDataContainer(
                                _activityDetails['Activity_Id'].toString()),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        getHeadingContainer('Recommended By'),
                        const SizedBox(
                          width: 49,
                        ),
                        _activityDetails.isEmpty
                            ? const SizedBox()
                            : getDataContainer(
                                _activityDetails['Recommended_By'].toString()),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        getHeadingContainer('Relevent Breed Version'),
                        const SizedBox(
                          width: 49,
                        ),
                        _activityDetails.isEmpty
                            ? const SizedBox()
                            : getDataContainer(
                                _activityDetails['Breed_Version_Id']
                                    .toString()),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        getHeadingContainer('Description'),
                        const SizedBox(
                          width: 49,
                        ),
                        _activityDetails.isEmpty
                            ? const SizedBox()
                            : getDataContainer(''),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        getHeadingContainer('Activity Plan Information'),
                        const SizedBox(
                          width: 49,
                        ),
                        _activityDetails.isEmpty
                            ? const SizedBox()
                            : TextButton(
                                onPressed: () {},
                                child: const Text('Document')),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
