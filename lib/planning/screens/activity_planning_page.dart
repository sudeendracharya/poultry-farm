import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/planning/providers/activity_plan_apis.dart';
import 'package:poultry_login_signup/planning/screens/activity_plan_details_page.dart';
import 'package:poultry_login_signup/planning/widgets/add_activity_plan_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

import '../../colors.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import 'dart:html' as html;
import 'dart:js' as js;

class ActivityPlanningPage extends StatefulWidget {
  ActivityPlanningPage({Key? key}) : super(key: key);

  @override
  State<ActivityPlanningPage> createState() => _ActivityPlanningPageState();
}

class _ActivityPlanningPageState extends State<ActivityPlanningPage> {
  var query = '';

  List list = [];

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<ActivityApis>(context, listen: false)
            .getActivityPlan(token)
            .then((value) {
          selectedActivityCodes.clear();
        });
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

  List activityPlanData = [];
  List selectedActivityIds = [];

  var extratedPermissions;
  bool loading = true;

  @override
  void initState() {
    getPermission('Activity_Plan').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<ActivityApis>(context, listen: false)
            .getActivityPlan(token);
      }
    });
    super.initState();
  }

  void updateCheckBox(int data) {
    setState(() {});
  }

  int defaultRowsPerPage = 5;

  void delete() {
    if (selectedActivityCodes.isNotEmpty) {
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<ActivityApis>(context, listen: false)
              .deleteActivityPlanData(selectedActivityCodes, token)
              .then((value) {
            if (value == 204) {
              successSnackbar('Successfully deleted the data');
              update(100);
              selectedActivityCodes.clear();
            } else {
              failureSnackbar('Something went wrong unable to delete the data');
              update(100);
              selectedActivityCodes.clear();
            }
          });
        }
      });
    } else {
      alertSnackBar('Please select the check box first');
    }
  }

  void searchBook(String query) {
    final searchOutput = activityPlanData.where((details) {
      final activityCode = details['Activity_Code'].toString().toLowerCase();

      final searchName = query.toLowerCase();

      return activityCode.contains(searchName);
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
    activityPlanData = Provider.of<ActivityApis>(context).activityPlan;

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
                      'Activity Planning',
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
                            hintText: 'Activity Code'),
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
                                        builder: (ctx) => AddActivityPlanDialog(
                                              reFresh: update,
                                            ),
                                        direction: AxisDirection.right);
                                  },
                                  icon: const Icon(Icons.add),
                                )
                              : const SizedBox(),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          // IconButton(
                          //   onPressed: () {
                          //     Get.toNamed(FirmDetailsPage.routeName);
                          //   },
                          //   icon: const Icon(Icons.edit),
                          // ),
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
                              query == '' ? activityPlanData : list,
                              updateCheckBox),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: const [
                            DataColumn(
                                label: Text('Activity Code',
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

List selectedActivityCodes = [];

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
          if (selectedActivityCodes.isEmpty) {
            selectedActivityCodes.add(data[index]['Activity_Id']);
          } else {
            if (value == true) {
              selectedActivityCodes.add(data[index]['Activity_Id']);
            } else {
              selectedActivityCodes.remove(data[index]['Activity_Id']);
            }
          }
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                if (prefs.containsKey('Activity_Id')) {
                  prefs.remove('Activity_Id');
                }
                final userData = json.encode(
                  {
                    'Activity_Id': data[index]['Activity_Id'],
                  },
                );
                prefs.setString('Activity_Id', userData);

                Get.toNamed(ActivityPlanDetailsPage.routeName);
              },
              child: Text(data[index]['Activity_Code']))),
          DataCell(Text(data[index]['Breed_Version_Id'].toString())),
          DataCell(
            TextButton(
              onPressed: () {
                downloadExcelSheet(
                    data[index]['Activity_Plan'], data[index]['Activity_Id']);
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

  void downloadExcelSheet(List activityDataList, var id) {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    Range range = sheet.getRangeByName('A1');
    range.setText('Age in Days');
    range = sheet.getRangeByName('B1');
    range.setText('Activity');
    range = sheet.getRangeByName('C1');
    range.setText('Notification Days');

    List exportActivityList = [];

    for (var data in activityDataList) {
      exportActivityList.add([
        data['Age'],
        data['Activity_Name'],
        data['Notification_Prior_To_Activity'],
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
    save(bytes, 'Activity$id.xlsx');

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
