import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart';

import '../../colors.dart';
import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/transfer_journal_apis.dart';

class TransferInScreen extends StatefulWidget {
  TransferInScreen({Key? key}) : super(key: key);

  @override
  State<TransferInScreen> createState() => _TransferInScreenState();
}

class _TransferInScreenState extends State<TransferInScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String query = '';

  List list = [];

  double _bottomPadding = 14;

  double headingContainerWidth = 120;

  double valueContainerWidth = 150;

  var wareHouseId;

  List wareHouseDetails = [];

  Map<String, dynamic> transferIn = {};

  TextEditingController quantityController = TextEditingController();

  TextEditingController shippingDateController = TextEditingController();

  List firmsList = [];

  List plantList = [];

  var firmId;

  var plantId;

  TextEditingController remarksController = TextEditingController();

  void update(int data) {}

  void updateCheckBox(int data) {
    setState(() {});
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

  bool loading = true;

  @override
  void initState() {
    getPermission().then((value) {
      setState(() {
        loading = false;
      });
    });
    getFirmList();

    super.initState();
  }

  Future<void> getFirmList() async {
    fetchCredientials().then((token) async {
      await Provider.of<InfrastructureApis>(context, listen: false)
          .getFirmDetails(token)
          .then((value1) {});
    });
  }

  Future<void> getPlantDetails(var firmId) async {
    fetchCredientials().then((token) async {
      await Provider.of<InfrastructureApis>(context, listen: false)
          .getPlantDetails(token, firmId)
          .then((value1) {});
    });
  }

  void getWareHouselist(var plantId) {
    fetchCredientials().then((token) {
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseDetails(plantId, token)
          .then((value1) {});
    });
  }

  int defaultRowsPerPage = 5;
  Map<String, dynamic> individualTransferOutData = {};

  // void delete() {
  //   if (selectedBatchCodes.isEmpty) {
  //     alertSnackBar('Select the checkbox first');
  //   } else {
  //     fetchCredientials().then((token) {
  //       if (token != '') {
  //         // Provider.of<BatchApis>(context, listen: false)
  //         //     .deleteBatchPlanStepOne(selectedBatchCodes, token);
  //       }
  //     });
  //   }
  // }

  void searchBook(String query) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<TransferJournalApi>(context, listen: false)
            .getIndividualTransferOutJournal(query, token);
      }
    });
  }

  Container headingContainer(String data) {
    return Container(
      width: headingContainerWidth,
      child: Text(data),
    );
  }

  Container valueContainer(String data) {
    return Container(
      width: valueContainerWidth,
      child: Text(data),
    );
  }

  SizedBox contentWidth() {
    return const SizedBox(
      width: 50,
    );
  }

  void _datePicker(TextEditingController controller, int value) {
    showDatePicker(
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ProjectColors.themecolor, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.green, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.red, // button text color
                ),
              ),
            ),
            child: child!);
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      // _startDate = pickedDate.millisecondsSinceEpoch;
      controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      if (value == 1) {
        transferIn['Received_Date'] =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);
      } else {
        transferIn['Received_Date'] =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);
      }

      setState(() {});
    });
  }

  void save() {
    transferIn['Transfer_Out_Id'] =
        individualTransferOutData['Transfer_Out_Id'];
    _formKey.currentState!.save();
    print(transferIn);

    fetchCredientials().then((token) {
      Provider.of<TransferJournalApi>(context, listen: false)
          .addTransferInJournal(transferIn, token)
          .then((value) {
        if (value == 200 || value == 201) {
          successSnackbar('Successfully added the data');
          _formKey.currentState!.reset();
          searchBook(query);
          // setState(() {});
        } else {
          failureSnackbar('Unable to add data something went wrong');
        }
      });
    });
  }

  var extratedTransferInPermissions;

  Future<void> getPermission() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('Transfer_In')) {
      extratedTransferInPermissions = {
        'Id': 'Transfer In',
        'Edit': false,
        'View': false,
        'Create': false,
        'Delete': false
      };
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('Transfer_In')!) as Map<String, dynamic>;

    extratedTransferInPermissions = extratedUserData['Transfer_In'];
    print(extratedTransferInPermissions);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    individualTransferOutData = Provider.of<TransferJournalApi>(context)
        .individualTransferOutJournalData;
    wareHouseDetails = Provider.of<InfrastructureApis>(
      context,
    ).warehouseDetails;
    firmsList = Provider.of<InfrastructureApis>(context).firmDetails;
    plantList = Provider.of<InfrastructureApis>(context).plantDetails;
    return loading == true
        ? const SizedBox()
        : extratedTransferInPermissions['View'] == false
            ? Container(
                width: width,
                height: size.height * 0.5,
                child: viewPermissionDenied(),
              )
            : Container(
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 34,
                    ),
                    Text(
                      'Transfer In',
                      style: ProjectStyles.contentHeaderStyle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          Container(
                            width: 253,
                            child: AdministrationSearchWidget(
                                search: (value) {},
                                reFresh: (value) {},
                                text: query,
                                onChanged: (value) {
                                  query = value;
                                },
                                hintText: 'Transfer code'),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 100,
                            height: 38,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ProjectColors.themecolor),
                              ),
                              onPressed: () {
                                searchBook(query);
                              },
                              child: const Text('Search'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    individualTransferOutData.isEmpty
                        ? const SizedBox()
                        : Text(
                            'Transfer Out',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                    const SizedBox(
                      height: 40,
                    ),
                    individualTransferOutData.isEmpty
                        ? const SizedBox()
                        : individualTransferOutData.length != 2
                            ? Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Transfer Code'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                  'Transfer_Code'] ??
                                              '',
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Product'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                  'Product__Product_Name'] ??
                                              '',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Shipped Date'),
                                        contentWidth(),
                                        valueContainer(
                                          DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(
                                                  individualTransferOutData[
                                                      'Despatch_Date'])),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Transfer Quantity'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                  'Transfer_Quantity']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Transfer Status'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                  'Transfer_Status'] ??
                                              '',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Warehouse Name'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                  'WareHouse_Id__WareHouse_Name']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Batch code'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                  'Batch_Id__Batch_Code']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Remarks'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                  'Remarks'] ??
                                              '',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Transfer Code'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                      'Transfer_Out']
                                                  ['Transfer_Code'] ??
                                              '',
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Product'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                      'Transfer_Out']
                                                  ['Product__Product_Name'] ??
                                              '',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Shipped Date'),
                                        contentWidth(),
                                        valueContainer(
                                          DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(
                                                  individualTransferOutData[
                                                          'Transfer_Out']
                                                      ['Shipped_Date'])),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Transfer Quantity'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                      'Transfer_Out']
                                                  ['Transfer_Quantity']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Transfer Status'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                      'Transfer_Out']
                                                  ['Transfer_Status'] ??
                                              '',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Warehouse code'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                      'Transfer_Out'][
                                                  'WareHouse_Id__WareHouse_Name']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Batch code'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                      'Transfer_Out']
                                                  ['Batch_Id__Batch_Code']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Remarks'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                  'Transfer_Out']['Remarks'] ??
                                              '',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                    individualTransferOutData.isEmpty
                        ? const SizedBox()
                        : individualTransferOutData.length == 2
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Transfer In',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                              )
                            : const SizedBox(),

                    individualTransferOutData.isEmpty
                        ? const SizedBox()
                        : individualTransferOutData.length == 2
                            ? Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Plant Name'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                      'Transfer_In'][
                                                  'WareHouse_Id__WareHouse_Plant_Id__Plant_Name']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Received Quantity'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                      'Transfer_In']
                                                  ['Received_Quantity']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Received Date'),
                                        contentWidth(),
                                        valueContainer(
                                          DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(
                                                  individualTransferOutData[
                                                          'Transfer_In']
                                                      ['Received_Date'])),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Warehouse Name'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                      'Transfer_In'][
                                                  'WareHouse_Id__WareHouse_Name']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: _bottomPadding),
                                    child: Row(
                                      children: [
                                        headingContainer('Remarks'),
                                        contentWidth(),
                                        valueContainer(
                                          individualTransferOutData[
                                                  'Transfer_In']['Remarks'] ??
                                              '',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 24.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 0.25,
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: const Text('Choose Firm'),
                                          ),
                                          Container(
                                            width: width * 0.25,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  value: firmId,
                                                  items: firmsList.map<
                                                      DropdownMenuItem<
                                                          String>>((e) {
                                                    return DropdownMenuItem(
                                                      child:
                                                          Text(e['Firm_Name']),
                                                      value: e['Firm_Name'],
                                                      onTap: () {
                                                        // firmId = e['Firm_Code'];
                                                        getPlantDetails(
                                                            e['Firm_Id']);
                                                        //print(warehouseCategory);
                                                      },
                                                    );
                                                  }).toList(),
                                                  hint: const Text(
                                                      'Please Choose firm'),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      firmId = value as String;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 24.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 0.25,
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: const Text('Choose Plant'),
                                          ),
                                          Container(
                                            width: width * 0.25,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  value: plantId,
                                                  items: plantList.map<
                                                      DropdownMenuItem<
                                                          String>>((e) {
                                                    return DropdownMenuItem(
                                                      child:
                                                          Text(e['Plant_Name']),
                                                      value: e['Plant_Name'],
                                                      onTap: () {
                                                        // firmId = e['Firm_Code'];
                                                        getWareHouselist(
                                                            e['Plant_Id']);
                                                        //print(warehouseCategory);
                                                      },
                                                    );
                                                  }).toList(),
                                                  hint: const Text(
                                                      'Please Choose plant'),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      plantId = value as String;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 24.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 0.25,
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: const Text('Warehouse'),
                                          ),
                                          Container(
                                            width: width * 0.25,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  value: wareHouseId,
                                                  items: wareHouseDetails.map<
                                                      DropdownMenuItem<
                                                          String>>((e) {
                                                    return DropdownMenuItem(
                                                      child: Text(
                                                          e['WareHouse_Code']),
                                                      value:
                                                          e['WareHouse_Code'],
                                                      onTap: () {
                                                        // firmId = e['Firm_Code'];
                                                        transferIn[
                                                                'WareHouse_Id'] =
                                                            e['WareHouse_Id'];
                                                        //print(warehouseCategory);
                                                      },
                                                    );
                                                  }).toList(),
                                                  hint: const Text(
                                                      'Please Choose wareHouse'),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      wareHouseId =
                                                          value as String;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 24.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 0.25,
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child:
                                                const Text('Received Quantity'),
                                          ),
                                          Container(
                                            width: width * 0.25,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child: TextFormField(
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        'Enter Received quantity',
                                                    border: InputBorder.none),
                                                controller: quantityController,
                                                onSaved: (value) {
                                                  transferIn[
                                                          'Received_Quantity'] =
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: width * 0.25,
                                                padding: const EdgeInsets.only(
                                                    bottom: 12),
                                                child:
                                                    const Text('Received Date'),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: size.width * 0.23,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.black26),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  child: TextFormField(
                                                    controller:
                                                        shippingDateController,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Choose Received date',
                                                            border: InputBorder
                                                                .none),
                                                    enabled: false,
                                                    // onSaved: (value) {
                                                    //   batchPlanDetails[
                                                    //       'Required_Date_Of_Delivery'] = value!;
                                                    // },
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () => _datePicker(
                                                    shippingDateController, 2),
                                                icon: Icon(
                                                  Icons.date_range_outlined,
                                                  color:
                                                      ProjectColors.themecolor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 24.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: width * 0.25,
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: const Text('Remarks'),
                                          ),
                                          Container(
                                            width: width * 0.25,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            'Enter Remarks',
                                                        border:
                                                            InputBorder.none),
                                                controller: remarksController,
                                                onSaved: (value) {
                                                  transferIn['Remarks'] =
                                                      value!;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Consumer<TransferJournalApi>(
                                        builder: (context, value, child) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            value.transferException.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ModularWidgets.exceptionDesign(
                                              MediaQuery.of(context).size,
                                              value.transferException[index]
                                                  [0]);
                                        },
                                      );
                                    }),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: width * 0.25,
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      ProjectColors.themecolor),
                                            ),
                                            onPressed: save,
                                            child: Text(
                                              'Submit',
                                              style: GoogleFonts.roboto(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.6,
                    //   padding: const EdgeInsets.only(top: 20),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       IconButton(
                    //         onPressed: () {
                    //           // showGlobalDrawer(
                    //           //     context: context,
                    //           //     builder: (ctx) => AddBatchPlanDetailsDialog(
                    //           //           reFresh: update,
                    //           //         ),
                    //           //     direction: AxisDirection.right);
                    //         },
                    //         icon: const Icon(Icons.add),
                    //       ),
                    //       const SizedBox(
                    //         width: 10,
                    //       ),
                    //       // IconButton(
                    //       //   onPressed: delete,
                    //       //   icon: const Icon(Icons.delete),
                    //       // ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 5.0),
                    //   child: Container(
                    //     width: size.width * 0.6,
                    //     child: PaginatedDataTable(
                    //       source: MySearchData(
                    //           query == '' ? batchDetails : list, updateCheckBox),
                    //       arrowHeadColor: ProjectColors.themecolor,

                    //       columns: [
                    //         DataColumn(
                    //             label: Text('Batch Code',
                    //                 style: ProjectStyles.paginatedHeaderStyle())),
                    //         DataColumn(
                    //             label: Text('Breed Name',
                    //                 style: ProjectStyles.paginatedHeaderStyle())),
                    //         DataColumn(
                    //             label: Text('Activity Code',
                    //                 style: ProjectStyles.paginatedHeaderStyle())),
                    //         DataColumn(
                    //             label: Text('Vaccination Code',
                    //                 style: ProjectStyles.paginatedHeaderStyle())),
                    //         DataColumn(
                    //             label: Text('Medication Code',
                    //                 style: ProjectStyles.paginatedHeaderStyle())),
                    //       ],
                    //       onRowsPerPageChanged: (index) {
                    //         setState(() {
                    //           defaultRowsPerPage = index!;
                    //         });
                    //       },
                    //       availableRowsPerPage: const <int>[
                    //         3,
                    //         5,
                    //         10,
                    //         20,
                    //         40,
                    //         60,
                    //         80,
                    //       ],
                    //       columnSpacing: 20,
                    //       //  horizontalMargin: 10,
                    //       rowsPerPage: defaultRowsPerPage,
                    //       showCheckboxColumn: false,
                    //       // addEmptyRows: false,
                    //       checkboxHorizontalMargin: 30,
                    //       // onSelectAll: (value) {},
                    //       showFirstLastButtons: true,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
  }
}
