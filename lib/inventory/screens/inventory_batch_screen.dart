import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/inventory/screens/inventory_batch_details_page.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/screens/dashboard_default_screen.dart';
import 'package:poultry_login_signup/screens/dashboard_screen.dart';

import 'package:poultry_login_signup/widgets/batch_search_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../search_widget.dart';

class InventoryBatchScreen extends StatefulWidget {
  InventoryBatchScreen({Key? key}) : super(key: key);

  static const routeName = '/InventoryBatchScreen';

  @override
  _InventoryBatchScreenState createState() => _InventoryBatchScreenState();
}

class _InventoryBatchScreenState extends State<InventoryBatchScreen> {
  var query = '';
  List plantData = [];

  var _plantName;

  var _totalBirds;

  var _totalEggs;
  var isLoading = true;
  var date;
  var birdSelected = true;
  var eggSelected = false;

  var batchQuery = '';

  List list = [];

  @override
  void initState() {
    super.initState();
    date = DateFormat.yMEd().format(DateTime.now()).toString();
    getPlantData().then((value) {
      reRun();
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<Apicalls>(context, listen: false)
            .getInventoryBatch(token, _plantName)
            .then((value1) {});
      });
    });
  }

  Future<void> getPlantData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('plantDetails')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('plantDetails')!) as Map<String, dynamic>;
    _plantName = extratedUserData['plantName'];
    _totalBirds = extratedUserData['totalBirds'];
    _totalEggs = extratedUserData['totalEggs'];
  }

  void reRun() {
    setState(() {
      isLoading = false;
    });
  }

  TextStyle numberStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 20,
      color: Colors.black,
    ));
  }

  TextStyle textStyle() {
    return GoogleFonts.roboto(
      textStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Color.fromRGBO(49, 49, 49, 1),
      ),
    );
  }

  Widget buildSearch() => BatchSearchWidget(
        text: batchQuery,
        hintText: 'Search',
        onChanged: searchBook,
      );

  void searchBook(String query) {
    final batches = plantData.where((batch) {
      final batchName = batch['Batch_Code'].toString().toLowerCase();
      final grading = batch['Grading'].toString().toLowerCase();
      final mortality = batch['Mortality_Rate'].toString().toLowerCase();

      final searchNumber = query.toLowerCase();

      return batchName.contains(searchNumber) ||
          grading.contains(searchNumber) ||
          mortality.contains(searchNumber);
    }).toList();

    setState(() {
      batchQuery = query;
      list = batches;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (batchQuery == '') {
      plantData = Provider.of<Apicalls>(context).batchDetails;
      list = plantData;
    }

    return Scaffold(
      appBar: AppBar(
        title: _plantName == null ? const Text('DashBoard') : Text(_plantName),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          Container(
              width: 216,
              height: 36,
              child: SearchWidget(
                  text: query, onChanged: (value) {}, hintText: 'Search')),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          const SizedBox(
            width: 6,
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
        ],
      ),
      body: isLoading == true
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(left: 45.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.offAllNamed(
                                      DashBoardDefaultScreen.routeName);
                                },
                                child: Text(
                                  'Dashboard',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: const Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_back_ios_new,
                                size: 15,
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.offNamed(DashBoardScreen.routeName);
                                },
                                child: Text(
                                  'Inventory',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: const Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_back_ios_new,
                                size: 15,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  _plantName.toString().toLowerCase(),
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color:
                                          const Color.fromRGBO(0, 0, 0, 0.5)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Text(
                                _plantName.toString().toUpperCase(),
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 36,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 38.0),
                            child: Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 201,
                                  height: 92,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(12),
                                    // color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          44, 96, 154, 0.65),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Total Birds',
                                                  style: textStyle(),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  _totalBirds.toString(),
                                                  style: numberStyle(),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 44,
                                            ),
                                            SizedBox(
                                              width: 46,
                                              height: 46,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        44, 96, 154, 1),
                                                child: Image.asset(
                                                  'assets/images/inventory/chicken.png',
                                                  width: 24.04,
                                                  height: 24.07,
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 3.0),
                                          child: Text(
                                            'Updated On $date',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 80,
                                ),
                                Container(
                                  width: 201,
                                  height: 92,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(12),
                                    // color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          44, 96, 154, 0.65),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Total Eggs',
                                                  style: textStyle(),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  _totalEggs.toString(),
                                                  style: numberStyle(),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 44,
                                            ),
                                            SizedBox(
                                              width: 46,
                                              height: 46,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        44, 96, 154, 1),
                                                child: Image.asset(
                                                  'assets/images/inventory/egg.png',
                                                  width: 24.04,
                                                  height: 24.07,
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 3.0),
                                          child: Text(
                                            'Updated On $date',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 80,
                                ),
                                Container(
                                  width: 201,
                                  height: 92,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(12),
                                    // color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          44, 96, 154, 0.65),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Total Batches',
                                                  style: textStyle(),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                plantData.isEmpty
                                                    ? Text(
                                                        'loading',
                                                        style: numberStyle(),
                                                      )
                                                    : Text(
                                                        plantData.length
                                                            .toString(),
                                                        style: numberStyle(),
                                                      )
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 44,
                                            ),
                                            SizedBox(
                                              width: 46,
                                              height: 46,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        44, 96, 154, 1),
                                                child: Image.asset(
                                                  'assets/images/inventory/truck.png',
                                                  width: 24.04,
                                                  height: 24.07,
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 3.0),
                                          child: Text(
                                            'Updated On $date',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 80,
                                ),
                                Container(
                                  width: 201,
                                  height: 92,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(12),
                                    // color: Colors.white,
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          44, 96, 154, 0.65),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Reminders',
                                                  style: textStyle(),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  '0',
                                                  style: numberStyle(),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 44,
                                            ),
                                            SizedBox(
                                              width: 46,
                                              height: 46,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        44, 96, 154, 1),
                                                child: Image.asset(
                                                  'assets/images/inventory/alert.png',
                                                  width: 24.04,
                                                  height: 24.07,
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 3.0),
                                          child: Text(
                                            'Updated On $date',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                        children: [
                          Container(
                            width: 103,
                            height: 44,
                            color: const Color.fromRGBO(245, 245, 245, 1),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Birds',
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Eggs',
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(153, 153, 153, 1),
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Batches',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          SizedBox(width: 253, child: buildSearch()),
                        ],
                      ),
                    ),
                    list.isEmpty
                        ? const SizedBox()
                        : Align(
                            alignment: Alignment.topLeft,
                            child: DataTable(
                                showCheckboxColumn: true,
                                headingTextStyle: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                ),
                                columns: const <DataColumn>[
                                  DataColumn(
                                      label: Text(
                                    'Batch Name',
                                    textAlign: TextAlign.left,
                                  )),
                                  DataColumn(label: Text('Grading')),
                                  DataColumn(label: Text('Mortality Rate')),
                                  DataColumn(label: Text('Production Rate')),
                                  DataColumn(
                                      label: Text('Feed Consumption Rate')),
                                ],
                                rows: <DataRow>[
                                  for (var data in list)
                                    // for(var data in displayData)
                                    DataRow(
                                      onSelectChanged: (value) {},
                                      cells: <DataCell>[
                                        DataCell(
                                          TextButton(
                                            onPressed: () async {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              final userData = json.encode(
                                                {
                                                  'plantName': _plantName,
                                                  'batchName':
                                                      data['Batch_Code'],
                                                  'grading': data['Grading'],
                                                  'productionRate':
                                                      data['Production_Rate'],
                                                  'feedConsumptionRate': data[
                                                      'Feed_Consumption_Rate'],
                                                  'mortalityRate':
                                                      data['Mortality_Rate'],
                                                  'wareHouseCode':
                                                      data['WareHouse_Code']
                                                },
                                              );
                                              prefs.setString(
                                                  'batchDetails', userData);

                                              Get.toNamed(
                                                InventoryBatchDetailScreen
                                                    .routeName,
                                              );
                                            },
                                            child: data['Batch_Code'] == null
                                                ? Text('null')
                                                : Text(
                                                    data['Batch_Code'],
                                                    style: GoogleFonts.roboto(
                                                      textStyle:
                                                          const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color: Color.fromRGBO(
                                                            68, 68, 68, 1),
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        DataCell(
                                          data['Grading'] == null
                                              ? Text('null')
                                              : Text(
                                                  data['Grading'].toString(),
                                                ),
                                        ),
                                        DataCell(
                                          data['Mortality_Rate'] == null
                                              ? Text('null')
                                              : Text(
                                                  data['Mortality_Rate']
                                                      .toString(),
                                                ),
                                        ),
                                        DataCell(
                                          data['Production_Rate'] == null
                                              ? Text('null')
                                              : Text(
                                                  data['Production_Rate']
                                                      .toString(),
                                                ),
                                        ),
                                        DataCell(
                                          data['Feed_Consumption_Rate'] == null
                                              ? Text('null')
                                              : Text(
                                                  data['Feed_Consumption_Rate']
                                                      .toString(),
                                                ),
                                        ),
                                      ],
                                    ),
                                ]),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
