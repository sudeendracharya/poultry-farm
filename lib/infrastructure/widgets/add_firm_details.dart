import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';

import 'package:provider/provider.dart';

import '../../styles.dart';
import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';
import '../screens/firm_details_screen.dart';

class AddFirmDetails extends StatefulWidget {
  AddFirmDetails({Key? key}) : super(key: key);
  static const routeName = '/AddFirmDetails';

  @override
  _AddFirmDetailsState createState() => _AddFirmDetailsState();
}

class _AddFirmDetailsState extends State<AddFirmDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var update = false;
  var firmId;

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var firmData = {
    'Firm_Code': '',
    'Firm_Name': '',
    'Email_Id': '',
    'Permanent_Account_Number': '',
    'Firm_Contact_Number': '',
    'Firm_Alternate_Contact_Number': '',
  };
  var initValues = {
    'Firm_Code': '',
    'Firm_Name': '',
    'Email_Id': '',
    'Permanent_Account_Number': '',
    'Firm_Contact_Number': '',
    'Firm_Alternate_Contact_Number': '',
  };

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      var data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      update = true;
      firmId = data['Firm_Id'];
      initValues = {
        'Firm_Code': data['Firm_Code'],
        'Firm_Name': data['Firm_Name'],
        'Email_Id': data['Email_Id'],
        'Permanent_Account_Number': data['Permanent_Account_Number'],
        'Firm_Contact_Number': data['Firm_Contact_Number'],
        'Firm_Alternate_Contact_Number': data['Firm_Alternate_Contact_Number'],
      };
    }

    super.didChangeDependencies();
  }

  void save() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .addFirmDetails(firmData, token)
          .then((value) {
        if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
          showDialog(
            context: context,
            builder: (ctx) => SuccessDialog(
                title: 'Success', subTitle: 'SuccessFully Added Firm Details'),
          );
          _formKey.currentState!.reset();
        } else {
          showDialog(
            context: context,
            builder: (ctx) => FailureDialog(
                title: 'Failed',
                subTitle: 'Something Went Wrong Please Try Again'),
          );
        }
      });
    });
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
          .editFirmDetails(firmData, firmId, token)
          .then((value) {
        if (value == 200 || value == 201) {
          showDialog(
            context: context,
            builder: (ctx) => SuccessDialog(
                title: 'Success', subTitle: 'SuccessFully Added Firm Details'),
          );
          _formKey.currentState!.reset();
        } else {
          showDialog(
            context: context,
            builder: (ctx) => FailureDialog(
                title: 'Failed',
                subTitle: 'Something Went Wrong Please Try Again'),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.of(context).pushReplacementNamed(FirmDetailScreen.routeName);
        Get.offAndToNamed(FirmDetailScreen.routeName);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 85),
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
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Enter Firm Code',
                                      border: InputBorder.none),
                                  initialValue: initValues['Firm_Code'],
                                  validator: (value) {},
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
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Enter Firm Name',
                                      border: InputBorder.none),
                                  initialValue: initValues['Firm_Name'],
                                  validator: (value) {},
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
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Enter Email ID',
                                      border: InputBorder.none),
                                  initialValue: initValues['Email_Id'],
                                  validator: (value) {},
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
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText:
                                          'Enter Permanent Account Number',
                                      border: InputBorder.none),
                                  initialValue:
                                      initValues['Permanent_Account_Number'],
                                  validator: (value) {},
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
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Enter firm Contact Number',
                                      border: InputBorder.none),
                                  initialValue:
                                      initValues['Firm_Contact_Number'],
                                  validator: (value) {},
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
                              child:
                                  const Text('Firm alternate Contact Number:'),
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
                                      labelText:
                                          'Enter Firm Alternate Contact Number:',
                                      border: InputBorder.none),
                                  initialValue: initValues[
                                      'Firm_Alternate_Contact_Number'],
                                  validator: (value) {},
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          update == false
                              ? Padding(
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
                                          'Update',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
