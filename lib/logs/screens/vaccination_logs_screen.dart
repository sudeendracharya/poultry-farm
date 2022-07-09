import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../screens/global_app_bar.dart';
import '../../screens/main_drawer_screen.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../providers/logs_api.dart';

class VaccinationLogsScreen extends StatefulWidget {
  VaccinationLogsScreen({Key? key}) : super(key: key);
  static const routeName = '/VaccinationLogsScreen';
  @override
  State<VaccinationLogsScreen> createState() => _VaccinationLogsScreenState();
}

class _VaccinationLogsScreenState extends State<VaccinationLogsScreen> {
  String query = '';
  ScrollController controller = ScrollController();

  GlobalKey<FormState> _formKey = GlobalKey();

  List list = [];

  Map<String, dynamic> vaccinationLogDetails = {};

  var extratedPermissions;
  bool loading = true;

  String searchQuery = '';

  @override
  void initState() {
    getPermission('Medication_Log').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  void searchBatchPlanCodes(String query) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<LogsApi>(context, listen: false).logException.clear();
        Provider.of<LogsApi>(context, listen: false)
            .getBatchPlanCodes(query, token);
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

  void searchBook(String query) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<LogsApi>(context, listen: false).logException.clear();
        Provider.of<LogsApi>(context, listen: false)
            .getVaccinationLog(query, token);
      }
    });
  }

  int defaultRowsPerPage = 5;

  Map<String, dynamic> vaccinationLog = {};
  ScrollController tableController = ScrollController();

  void updateCheckBox(Map<String, dynamic> data) {
    var size = MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size;
    // print(size.width);
    // print(size.height);

    if (data['Status'] == 'False') {
      Get.dialog(
        Dialog(
          child: Container(
            width: size.width * 0.35,
            height: size.height * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.015,
                    vertical: size.height * 0.01,
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.3,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Mode of Administration'),
                                ),
                                Container(
                                  width: size.width * 0.3,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          hintText:
                                              'Enter Mode of Administration',
                                          border: InputBorder.none),
                                      // controller: saleCodeController,
                                      onSaved: (value) {
                                        vaccinationLog[
                                            'Mode_Of_Administration'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.3,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Site of Administration'),
                                ),
                                Container(
                                  width: size.width * 0.3,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          hintText:
                                              'Enter Site of Administration',
                                          border: InputBorder.none),
                                      // controller: saleCodeController,
                                      onSaved: (value) {
                                        vaccinationLog[
                                            'Site_Of_Administration'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.3,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Dosage Per Bird'),
                                ),
                                Container(
                                  width: size.width * 0.3,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: 'Enter Dosage Per Bird',
                                          border: InputBorder.none),
                                      // controller: saleCodeController,
                                      onSaved: (value) {
                                        vaccinationLog['Dosage_Per_Bird'] =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.3,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Dosage Unit'),
                                ),
                                Container(
                                  width: size.width * 0.3,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: 'Enter Dosage Unit',
                                          border: InputBorder.none),
                                      // controller: saleCodeController,
                                      onSaved: (value) {
                                        vaccinationLog['Dosage_Unit'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.3,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Vaccinators'),
                                ),
                                Container(
                                  width: size.width * 0.3,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: 'Vaccinators',
                                          border: InputBorder.none),
                                      // controller: saleCodeController,
                                      onSaved: (value) {
                                        vaccinationLog['Vaccinators'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.3,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Description'),
                                ),
                                Container(
                                  width: size.width * 0.3,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          hintText: 'Enter Description',
                                          border: InputBorder.none),
                                      // controller: saleCodeController,
                                      onSaved: (value) {
                                        vaccinationLog['Description'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Container(
                            width: size.width * 0.3,
                            height: 36,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        ProjectColors.themecolor)),
                                onPressed: () {
                                  _formKey.currentState!.save();
                                  if (data['Status'] == 'False') {
                                    String dateTime =
                                        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                                            .format(DateTime.now());
                                    vaccinationLog['Vaccination_LogId'] =
                                        data['Vaccination_LogId'];
                                    vaccinationLog['Status'] = 'Started';
                                    vaccinationLog['From_Date'] = dateTime;
                                    // print(vaccinationLog);
                                    fetchCredientials().then((token) {
                                      if (token != '') {
                                        Provider.of<LogsApi>(context,
                                                listen: false)
                                            .updateVaccinationLog(
                                                vaccinationLog, token)
                                            .then((value) {
                                          if (value == 202 || value == 204) {
                                            Get.back();
                                            searchBook(searchQuery);
                                          } else {
                                            failureSnackbar(
                                                'Something went wrong unable to update the data');
                                          }
                                        });
                                      }
                                    });
                                  } else {}
                                  setState(() {});
                                },
                                child: const Text('Save')),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // LayoutBuilder(
          //   builder: (BuildContext context, BoxConstraints constraints) {
          //     return Container(
          //       width: constraints.minWidth * 0.5,
          //       height: constraints.minHeight * 0.4,
          //       color: Colors.white,
          //     );
          //   },
          // ),
        ),
      );
    } else {
      Get.defaultDialog(
          title: 'Alert',
          buttonColor: ProjectColors.themecolor,
          titleStyle: const TextStyle(color: Colors.black),
          middleText: 'Are you sure want to end this Vaccination?',
          titlePadding: const EdgeInsets.all(8),
          confirm: TextButton(
              onPressed: () {
                String dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                    .format(DateTime.now());
                // vaccinationLog['Vaccination_LogId'] = data['Vaccination_LogId'];
                // vaccinationLog['Status'] = 'Completed';
                // vaccinationLog['To_Date'] = data['To_Date'];
                // print(vaccinationLog);
                fetchCredientials().then((token) {
                  if (token != '') {
                    Provider.of<LogsApi>(context, listen: false)
                        .updateVaccinationLog({
                      'Vaccination_LogId': data['Vaccination_LogId'],
                      'Status': 'Completed',
                      'To_Date': dateTime,
                    }, token).then((value) {
                      if (value == 202 || value == 204) {
                        Get.back();
                        searchBook(searchQuery);
                      } else {
                        failureSnackbar(
                            'Something went wrong unable to update the data');
                      }
                    });
                  }
                });
              },
              child: const Text('Yes')),
          cancel: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('No')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    var size = MediaQuery.of(context).size;
    vaccinationLogDetails = Provider.of<LogsApi>(context).vaccinationLog;
    // print(size.width * 0.95);
    // print(size.height * 0.6);
    return Scaffold(
      drawer: MainDrawer(controller: controller),
      appBar: GlobalAppBar(query: query, appbar: AppBar()),
      body: loading == true
          ? const SizedBox()
          : extratedPermissions['View'] == false
              ? SizedBox(
                  width: size.width,
                  height: size.height * 0.5,
                  child: viewPermissionDenied(),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 18.0, left: 18),
                  child: SingleChildScrollView(
                    child: Container(
                      width: size.width,
                      height: size.height,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text('Dashboard',
                                      style: breadCrumpsStyle),
                                ),
                                const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 15,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Vaccination Log',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color:
                                            const Color.fromRGBO(0, 0, 0, 0.5)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(
                          //   height: 18,
                          // ),
                          Positioned(
                            top: size.height * 0.05,
                            left: 10,
                            child: Row(
                              children: [
                                Text(
                                  'Vaccination Log',
                                  style: ProjectStyles.contentHeaderStyle(),
                                ),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 20.0),
                          //   child: Row(
                          //     children: [

                          //       const SizedBox(
                          //         width: 20,
                          //       ),
                          //       // Container(
                          //       //   width: 100,
                          //       //   height: 38,
                          //       //   child: ElevatedButton(
                          //       //     style: ButtonStyle(
                          //       //       backgroundColor: MaterialStateProperty.all(
                          //       //           ProjectColors.themecolor),
                          //       //     ),
                          //       //     onPressed: () {
                          //       //       // print(query);
                          //       //       searchBook(query);
                          //       //     },
                          //       //     child: const Text('Search'),
                          //       //   ),
                          //       // ),
                          //     ],
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 18,
                          // ),
                          // Consumer<LogsApi>(
                          //   builder: (context, value, child) {
                          //     return Row(
                          //       children: [
                          //         Text(
                          //           value.logException.isEmpty
                          //               ? ''
                          //               : value.logException['Message'],
                          //           style: ProjectStyles.contentHeaderStyle()
                          //               .copyWith(
                          //                   fontSize: 16, color: Colors.red),
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // ),
                          // const SizedBox(
                          //   height: 18,
                          // ),
                          Positioned(
                            top: size.height * 0.17,
                            left: size.width * 0.004,
                            child: SizedBox(
                              width: size.width * 0.95,
                              // height: size.height,
                              child: PaginatedDataTable(
                                headingRowHeight: 25,
                                header: Text(
                                  vaccinationLogDetails['log'] == null
                                      ? ''
                                      : vaccinationLogDetails['log'][0]
                                          ['Batch_Plan_Code'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                // dragStartBehavior: DragStartBehavior.down,
                                onPageChanged: (value) {
                                  // print(value);
                                },
                                source: MySearchData(
                                  vaccinationLogDetails.isEmpty
                                      ? list
                                      : vaccinationLogDetails['log'],
                                  updateCheckBox,
                                  extratedPermissions['Edit'],
                                ),
                                arrowHeadColor: ProjectColors.themecolor,

                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Vaccination Name',
                                      style:
                                          ProjectStyles.paginatedHeaderStyle(),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Age',
                                      style:
                                          ProjectStyles.paginatedHeaderStyle(),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Mode of Administration',
                                      style:
                                          ProjectStyles.paginatedHeaderStyle(),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Site of Administration',
                                      style:
                                          ProjectStyles.paginatedHeaderStyle(),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Dosage per Bird',
                                      style:
                                          ProjectStyles.paginatedHeaderStyle(),
                                    ),
                                  ),
                                  DataColumn(
                                      label: Text('Dosage Unit',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Description',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Vaccinators',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Start Date',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('End Date',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Status',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Action',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
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
                                showCheckboxColumn: false,
                                // addEmptyRows: false,
                                checkboxHorizontalMargin: 30,
                                // onSelectAll: (value) {},
                                showFirstLastButtons: true,
                              ),
                            ),
                          ),
                          Positioned(
                            top: size.height * 0.1,
                            left: size.width * 0.004,
                            child: Column(
                              children: [
                                Container(
                                  width: 253,
                                  child: AdministrationSearchWidget(
                                      search: (value) {
                                        searchBook(query);
                                      },
                                      reFresh: (value) {
                                        setState(() {});
                                      },
                                      text: query,
                                      onChanged: (value) {
                                        if (value.length >= 2) {
                                          searchBatchPlanCodes(value);
                                        }
                                        query = value;
                                      },
                                      hintText: 'Batch plan code'),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                query == ''
                                    ? const SizedBox()
                                    : Consumer<LogsApi>(
                                        builder: (context, value, child) {
                                          return value.batchPlanCodeList.isEmpty
                                              ? const SizedBox()
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width: 240,
                                                  height: 200,
                                                  child: ListView.builder(
                                                    itemCount: value
                                                        .batchPlanCodeList
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return ListTile(
                                                        key: UniqueKey(),
                                                        onTap: () {
                                                          searchBook(value
                                                                      .batchPlanCodeList[
                                                                  index][
                                                              'Batch_Plan_Code']);
                                                          setState(() {
                                                            searchQuery = value
                                                                        .batchPlanCodeList[
                                                                    index][
                                                                'Batch_Plan_Code'];
                                                            query = '';
                                                          });
                                                        },
                                                        title: Text(value
                                                                    .batchPlanCodeList[
                                                                index][
                                                            'Batch_Plan_Code']),
                                                      );
                                                    },
                                                  ),
                                                );
                                        },
                                      )
                              ],
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

List selectedBatchCodes = [];

class MySearchData extends DataTableSource {
  final List<dynamic> data;
  final ValueChanged<Map<String, dynamic>> reFresh;
  MySearchData(this.data, this.reFresh, this.permission);
  final bool permission;

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(
        // onSelectChanged: (value) {
        //   data[index]['Is_Selected'] = value;
        //   reFresh(100);
        //   if (selectedBatchCodes.isEmpty) {
        //     selectedBatchCodes.add(data[index]['Batch_Plan_Id']);
        //   } else {
        //     if (value == true) {
        //       selectedBatchCodes.add(data[index]['Batch_Plan_Id']);
        //     } else {
        //       selectedBatchCodes.remove(data[index]['Batch_Plan_Id']);
        //     }
        //   }
        // print(selectedBatchCodes);
        // },
        // selected: data[index]['Is_Selected'],
        cells: [
          DataCell(Text(data[index]['Vaccination_Name'])),
          DataCell(Text(data[index]['Age'].toString())),
          // DataCell(Text(
          //   DateFormat('dd-MM-yyyy').format(
          //     DateTime.parse(
          //       data[index]['Date'],
          //     ),
          //   ),
          // )),
          DataCell(Text(data[index]['Mode_Of_Administration'])),
          DataCell(Text(data[index]['Site_Of_Administration'])),
          DataCell(Text(data[index]['Dosage_Per_Bird'].toString())),
          DataCell(Text(data[index]['Dosage_Unit'].toString())),
          DataCell(Text(data[index]['Description'])),
          DataCell(Text(data[index]['Vaccinators'])),
          data[index]['From_Date'] == null
              ? const DataCell(SizedBox())
              : DataCell(Text(
                  DateFormat('dd-MM-yyyy').format(
                    DateTime.parse(
                      data[index]['From_Date'],
                    ),
                  ),
                )),
          data[index]['To_Date'] == null
              ? const DataCell(SizedBox())
              : DataCell(Text(
                  DateFormat('dd-MM-yyyy').format(
                    DateTime.parse(
                      data[index]['To_Date'],
                    ),
                  ),
                )),
          DataCell(Text(data[index]['Status'].toString())),
          permission == true
              ? DataCell(
                  data[index]['Status'] == 'Completed'
                      ? TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Vaccination Ended',
                            style: TextStyle(color: Colors.grey),
                          ))
                      : TextButton(
                          onPressed: () {
                            reFresh(data[index]);
                          },
                          child: data[index]['Status'] == 'False'
                              ? Text(
                                  'Start Vaccination',
                                  style: TextStyle(
                                      color: ProjectColors.themecolor),
                                )
                              : Text(
                                  'End Vaccination',
                                  style: TextStyle(
                                    color: ProjectColors.themecolor,
                                  ),
                                )),
                )
              : const DataCell(SizedBox()),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
