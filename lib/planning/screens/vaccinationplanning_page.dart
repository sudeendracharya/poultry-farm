import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/planning/providers/activity_plan_apis.dart';
import 'package:poultry_login_signup/planning/screens/vaccination_plan_details_page.dart';
import 'package:poultry_login_signup/planning/widgets/add_vaccination_plan_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

import '../../colors.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import 'dart:html' as html;
import 'dart:js' as js;

class VaccinationPlanningPage extends StatefulWidget {
  VaccinationPlanningPage({Key? key}) : super(key: key);

  @override
  State<VaccinationPlanningPage> createState() =>
      _VaccinationPlanningPageState();
}

class _VaccinationPlanningPageState extends State<VaccinationPlanningPage> {
  var query = '';

  List _vaccinationPlanData = [];
  List _selectedVaccinationPlanIds = [];

  List list = [];

  var extratedPermissions;

  bool loading = true;

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<ActivityApis>(context, listen: false)
            .getVaccinationPlan(token);
      }
    });
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

  @override
  void initState() {
    getPermission('Vaccination_Plan').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<ActivityApis>(context, listen: false)
            .getVaccinationPlan(token);
      }
    });

    super.initState();
  }

  int defaultRowsPerPage = 5;

  void updateCheckBox(int data) {
    setState(() {});
  }

  void delete() {
    if (selectedVaccinationCodes.isNotEmpty) {
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<ActivityApis>(context, listen: false)
              .deleteVaccinationPlanData(selectedVaccinationCodes, token)
              .then((value) {
            if (value == 204) {
              successSnackbar('successfully deleted the data');
              update(100);
            } else {
              failureSnackbar('unable to delete the data something went wrong');
              update(100);
            }
          });
        }
      });
    } else {
      alertSnackBar('please select the checkbox first');
    }
  }

  void searchBook(String query) {
    final searchOutput = _vaccinationPlanData.where((details) {
      final vaccinationCode = details['Vaccination_Code'];

      final searchName = query;

      return vaccinationCode.contains(searchName);
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
    _vaccinationPlanData = Provider.of<ActivityApis>(context).vaccinationPlan;
    List batchDetails = [];
    return loading == true
        ? const Center(
            child: Text('Loading'),
          )
        : extratedPermissions['View'] == false
            ? SizedBox(
                height: size.height * 0.5,
                child: const Center(
                    child: Text('You don\'t have access to view this page')),
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
                      'Vaccination Plan',
                      style: ProjectStyles.contentHeaderStyle(),
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
                      width: size.width * 0.5,
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          extratedPermissions['Create'] == true
                              ? IconButton(
                                  onPressed: () {
                                    showGlobalDrawer(
                                        context: context,
                                        builder: (ctx) =>
                                            AddVaccinationPlanDialog(
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
                          extratedPermissions['Delete'] == true
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
                        width: size.width * 0.5,
                        child: PaginatedDataTable(
                          source: MySearchData(
                              query == '' ? _vaccinationPlanData : list,
                              updateCheckBox),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: const [
                            DataColumn(
                                label: Text('Vaccination Code',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Relevent Breed Information',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Plan Information',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
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

List selectedVaccinationCodes = [];

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
          if (selectedVaccinationCodes.isEmpty) {
            selectedVaccinationCodes.add(data[index]['Vaccination_Id']);
          } else {
            if (value == true) {
              selectedVaccinationCodes.add(data[index]['Vaccination_Id']);
            } else {
              selectedVaccinationCodes.remove(data[index]['Vaccination_Id']);
            }
          }
          // print(selectedVaccinationCodes);
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                if (prefs.containsKey('Vaccination_Id')) {
                  prefs.remove('Vaccination_Id');
                }
                final userData = json.encode(
                  {
                    'Vaccination_Id': data[index]['Vaccination_Id'],
                  },
                );
                prefs.setString('Vaccination_Id', userData);

                Get.toNamed(VaccinationPlanDetails.routeName);
              },
              child: Text(data[index]['Vaccination_Code']))),
          DataCell(Text(data[index]['Breed_Version_Id'].toString())),
          DataCell(
            TextButton(
              onPressed: () {
                downloadExcelSheet(data[index]['Vaccination_Plan'],
                    data[index]['Vaccination_Id']);
              },
              child: const Text('Download'),
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
}
