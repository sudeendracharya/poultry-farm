import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/logs/providers/logs_api.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/screens/global_app_bar.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../providers/apicalls.dart';
import '../../screens/main_drawer_screen.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';

class ActivityLogsScreen extends StatefulWidget {
  ActivityLogsScreen({Key? key}) : super(key: key);

  static const routeName = '/ActivityLogsScreen';

  @override
  State<ActivityLogsScreen> createState() => _ActivityLogsScreenState();
}

class _ActivityLogsScreenState extends State<ActivityLogsScreen> {
  String query = '';
  ScrollController controller = ScrollController();

  List list = [];

  Map activityLogDetails = {};

  var extratedPermissions;
  bool loading = true;
  var route;

  String searchQuery = '';

  var selectedFirmName;

  List firmList = [];
  List plantList = [];
  List warehouseList = [];
  List batchCodeList = [];

  var selectedPlantName;

  var selectedWarehouseName;

  var batchPlanCode;

  var selectedBatchCode;

  @override
  void initState() {
    route = Get.arguments;

    getPermission('Activity_Log').then((value) {
      extratedPermissions = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) {
      Provider.of<InfrastructureApis>(context, listen: false)
          .getFirmDetails(token)
          .then((value1) {});
    });
    super.initState();
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

  void searchBook(String batchPlanCode, var activityNumber) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<LogsApi>(context, listen: false).logException.clear();
        Provider.of<LogsApi>(context, listen: false)
            .getActivityLog(batchPlanCode, 'None', token);
      }
    });
  }

  void searchBatchPlanCodes(String query) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<LogsApi>(context, listen: false).logException.clear();
        Provider.of<LogsApi>(context, listen: false)
            .searchActivityNumbers(query, token);
      }
    });
  }

  int defaultRowsPerPage = 5;
  void updateCheckBox(Map<String, dynamic> data) {
    if (data['Status'] == 'Not Started') {
      String dateTime =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now());

      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<LogsApi>(context, listen: false).updateActivityLog({
            'Activity_LogId': data['Activity_LogId'],
            'Status': 'Started',
            'From_Date': dateTime,
          }, token).then((value) {
            if (value == 202 || value == 204) {
              searchBook(batchPlanCode, searchQuery);
            } else {
              failureSnackbar('Something went wrong unable to update the data');
            }
          });
        }
      });
    } else {
      Get.defaultDialog(
          title: 'Alert',
          buttonColor: ProjectColors.themecolor,
          titleStyle: const TextStyle(color: Colors.black),
          middleText: 'Are you sure want to end this Activity?',
          titlePadding: const EdgeInsets.all(8),
          confirm: TextButton(
              onPressed: () {
                String dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                    .format(DateTime.now());

                fetchCredientials().then((token) {
                  if (token != '') {
                    Provider.of<LogsApi>(context, listen: false)
                        .updateActivityLog({
                      'Activity_LogId': data['Activity_LogId'],
                      'Status': 'Completed',
                      'To_Date': dateTime,
                    }, token).then((value) {
                      if (value == 202 || value == 204) {
                        print(searchQuery);
                        searchBook(batchPlanCode, searchQuery);
                        Get.back();
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    activityLogDetails = Provider.of<LogsApi>(context).activityLog;
    firmList = Provider.of<InfrastructureApis>(context).firmDetails;
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
                  padding: const EdgeInsets.only(top: 18.0, left: 25),
                  child: SingleChildScrollView(
                    child: SizedBox(
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
                                    'Activity Log',
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
                                  'Activity Record',
                                  style: ProjectStyles.contentHeaderStyle(),
                                ),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 20.0),
                          //   child: Row(
                          //     children: [
                          //       Container(
                          //         width: 253,
                          //         child: AdministrationSearchWidget(
                          //             search: (value) {
                          //               searchBook(query);
                          //             },
                          //             reFresh: (value) {
                          //               setState(() {});
                          //             },
                          //             text: query,
                          //             onChanged: (value) {
                          //               query = value;
                          //             },
                          //             hintText: 'Batch Plan code'),
                          //       ),
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
                          //       //       print(query);
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
                            child: Column(
                              children: [
                                SizedBox(
                                  width: size.width * 0.6,
                                  child: PaginatedDataTable(
                                    headingRowHeight: 28,
                                    header: Text(
                                      activityLogDetails['log'] == null ||
                                              activityLogDetails['log'].isEmpty
                                          ? ''
                                          : activityLogDetails['log'][0]
                                              ['Batch_Plan_Code'],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    source: MySearchData(
                                        activityLogDetails.isEmpty
                                            ? list
                                            : activityLogDetails['log'].isEmpty
                                                ? []
                                                : activityLogDetails['log'],
                                        updateCheckBox,
                                        extratedPermissions['Edit']),
                                    arrowHeadColor: ProjectColors.themecolor,

                                    columns: [
                                      DataColumn(
                                          label: Text('Activity Name',
                                              style: ProjectStyles
                                                  .paginatedHeaderStyle())),
                                      DataColumn(
                                          label: Text('From Date',
                                              style: ProjectStyles
                                                  .paginatedHeaderStyle())),
                                      DataColumn(
                                          label: Text('To Date',
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
                              ],
                            ),
                          ),
                          Positioned(
                            top: size.height * 0.1,
                            left: size.width * 0.004,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 253,
                                  child: AdministrationSearchWidget(
                                      search: (value) {
                                        // searchBook(query);
                                      },
                                      reFresh: (value) {
                                        setState(() {});
                                      },
                                      text: query,
                                      onChanged: (value) {
                                        if (value.length >= 2) {
                                          searchBatchPlanCodes(value);
                                        }
                                        setState(() {
                                          query = value;
                                        });
                                      },
                                      hintText: 'Activity Number'),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                query == ''
                                    ? const SizedBox()
                                    : Consumer<LogsApi>(
                                        builder: (context, value, child) {
                                          return value
                                                  .activityNumbersList.isEmpty
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
                                                        .activityNumbersList
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return ListTile(
                                                        key: UniqueKey(),
                                                        onTap: () {
                                                          searchBook(
                                                              value.activityNumbersList[
                                                                      index][
                                                                  'Batch_Plan_Code'],
                                                              value.activityNumbersList[
                                                                      index][
                                                                  'Activity_Number']);
                                                          setState(() {
                                                            searchQuery = value
                                                                        .activityNumbersList[
                                                                    index][
                                                                'Activity_Number'];
                                                            batchPlanCode =
                                                                value.activityNumbersList[
                                                                        index][
                                                                    'Batch_Plan_Code'];
                                                            print(
                                                                '$searchQuery, $batchPlanCode');
                                                            query = '';
                                                          });
                                                        },
                                                        title: Text(value
                                                                    .activityNumbersList[
                                                                index][
                                                            'Activity_Number']),
                                                      );
                                                    },
                                                  ),
                                                );
                                        },
                                      )
                              ],
                            ),
                          ),
                          Positioned(
                              top: size.height * 0.11,
                              left: size.width * 0.2,
                              child: const Text(
                                'Or',
                                style: TextStyle(fontSize: 18),
                              )),
                          Positioned(
                            top: size.height * 0.1,
                            left: size.width * 0.23,
                            child: Container(
                                width: size.width * 0.13,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                ProjectColors.themecolor)),
                                    onPressed: () {
                                      filterBasedOnPlant(
                                          firmList,
                                          plantList,
                                          warehouseList,
                                          batchCodeList,
                                          selectedFirmName,
                                          searchPlant,
                                          selectedPlantName,
                                          searchWareHouse,
                                          selectedWarehouseName,
                                          searchBatchCodes,
                                          selectedBatchCode,
                                          searchBook);
                                    },
                                    child: const Text('Filter Based on Plant'))
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 12, vertical: 6),
                                //   child: DropdownButtonHideUnderline(
                                //     child: DropdownButton(
                                //       isExpanded: true,
                                //       value: selectedFirmName,
                                //       items: firmList
                                //           .map<DropdownMenuItem<String>>((e) {
                                //         return DropdownMenuItem(
                                //           value: e['Firm_Name'],
                                //           onTap: () {
                                //             searchPlant(e['Firm_Id']);
                                //           },
                                //           child:
                                //               Text(e['Breed_Version'].toString()),
                                //         );
                                //       }).toList(),
                                //       hint: const Text('Choose Firm'),
                                //       onChanged: (value) {
                                //         setState(() {
                                //           selectedFirmName = value as String;
                                //         });
                                //       },
                                //     ),
                                //   ),
                                // ),
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  void searchPlant(e) {
    fetchCredientials().then((token) {
      Provider.of<InfrastructureApis>(context, listen: false)
          .getPlantDetails(token, e)
          .then((value1) {});
    });
  }

  void searchWareHouse(e) {
    print('id $e');
    fetchCredientials().then((token) {
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseDetailsForAll(e, token)
          .then((value1) {});
    });
  }

  void searchBatchCodes(e) {
    fetchCredientials().then((token) {
      Provider.of<InfrastructureApis>(context, listen: false)
          .getBatchCodeDetails(e, token)
          .then((value1) {});
    });
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
        //   print(selectedBatchCodes);
        // },
        // selected: data[index]['Is_Selected'],
        cells: [
          DataCell(Text(data[index]['Activity_Name'])),
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
                          // style: ButtonStyle(
                          //     backgroundColor:
                          //         MaterialStateProperty.all(Colors.grey)),
                          onPressed: () {},
                          child: const Text(
                            'Action Completed',
                            style: TextStyle(color: Colors.grey),
                          ))
                      : TextButton(
                          onPressed: () {
                            reFresh(data[index]);
                          },
                          child: data[index]['Status'] == 'Not Started'
                              ? Text(
                                  'Start Activity',
                                  style: TextStyle(
                                      color: ProjectColors.themecolor),
                                )
                              : Text('End Activity',
                                  style: TextStyle(
                                      color: ProjectColors.themecolor)),
                        ),
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

void filterBasedOnPlant(
    List firmList,
    List plantList,
    List warehouseList,
    List batchCodeList,
    var selectedFirmName,
    var searchPlant,
    var selectedPlantName,
    var searchWareHouse,
    var selectedWarehouseName,
    var searchBatchCodes,
    var selectedBatchCode,
    var searchBook) {
  Get.dialog(Dialog(
    child: Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          plantList = Provider.of<InfrastructureApis>(context).plantDetails;
          warehouseList =
              Provider.of<InfrastructureApis>(context).warehouseDetails;
          batchCodeList =
              Provider.of<InfrastructureApis>(context).batchCodeDetails;
          return Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Filter',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        value: selectedFirmName,
                        items: firmList.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            value: e['Firm_Name'],
                            onTap: () {
                              searchPlant(e['Firm_Id']);
                              selectedPlantName = null;
                            },
                            child: Text(e['Firm_Name']),
                          );
                        }).toList(),
                        hint: const Text('Choose Firm'),
                        onChanged: (value) {
                          setState(() {
                            selectedFirmName = value as String;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        value: selectedPlantName,
                        items: plantList.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            value: e['Plant_Name'],
                            onTap: () {
                              searchWareHouse(e['Plant_Id']);
                              selectedWarehouseName = null;
                            },
                            child: Text(e['Plant_Name']),
                          );
                        }).toList(),
                        hint: const Text('Choose Plant'),
                        onChanged: (value) {
                          setState(() {
                            selectedPlantName = value as String;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        value: selectedWarehouseName,
                        items: warehouseList.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            value: e['WareHouse_Name'],
                            onTap: () {
                              searchBatchCodes(e['WareHouse_Id']);
                              selectedBatchCode = null;
                            },
                            child: Text(e['WareHouse_Name']),
                          );
                        }).toList(),
                        hint: const Text('Choose Warehouse'),
                        onChanged: (value) {
                          setState(() {
                            selectedWarehouseName = value as String;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        value: selectedBatchCode,
                        items: batchCodeList.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            value: e['Batch_Plan_Code'],
                            onTap: () {
                              // searchBatchCodes(e['WareHouse_Id']);
                            },
                            child: Text(e['Batch_Plan_Code']),
                          );
                        }).toList(),
                        hint: const Text('Choose Batch Code'),
                        onChanged: (value) {
                          setState(() {
                            selectedBatchCode = value as String;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 80,
                  height: 30,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              ProjectColors.themecolor)),
                      onPressed: () {
                        if (selectedBatchCode == null) {
                          Get.snackbar('Alert',
                              'Please Select the batch Code First to search',
                              duration: const Duration(seconds: 4),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: ProjectColors.themecolor,
                              colorText: Colors.white);
                        } else {
                          searchBook(selectedBatchCode, 'None');
                          Get.back();
                        }
                      },
                      child: const Text('Search')))
            ],
          );
        },
      ),
    ),
  ));
}
