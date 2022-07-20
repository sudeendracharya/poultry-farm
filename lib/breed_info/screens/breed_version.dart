import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:poultry_login_signup/breed_info/widgets/add_breed_version_details_dialog.dart';
import 'package:poultry_login_signup/breed_info/widgets/edit_breed_version_details_dialog.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/breed_info/providers/breed_info_apicalls.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

class BreedVersion extends StatefulWidget {
  BreedVersion({Key? key}) : super(key: key);
  static const routeName = '/BreedVersion';

  @override
  _BreedVersionState createState() => _BreedVersionState();
}

class _BreedVersionState extends State<BreedVersion> {
  var query = '';

  List list = [];

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false)
            .getBreedversionInfo(token);
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

  List breedDetails = [];
  List selectedActivityIds = [];
  int defaultRowsPerPage = 5;
  ScrollController _scrollController = ScrollController();
  var extratedPermissions;
  bool loading = true;
  @override
  void initState() {
    selectedBreedVersion.clear();
    getPermission('Breed_Version').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false)
            .getBreedversionInfo(token);
      }
    });
    super.initState();
  }

  void updateCheckBox(int data) {
    setState(() {});
  }

  void delete() {
    if (selectedBreedVersion.isEmpty) {
      alertSnackBar('Please select the checkbox to delete');
    } else {
      List temp = [];
      for (var data in selectedBreedVersion) {
        temp.add(data['Breed_Version_Id']);
      }
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<BreedInfoApis>(context, listen: false)
              .deleteVersionDetails(temp, token)
              .then((value) {
            if (value == 204) {
              update(100);
              successSnackbar('Successfully deleted the data');
            } else {
              failureSnackbar('Unable to delete the data something went wrong');
            }
          });
        }
      });
    }
  }

  void searchBook(String query) {
    final searchOutput = breedDetails.where((details) {
      final breedName = details['Breed_Version'];

      final searchName = query;

      return breedName.contains(searchName);
    }).toList();

    setState(() {
      this.query = query;
      list = searchOutput;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    breedDetails = Provider.of<BreedInfoApis>(context).breedVersion;
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
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 34,
                    ),
                    Text(
                      'Breed Version',
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
                          hintText: 'Search',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
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
                                            AddBreedVersionDetailsDialog(
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
                          extratedPermissions['Edit'] == true
                              ? selectedBreedVersion.length == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showGlobalDrawer(
                                            context: context,
                                            builder: (ctx) =>
                                                EditBreedVersionDetailsDialog(
                                                  breedVersionId:
                                                      selectedBreedVersion[0][
                                                              'Breed_Version_Id']
                                                          .toString(),
                                                  breedId:
                                                      selectedBreedVersion[0]
                                                          ['Breed_Id'],
                                                  breedVersion:
                                                      selectedBreedVersion[0]
                                                              ['Breed_Version']
                                                          .toString(),
                                                  referenceData:
                                                      selectedBreedVersion[0]
                                                          ['Reference_Data'],
                                                  reFresh: update,
                                                ),
                                            direction: AxisDirection.right);
                                      },
                                      icon: const Icon(Icons.edit),
                                    )
                                  : const SizedBox()
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
                      child: SizedBox(
                        width: size.width * 0.35,
                        child: PaginatedDataTable(
                          source: MySearchData(
                              query == '' ? breedDetails : list,
                              updateCheckBox),
                          arrowHeadColor: ProjectColors.themecolor,

                          columns: const [
                            DataColumn(
                                label: Text('Breed Version',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Reference Data',
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

List selectedBreedVersion = [];

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
          if (selectedBreedVersion.isEmpty) {
            selectedBreedVersion.add(data[index]);
          } else {
            if (value == true) {
              selectedBreedVersion.add(data[index]);
            } else {
              selectedBreedVersion.remove(data[index]);
            }
          }
          // print(selectedBreedVersion);
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(Text(data[index]['Breed_Version'].toString())),
          DataCell(TextButton(
              onPressed: () {
                downloadExcelSheet(data[index]['Reference_Data'],
                    data[index]['Breed_Version'].toString());
              },
              child: const Text('Download'))),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  void downloadExcelSheet(List breedInfoDataList, var id) {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    Range range = sheet.getRangeByName('A1');
    range.setText('Mortality');
    range = sheet.getRangeByName('B1');
    range.setText('Body Weight');
    range = sheet.getRangeByName('C1');
    range.setText('Primarily Days');
    range = sheet.getRangeByName('D1');
    range.setText('Feed Consumption');
    range = sheet.getRangeByName('E1');
    range.setText('Egg Production Rate');

    List exportActivityList = [];
    if (breedInfoDataList.isNotEmpty) {
      for (var data in breedInfoDataList) {
        exportActivityList.add([
          data['Mortality'],
          data['Body_Weight'],
          data['Primarily_Days'],
          data['Feed_Consumption'],
          data['Egg_Production_Rate'],
        ]);
      }
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
    save(bytes, 'breedInfo$id.xlsx');

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
