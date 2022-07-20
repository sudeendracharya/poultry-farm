import 'dart:math';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/admin/providers/admin_apis.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:poultry_login_signup/widgets/modular_widgets.dart';

import 'package:provider/provider.dart';

import '../../admin/widgets/add_permissions_dialog.dart';
import '../../admin/widgets/add_user_roles.dart';

class AddFirmDetailsDialog extends StatefulWidget {
  AddFirmDetailsDialog({
    Key? key,
    this.email,
    this.firmAlternateContactNumber,
    this.firmCode,
    this.firmContactNumber,
    this.firmName,
    this.pan,
    this.firmId,
    this.update,
    required this.reFresh,
  }) : super(key: key);
  var update;
  var firmId;
  var firmCode;
  var firmName;
  var email;
  var pan;
  var firmContactNumber;
  var firmAlternateContactNumber;

  final ValueChanged<int> reFresh;

  @override
  _AddFirmDetailsDialogState createState() => _AddFirmDetailsDialogState();
}

class _AddFirmDetailsDialogState extends State<AddFirmDetailsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _plantFormKey = GlobalKey();
  final GlobalKey<FormState> _userPermissionKey = GlobalKey();
  final GlobalKey<FormState> _userFormKey = GlobalKey();

  var update = false;
  var _firmId;
  var _firmCode;
  var _firmName;
  var _plantCode;
  var _plantName;
  var validationError = false;
  bool firmCodeError = false;
  bool firmNameError = false;
  bool emailError = false;
  bool panError = false;
  bool contactNumberError = false;
  bool alternateContactNumberError = false;

  var errorTitle;
  var errorMessage;

  int index = 0;

  var _selected = true;

  var batchPermissionValue;

  List batchPermissionList = ['Read', 'Write', 'Update', 'Delete'];
  List eggsPermissionList = ['Read', 'Write', 'Update', 'Delete'];
  List mortalityPermissionList = ['Read', 'Write', 'Update', 'Delete'];
  List gradingPermissionList = ['Read', 'Write', 'Update', 'Delete'];
  List module5List = ['Read', 'Write', 'Update', 'Delete'];

  var module5Value;

  var gradingPermissionValue;

  var mortalityPermissionValue;

  var eggsPermissionValue;

  var roleId;

  List roleList = [];
  String plantErrorTitle = '';

  String plantErrorMessage = '';

  bool plantCodeError = false;

  bool plantNameError = false;

  bool address1 = false;

  bool address2 = false;

  bool district = false;

  bool taluk = false;

  bool state = false;

  bool pincode = false;

  List _firmException = [];

  TextEditingController firmCodeController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController firmContactNumberController = TextEditingController();
  TextEditingController firmAlternateContactNumberController =
      TextEditingController();
  TextEditingController plantCodeController = TextEditingController();
  TextEditingController plantNameController = TextEditingController();
  TextEditingController plantPincodeController = TextEditingController();
  TextEditingController plantAddresController = TextEditingController();
  String plantCodeValidationMessage = '';
  String plantNameValidationMessage = '';
  String plantAddressValidationMessage = '';
  String plantTalukValidationMessage = '';
  String plantDistrictValidationMessage = '';
  String plantStateValidationMessage = '';
  String plantPincodeValidationMessage = '';

  bool plantCodeValidation = true;
  bool plantNameValidation = true;
  bool plantAddressValidation = true;
  bool plantTalukValidation = true;
  bool plantDistrictValidation = true;
  bool plantStateValidation = true;
  bool plantPincodeValidation = true;

  String firmCodeValidationMessage = '';
  String firmNameValidationMessage = '';
  String emailIdValidationMessage = '';
  String panValidationMessage = '';
  String firmContactNumberValidationMessage = '';
  String firmAlternateContactNumberValidationMessage = '';

  bool firmCodeValidation = true;
  bool firmNameValidation = true;
  bool emailIdValidation = true;
  bool panValidation = true;
  bool firmContactNumberValidation = true;
  bool firmAlternateContactNumberValidation = true;
  bool firmNameLengthError = false;

  String? countryValue;

  String? stateValue;

  String? cityValue;

  bool plantCountryValidation = true;

  String plantCountryValidationMessage = '';

  bool validate() {
    if (firmCodeController.text == '') {
      firmCodeValidationMessage = 'Firm Code Cannot Be Empty';
      firmCodeValidation = false;
    } else {
      firmCodeValidation = true;
    }

    // if (firmNameController.text == '') {
    //   firmNameValidationMessage = 'Firm Name Cannot Be Empty';
    //   firmNameValidation = false;
    // } else {
    //   firmNameValidation = true;
    // }

    if (firmNameController.text.length > 30) {
      firmNameValidationMessage =
          'Firm Name Cannot Be Greater Than 30 Characters';
      firmNameValidation = false;
    } else if (firmNameController.text == '') {
      firmNameValidationMessage = 'Firm Name Cannot Be Empty';
      firmNameValidation = false;
    } else {
      firmNameValidation = true;
    }
    // if (emailIdController.text == '') {
    //   emailIdValidationMessage = 'Email Id Cannot Be Empty';
    //   emailIdValidation = false;
    // } else {
    //   emailIdValidation = true;
    // }

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailIdController.text);
    if (emailValid != true) {
      emailIdValidationMessage = 'Provide A Valid Email Address';
      emailIdValidation = false;
    } else if (emailIdController.text == '') {
      emailIdValidationMessage = 'Email Id Cannot Be Empty';
      emailIdValidation = false;
    } else {
      emailIdValidation = true;
    }
    if (panController.text != '') {
      bool panValid =
          RegExp(r"^[A-Z]+[0-9]+[A-Z]").hasMatch(panController.text);
      if (!panValid) {
        panValidationMessage = 'Enter a valid Pan Card';
        panValidation = false;
      } else if (panController.text.length != 10) {
        panValidationMessage = 'Enter a valid Pan Card';
        panValidation = false;
      } else {
        panValidation = true;
      }
    } else {
      panValidation = true;
    }

    if (firmContactNumberController.text == '') {
      firmContactNumberValidationMessage = 'Contact Number Cannot Be Empty';
      firmContactNumberValidation = false;
    } else if (firmContactNumberController.text.length != 10) {
      firmContactNumberValidationMessage =
          'This field should contain 10 characters';
      firmContactNumberValidation = false;
    } else {
      firmContactNumberValidation = true;
    }
    if (firmAlternateContactNumberController.text != '') {
      if (firmAlternateContactNumberController.text.length != 10) {
        firmAlternateContactNumberValidationMessage =
            'This field should contain 10 characters.';
        firmAlternateContactNumberValidation = false;
      } else {
        firmAlternateContactNumberValidation = true;
      }
    } else {
      firmAlternateContactNumberValidation = true;
    }

    if (firmCodeValidation == true &&
        firmNameValidation == true &&
        emailIdValidation == true &&
        panValidation == true &&
        firmContactNumberValidation == true &&
        firmAlternateContactNumberValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  @override
  void initState() {
    firmCodeController.text = getRandom(4, 'Firm-');
    plantCodeController.text = getRandom(4, 'Plant-');

    // firmCodeController.text = getRandom(4);
    // Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   Provider.of<AdminApis>(context, listen: false).getUserRoles(token);
    // });
    super.initState();
  }

  void getUserRoles(int data) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<AdminApis>(context, listen: false).getUserRoles(token);
    });
  }

  var firmData = {
    'Firm_Code': '',
    'Firm_Name': '',
    'Email_Id': '',
    'Permanent_Account_Number': '',
    'Firm_Contact_Number': '',
    'Firm_Alternate_Contact_Number': '',
  };

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

  var user = {
    'User_Name': '',
    'User_Phone_Number': '',
    'User_Role_Name': '',
    'User_Email': '',
    'User_Permissions': ''
  };

  void getData(int index) {}

  void save() {
    var isValid = validate();
    if (!isValid) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .addFirmDetails(firmData, token)
          .then((value) {
        if (value['StatusCode'] == 200 || value['StatusCode'] == 201) {
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            message: 'Successfully Added Firm Details',
            title: 'Success',
          ));
          _formKey.currentState!.reset();
          // Provider.of<InfrastructureApis>(context, listen: false)
          //     .getFirmDetails(token);

          _firmId = value['FirmId'];
          _firmCode = value['FirmCode'];
          _firmName = value['FirmName'];
          if (index <= 0) {
            setState(() {
              index += 1;
            });
          }
          widget.reFresh(100);
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

    if (countryValue == null) {
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

  Future<void> savePlantData() async {
    var isValid = validatePlantData();
    if (!isValid) {
      setState(() {});
      return;
    }
    _plantFormKey.currentState!.save();

    plantDetails['Plant_District'] = cityValue ?? '';
    plantDetails['Plant_Country'] = countryValue ?? '';
    plantDetails['Plant_State'] = stateValue ?? '';

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .addPlantDetails(plantDetails, _firmId, token)
            .then((value) {
          if (value['StatusCode'] == 200 || value['StatusCode'] == 201) {
            // _plantCode = value['PlantCode'];
            // _plantName = value['PlantName'];
            Get.back();
            Get.showSnackbar(GetSnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: Theme.of(context).backgroundColor,
              message: 'Successfully Added Plant Details',
              title: 'Success',
            ));

            // if (index >= 0) {
            //   setState(() {
            //     index += 1;
            //   });
            // }

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
      print(e);
    }
  }

  void updateData() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .editFirmDetails(firmData, widget.firmId, token)
          .then((value) {
        if (value == 202 || value == 201) {
          widget.reFresh(100);
          Get.back();
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            message: 'Successfully Edited Firm Details',
            title: 'Success',
          ));

          // _formKey.currentState!.setState(() {

          // });
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
  }

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

  @override
  Widget build(BuildContext context) {
    roleList = Provider.of<AdminApis>(context).userRoles;
    _firmException =
        Provider.of<InfrastructureApis>(context, listen: false).firmException;
    return Container(
      width: 550,
      height: MediaQuery.of(context).size.height,
      // padding: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      child: Drawer(
        child: Theme(
          data: ThemeData(
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(primary: const Color.fromRGBO(44, 95, 154, 1)),
          ),
          child: Stepper(
              type: StepperType.horizontal,
              currentStep: index,
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: SizedBox(
                          width: 200,
                          height: 48,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(44, 96, 154, 1),
                                ),
                              ),
                              onPressed: details.onStepContinue,
                              child: update == false
                                  ? Text(
                                      'Add Details',
                                      style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(255, 254, 254, 1),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Update Details',
                                      style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(255, 254, 254, 1),
                                        ),
                                      ),
                                    )),
                        ),
                      ),
                      const SizedBox(
                        width: 42,
                      ),
                      GestureDetector(
                        onTap: details.onStepCancel,
                        child: Container(
                          width: 200,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromRGBO(44, 96, 154, 1),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                );
              },
              elevation: 0,
              onStepCancel: () {
                if (index > 0) {
                  setState(() {
                    index -= 1;
                  });
                }
              },
              onStepContinue: () {
                if (index >= 0) {
                  if (index == 0) {
                    save();
                  } else if (index == 1) {
                    savePlantData();
                  }
                }
              },
              onStepTapped: (int value) {
                setState(() {
                  index = value;
                });
              },
              steps: [
                Step(
                  isActive: _selected,
                  title: const SizedBox(),
                  content: addFirmDetails(context),
                ),
                Step(
                  isActive: index >= 1 ? true : false,
                  title: const SizedBox(),
                  content: addPlantDetails(context),
                ),
                // Step(
                //   isActive: index >= 2 ? true : false,
                //   title: const SizedBox(),
                //   content: addUserPermissions(context),
                // ),
                // Step(
                //   isActive: index >= 3 ? true : false,
                //   title: const SizedBox(),
                //   content: addUsers(context),
                // ),
              ]),
        ),
      ),
    );
  }

  SingleChildScrollView addFirmDetails(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Firm Details',
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
                  children: const [
                    Text(
                      'Add Firm',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
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
                        child: const Text('Firm Code:'),
                      ),
                      Container(
                        width: 440,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                              color: firmCodeError == false
                                  ? Colors.black26
                                  : const Color.fromRGBO(243, 60, 60, 1)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: TextFormField(
                            // controller: firmCodeController,
                            decoration: InputDecoration(
                                hintText: firmCodeError == false
                                    ? 'Enter Firm Code'
                                    : '',
                                border: InputBorder.none),
                            controller: firmCodeController,
                            // initialValue: widget.firmCode != null
                            //     ? widget.firmCode.toString()
                            //     : '',

                            onSaved: (value) {
                              firmData['Firm_Code'] = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              firmCodeValidation == true
                  ? const SizedBox()
                  : ModularWidgets.validationDesign(
                      size, firmCodeValidationMessage),
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
                        child: const Text('Firm Name:'),
                      ),
                      Container(
                        width: 440,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                            color: firmNameError == false
                                ? Colors.black26
                                : const Color.fromRGBO(243, 60, 60, 1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: firmNameError == false
                                    ? 'Enter Firm Name'
                                    : '',
                                border: InputBorder.none),
                            controller: firmNameController,
                            // initialValue: widget.firmName ?? '',
                            onSaved: (value) {
                              firmData['Firm_Name'] = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              firmNameValidation == true
                  ? const SizedBox()
                  : ModularWidgets.validationDesign(
                      size, firmNameValidationMessage),
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
                        child: const Text('Email ID:'),
                      ),
                      Container(
                        width: 440,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                            color: emailError == false
                                ? Colors.black26
                                : const Color.fromRGBO(243, 60, 60, 1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText:
                                    emailError == false ? 'Enter Email ID' : '',
                                border: InputBorder.none),
                            // initialValue: widget.email ?? '',
                            controller: emailIdController,
                            onSaved: (value) {
                              firmData['Email_Id'] = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              emailIdValidation == true
                  ? const SizedBox()
                  : ModularWidgets.validationDesign(
                      size, emailIdValidationMessage),
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
                        child: const Text('Permanent Account Number:'),
                      ),
                      Container(
                        width: 440,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                            color: panError == false
                                ? Colors.black26
                                : const Color.fromRGBO(243, 60, 60, 1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: panError == false
                                    ? 'Enter Permanent Account Number'
                                    : '',
                                border: InputBorder.none),
                            // initialValue: widget.pan ?? '',
                            controller: panController,
                            onSaved: (value) {
                              firmData['Permanent_Account_Number'] = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              panValidation == true
                  ? const SizedBox()
                  : ModularWidgets.validationDesign(size, panValidationMessage),
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
                        child: const Text('Firm Contact Number:'),
                      ),
                      Container(
                        width: 440,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                            color: contactNumberError == false
                                ? Colors.black26
                                : const Color.fromRGBO(243, 60, 60, 1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                hintText: contactNumberError == false
                                    ? 'Enter firm Contact Number'
                                    : '',
                                border: InputBorder.none),
                            // initialValue: widget.firmContactNumber ?? '',
                            controller: firmContactNumberController,
                            onSaved: (value) {
                              firmData['Firm_Contact_Number'] = value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              firmContactNumberValidation == true
                  ? const SizedBox()
                  : ModularWidgets.validationDesign(
                      size, firmContactNumberValidationMessage),
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
                        child: const Text('Firm Alternate Contact Number:'),
                      ),
                      Container(
                        width: 440,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(
                            color: alternateContactNumberError == false
                                ? Colors.black26
                                : const Color.fromRGBO(243, 60, 60, 1),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                hintText: alternateContactNumberError == false
                                    ? 'Enter Firm Alternate Contact Number:'
                                    : '',
                                border: InputBorder.none),
                            // initialValue:
                            //     widget.firmAlternateContactNumber ?? '',
                            controller: firmAlternateContactNumberController,
                            onSaved: (value) {
                              firmData['Firm_Alternate_Contact_Number'] =
                                  value!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              firmAlternateContactNumberValidation == true
                  ? const SizedBox()
                  : ModularWidgets.validationDesign(
                      size, firmAlternateContactNumberValidationMessage),
              validationError == false
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 24.0),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              errorTitle ?? '',
                                              style: GoogleFonts.roboto(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                      color: Color.fromRGBO(
                                                          68, 68, 68, 1))),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              errorMessage ?? '',
                                              style: GoogleFonts.roboto(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
                                                      color: Color.fromRGBO(
                                                          68, 68, 68, 1))),
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
                    ),
              Consumer<InfrastructureApis>(builder: (context, value, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.firmException.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ModularWidgets.exceptionDesign(
                        MediaQuery.of(context).size,
                        value.firmException[index][0]);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
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

  Form addPlantDetails(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Form(
      key: _plantFormKey,
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
                children: const [
                  Text(
                    'Add Plant',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
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
                                : const Color.fromRGBO(243, 60, 60, 1)),
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
                                : const Color.fromRGBO(243, 60, 60, 1)),
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
                                : const Color.fromRGBO(243, 60, 60, 1)),
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
                            plantDetails['Plant_Address_Line_1'] = value!;
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
                                : const Color.fromRGBO(243, 60, 60, 1)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: address2 == false
                                  ? 'Enter Plant Address'
                                  : '',
                              border: InputBorder.none),
                          onSaved: (value) {
                            plantDetails['Plant_Address_Line_2'] = value!;
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
            //                     : const Color.fromRGBO(243, 60, 60, 1)),
            //           ),
            //           child: Padding(
            //             padding: const EdgeInsets.symmetric(
            //                 horizontal: 12, vertical: 6),
            //             child: TextFormField(
            //               decoration: InputDecoration(
            //                   hintText:
            //                       taluk == false ? 'Enter Plant Taluk' : '',
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
            //           child: const Text('Plant District'),
            //         ),
            //         Container(
            //           width: 440,
            //           height: 36,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(8),
            //             color: Colors.white,
            //             border: Border.all(
            //                 color: district == false
            //                     ? Colors.black26
            //                     : const Color.fromRGBO(243, 60, 60, 1)),
            //           ),
            //           child: Padding(
            //             padding: const EdgeInsets.symmetric(
            //                 horizontal: 12, vertical: 6),
            //             child: TextFormField(
            //               decoration: InputDecoration(
            //                   hintText: district == false
            //                       ? 'Enter Plant District'
            //                       : '',
            //                   border: InputBorder.none),
            //               onSaved: (value) {
            //                 plantDetails['Plant_District'] = value!;
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
                        onCountryChanged: (value) {
                          setState(() {
                            ///store value in country variable
                            countryValue = value;
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

                    // Container(
                    //   width: 440,
                    //   padding: const EdgeInsets.only(bottom: 12),
                    //   child: const Text('Plant State'),
                    // ),
                    // Container(
                    //   width: 440,
                    //   height: 36,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(8),
                    //     color: Colors.white,
                    //     border: Border.all(
                    //         color: state == false
                    //             ? Colors.black26
                    //             : const Color.fromRGBO(243, 60, 60, 1)),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 12, vertical: 6),
                    //     child: TextFormField(
                    //       decoration: InputDecoration(
                    //           hintText:
                    //               state == false ? 'Enter Plant State' : '',
                    //           border: InputBorder.none),
                    //       onSaved: (value) {
                    //         plantDetails['Plant_State'] = value!;
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
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
                                : const Color.fromRGBO(243, 60, 60, 1)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText:
                                  pincode == false ? 'Enter Plant Pincode' : '',
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

            Consumer<InfrastructureApis>(builder: (context, value, child) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.plantException.length,
                itemBuilder: (BuildContext context, int index) {
                  return ModularWidgets.exceptionDesign(
                      MediaQuery.of(context).size,
                      value.plantException[index][0]);
                },
              );
            }),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 25.0),
            //         child: SizedBox(
            //           width: 200,
            //           height: 48,
            //           child: ElevatedButton(
            //               style: ButtonStyle(
            //                 backgroundColor: MaterialStateProperty.all(
            //                   const Color.fromRGBO(44, 96, 154, 1),
            //                 ),
            //               ),
            //               onPressed: save,
            //               child: Text(
            //                 'Add Details',
            //                 style: GoogleFonts.roboto(
            //                   textStyle: const TextStyle(
            //                     fontWeight: FontWeight.w500,
            //                     fontSize: 18,
            //                     color: Color.fromRGBO(255, 254, 254, 1),
            //                   ),
            //                 ),
            //               )),
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 42,
            //       ),
            //       GestureDetector(
            //         onTap: () {
            //           if (index > 0) {
            //             setState(() {
            //               index -= 1;
            //             });
            //           }
            //         },
            //         child: Container(
            //           width: 200,
            //           height: 48,
            //           alignment: Alignment.center,
            //           decoration: BoxDecoration(
            //             border: Border.all(
            //               color: const Color.fromRGBO(44, 96, 154, 1),
            //             ),
            //           ),
            //           child: const Text('Cancel'),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
    );
  }

  Padding addUserPermissions(BuildContext context) {
    double width = 300;
    TextStyle keyStyle() {
      return GoogleFonts.roboto(
          textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(68, 68, 68, 1)));
    }

    TextStyle valueStyle() {
      return GoogleFonts.roboto(
          textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(68, 68, 68, 1)));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _userPermissionKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Firm Id',
                      style: keyStyle(),
                    ),
                    Text(_firmCode ?? '')
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Firm Name',
                      style: keyStyle(),
                    ),
                    Text(_firmName ?? '')
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Plant Id',
                      style: keyStyle(),
                    ),
                    Text(_plantCode ?? '')
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Plant Name',
                      style: keyStyle(),
                    ),
                    Text(_plantName ?? '')
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                children: [
                  Text(
                    'User Permissions',
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 36)),
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
                      child: const Text('Permission'),
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
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Permission Name',
                              border: InputBorder.none),
                          validator: (value) {},
                          onSaved: (value) {
                            plantDetails['Plant_State'] = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Select the modules to give add under the <Permission_Name>  to give access',
                style: keyStyle(),
              ),
            ),
            Container(
                width: 440,
                padding: EdgeInsets.only(top: 37),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 220,
                          child: Text(
                            'Module',
                            style: keyStyle(),
                          ),
                        ),
                        SizedBox(
                          width: 220,
                          child: Text(
                            'Access',
                            style: keyStyle(),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220,
                            child: Text(
                              'Batch',
                              style: keyStyle(),
                            ),
                          ),
                          Container(
                            width: 220,
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
                                  value: batchPermissionValue,
                                  items: batchPermissionList
                                      .map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                      onTap: () {
                                        // wareHouseDetails['Plant_Id'] =
                                        //     e['Plant_Id'];
                                      },
                                    );
                                  }).toList(),
                                  hint: const Text('Choose Permission'),
                                  onChanged: (value) {
                                    setState(() {
                                      batchPermissionValue = value as String;
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
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220,
                            child: Text(
                              'Eggs',
                              style: keyStyle(),
                            ),
                          ),
                          Container(
                            width: 220,
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
                                  value: eggsPermissionValue,
                                  items: eggsPermissionList
                                      .map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                      onTap: () {
                                        // wareHouseDetails['Plant_Id'] =
                                        //     e['Plant_Id'];
                                      },
                                    );
                                  }).toList(),
                                  hint: const Text('Choose Permission'),
                                  onChanged: (value) {
                                    setState(() {
                                      eggsPermissionValue = value as String;
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
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220,
                            child: Text(
                              'Mortality',
                              style: keyStyle(),
                            ),
                          ),
                          Container(
                            width: 220,
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
                                  value: mortalityPermissionValue,
                                  items: mortalityPermissionList
                                      .map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                      onTap: () {
                                        // wareHouseDetails['Plant_Id'] =
                                        //     e['Plant_Id'];
                                      },
                                    );
                                  }).toList(),
                                  hint: const Text('Choose Permission'),
                                  onChanged: (value) {
                                    setState(() {
                                      mortalityPermissionValue =
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
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220,
                            child: Text(
                              'Grading',
                              style: keyStyle(),
                            ),
                          ),
                          Container(
                            width: 220,
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
                                  value: gradingPermissionValue,
                                  items: gradingPermissionList
                                      .map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                      onTap: () {
                                        // wareHouseDetails['Plant_Id'] =
                                        //     e['Plant_Id'];
                                      },
                                    );
                                  }).toList(),
                                  hint: const Text('Choose Permission'),
                                  onChanged: (value) {
                                    setState(() {
                                      gradingPermissionValue = value as String;
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
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220,
                            child: Text(
                              'Module 5',
                              style: keyStyle(),
                            ),
                          ),
                          Container(
                            width: 220,
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
                                  value: module5Value,
                                  items: module5List
                                      .map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                      onTap: () {
                                        // wareHouseDetails['Plant_Id'] =
                                        //     e['Plant_Id'];
                                      },
                                    );
                                  }).toList(),
                                  hint: const Text('Choose Permission'),
                                  onChanged: (value) {
                                    setState(() {
                                      module5Value = value as String;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Padding addUsers(BuildContext context) {
    double width = 300;
    TextStyle keyStyle() {
      return GoogleFonts.roboto(
          textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(68, 68, 68, 1)));
    }

    TextStyle valueStyle() {
      return GoogleFonts.roboto(
          textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(68, 68, 68, 1)));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _userFormKey,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Firm Id',
                      style: keyStyle(),
                    ),
                    Text(_firmCode ?? '')
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Firm Name',
                      style: keyStyle(),
                    ),
                    Text(_firmName ?? '')
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Plant Id',
                      style: keyStyle(),
                    ),
                    Text(_plantCode ?? '')
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Plant Name',
                      style: keyStyle(),
                    ),
                    Text(_plantName ?? '')
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Permissions',
                      style: keyStyle(),
                    ),
                    Text('')
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                children: [
                  Text(
                    'User Details',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 36),
                    ),
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
                      child: const Text('User Id'),
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
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Enter User Id',
                              border: InputBorder.none),
                          //initialValue: initValues['Plant_Code'],
                          validator: (value) {},
                          onSaved: (value) {
                            user['User_Id'] = value!;
                          },
                        ),
                      ),
                    ),
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
                      child: const Text('User Name'),
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
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Enter User Name',
                              border: InputBorder.none),
                          //initialValue: initValues['Plant_Code'],
                          validator: (value) {},
                          onSaved: (value) {
                            user['User_Name'] = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //  Padding(
            //         padding: const EdgeInsets.only(top: 24.0),
            //         child: Align(
            //           alignment: Alignment.topLeft,
            //           child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Container(
            //                 width: 440,
            //                 padding: const EdgeInsets.only(bottom: 12),
            //                 child: const Text('Firm Id'),
            //               ),
            //               Container(
            //                 width: 440,
            //                 height: 36,
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(8),
            //                   color: Colors.white,
            //                   border: Border.all(color: Colors.black26),
            //                 ),
            //                 child: Padding(
            //                   padding: const EdgeInsets.symmetric(
            //                       horizontal: 12, vertical: 6),
            //                   child: DropdownButtonHideUnderline(
            //                     child: DropdownButton(
            //                       value: firmName,
            //                       items: firmData
            //                           .map<DropdownMenuItem<String>>((e) {
            //                         return DropdownMenuItem(
            //                           child: Text(e['Firm_Name']),
            //                           value: e['Firm_Name'],
            //                           onTap: () {
            //                             // firmId = e['Firm_Code'];
            //                             plantDetails['Firm_Name'] =
            //                                 e['Firm_Name'].toString();
            //                             print(plantDetails['Firm_Name']);
            //                           },
            //                         );
            //                       }).toList(),
            //                       hint: const Text('Please Choose firm Id'),
            //                       onChanged: (value) {
            //                         setState(() {
            //                           firmName = value as String;
            //                         });
            //                       },
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
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
                      child: const Text('Phone Number'),
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
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Enter Phone Number',
                              border: InputBorder.none),
                          //initialValue: initValues['Plant_Code'],
                          validator: (value) {},
                          onSaved: (value) {
                            user['User_Phone_Number'] = value!;
                          },
                        ),
                      ),
                    ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('User Role'),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showGlobalDrawer(
                                      context: context,
                                      builder: (ctx) => AddUserRoles(
                                            reFresh: getUserRoles,
                                          ),
                                      direction: AxisDirection.right);
                                },
                                icon: const Icon(Icons.add),
                              ),
                              const Text('Add')
                            ],
                          ),
                        ],
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
                            value: roleId,
                            items: roleList.map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                child: Text(e['Role_Name']),
                                value: e['Role_Name'],
                                onTap: () {
                                  user['Role_Id'] = e['Role_Id'].toString();
                                },
                              );
                            }).toList(),
                            hint: const Text('Choose Role Name'),
                            onChanged: (value) {
                              setState(() {
                                roleId = value as String;
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
              padding: const EdgeInsets.only(top: 24.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 440,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text('User Email'),
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
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Enter Email Address',
                              border: InputBorder.none),
                          //initialValue: initValues['Plant_Code'],
                          validator: (value) {},
                          onSaved: (value) {
                            user['User_Email'] = value!;
                          },
                        ),
                      ),
                    ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('User Permission'),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) =>
                                            AddPermissionsDialog());
                                  },
                                  icon: const Icon(Icons.add)),
                              const Text('Add'),
                            ],
                          )
                        ],
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
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Enter USer Permission',
                              border: InputBorder.none),
                          //initialValue: initValues['Plant_Code'],
                          validator: (value) {},
                          onSaved: (value) {
                            user['User_Permissions'] = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //

            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 30.0),
            //         child: SizedBox(
            //           width: 200,
            //           height: 48,
            //           child: ElevatedButton(
            //               style: ButtonStyle(
            //                 backgroundColor: MaterialStateProperty.all(
            //                   const Color.fromRGBO(44, 96, 154, 1),
            //                 ),
            //               ),
            //               onPressed: save,
            //               child: Text(
            //                 'Add User',
            //                 style: GoogleFonts.roboto(
            //                   textStyle: const TextStyle(
            //                     fontWeight: FontWeight.w500,
            //                     fontSize: 18,
            //                     color: Color.fromRGBO(255, 254, 254, 1),
            //                   ),
            //                 ),
            //               )),
            //         ),
            //       ),
            //       const SizedBox(
            //         width: 42,
            //       ),
            //       GestureDetector(
            //         onTap: () {
            //           Navigator.of(context).pop();
            //         },
            //         child: Container(
            //           width: 200,
            //           height: 48,
            //           alignment: Alignment.center,
            //           decoration: BoxDecoration(
            //             border: Border.all(
            //               color: const Color.fromRGBO(44, 96, 154, 1),
            //             ),
            //           ),
            //           child: const Text('Cancel'),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
