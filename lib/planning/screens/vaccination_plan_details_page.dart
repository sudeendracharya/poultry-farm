import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/planning/widgets/edit_vaccination_plan_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/apicalls.dart';
import '../../screens/dashboard_default_screen.dart';
import '../../screens/global_app_bar.dart';
import '../../screens/main_drawer_screen.dart';
import '../../screens/operations_screen.dart';
import '../../screens/secondary_dashboard_screen.dart';
import '../providers/activity_plan_apis.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Column, Row, Alignment;

class VaccinationPlanDetails extends StatefulWidget {
  VaccinationPlanDetails({Key? key}) : super(key: key);

  static const routeName = '/VaccinationPlanDetails';

  @override
  State<VaccinationPlanDetails> createState() => _VaccinationPlanDetailsState();
}

class _VaccinationPlanDetailsState extends State<VaccinationPlanDetails> {
  var query = '';
  ScrollController controller = ScrollController();

  String _vaccinationId = '';

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

  var extratedPermissions;
  bool loading = true;
  @override
  void initState() {
    getPermission('Vaccination_Plan').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    getActivityId().then((value) {
      if (_vaccinationId != '') {
        fetchCredientials().then((token) {
          if (token != '') {
            Provider.of<ActivityApis>(context, listen: false)
                .getSingleVaccinationPlan(token, _vaccinationId);
          }
        });
      }
    });

    super.initState();
  }

  Future<void> getActivityId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('Vaccination_Id')) {
      var extratedData = json.decode(prefs.getString('Vaccination_Id')!)
          as Map<String, dynamic>;
      // print(extratedData);
      _vaccinationId = extratedData['Vaccination_Id'].toString();
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

  Map<String, dynamic> _vaccinationDetails = {};
  Container getHeadingContainer(var data) {
    return Container(
      width: 200,
      height: 35,
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

  void downloadExcelSheet(List vaccinationDataList, var id) {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    Range range = sheet.getRangeByName('A1');
    range.setText('Age');
    range = sheet.getRangeByName('B1');
    range.setText('Mode');
    range = sheet.getRangeByName('C1');
    range.setText('Site');
    range = sheet.getRangeByName('D1');
    range.setText('Dosage');
    range = sheet.getRangeByName('E1');
    range.setText('Description');
    range = sheet.getRangeByName('F1');
    range.setText('Dosage_Unit');
    range = sheet.getRangeByName('G1');
    range.setText('Vaccination_Name');
    range = sheet.getRangeByName('H1');
    range.setText('Notification_Prior_Days');
    range = sheet.getRangeByName('I1');
    range.setText('Vaccine_Store_Temperature');

    List exportActivityList = [];

    for (var data in vaccinationDataList) {
      exportActivityList.add([
        data['Age'],
        data['Mode'],
        data['Site'],
        data['Dosage'],
        data['Description'],
        data['Dosage_Unit'],
        data['Vaccination_Name'],
        data['Notification_Prior_Days'],
        data['Vaccine_Store_Temperature'],
      ]);
    }

    for (int i = 0; i < exportActivityList.length; i++) {
      sheet.importList(exportActivityList[i], i + 2, 1, false);
    }
    final List<int> bytes = workbook.saveAsStream();

    // File file=File();

    // file.writeAsBytes(bytes);

    // _localFile.then((value) {
    //   final file = value;
    //   file.writeAsBytes(bytes);
    // });
    save(bytes, 'Vaccination$id.xlsx');

    // final blob = html.Blob([bytes], 'application/vnd.ms-excel');
    // final url = html.Url.createObjectUrlFromBlob(blob);
    // html.window.open(url, "_blank");
    // html.Url.revokeObjectUrl(url);
    workbook.dispose();
  }

  void save(Object bytes, String fileName) {
    js.context.callMethod("saveAs", <Object>[
      html.Blob(<Object>[bytes]),
      fileName
    ]);
  }

  void update(int value) {}

  @override
  Widget build(BuildContext context) {
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    _vaccinationDetails =
        Provider.of<ActivityApis>(context).singleVaccinationPlan;
    return Scaffold(
      drawer: MainDrawer(controller: controller),
      appBar: GlobalAppBar(query: query, appbar: AppBar()),
      body: loading == true
          ? const Center(
              child: Text('Loading'),
            )
          : Padding(
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
                          Get.offNamed(DashBoardDefaultScreen.routeName,
                              arguments: 2);
                        },
                        child: Text('Reference Data', style: breadCrumpsStyle),
                      ),
                      const Icon(
                        Icons.arrow_back_ios_new,
                        size: 15,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offNamed(DashBoardDefaultScreen.routeName,
                              arguments: 2);
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
                          _vaccinationDetails.isEmpty
                              ? ''
                              : _vaccinationDetails['Vaccination_Code'],
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
                      _vaccinationDetails.isEmpty
                          ? const SizedBox()
                          : Text(
                              _vaccinationDetails['Vaccination_Code'],
                              style:
                                  // style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
                                  GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 36),
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
                                          EditVaccinationPlanDialog(
                                            vaccinationId: _vaccinationId,
                                            reFresh: update,
                                            recommendedBy: _vaccinationDetails[
                                                'Recommended_By'],
                                            vaccinationPlan:
                                                _vaccinationDetails[
                                                    'Vaccination_Plan'],
                                            breedVersionId: _vaccinationDetails[
                                                    'Breed_Version_Id__Breed_Version']
                                                .toString(),
                                            description: _vaccinationDetails[
                                                'Description'],
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
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 42),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Vaccination Details',
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
                              getHeadingContainer('Vaccination Plan Code'),
                              const SizedBox(
                                width: 49,
                              ),
                              _vaccinationDetails.isEmpty
                                  ? const SizedBox()
                                  : getDataContainer(
                                      _vaccinationDetails['Vaccination_Code']
                                          .toString()),
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
                              _vaccinationDetails.isEmpty
                                  ? const SizedBox()
                                  : getDataContainer(
                                      _vaccinationDetails['Recommended_By']
                                          .toString()),
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
                              _vaccinationDetails.isEmpty
                                  ? const SizedBox()
                                  : getDataContainer(_vaccinationDetails[
                                          'Breed_Version_Id__Breed_Version']
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
                              _vaccinationDetails.isEmpty
                                  ? const SizedBox()
                                  : getDataContainer(
                                      _vaccinationDetails['Description']),
                            ],
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Row(
                            children: [
                              getHeadingContainer(
                                  'Vaccination Plan Information'),
                              const SizedBox(
                                width: 49,
                              ),
                              _vaccinationDetails.isEmpty
                                  ? const SizedBox()
                                  : TextButton(
                                      onPressed: () {
                                        downloadExcelSheet(
                                            _vaccinationDetails[
                                                'Vaccination_Plan'],
                                            _vaccinationDetails[
                                                'Vaccination_Id']);
                                      },
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
