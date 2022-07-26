import 'dart:convert';
import 'dart:html';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:poultry_login_signup/screens/production_dashboard.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../infrastructure/widgets/add_firm_details_dialog.dart';

class FirmPlantSelectionPage extends StatefulWidget {
  FirmPlantSelectionPage({Key? key}) : super(key: key);

  static const routeName = '/FirmPlantSelectionPage';

  @override
  _FirmPlantSelectionPageState createState() => _FirmPlantSelectionPageState();
}

class _FirmPlantSelectionPageState extends State<FirmPlantSelectionPage> {
  Map<String, dynamic> fcmDeviceModel = {
    'registration_id': '',
    'name': '',
    'device_id': '',
    'type': '',
  };
  var firmId;

  List firmList = [];

  var plantId;

  List plantList = [];

  bool _firmSelected = false;

  var _firmName;
  var _plantName;
  var _plantId;
  var _firmId;
  var _userName;
  var token;
  @override
  void initState() {
    super.initState();
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      token = Provider.of<Apicalls>(context, listen: false).token;
      _userName = Provider.of<Apicalls>(context, listen: false).userName;

      Provider.of<InfrastructureApis>(context, listen: false)
          .getFirmDetails(token)
          .then((value1) {});
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
    });
    _getId().then((value) async {
      fcmDeviceModel['device_id'] = value;
      FirebaseMessaging.instance
          .getToken(
              vapidKey:
                  'BLWUwuMEv70r8ptiPqaJWYBBL3AizobTwdVSiHHmDybKCdpSxLmFsotosfs5YqDnDLiBWMp_Aqm5n8KjpQF7SU0')
          .then((value) {
        fcmDeviceModel['registration_id'] = value.toString();
        Provider.of<Apicalls>(context, listen: false).getUser().then((value) {
          if (value['StatusCode'] == 200) {
            fcmDeviceModel['name'] = value['Id'];
            Provider.of<Apicalls>(context, listen: false)
                .sendFCMDeviceModel(fcmDeviceModel, token);
          } else {
            var window =
                MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
            double width = window.size.width;

            Get.showSnackbar(GetSnackBar(
              backgroundColor: Colors.white,
              margin: EdgeInsets.only(left: width * 0.85, top: 50),
              leftBarIndicatorColor: Colors.grey,
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 3),
              maxWidth: 337,
              titleText: Text(
                'Failed',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(color: Colors.black)),
              ),

              messageText: Text(
                'Something Went Wrong please Try Again',
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(color: Colors.black),
                ),
              ),

              // snackStyle: SnackStyle.GROUNDED,
              mainButton: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.close)),
            ));
          }
        });
      });
    });
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.supportsSimd) {
      // import 'dart:io'
      fcmDeviceModel['type'] = 'browser';
      var iosDeviceInfo = await deviceInfo.webBrowserInfo;
      return iosDeviceInfo.userAgent; // unique ID on iOS
    } else {
      fcmDeviceModel['type'] = 'browser';
      var androidDeviceInfo = await deviceInfo.webBrowserInfo;
      return androidDeviceInfo.userAgent; // unique ID on Android
    }
  }

  void fechplantList(int id) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getPlantDetails(
            token,
            id,
          )
          .then((value1) {});
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
    });
  }

  void update(int value) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;

      Provider.of<InfrastructureApis>(context, listen: false)
          .getFirmDetails(token)
          .then((value1) {});
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    firmList = Provider.of<InfrastructureApis>(
      context,
    ).firmDetails;
    plantList = Provider.of<InfrastructureApis>(
      context,
    ).plantDetails;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.asset(
                    'assets/images/Welcome_Image.png',
                    alignment: Alignment.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    alignment: Alignment.topCenter,
                    child: Form(
                      // key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 427,
                            alignment: Alignment.topLeft,
                            child: _userName == ''
                                ? Text(
                                    'Hi User, Welcome',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(44, 96, 154, 1),
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Hi $_userName, Welcome',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(44, 96, 154, 1),
                                      ),
                                    ),
                                  ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 43.0),
                            child: Container(
                              width: 427,
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Select the firm',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Align(
                              // alignment: Alignment.topLeft,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 6.0),
                                    child: Container(
                                      width: 440,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text('Firm Name'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 440,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black26),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: firmId,
                                          items: firmList
                                              .map<DropdownMenuItem<String>>(
                                                  (e) {
                                            return DropdownMenuItem(
                                              child: e['Firm_Name'] ==
                                                      'Add New Firm'
                                                  ? IconButton(
                                                      onPressed: () {
                                                        addNewFirm(context);
                                                      },
                                                      icon:
                                                          const Icon(Icons.add))
                                                  : Text(e['Firm_Name']),
                                              value: e['Firm_Name'],
                                              onTap: () {
                                                if (e['Firm_Name'] ==
                                                    'Add New Firm') {
                                                } else {
                                                  _firmId = e['Firm_Id'];
                                                  _firmName = e['Firm_Name'];
                                                  fechplantList(e['Firm_Id']);
                                                  plantId = null;
                                                }
                                              },
                                            );
                                          }).toList(),
                                          hint: const Text('Choose Firm Name'),
                                          onChanged: (value) {
                                            setState(() {
                                              firmId = value as String;
                                              _firmSelected = true;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          _firmSelected == false
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 24.0),
                                  child: Align(
                                    // alignment: Alignment.topLeft,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 440,
                                          padding:
                                              const EdgeInsets.only(bottom: 6),
                                          child: const Text('Plant Name'),
                                        ),
                                        Container(
                                          width: 440,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black26),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            child: DropdownButtonHideUnderline(
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
                                                      _plantId = e['Plant_Id'];
                                                      _plantName =
                                                          e['Plant_Name'];
                                                      // wareHouseDetails['Plant_Id'] = e['Plant_Id'];
                                                    },
                                                  );
                                                }).toList(),
                                                hint: const Text(
                                                    'Choose Plant Name'),
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
                                ),

                          Padding(
                            padding: _firmSelected == false
                                ? const EdgeInsets.only(top: 179.0)
                                : const EdgeInsets.only(top: 97.0),
                            child: Container(
                              width: 426,
                              height: 56,
                              child: Row(
                                children: [
                                  Container(
                                    width: 426 / 2.2,
                                    height: 48,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color.fromRGBO(
                                                      44, 96, 154, 1))),
                                      onPressed: () async {
                                        final prefs = await SharedPreferences
                                            .getInstance();

                                        final userData = json.encode(
                                          {
                                            'FirmName': _firmName,
                                            'FirmId': _firmId,
                                            'PlantName': _plantName,
                                            'PlantId': _plantId,
                                          },
                                        );
                                        prefs.setString(
                                            'FirmAndPlantDetails', userData);
                                        Get.offNamed(ProductionDashBoardScreen
                                            .routeName);
                                      },
                                      child: Text(
                                        'Continue',
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 24)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 38,
                                  ),
                                  Container(
                                    width: 426 / 2.2,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            44, 96, 154, 1),
                                      ),
                                    ),
                                    child: TextButton(
                                      style: ButtonStyle(),
                                      // key: const Key('Log In'),
                                      onPressed: () {},
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Color.fromRGBO(
                                                    44, 96, 154, 1),
                                                fontSize: 24)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   alignment: Alignment.topLeft,
                          //   width: 426,
                          //   child: TextButton(
                          //       onPressed: () {
                          //         window.open(
                          //             'https://poultryfarmerp.herokuapp.com/accounts/password/reset/',
                          //             '_self');
                          //       },
                          //       child: Text(
                          //         'forgot password?',
                          //         style: GoogleFonts.roboto(
                          //             textStyle: const TextStyle(
                          //                 fontWeight: FontWeight.w400,
                          //                 fontSize: 18,
                          //                 color: Color.fromRGBO(
                          //                     133, 133, 133, 1))),
                          //       )),
                          // ),
                          const SizedBox(
                            height: 96,
                          ),
                          // Container(
                          //   alignment: Alignment.center,
                          //   width: 426,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       TextButton(
                          //         onPressed: () {
                          //           // Navigator.of(context)
                          //           //     .pushNamed(SignUp.routeName);
                          //           // Get.to(SignUp());
                          //         },
                          //         child: Text(
                          //           'Create an account',
                          //           style: GoogleFonts.roboto(
                          //             textStyle: const TextStyle(
                          //               fontWeight: FontWeight.w500,
                          //               fontSize: 18,
                          //               color: Color.fromRGBO(44, 96, 154, 1),
                          //               decoration: TextDecoration.underline,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       const Icon(
                          //         Icons.arrow_forward,
                          //         size: 16,
                          //         color: Color.fromRGBO(44, 96, 154, 1),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> addNewFirm(BuildContext context) {
    return showGlobalDrawer(
        context: context,
        builder: (ctx) => AddFirmDetailsDialog(
              reFresh: update,
            ),
        direction: AxisDirection.right);
  }
}
