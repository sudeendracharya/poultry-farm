import 'dart:math';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';

import 'package:provider/provider.dart';

import '../../main.dart';
import '../../styles.dart';
import '../../widgets/modular_widgets.dart';

class AddPlantDetails extends StatefulWidget {
  AddPlantDetails({
    Key? key,
    this.firmId,
    required this.reFresh,
    this.plantId,
    this.pinCode,
    this.plantAddressLine1,
    this.plantAddressLine2,
    this.plantCode,
    this.plantDistrict,
    this.plantName,
    this.plantState,
    this.plantTaluk,
    this.update,
  }) : super(key: key);
  static const routeName = '/AddPlantDetails';

  var firmId;
  final ValueChanged<int> reFresh;
  var plantId;
  var update;
  var plantCode;
  var plantName;
  var plantAddressLine1;
  var plantAddressLine2;
  var plantTaluk;
  var plantDistrict;
  var plantState;
  var pinCode;

  @override
  _AddPlantDetailsState createState() => _AddPlantDetailsState();
}

class _AddPlantDetailsState extends State<AddPlantDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String errorTitle = '';

  String errorMessage = '';

  bool plantCodeError = false;

  bool plantNameError = false;

  bool address1 = false;

  bool address2 = false;

  bool district = false;

  bool taluk = false;

  bool state = false;

  bool pincode = false;

  String countryValue = '';

  String? stateValue;

  String? cityValue;

  TextEditingController plantAddress2Controller = TextEditingController();
  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  List firmData = [];
  List firmNames = [];
  var firmId;
  var firmName;
  var update = false;
  var plantId;
  GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    clearPlantException(context);
    plantCodeController.text = widget.plantCode ?? getRandom(4, 'Plant-');
    plantNameController.text = widget.plantName ?? '';
    plantPincodeController.text =
        widget.pinCode == null ? '' : widget.pinCode.toString();
    plantAddresController.text = widget.plantAddressLine1 ?? '';
    plantAddress2Controller.text = widget.plantAddressLine2 ?? '';
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getFirmDetails(token)
          .then((value1) {});
    });
  }

  TextEditingController plantCodeController = TextEditingController();
  TextEditingController plantNameController = TextEditingController();
  TextEditingController plantPincodeController = TextEditingController();
  TextEditingController plantAddresController = TextEditingController();
  String plantCodeValidationMessage = '';
  String plantNameValidationMessage = '';
  String plantAddressValidationMessage = '';
  String plantCountryValidationMessage = '';
  String plantDistrictValidationMessage = '';
  String plantStateValidationMessage = '';
  String plantPincodeValidationMessage = '';

  bool plantCodeValidation = true;
  bool plantNameValidation = true;
  bool plantAddressValidation = true;
  bool plantCountryValidation = true;
  bool plantDistrictValidation = true;
  bool plantStateValidation = true;
  bool plantPincodeValidation = true;

  double width = 600;
  var plantDetails = {
    'Firm_Name': '',
    'Plant_Code': '',
    'Plant_Name': '',
    'Plant_Address_Line_1': '',
    'Plant_Address_Line_2': '',
    'Plant_Taluk': '',
    'Plant_District': '',
    'Plant_State': '',
    'Plant_Pincode': '',
  };

  var initValues = {
    'Firm_Name': '',
    'Plant_Code': '',
    'Plant_Name': '',
    'Plant_Address_Line_1': '',
    'Plant_Address_Line_2': '',
    'Plant_Taluk': '',
    'Plant_District': '',
    'Plant_State': '',
    'Plant_Pincode': '',
  };

  String getRandom(int length, String name) {
    const ch = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random r = Random();
    return name +
        String.fromCharCodes(
          Iterable.generate(
            length,
            (_) => ch.codeUnitAt(
              r.nextInt(ch.length),
            ),
          ),
        );
  }

  bool validatePlantData() {
    if (plantCodeController.text == '') {
      plantCodeValidationMessage = 'Plant Code Cannot Be Empty';
      plantCodeValidation = false;
    } else {
      plantCodeValidation = true;
    }
    if (plantNameController.text.length > 30) {
      plantNameValidationMessage =
          'Plant Name Cannot Be Greater Than 30 Characters';
      plantNameValidation = false;
    } else if (plantNameController.text == '') {
      plantNameValidationMessage = 'Plant Name Cannot Be Empty';
      plantNameValidation = false;
    } else {
      plantNameValidation = true;
    }
    if (plantAddresController.text == '') {
      plantAddressValidationMessage = 'plant Address Cannot Be Empty';
      plantAddressValidation = false;
    } else {
      plantAddressValidation = true;
    }

    if (plantPincodeController.text.length > 6) {
      plantPincodeValidationMessage = 'Pincode Cannot Exceed 6 Characters';
      plantPincodeValidation = false;
    } else if (plantPincodeController.text == '') {
      plantPincodeValidationMessage = 'Plant Pincode Cannot Be Empty';
      plantPincodeValidation = false;
    } else {
      plantPincodeValidation = true;
    }

    if (countryValue == '') {
      plantCountryValidationMessage = 'Country Field Cannot Be Empty';
      plantCountryValidation = false;
    } else {
      plantCountryValidation = true;
    }

    if (stateValue == null) {
      plantStateValidationMessage = 'State Field Cannot Be Empty';
      plantStateValidation = false;
    } else {
      plantStateValidation = true;
    }

    if (cityValue == null) {
      plantDistrictValidationMessage = 'City Field Cannot Be Empty';
      plantDistrictValidation = false;
    } else {
      plantDistrictValidation = true;
    }
    if (plantCodeValidation == true &&
        plantNameValidation == true &&
        plantAddressValidation == true &&
        plantPincodeValidation == true &&
        plantCountryValidation == true &&
        plantStateValidation == true &&
        plantDistrictValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> save() async {
    var isValid = validatePlantData();
    if (!isValid) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    // print(plantDetails);
    // print('Firm Id ${widget.firmId}');
    plantDetails['Plant_District'] = cityValue ?? '';
    plantDetails['Plant_Country'] = countryValue;
    plantDetails['Plant_State'] = stateValue ?? '';

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .addPlantDetails(plantDetails, widget.firmId, token)
            .then((value) {
          if (value['StatusCode'] == 200 || value['StatusCode'] == 201) {
            widget.reFresh(100);
            Get.showSnackbar(GetSnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: Theme.of(context).backgroundColor,
              message: 'Successfully Added Firm Details',
              title: 'Success',
            ));
            _formKey.currentState!.reset();
          } else {
            Get.showSnackbar(GetSnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: Theme.of(context).backgroundColor,
              message: 'Something Went Wrong',
              title: 'Failed',
            ));
          }
        });
      });
    } catch (e) {
      // print(e);
    }
  }

  Future<void> updateData() async {
    var isValid = validatePlantData();
    if (!isValid) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    // print(plantDetails);
    plantDetails['Plant_District'] = cityValue ?? '';
    plantDetails['Plant_Country'] = countryValue;
    plantDetails['Plant_State'] = stateValue ?? '';
    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .editPlantDetails(plantDetails, widget.plantId, token)
            .then((value) {
          if (value == 202 || value == 201) {
            widget.reFresh(100);
            Get.back();
            Get.showSnackbar(GetSnackBar(
              duration: const Duration(seconds: 3),
              backgroundColor: Theme.of(context).backgroundColor,
              message: 'Successfully edited the data',
              title: 'Success',
            ));

            // _formKey.currentState!.reset();
          } else {
            Get.showSnackbar(GetSnackBar(
              duration: const Duration(seconds: 3),
              backgroundColor: Theme.of(context).backgroundColor,
              message: 'Something Went Wrong Please Try Again',
              title: 'Failed',
            ));
          }
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  void showError(String error) {
    switch (error) {
      case 'PlantCode':
        setState(() {
          errorTitle = 'Plant Code';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          plantCodeError = true;
        });
        break;
      case 'PlantName':
        setState(() {
          errorTitle = 'Plant Name';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          plantNameError = true;
        });
        break;
      case 'Address1':
        setState(() {
          errorTitle = 'Address1';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          address1 = true;
        });
        break;
      case 'Address2':
        setState(() {
          errorTitle = 'Address2';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          address2 = true;
        });
        break;
      case 'Taluk':
        setState(() {
          errorTitle = 'Taluk';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          taluk = true;
        });
        break;
      case 'District':
        setState(() {
          errorTitle = 'District';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          district = true;
        });
        break;
      case 'State':
        setState(() {
          errorTitle = 'State';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          state = true;
        });
        break;
      case 'Pincode':
        setState(() {
          errorTitle = 'Pincode';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          pincode = true;
        });
        break;
      default:
    }
  }

  Padding showErrorDialog(String errorTitle, String errorMessage) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 440,
              height: 48,
              // color: const Color.fromRGBO(255, 219, 219, 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromRGBO(255, 219, 219, 1),
                border: Border.all(
                  color: const Color.fromRGBO(255, 219, 219, 1),
                ),
              ),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              errorTitle,
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Color.fromRGBO(68, 68, 68, 1))),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              errorMessage,
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Color.fromRGBO(68, 68, 68, 1))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    firmData = Provider.of<InfrastructureApis>(
      context,
    ).firmDetails;

    // if (firmData.isNotEmpty) {
    //   for (var data in firmData) {
    //     firmNames.add(data['Firm_Name'].toString());
    //   }
    // }

    return SafeArea(
      child: Container(
        width: 500,
        height: MediaQuery.of(context).size.height,
        child: Drawer(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Plant Details',
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 36)),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 36.0),
                        child: Row(
                          children: [
                            widget.plantId == null
                                ? const Text(
                                    'Add Plant',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  )
                                : const Text(
                                    'Update Plant',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18),
                                  )
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 440,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Plant code'),
                              ),
                              Container(
                                width: 440,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: plantCodeError == false
                                          ? Colors.black26
                                          : const Color.fromRGBO(
                                              243, 60, 60, 1)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: plantCodeError == false
                                            ? 'Enter Plant Code'
                                            : '',
                                        border: InputBorder.none),
                                    controller: plantCodeController,
                                    onSaved: (value) {
                                      plantDetails['Plant_Code'] = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      plantCodeValidation == true
                          ? const SizedBox()
                          : ModularWidgets.validationDesign(
                              size, plantCodeValidationMessage),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 440,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Plant Name'),
                              ),
                              Container(
                                width: 440,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: plantNameError == false
                                          ? Colors.black26
                                          : const Color.fromRGBO(
                                              243, 60, 60, 1)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: plantNameError == false
                                            ? 'Enter Plant Name'
                                            : '',
                                        border: InputBorder.none),
                                    controller: plantNameController,
                                    onSaved: (value) {
                                      plantDetails['Plant_Name'] = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      plantNameValidation == true
                          ? const SizedBox()
                          : ModularWidgets.validationDesign(
                              size, plantNameValidationMessage),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 100,
                                child: CSCPicker(
                                  showStates: true,
                                  showCities: true,
                                  countrySearchPlaceholder: "Country",
                                  stateSearchPlaceholder: "State",
                                  citySearchPlaceholder: "City",

                                  ///labels for dropdown
                                  countryDropdownLabel: "*Country",
                                  stateDropdownLabel: "*State",
                                  cityDropdownLabel: "*City",
                                  flagState: CountryFlag.DISABLE,
                                  onCountryChanged: (value) {
                                    setState(() {
                                      ///store value in country variable
                                      countryValue = value.removeAllWhitespace;
                                    });
                                  },

                                  ///triggers once state selected in dropdown
                                  onStateChanged: (value) {
                                    setState(() {
                                      ///store value in state variable
                                      stateValue = value;
                                    });
                                  },

                                  ///triggers once city selected in dropdown
                                  onCityChanged: (value) {
                                    setState(() {
                                      ///store value in city variable
                                      cityValue = value;
                                    });
                                  },
                                ),
                              ),
                              plantCountryValidation == true
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: ModularWidgets.validationDesign(
                                          size, plantCountryValidationMessage),
                                    ),
                              plantStateValidation == true
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: ModularWidgets.validationDesign(
                                          size, plantStateValidationMessage),
                                    ),

                              plantDistrictValidation == true
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: ModularWidgets.validationDesign(
                                          size, plantDistrictValidationMessage),
                                    ),

                              // Container(
                              //   width: 440,
                              //   padding: const EdgeInsets.only(bottom: 12),
                              //   child: const Text('Plant District'),
                              // ),
                              // Container(
                              //   width: 440,
                              //   height: 36,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(8),
                              //     color: Colors.white,
                              //     border: Border.all(
                              //         color: district == false
                              //             ? Colors.black26
                              //             : const Color.fromRGBO(
                              //                 243, 60, 60, 1)),
                              //   ),
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 12, vertical: 6),
                              //     child: TextFormField(
                              //       decoration: InputDecoration(
                              //           hintText: district == false
                              //               ? 'Enter Plant District'
                              //               : '',
                              //           border: InputBorder.none),
                              //       onSaved: (value) {
                              //         plantDetails['Plant_District'] = value!;
                              //       },
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 440,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Plant Address Line 1 '),
                              ),
                              Container(
                                width: 440,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: address1 == false
                                          ? Colors.black26
                                          : const Color.fromRGBO(
                                              243, 60, 60, 1)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: address1 == false
                                            ? 'Enter Plant Address'
                                            : '',
                                        border: InputBorder.none),
                                    controller: plantAddresController,
                                    onSaved: (value) {
                                      plantDetails['Plant_Address_Line_1'] =
                                          value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      plantAddressValidation == true
                          ? const SizedBox()
                          : ModularWidgets.validationDesign(
                              size, plantAddressValidationMessage),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 440,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Plant Address Line 2 '),
                              ),
                              Container(
                                width: 440,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: address2 == false
                                          ? Colors.black26
                                          : const Color.fromRGBO(
                                              243, 60, 60, 1)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    controller: plantAddress2Controller,
                                    decoration: InputDecoration(
                                        hintText: address2 == false
                                            ? 'Enter Plant Address'
                                            : '',
                                        border: InputBorder.none),
                                    onSaved: (value) {
                                      plantDetails['Plant_Address_Line_2'] =
                                          value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.only(top: 24.0),
                      //   child: Align(
                      //     alignment: Alignment.topLeft,
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Container(
                      //           width: 440,
                      //           padding: const EdgeInsets.only(bottom: 12),
                      //           child: const Text('Plant Taluk'),
                      //         ),
                      //         Container(
                      //           width: 440,
                      //           height: 36,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(8),
                      //             color: Colors.white,
                      //             border: Border.all(
                      //                 color: taluk == false
                      //                     ? Colors.black26
                      //                     : const Color.fromRGBO(
                      //                         243, 60, 60, 1)),
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.symmetric(
                      //                 horizontal: 12, vertical: 6),
                      //             child: TextFormField(
                      //               decoration: InputDecoration(
                      //                   hintText: taluk == false
                      //                       ? 'Enter Plant Taluk'
                      //                       : '',
                      //                   border: InputBorder.none),
                      //               onSaved: (value) {
                      //                 plantDetails['Plant_Taluk'] = value!;
                      //               },
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.only(top: 24.0),
                      //   child: Align(
                      //     alignment: Alignment.topLeft,
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Container(
                      //           width: 440,
                      //           padding: const EdgeInsets.only(bottom: 12),
                      //           child: const Text('Plant State'),
                      //         ),
                      //         Container(
                      //           width: 440,
                      //           height: 36,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(8),
                      //             color: Colors.white,
                      //             border: Border.all(
                      //                 color: state == false
                      //                     ? Colors.black26
                      //                     : const Color.fromRGBO(
                      //                         243, 60, 60, 1)),
                      //           ),
                      //           child: Padding(
                      //             padding: const EdgeInsets.symmetric(
                      //                 horizontal: 12, vertical: 6),
                      //             child: TextFormField(
                      //               decoration: InputDecoration(
                      //                   hintText: state == false
                      //                       ? 'Enter Plant State'
                      //                       : '',
                      //                   border: InputBorder.none),
                      //               onSaved: (value) {
                      //                 plantDetails['Plant_State'] = value!;
                      //               },
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 440,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Plant Pincode'),
                              ),
                              Container(
                                width: 440,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: pincode == false
                                          ? Colors.black26
                                          : const Color.fromRGBO(
                                              243, 60, 60, 1)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: pincode == false
                                            ? 'Enter Plant Pincode'
                                            : '',
                                        border: InputBorder.none),
                                    controller: plantPincodeController,
                                    onSaved: (value) {
                                      plantDetails['Plant_Pincode'] = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      plantPincodeValidation == true
                          ? const SizedBox()
                          : ModularWidgets.validationDesign(
                              size, plantPincodeValidationMessage),
                      Consumer<InfrastructureApis>(
                          builder: (context, value, child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: value.plantException.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ModularWidgets.exceptionDesign(
                                MediaQuery.of(context).size,
                                value.plantException[index]);
                          },
                        );
                      }),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.update == null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 25.0),
                                    child: SizedBox(
                                      width: 200,
                                      height: 48,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              const Color.fromRGBO(
                                                  44, 96, 154, 1),
                                            ),
                                          ),
                                          onPressed: save,
                                          child: Text(
                                            'Add Details',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color: Color.fromRGBO(
                                                    255, 254, 254, 1),
                                              ),
                                            ),
                                          )),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 25.0),
                                    child: SizedBox(
                                      width: 200,
                                      height: 48,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              const Color.fromRGBO(
                                                  44, 96, 154, 1),
                                            ),
                                          ),
                                          onPressed: updateData,
                                          child: Text(
                                            'Update Details',
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color: Color.fromRGBO(
                                                    255, 254, 254, 1),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                            const SizedBox(
                              width: 42,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 200,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromRGBO(44, 96, 154, 1),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: ProjectStyles.cancelStyle(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // update == false
                      //     ? Padding(
                      //         padding: const EdgeInsets.only(top: 25.0),
                      //         child: ElevatedButton(
                      //             onPressed: save, child: const Text('Save')),
                      //       )
                      //     : Padding(
                      //         padding: const EdgeInsets.only(top: 25.0),
                      //         child: ElevatedButton(
                      //             onPressed: updateData,
                      //             child: const Text('update')),
                      //       )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
