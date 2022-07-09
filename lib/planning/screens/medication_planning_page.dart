import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/planning/providers/activity_plan_apis.dart';
import 'package:poultry_login_signup/planning/screens/medication_plan_details_page.dart';
import 'package:poultry_login_signup/planning/widgets/add_medication_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import 'dart:html' as html;
import 'dart:js' as js;

class MedicationPlanningPage extends StatefulWidget {
  MedicationPlanningPage({Key? key}) : super(key: key);

  @override
  State<MedicationPlanningPage> createState() => _MedicationPlanningPageState();
}

class _MedicationPlanningPageState extends State<MedicationPlanningPage> {
  var query = '';

  List list = [];

  var extratedPermissions;

  bool loading = true;

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

  int defaultRowsPerPage = 5;
  void updateCheckBox(int data) {
    setState(() {});
  }

  List selectedMedicalIds = [];

  @override
  void initState() {
    getPermission('Medication_Plan').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      Provider.of<ActivityApis>(context, listen: false)
          .getMedicationPlanData(token);
    });
    super.initState();
  }

  void update(int data) {
    fetchCredientials().then((token) {
      Provider.of<ActivityApis>(context, listen: false)
          .getMedicationPlanData(token);
    });
  }

  List medicationPlanDetails = [];

  void delete() {
    if (selectedMedicationCodes.isNotEmpty) {
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<ActivityApis>(context, listen: false)
              .deleteMedicationPlanData(selectedMedicationCodes, token)
              .then((value) {
            if (value == 204) {
              successSnackbar('Successfully deleted the data');
              update(100);
            } else {
              failureSnackbar('Something went wrong unable to delete the data');
              update(100);
            }
          });
        }
      });
    } else {
      alertSnackBar('Please select the check box first');
    }
  }

  void searchBook(String query) {
    final searchOutput = medicationPlanDetails.where((details) {
      final vaccinationCode = details['Medication_Code'];

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
    medicationPlanDetails = Provider.of<ActivityApis>(context).medicationPlan;
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
                      'Medication Planning',
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
                                            AddMedicationPlanDialog(
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
                              query == '' ? medicationPlanDetails : list,
                              updateCheckBox),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: const [
                            DataColumn(
                                label: Text('Medication Code',
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

List selectedMedicationCodes = [];

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
          if (selectedMedicationCodes.isEmpty) {
            selectedMedicationCodes.add(data[index]['Medication_Id']);
          } else {
            if (value == true) {
              selectedMedicationCodes.add(data[index]['Medication_Id']);
            } else {
              selectedMedicationCodes.remove(data[index]['Medication_Id']);
            }
          }
          // print(selectedMedicationCodes);
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                if (prefs.containsKey('Medication_Id')) {
                  prefs.remove('Medication_Id');
                }
                final userData = json.encode(
                  {
                    'Medication_Id': data[index]['Medication_Id'],
                  },
                );
                prefs.setString('Medication_Id', userData);

                Get.toNamed(MedicationPlanDetails.routeName);
              },
              child: Text(data[index]['Medication_Code']))),
          DataCell(Text(data[index]['Breed_Version_Id'].toString())),
          DataCell(
            TextButton(
              onPressed: () {
                downloadExcelSheet(data[index]['Medication_Plan'],
                    data[index]['Medication_Id']);
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
    range.setText('Medication_Name');
    range = sheet.getRangeByName('H1');
    range.setText('Notification_Prior_Days');

    List exportActivityList = [];

    for (var data in vaccinationDataList) {
      exportActivityList.add([
        data['Age'],
        data['Mode'],
        data['Site'],
        data['Dosage'],
        data['Description'],
        data['Dosage_Unit'],
        data['Medication_Name'],
        data['Notification_Prior_Days'],
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
    save(bytes, 'Medication$id.xlsx');

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
