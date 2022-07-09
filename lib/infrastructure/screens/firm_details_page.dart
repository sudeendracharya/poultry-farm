import 'dart:convert';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/admin/providers/admin_apis.dart';
import 'package:poultry_login_signup/infrastructure/screens/firms_page.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:poultry_login_signup/screens/global_app_bar.dart';

import 'package:poultry_login_signup/screens/main_dash_board.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/add_plant_details.dart';
import '../widgets/edit_firm_details_dialog.dart';

class FirmDetailsPage extends StatefulWidget {
  FirmDetailsPage({Key? key}) : super(key: key);

  static const routeName = '/FirmDetailsPage';

  @override
  _FirmDetailsPageState createState() => _FirmDetailsPageState();
}

class _FirmDetailsPageState extends State<FirmDetailsPage> {
  var query = '';

  var firmId;

  List plantDetails = [];

  var _firmName;

  var _firmCode;

  var _contactNumber;

  var _pan;

  var _permanentContactNumber;

  var _firmId;

  bool _isLoading = true;

  var _email;
  var _alternateContactNumber;

  var selected = false;

  var count = 0;

  List temp = [];

  @override
  void initState() {
    firmId = Get.arguments;

    getFirmData().then((value) {
      reRun();
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .getPlantDetails(token, _firmId)
            .then((value1) {});
      });
    });

    super.initState();
  }

  void getUserRoles(int data) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<AdminApis>(context, listen: false).getUserRoles(token);
    });
  }

  Future<void> getFirmData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('FirmDetails')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('FirmDetails')!) as Map<String, dynamic>;
    _firmName = extratedUserData['firmName'];
    _firmCode = extratedUserData['firmCode'];
    _contactNumber = extratedUserData['contactNumber'].toString();
    _pan = extratedUserData['pan'];
    _permanentContactNumber =
        extratedUserData['permanentContactNumber'].toString();
    _firmId = extratedUserData['firmId'].toString();
    _email = extratedUserData['email'];
    _alternateContactNumber = extratedUserData['alternateContactNumber'];
  }

  void reRun() {
    setState(() {
      _isLoading = false;
    });
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

  Container getHeadingContainer(var data) {
    return Container(
      width: 200,
      height: 25,
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

  void updateFirmDatas(int data) {
    getFirmData().then((value) {
      reRun();
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        // Provider.of<InfrastructureApis>(context, listen: false)
        //     .getFirmDetails(token)
        //     .then((value1) {});
      });
    });
  }

  void update(int data) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getPlantDetails(token, _firmId)
          .then((value1) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    plantDetails = Provider.of<InfrastructureApis>(context).plantDetails;
    final breadCrumpsStyle = Theme.of(context).textTheme.headline4;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(FirmsPage.routeName);
        return true;
      },
      child: Scaffold(
        appBar: GlobalAppBar(query: query, appbar: AppBar()),
        body: Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 43),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.offAllNamed(MainDashBoardScreen.routeName);
                      },
                      child: Text('Dashboard', style: breadCrumpsStyle),
                    ),
                    const Icon(
                      Icons.arrow_back_ios_new,
                      size: 15,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offNamed(FirmsPage.routeName);
                      },
                      child: Text('Infrastructure', style: breadCrumpsStyle),
                    ),
                    const Icon(
                      Icons.arrow_back_ios_new,
                      size: 15,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: _firmName == null
                          ? const SizedBox()
                          : Text(_firmName, style: breadCrumpsStyle),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _firmName == null
                          ? const SizedBox()
                          : Text(
                              _firmName,
                              style:
                                  // style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
                                  GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 36),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(right: 143),
                        child: TextButton(
                          onPressed: () {
                            showGlobalDrawer(
                                context: context,
                                builder: (ctx) => EditFirmDetailsDialog(
                                      reFresh: updateFirmDatas,
                                      email: _email,
                                      firmAlternateContactNumber:
                                          _alternateContactNumber,
                                      firmCode: _firmCode,
                                      firmContactNumber: _contactNumber,
                                      firmId: _firmId,
                                      firmName: _firmName,
                                      pan: _pan,
                                      update: true,
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
                                      decoration: TextDecoration.underline,
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, top: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Administration Details',
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
                            getHeadingContainer('Firm Code'),
                            const SizedBox(
                              width: 49,
                            ),
                            _firmCode == null
                                ? const SizedBox()
                                : getDataContainer(_firmCode),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('Firm Name'),
                            const SizedBox(
                              width: 49,
                            ),
                            _firmName == null
                                ? const SizedBox()
                                : getDataContainer(_firmName),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('Phone Number'),
                            const SizedBox(
                              width: 49,
                            ),
                            _contactNumber == null
                                ? const SizedBox()
                                : getDataContainer(_contactNumber),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('Email Id'),
                            const SizedBox(
                              width: 49,
                            ),
                            _email == null
                                ? const SizedBox()
                                : getDataContainer(_email),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            getHeadingContainer('PAN'),
                            const SizedBox(
                              width: 49,
                            ),
                            _pan == null
                                ? const SizedBox()
                                : getDataContainer(_pan),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 30.0, left: 30.0, right: 142),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Plant Details',
                          style: styleData(),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showGlobalDrawer(
                                context: context,
                                builder: (ctx) => AddPlantDetails(
                                      firmId: _firmId,
                                      reFresh: update,
                                    ),
                                direction: AxisDirection.right);
                          },
                          icon: const Icon(Icons.add)),
                      count == 1 && selected == true ||
                              count == 1 && selected == false
                          ? IconButton(
                              onPressed: () {
                                showGlobalDrawer(
                                    context: context,
                                    builder: (ctx) => AddPlantDetails(
                                          firmId: _firmId,
                                          reFresh: update,
                                          pinCode: temp[0]['Plant_Pincode']
                                              .toString(),
                                          plantAddressLine1: temp[0]
                                              ['Plant_Address_Line_1'],
                                          plantAddressLine2: temp[0]
                                              ['Plant_Address_Line_2'],
                                          plantCode:
                                              temp[0]['Plant_Code'].toString(),
                                          plantDistrict: temp[0]
                                              ['Plant_District'],
                                          plantId: temp[0]['Plant_Id'],
                                          plantName: temp[0]['Plant_Name'],
                                          plantState: temp[0]['Plant_State'],
                                          plantTaluk: temp[0]['Plant_Taluk'],
                                          update: true,
                                        ),
                                    direction: AxisDirection.right);
                              },
                              icon: const Icon(Icons.edit),
                            )
                          : const SizedBox(),
                      selected == true || count >= 1
                          ? IconButton(
                              onPressed: () {
                                if (temp.isEmpty) {
                                  Get.showSnackbar(GetSnackBar(
                                    duration: const Duration(seconds: 2),
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    message:
                                        'Please Select the check box first',
                                    title: 'Alert',
                                  ));
                                } else {
                                  List plantIds = [];
                                  for (var data in temp) {
                                    plantIds.add(data['Plant_Id']);
                                  }
                                  Provider.of<Apicalls>(context, listen: false)
                                      .tryAutoLogin()
                                      .then((value) {
                                    var token = Provider.of<Apicalls>(context,
                                            listen: false)
                                        .token;
                                    Provider.of<InfrastructureApis>(context,
                                            listen: false)
                                        .deletePlantDetails(plantIds, token)
                                        .then((value1) {
                                      if (value1 == 204) {
                                        Provider.of<InfrastructureApis>(context,
                                                listen: false)
                                            .getPlantDetails(token, firmId);
                                      }
                                    });
                                  });
                                }
                              },
                              icon: const Icon(Icons.delete),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 30),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 280,
                      // decoration: BoxDecoration(border: Border.all()),
                      child: InteractiveViewer(
                        alignPanAxis: true,
                        constrained: false,
                        // panEnabled: false,
                        scaleEnabled: false,
                        child: DataTable(
                            showCheckboxColumn: true,
                            columnSpacing: width <= 770
                                ? 45
                                : MediaQuery.of(context).size.width *
                                    0.09765625,
                            headingTextStyle: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ),
                            columns: const <DataColumn>[
                              DataColumn(
                                  label: Text(
                                'plant Id',
                                textAlign: TextAlign.left,
                              )),
                              DataColumn(label: Text('plant Name')),
                              DataColumn(label: Text('Location')),
                              DataColumn(label: Text('Country')),
                              DataColumn(label: Text('State')),
                              DataColumn(label: Text('City')),
                            ],
                            rows: <DataRow>[
                              for (var data in plantDetails)
                                DataRow(
                                  selected: data['Selected'],
                                  onSelectChanged: (value) {
                                    setState(() {
                                      data['Selected'] = value;
                                      selected = value!;
                                      if (value == true) {
                                        count = count + 1;
                                        temp.add(data);
                                      } else {
                                        temp.remove(data);
                                        count = count - 1;
                                      }
                                    });
                                  },
                                  cells: <DataCell>[
                                    DataCell(
                                      Text(data['Plant_Code']),
                                    ),
                                    DataCell(Text(data['Plant_Name'])),
                                    DataCell(Text(data['Plant_Address_Line_1'] +
                                        data['Plant_Address_Line_2'])),
                                    DataCell(Text(data['Plant_Country'] ?? '')),
                                    DataCell(Text(data['Plant_State'] ?? '')),
                                    DataCell(
                                        Text(data['Plant_District'] ?? '')),
                                  ],
                                ),
                            ]),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 30.0, left: 33),
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: SizedBox(
                //       width: 400,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             'Permissions',
                //             style: styleData(),
                //           ),
                //           IconButton(
                //             onPressed: () {},
                //             icon: const Icon(Icons.add),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 30.0),
                //     child: DataTable(
                //         columnSpacing: width <= 770
                //             ? 45
                //             : MediaQuery.of(context).size.width * 0.09765625,
                //         showCheckboxColumn: true,
                //         headingTextStyle: GoogleFonts.roboto(
                //           textStyle: const TextStyle(
                //             fontWeight: FontWeight.w700,
                //             fontSize: 18,
                //             color: Color.fromRGBO(0, 0, 0, 1),
                //           ),
                //         ),
                //         columns: [
                //           DataColumn(
                //               label: Text(
                //             'permissions',
                //             textAlign: TextAlign.left,
                //           )),
                //           DataColumn(label: Text('Modules')),
                //         ],
                //         rows: []),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 30.0, left: 33),
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: SizedBox(
                //       width: 400,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             'Users',
                //             style: styleData(),
                //           ),
                //           IconButton(
                //             onPressed: () {},
                //             icon: const Icon(Icons.add),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 30.0),
                //     child: DataTable(
                //         columnSpacing: width <= 770
                //             ? 45
                //             : MediaQuery.of(context).size.width * 0.09765625,
                //         showCheckboxColumn: true,
                //         headingTextStyle: GoogleFonts.roboto(
                //           textStyle: const TextStyle(
                //             fontWeight: FontWeight.w700,
                //             fontSize: 18,
                //             color: Color.fromRGBO(0, 0, 0, 1),
                //           ),
                //         ),
                //         columns: [
                //           DataColumn(
                //               label: Text(
                //             'User Id',
                //             textAlign: TextAlign.left,
                //           )),
                //           DataColumn(label: Text('User Name')),
                //           DataColumn(label: Text('Phone No')),
                //           DataColumn(label: Text('Email')),
                //         ],
                //         rows: []),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 30.0, left: 33),
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: SizedBox(
                //       width: 400,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             'Roles',
                //             style: styleData(),
                //           ),
                //           IconButton(
                //             onPressed: () {
                //               showGlobalDrawer(
                //                 context: context,
                //                 builder: (ctx) => AddUserRoles(
                //                   reFresh: getUserRoles,
                //                 ),
                //                 direction: AxisDirection.right,
                //               );
                //             },
                //             icon: const Icon(Icons.add),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 30.0),
                //     child: DataTable(
                //         columnSpacing: width <= 770
                //             ? 45
                //             : MediaQuery.of(context).size.width * 0.09765625,
                //         showCheckboxColumn: true,
                //         headingTextStyle: GoogleFonts.roboto(
                //           textStyle: const TextStyle(
                //             fontWeight: FontWeight.w700,
                //             fontSize: 18,
                //             color: Color.fromRGBO(0, 0, 0, 1),
                //           ),
                //         ),
                //         columns: [
                //           DataColumn(
                //               label: Text(
                //             'Role Name',
                //             textAlign: TextAlign.left,
                //           )),
                //           DataColumn(label: Text('Role Description')),
                //           DataColumn(label: Text('Role Permission')),
                //         ],
                //         rows: []),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
