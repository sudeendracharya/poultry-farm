import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../screens/global_app_bar.dart';
import '../../screens/main_drawer_screen.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/logs_api.dart';
import 'activity_logs_screen.dart';

class MedicationLogsScreen extends StatefulWidget {
  MedicationLogsScreen({Key? key}) : super(key: key);
  static const routeName = '/MedicationLogsScreen';
  @override
  State<MedicationLogsScreen> createState() => _MedicationLogsScreenState();
}

class _MedicationLogsScreenState extends State<MedicationLogsScreen> {
  String query = '';
  ScrollController controller = ScrollController();

  List list = [];

  Map<String, dynamic> medicationLogDetails = {};

  var extratedPermissions;
  bool loading = true;

  String searchQuery = '';

  var batchPlanCode;

  List firmList = [];

  List plantList = [];

  List warehouseList = [];

  List batchCodeList = [];

  var selectedFirmName;

  var selectedPlantName;

  var selectedWarehouseName;

  var selectedBatchCode;

  var selectedUnitOfMeasurement;

  List unitDetails = [];
  @override
  void initState() {
    getPermission('Medication_Log').then((value) {
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

  void searchBatchPlanCodes(String query) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<LogsApi>(context, listen: false).logException.clear();
        Provider.of<LogsApi>(context, listen: false)
            .searchMedicationNumbers(query, token);
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

  void searchBook(String query, var medicationNumber) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<LogsApi>(context, listen: false).logException.clear();
        Provider.of<LogsApi>(context, listen: false)
            .getMedicationLog(query, medicationNumber, token);
        batchPlanCode = query;
      }
    });
  }

  int defaultRowsPerPage = 5;
  Map<String, dynamic> medicationLog = {};
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController modeOfAdministrationController =
      TextEditingController();
  TextEditingController siteOfAdministrationController =
      TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController vaccinatorController = TextEditingController();
  TextEditingController dosagePerBirdController = TextEditingController();

  bool modeOfAdministrationValidate = true;
  bool siteOfAdministrationValidate = true;
  bool descriptionValidate = true;
  bool vaccinatorValidate = true;
  bool dosagePerBirdValidate = true;
  bool unitValidate = true;

  String modeOfAdministrationValidateMessage = '';
  String siteOfAdministrationValidateMessage = '';
  String descriptionValidateMessage = '';
  String vaccinatorValidateMessage = '';
  String dosagePerBirdValidateMessage = '';
  String unitValidateMessage = '';
  bool validateMedication() {
    if (modeOfAdministrationController.text == '') {
      modeOfAdministrationValidate = false;
      modeOfAdministrationValidateMessage =
          'Mode Of Administration cannot be null';
    } else {
      modeOfAdministrationValidate = true;
    }

    if (siteOfAdministrationController.text == '') {
      siteOfAdministrationValidate = false;
      siteOfAdministrationValidateMessage =
          'Site Of Administration cannot be null';
    } else {
      siteOfAdministrationValidate = true;
    }

    if (descriptionController.text == '') {
      descriptionValidate = false;
      descriptionValidateMessage = 'Description cannot be null';
    } else {
      descriptionValidate = true;
    }

    if (vaccinatorController.text == '') {
      vaccinatorValidate = false;
      vaccinatorValidateMessage = 'Vaccinator cannot be null';
    } else {
      vaccinatorValidate = true;
    }

    if (dosagePerBirdController.text.isNum != true) {
      dosagePerBirdValidate = false;
      dosagePerBirdValidateMessage = 'Enter a valid Dosage Per Bird';
    } else {
      dosagePerBirdValidate = true;
    }
    if (selectedUnitOfMeasurement == null) {
      unitValidate = false;
      unitValidateMessage = 'Select Unit';
    } else {
      unitValidate = true;
    }

    if (modeOfAdministrationValidate == true &&
        siteOfAdministrationValidate == true &&
        descriptionValidate == true &&
        dosagePerBirdValidate == true &&
        unitValidate == true) {
      return true;
    } else {
      return false;
    }
  }

  void updateCheckBox(Map<String, dynamic> data) {
    var size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;

      Provider.of<Apicalls>(context, listen: false)
          .getStandardUnitValues(token);
    });
    if (data['Status'] == 'not_started') {
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
                unitDetails = Provider.of<Apicalls>(context).standardUnitList;

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
                                      controller:
                                          modeOfAdministrationController,
                                      onSaved: (value) {
                                        medicationLog[
                                            'Mode_Of_Administration'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          modeOfAdministrationValidate == true
                              ? const SizedBox()
                              : ModularWidgets.validationDesign(
                                  size, modeOfAdministrationValidateMessage),
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
                                      controller:
                                          siteOfAdministrationController,
                                      onSaved: (value) {
                                        medicationLog[
                                            'Site_Of_Administration'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          siteOfAdministrationValidate == true
                              ? const SizedBox()
                              : ModularWidgets.validationDesign(
                                  size, siteOfAdministrationValidateMessage),
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
                                      controller: dosagePerBirdController,
                                      onSaved: (value) {
                                        medicationLog['Dosage_Per_Bird'] =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          dosagePerBirdValidate == true
                              ? const SizedBox()
                              : ModularWidgets.validationDesign(
                                  size, dosagePerBirdValidateMessage),
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
                                        horizontal: 5.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: selectedUnitOfMeasurement,
                                        items: unitDetails
                                            .map<DropdownMenuItem<String>>((e) {
                                          return DropdownMenuItem(
                                            value: e['Unit_Name'],
                                            onTap: () {
                                              medicationLog['Dosage_Unit'] =
                                                  e['Unit_Id'];
                                            },
                                            child: Text(e['Unit_Name']),
                                          );
                                        }).toList(),
                                        hint: const SizedBox(
                                            width: 404, child: Text('Select')),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedUnitOfMeasurement =
                                                value as String?;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          unitValidate == true
                              ? const SizedBox()
                              : ModularWidgets.validationDesign(
                                  size, unitValidateMessage),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 24.0),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Container(
                          //         width: size.width * 0.3,
                          //         padding: const EdgeInsets.only(bottom: 12),
                          //         child: const Text('Vaccinators'),
                          //       ),
                          //       Container(
                          //         width: size.width * 0.3,
                          //         height: 36,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(8),
                          //           color: Colors.white,
                          //           border: Border.all(color: Colors.black26),
                          //         ),
                          //         child: Padding(
                          //           padding: const EdgeInsets.symmetric(
                          //               horizontal: 12, vertical: 6),
                          //           child: TextFormField(
                          //             decoration: const InputDecoration(
                          //                 hintText: 'Vaccinators',
                          //                 border: InputBorder.none),
                          //             // controller: saleCodeController,
                          //             onSaved: (value) {
                          //               medicationLog['Vaccinators'] = value!;
                          //             },
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
                                      controller: descriptionController,
                                      onSaved: (value) {
                                        medicationLog['Description'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          descriptionValidate == true
                              ? const SizedBox()
                              : ModularWidgets.validationDesign(
                                  size, descriptionValidateMessage),
                          const SizedBox(
                            height: 24,
                          ),
                          SizedBox(
                            width: size.width * 0.3,
                            height: 36,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        ProjectColors.themecolor)),
                                onPressed: () {
                                  bool validateData = validateMedication();
                                  if (validateData != true) {
                                    setState(() {});
                                    return;
                                  }
                                  _formKey.currentState!.save();

                                  String dateTime =
                                      DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                                          .format(DateTime.now());
                                  medicationLog['Medication_LogId'] =
                                      data['Medication_LogId'];
                                  medicationLog['Status'] = 'Started';
                                  medicationLog['Start_Date'] = dateTime;

                                  fetchCredientials().then((token) {
                                    if (token != '') {
                                      Provider.of<LogsApi>(context,
                                              listen: false)
                                          .updateMedicationLog(
                                              medicationLog, token)
                                          .then((value) {
                                        if (value == 202 || value == 204) {
                                          Get.back();
                                          searchBook(
                                              batchPlanCode,
                                              searchQuery == ''
                                                  ? 'None'
                                                  : searchQuery);
                                        } else {
                                          failureSnackbar(
                                              'Something went wrong unable to update the data');
                                        }
                                      });
                                    }
                                  });

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
        ),
      );
      // String dateTime =
      //     DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now());

      // fetchCredientials().then((token) {
      //   if (token != '') {
      //     Provider.of<LogsApi>(context, listen: false).updateMedicationLog({
      //       'Medication_LogId': data['Medication_LogId'],
      //       'Status': 'Started',
      //       'Start_Date': dateTime,
      //     }, token).then((value) {
      //       if (value == 202 || value == 204) {
      //         Get.back();
      //         searchBook(query);
      //       } else {
      //         failureSnackbar('Something went wrong unable to update the data');
      //       }
      //     });
      //   }
      // });
    } else {
      Get.defaultDialog(
          title: 'Alert',
          buttonColor: ProjectColors.themecolor,
          titleStyle: const TextStyle(color: Colors.black),
          middleText: 'Are you sure want to end this Medication?',
          titlePadding: const EdgeInsets.all(8),
          confirm: TextButton(
              onPressed: () {
                String dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                    .format(DateTime.now());

                fetchCredientials().then((token) {
                  if (token != '') {
                    Provider.of<LogsApi>(context, listen: false)
                        .updateMedicationLog({
                      'Medication_LogId': data['Medication_LogId'],
                      'Status': 'Completed',
                      'Completed_Date': dateTime,
                    }, token).then((value) {
                      if (value == 202 || value == 204) {
                        Get.back();
                        searchBook(batchPlanCode,
                            searchQuery == '' ? 'None' : searchQuery);
                      } else {
                        Get.back();
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
    medicationLogDetails = Provider.of<LogsApi>(context).medicationLog;
    firmList = Provider.of<InfrastructureApis>(context).firmDetails;

    return Scaffold(
      drawer: MainDrawer(controller: controller),
      appBar: GlobalAppBar(firmName: query, appbar: AppBar()),
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
                                    'Medication Log',
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
                                      Provider.of<InfrastructureApis>(context,
                                              listen: false)
                                          .plantDetails
                                          .clear();
                                      Provider.of<InfrastructureApis>(context,
                                              listen: false)
                                          .warehouseDetails
                                          .clear();
                                      Provider.of<InfrastructureApis>(context,
                                              listen: false)
                                          .batchCodeDetails
                                          .clear();
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
                                    child: const Text('Search By Firm'))
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
                          ),
                          Positioned(
                            top: size.height * 0.05,
                            left: 10,
                            child: Row(
                              children: [
                                Text(
                                  'Medication Record',
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
                            child: SizedBox(
                              width: size.width * 0.95,
                              child: PaginatedDataTable(
                                headingRowHeight: 25,

                                header: Text(
                                  medicationLogDetails['log'] == null ||
                                          medicationLogDetails['log'].isEmpty
                                      ? ''
                                      : medicationLogDetails['log'][0]
                                          ['Batch_Plan_Code'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                source: MySearchData(
                                    medicationLogDetails.isEmpty
                                        ? list
                                        : medicationLogDetails['log'],
                                    updateCheckBox,
                                    extratedPermissions['Edit']),
                                arrowHeadColor: ProjectColors.themecolor,

                                columns: [
                                  DataColumn(
                                      label: Text('Medication Name',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Age',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Date',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Mode of Delivery',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Site of Administration',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Dosage per Bird',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Dosage Unit',
                                          style: ProjectStyles
                                              .paginatedHeaderStyle())),
                                  DataColumn(
                                      label: Text('Description',
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
                                SizedBox(
                                  width: 253,
                                  child: AdministrationSearchWidget(
                                      search: (value) {
                                        searchBook(batchPlanCode, query);
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
                                      hintText: 'Medication Number'),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                query == ''
                                    ? const SizedBox()
                                    : Consumer<LogsApi>(
                                        builder: (context, value, child) {
                                          return value
                                                  .medicationNumbersList.isEmpty
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
                                                        .medicationNumbersList
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return ListTile(
                                                        key: UniqueKey(),
                                                        onTap: () {
                                                          searchBook(
                                                              value.medicationNumbersList[
                                                                      index][
                                                                  'Batch_Plan_Code'],
                                                              value.medicationNumbersList[
                                                                      index][
                                                                  'Medication_Activity_Number']);
                                                          setState(() {
                                                            searchQuery = value
                                                                        .medicationNumbersList[
                                                                    index][
                                                                'Medication_Activity_Number'];
                                                            batchPlanCode =
                                                                value.medicationNumbersList[
                                                                        index][
                                                                    'Batch_Plan_Code'];
                                                            query = '';
                                                          });
                                                        },
                                                        title: Text(value
                                                                    .medicationNumbersList[
                                                                index][
                                                            'Medication_Activity_Number']),
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

  void searchPlant(e) {
    fetchCredientials().then((token) {
      Provider.of<InfrastructureApis>(context, listen: false)
          .getPlantDetails(token, e)
          .then((value1) {});
    });
  }

  void searchWareHouse(e) {
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
          DataCell(Text(data[index]['Medication_Name'])),
          DataCell(Text(data[index]['Age'].toString())),
          data[index]['Date'] == null
              ? const DataCell(SizedBox())
              : DataCell(Text(
                  DateFormat('dd-MM-yyyy').format(
                    DateTime.parse(
                      data[index]['Date'],
                    ),
                  ),
                )),
          DataCell(Text(data[index]['Mode_Of_Delivery'])),
          DataCell(Text(data[index]['Site_Of_Administration'])),
          DataCell(Text(data[index]['Dosage_Per_Bird'])),
          DataCell(Text(data[index]['Dosage_Unit'])),
          DataCell(Text(data[index]['Description'])),
          data[index]['Start_Date'] == null
              ? const DataCell(SizedBox())
              : DataCell(Text(
                  DateFormat('dd-MM-yyyy').format(
                    DateTime.parse(
                      data[index]['Start_Date'],
                    ),
                  ),
                )),
          data[index]['Completed_Date'] == null
              ? const DataCell(SizedBox())
              : DataCell(Text(
                  DateFormat('dd-MM-yyyy').format(
                    DateTime.parse(
                      data[index]['Completed_Date'],
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
                            'Medication Ended',
                            style: TextStyle(color: Colors.grey),
                          ))
                      : TextButton(
                          onPressed: () {
                            reFresh(data[index]);
                          },
                          child: data[index]['Status'] == 'not_started'
                              ? Text(
                                  'Start Medication',
                                  style: TextStyle(
                                      color: ProjectColors.themecolor),
                                )
                              : Text(
                                  'End Medication',
                                  style: TextStyle(
                                      color: ProjectColors.themecolor),
                                ),
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
