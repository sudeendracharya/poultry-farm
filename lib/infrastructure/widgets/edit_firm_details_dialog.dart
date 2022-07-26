import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../widgets/modular_widgets.dart';

class EditFirmDetailsDialog extends StatefulWidget {
  EditFirmDetailsDialog(
      {Key? key,
      this.email,
      this.firmAlternateContactNumber,
      this.firmCode,
      this.firmContactNumber,
      this.firmId,
      this.firmName,
      this.pan,
      this.update,
      required this.reFresh})
      : super(key: key);
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
  _EditFirmDetailsDialogState createState() => _EditFirmDetailsDialogState();
}

class _EditFirmDetailsDialogState extends State<EditFirmDetailsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var validationError = false;
  bool firmCodeError = false;
  bool firmNameError = false;
  bool emailError = false;
  bool panError = false;
  bool contactNumberError = false;
  bool alternateContactNumberError = false;

  var errorTitle;
  var errorMessage;
  var firmData = {
    'Firm_Code': '',
    'Firm_Name': '',
    'Email_Id': '',
    'Permanent_Account_Number': '',
    'Firm_Contact_Number': '',
    'Firm_Alternate_Contact_Number': '',
  };

  TextEditingController firmCodeController = TextEditingController();
  TextEditingController firmNameController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController firmContactNumberController = TextEditingController();
  TextEditingController firmAlternateContactNumberController =
      TextEditingController();
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

  void showError(String error) {
    switch (error) {
      case 'FirmCode':
        setState(() {
          errorTitle = 'Firm Code';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          firmCodeError = true;
        });
        break;
      case 'FirmName':
        setState(() {
          errorTitle = 'Firm Name';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          firmNameError = true;
        });
        break;
      case 'EmailId':
        setState(() {
          errorTitle = 'Email Id';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          emailError = true;
        });
        break;
      case 'PAN':
        setState(() {
          errorTitle = 'PAN';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          panError = true;
        });
        break;
      case 'ContactNumber':
        setState(() {
          errorTitle = 'Contact Number';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          contactNumberError = true;
        });
        break;
      case 'AlternateContactNumber':
        setState(() {
          errorTitle = 'Alternate Contact Number';
          errorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          alternateContactNumberError = true;
        });
        break;
      default:
    }
  }

  @override
  void initState() {
    clearFirmException(context);
    firmCodeController.text = widget.firmCode.toString();
    firmNameController.text = widget.firmName;
    emailIdController.text = widget.email;
    panController.text = widget.pan;
    firmContactNumberController.text = widget.firmContactNumber.toString();
    firmAlternateContactNumberController.text =
        widget.firmAlternateContactNumber.toString();
    super.initState();
  }

  void updateData() {
    var isValid = validate();
    if (!isValid) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    // print(firmData);

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
                              'Update Firm',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18),
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
                                          : const Color.fromRGBO(
                                              243, 60, 60, 1)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: firmCodeError == false
                                            ? 'Enter Firm Code'
                                            : '',
                                        border: InputBorder.none),
                                    controller: firmCodeController,
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
                                        hintText: emailError == false
                                            ? 'Enter Email ID'
                                            : '',
                                        border: InputBorder.none),
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
                                    controller: panController,
                                    onSaved: (value) {
                                      firmData['Permanent_Account_Number'] =
                                          value!;
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
                          : ModularWidgets.validationDesign(
                              size, panValidationMessage),
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
                                    controller: firmContactNumberController,
                                    decoration: InputDecoration(
                                        hintText: contactNumberError == false
                                            ? 'Enter firm Contact Number'
                                            : '',
                                        border: InputBorder.none),
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
                                child: const Text(
                                    'Firm alternate Contact Number:'),
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
                                        hintText: alternateContactNumberError ==
                                                false
                                            ? 'Enter Firm Alternate Contact Number:'
                                            : '',
                                        border: InputBorder.none),
                                    controller:
                                        firmAlternateContactNumberController,
                                    onSaved: (value) {
                                      firmData[
                                              'Firm_Alternate_Contact_Number'] =
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
                          : ModularWidgets.validationDesign(size,
                              firmAlternateContactNumberValidationMessage),
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
                                        color: const Color.fromRGBO(
                                            255, 219, 219, 1),
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              255, 219, 219, 1),
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
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          68,
                                                                          68,
                                                                          68,
                                                                          1))),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      errorMessage ?? '',
                                                      style: GoogleFonts.roboto(
                                                          textStyle:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 12,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          68,
                                                                          68,
                                                                          68,
                                                                          1))),
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
                      Consumer<InfrastructureApis>(
                          builder: (context, value, child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: value.firmException.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ModularWidgets.exceptionDesign(
                                MediaQuery.of(context).size,
                                value.firmException[index]);
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
                                        vertical: 40.0),
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
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 74.0),
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
                                Get.back();
                                // Navigator.of(context).pop();
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
                                child: Text('Cancel'),
                              ),
                            ),
                          ],
                        ),
                      ),
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
