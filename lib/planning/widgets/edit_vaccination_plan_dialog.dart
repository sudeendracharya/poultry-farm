import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/activity_plan_apis.dart';

class EditVaccinationPlanDialog extends StatefulWidget {
  EditVaccinationPlanDialog(
      {Key? key,
      required this.reFresh,
      required this.recommendedBy,
      required this.vaccinationPlan,
      required this.breedVersionId,
      required this.vaccinationId,
      required this.vaccinationCode})
      : super(key: key);

  final ValueChanged<int> reFresh;
  final String vaccinationId;
  final String recommendedBy;
  final List vaccinationPlan;
  final String breedVersionId;

  final String vaccinationCode;

  @override
  State<EditVaccinationPlanDialog> createState() =>
      _EditVaccinationPlanDialogState();
}

class _EditVaccinationPlanDialogState extends State<EditVaccinationPlanDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _singleActivityFormKey = GlobalKey();
  var activityPlanIdError = false;

  Map<String, dynamic> vaccinationPlanData = {
    'Vaccination_Id': '',
    'Recommended_By': '',
    'Vaccination_Plan': [],
    'Breed_Version_Id': '',
    'Description': '',
  };
  var vaccinationPlan = {
    'Age': '',
    'Vaccination_Name': null,
    'Mode': null,
    'Site': null,
    'Dosage': null,
    'Dosage_Unit': null,
    'Vaccine_Store_Temperature': null,
    'Notification_Prior_Days': null,
    'Description': '',
  };

  Map<String, dynamic> singleVaccinationPlan = {
    'Age': '',
    'Vaccination_Name': null,
    'Mode': null,
    'Site': null,
    'Dosage': null,
    'Dosage_Unit': null,
    'Vaccine_Store_Temperature': null,
    'Notification_Prior_Days': null,
    'Description': '',
  };

  var breedVersionId;
  bool fileSelected = false;
  String fileName = '';

  List breedVersion = [];

  List sendData = [];

  var _age;

  var _vaccination_Name;

  var _mode;

  var _site;

  Map<String, dynamic> _singlevaccinationPlanDetails = {};

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

  @override
  void initState() {
    clearActivityPlanException(context);

    breedVersionId = widget.breedVersionId;

    if (widget.vaccinationPlan.length == 1) {
      ageController.text = widget.vaccinationPlan[0]['Age'].toString();
      modeController.text = widget.vaccinationPlan[0]['Mode'];
      siteController.text = widget.vaccinationPlan[0]['Site'];
      dosageController.text = widget.vaccinationPlan[0]['Dosage'].toString();
      dosageUnitController.text =
          widget.vaccinationPlan[0]['Dosage_Unit'].toString();
      vaccinationDescriptionController.text =
          widget.vaccinationPlan[0]['Description'];
      vaccinationNameController.text =
          widget.vaccinationPlan[0]['Vaccination_Name'];
      notificationPriorController.text =
          widget.vaccinationPlan[0]['Notification_Prior_Days'];
      vaccineStoreTemperatureController.text =
          widget.vaccinationPlan[0]['Vaccine_Store_Temperature'].toString();
    }
    recommendedByController.text = widget.recommendedBy;

    vaccinationCodeController.text = widget.vaccinationCode.toString();
    vaccinationPlanData['Vaccination_Id'] = widget.vaccinationId.toString();
    vaccinationPlanData['Breed_Version_Id'] = widget.breedVersionId;
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<ActivityApis>(context, listen: false)
            .getBreedDetails(token);
      }
    });

    if (widget.vaccinationPlan.length == 1) {
      _singlevaccinationPlanDetails = widget.vaccinationPlan[0];
    }

    super.initState();
  }

  Future<void> getExcelFile() async {
    await FilePicker.platform
        .pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    )
        .then((value) {
      if (value != null) {
        // print('object1');
        fileName = value.files.single.name;
        var excel = Excel.decodeBytes(value.files.single.bytes!);

        List names = [
          'Age',
          'Vaccination_Name',
          'Mode',
          'Site',
          'Dosage',
          'Dosage_Unit',
          'Vaccine_Store_Temperature',
          'Notification_Prior_Days',
          'Description',
        ];

        for (var table in excel.tables.keys) {
          for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
            Map temp = {
              'Age': '',
              'Vaccination_Name': null,
              'Mode': null,
              'Site': null,
              'Dosage': null,
              'Dosage_Unit': null,
              'Vaccine_Store_Temperature': null,
              'Notification_Prior_Days': null,
              'Description': '',
            };
            List tempList = [];
            // print(excel.tables[table]!.rows[i].length.toString());

            for (int j = 0; j < excel.tables[table]!.rows[i].length; j++) {
              temp[names[j]] = excel.tables[table]!.rows[i][j] == null
                  ? ''
                  : excel.tables[table]!.rows[i][j]!.value;
              tempList.add(excel.tables[table]!.rows[i][j] == null
                  ? ''
                  : excel.tables[table]!.rows[i][j]!.value);
            }
            sendData.add(temp);
          }
        }

        for (int i = 0; i < sendData.length; i++) {
          if (sendData[i]['Age'] == '' ||
              sendData[i]['Age'] == null ||
              sendData[i]['Vaccination_Name'] == '' ||
              sendData[i]['Vaccination_Name'] == null ||
              sendData[i]['Mode'] == '' ||
              sendData[i]['Mode'] == null ||
              sendData[i]['Site'] == '' ||
              sendData[i]['Site'] == null ||
              sendData[i]['Dosage'] == '' ||
              sendData[i]['Dosage'] == null ||
              sendData[i]['Dosage_Unit'] == '' ||
              sendData[i]['Dosage_Unit'] == null ||
              sendData[i]['Vaccine_Store_Temperature'] == '' ||
              sendData[i]['Vaccine_Store_Temperature'] == null ||
              sendData[i]['Notification_Prior_Days'] == '' ||
              sendData[i]['Notification_Prior_Days'] == null ||
              sendData[i]['Description'] == '' ||
              sendData[i]['Description'] == null) {
            Get.dialog(
              AlertDialog(
                  title: const Text(
                    'Alert',
                    style: TextStyle(color: Colors.black),
                  ),
                  content: const Text(
                    'one or more rows contains null value',
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('ok'))
                  ]),
            );

            return;
          }
        }

        setState(() {});
      }
    });
  }

  TextEditingController vaccinationCodeController = TextEditingController();
  TextEditingController recommendedByController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController vaccinationNameController = TextEditingController();
  TextEditingController modeController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController dosageUnitController = TextEditingController();
  TextEditingController vaccineStoreTemperatureController =
      TextEditingController();
  TextEditingController notificationPriorController = TextEditingController();
  TextEditingController vaccinationDescriptionController =
      TextEditingController();

  bool vaccinationCodeValidation = true;
  bool recommendedByValidation = true;
  bool breedVersionValidation = true;
  bool ageValidation = true;
  bool vaccinationNameValidation = true;
  bool modeValidation = true;
  bool siteValidation = true;
  bool dosageValidation = true;
  bool dosageUnitValidation = true;
  bool vaccineStoreTemperatureValidation = true;
  bool notificationPriorValidation = true;
  bool vaccinationDescriptionValidation = true;

  String vaccinationCodeValidationMessage = '';
  String recommendedByValidationMessage = '';
  String breedVersionValidationMessage = '';
  String ageValidationMessage = '';
  String vaccinationNameValidationMessage = '';
  String modeValidationMessage = '';
  String siteValidationMessage = '';
  String dosageValidationMessage = '';
  String dosageUnitValidationMessage = '';
  String vaccineStoreTemperatureValidationMessage = '';
  String notificationPriorValidationMessage = '';
  String vaccinationDescriptionValidationMessage = '';

  bool validate() {
    if (vaccinationCodeController.text == '') {
      vaccinationCodeValidationMessage = 'Vaccination code cannot be empty';
      vaccinationCodeValidation = false;
    } else if (vaccinationCodeController.text.length > 9) {
      vaccinationCodeValidationMessage =
          'Vaccination code cannot be greater then 9 characters';
      vaccinationCodeValidation = false;
    } else {
      vaccinationCodeValidation = true;
    }
    if (recommendedByController.text == '') {
      recommendedByValidationMessage = 'Recommended by cannot be empty';
      recommendedByValidation = false;
    } else {
      recommendedByValidation = true;
    }
    if (breedVersionId == null) {
      breedVersionValidationMessage = 'Breed version cannot be empty';
      breedVersionValidation = false;
    } else {
      breedVersionValidation = true;
    }

    if (sendData.isEmpty) {
      if (ageController.text.isNum != true) {
        ageValidationMessage = 'Enter a valid age';
        ageValidation = false;
      } else if (ageController.text == '') {
        ageValidationMessage = 'Age cannot be empty';
        ageValidation = false;
      } else if (ageController.text.length > 6) {
        ageValidationMessage = 'Age Cannot be greater then 6 characters';
        ageValidation = false;
      } else {
        ageValidation = true;
      }
      if (vaccinationNameController.text == '') {
        vaccinationNameValidationMessage = 'Vaccination name cannot be empty';
        vaccinationNameValidation = false;
      } else if (vaccinationNameController.text.length > 12) {
        vaccinationNameValidationMessage =
            'Vaccination name cannot be greater then 12 characters';
        vaccinationNameValidation = false;
      } else {
        vaccinationNameValidation = true;
      }
      if (modeController.text == '') {
        modeValidationMessage = 'Mode of administration cannot be empty';
        modeValidation = false;
      } else {
        modeValidation = true;
      }
      if (siteController.text == '') {
        siteValidationMessage = 'Site of administration cannot be empty';
        siteValidation = false;
      } else {
        siteValidation = true;
      }
      if (dosageController.text.isNum != true) {
        dosageValidationMessage = 'Enter a Valid Dosage per bird';
        dosageValidation = false;
      } else if (dosageController.text == '') {
        dosageValidationMessage = 'Dosage per bird cannot be empty';
        dosageValidation = false;
      } else {
        dosageValidation = true;
      }
      if (dosageUnitController.text.isNotEmpty != true) {
        dosageUnitValidationMessage = 'Enter a valid Dosage unit';
        dosageUnitValidation = false;
      } else if (dosageUnitController.text == '') {
        dosageUnitValidationMessage = 'Dosage unit cannot be empty';
        dosageUnitValidation = false;
      } else {
        dosageUnitValidation = true;
      }
      if (vaccineStoreTemperatureController.text == '') {
        vaccineStoreTemperatureValidationMessage =
            'Vaccination store temperature cannot be empty';
        vaccineStoreTemperatureValidation = false;
      } else {
        vaccineStoreTemperatureValidation = true;
      }

      if (notificationPriorController.text.isNum != true) {
        notificationPriorValidationMessage =
            'Enter a valid Notification Prior to days ';
        notificationPriorValidation = false;
      } else if (notificationPriorController.text.length > 2) {
        notificationPriorValidationMessage =
            'Notification Prior to days cannot be greater then 2 characters ';
        notificationPriorValidation = false;
      } else if (notificationPriorController.text == '') {
        notificationPriorValidationMessage =
            'Notification Prior to days cannot be empty';
        notificationPriorValidation = false;
      } else {
        notificationPriorValidation = true;
      }

      if (vaccinationDescriptionController.text == '') {
        vaccinationDescriptionValidation = false;
        vaccinationDescriptionValidationMessage = 'Description cannot be empty';
      } else if (vaccinationDescriptionController.text.length > 30) {
        vaccinationDescriptionValidation = false;
        vaccinationDescriptionValidationMessage =
            'Description cannot contain more then 30 characters';
      } else {
        vaccinationDescriptionValidation = true;
      }

      if (vaccinationCodeValidation == true &&
          recommendedByValidation == true &&
          breedVersionValidation == true &&
          ageValidation == true &&
          vaccinationNameValidation == true &&
          modeValidation == true &&
          siteValidation == true &&
          dosageValidation == true &&
          dosageUnitValidation == true &&
          vaccineStoreTemperatureValidation == true &&
          notificationPriorValidation == true &&
          vaccinationDescriptionValidation == true) {
        return true;
      } else {
        return false;
      }
    } else {
      if (vaccinationCodeValidation == true &&
          recommendedByValidation == true &&
          breedVersionValidation == true) {
        return true;
      } else {
        return false;
      }
    }
  }

  void save() {
    bool validateData = validate();

    if (validateData != true) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();

    if (sendData.isEmpty) {
      bool validate = _singleActivityFormKey.currentState!.validate();
      if (validate != true) {
        return;
      }
      _singleActivityFormKey.currentState!.save();
      sendData.add(singleVaccinationPlan);
    }
    vaccinationPlanData['Vaccination_Plan'] = sendData;

    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<ActivityApis>(context, listen: false)
            .updateVaccinationPlanData(
          vaccinationPlanData,
          token,
          widget.vaccinationId,
        )
            .then((value) {
          if (value == 202 || value == 200) {
            widget.reFresh(100);
            Get.back();

            successSnackbar('Successfully added Vaccination Plan');
          } else {
            failureSnackbar('Something Went Wrong');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    breedVersion = Provider.of<ActivityApis>(context).breedReferenceList;
    if (breedVersion.isNotEmpty) {
      for (var data in breedVersion) {
        if (data['Breed_Version_Id'] == widget.breedVersionId) {
          breedVersionId = data['Breed_Version'];
        }
      }
    }
    return Container(
      width: size.width * 0.3,
      height: size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      child: Drawer(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Vaccination Planning',
                        style: ProjectStyles.formFieldsHeadingStyle(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: size.width * 0.25,
                            padding: const EdgeInsets.only(bottom: 12),
                            child: const Text('Vaccination Code'),
                          ),
                          Container(
                            width: size.width * 0.25,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(
                                  color: activityPlanIdError == false
                                      ? Colors.black26
                                      : const Color.fromRGBO(243, 60, 60, 1)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: activityPlanIdError == false
                                        ? 'Enter Vaccination Code'
                                        : '',
                                    border: InputBorder.none),
                                controller: vaccinationCodeController,
                                onSaved: (value) {
                                  vaccinationPlanData['Vaccination_Code'] =
                                      value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  vaccinationCodeValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, vaccinationCodeValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: size.width * 0.25,
                            padding: const EdgeInsets.only(bottom: 12),
                            child: const Text('Recommended By'),
                          ),
                          Container(
                            width: size.width * 0.25,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(
                                  color: activityPlanIdError == false
                                      ? Colors.black26
                                      : const Color.fromRGBO(243, 60, 60, 1)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    hintText: activityPlanIdError == false
                                        ? 'Enter Recommended By'
                                        : '',
                                    border: InputBorder.none),
                                controller: recommendedByController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // showError('FirmCode');
                                    return '';
                                  }
                                },
                                onSaved: (value) {
                                  vaccinationPlanData['Recommended_By'] =
                                      value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  recommendedByValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, recommendedByValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: size.width * 0.25,
                            child: const Text('Relevant Breed Information'),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: size.width * 0.25,
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
                                  value: breedVersionId,
                                  items: breedVersion
                                      .map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      value: e['Breed_Version'].toString(),
                                      onTap: () {
                                        vaccinationPlanData[
                                                'Breed_Version_Id'] =
                                            e['Breed_Version_Id'];
                                      },
                                      child:
                                          Text(e['Breed_Version'].toString()),
                                    );
                                  }).toList(),
                                  hint: const Text(
                                      'Choose Relevant breed version'),
                                  onChanged: (value) {
                                    setState(() {
                                      breedVersionId = value as String;
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
                  breedVersionValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, breedVersionValidationMessage),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Align(
                  //     alignment: Alignment.topLeft,
                  //     child: Column(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Container(
                  //           width: size.width * 0.25,
                  //           padding: const EdgeInsets.only(bottom: 12),
                  //           child: const Text('Description'),
                  //         ),
                  //         Container(
                  //           width: size.width * 0.25,
                  //           height: 36,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(8),
                  //             color: Colors.white,
                  //             border: Border.all(
                  //                 color: activityPlanIdError == false
                  //                     ? Colors.black26
                  //                     : const Color.fromRGBO(243, 60, 60, 1)),
                  //           ),
                  //           child: Padding(
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 12, vertical: 6),
                  //             child: TextFormField(
                  //               decoration: InputDecoration(
                  //                   hintText: activityPlanIdError == false
                  //                       ? 'Enter description'
                  //                       : '',
                  //                   border: InputBorder.none),
                  //               initialValue: widget.description,
                  //               validator: (value) {
                  //                 if (value!.isEmpty) {
                  //                   // showError('FirmCode');
                  //                   return '';
                  //                 }
                  //               },
                  //               onSaved: (value) {
                  //                 vaccinationPlanData['Description'] = value!;
                  //               },
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 36,
                  // ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Vaccination Plan Information',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Text(
                        'Upload the document(xlsx)',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      const SizedBox(
                        width: 11,
                      ),
                      GestureDetector(
                        onTap: () {
                          getExcelFile();
                        },
                        child: Icon(
                          Icons.cloud_upload_outlined,
                          color: ProjectColors.themecolor,
                        ),
                      ),
                      const SizedBox(
                        width: 11,
                      ),
                      fileName != ''
                          ? Text(fileName.toString())
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'OR',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Form(
                    key: _singleActivityFormKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: size.width * 0.25,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Primarily Age in Days'),
                                ),
                                Container(
                                  width: size.width * 0.25,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: activityPlanIdError == false
                                            ? Colors.black26
                                            : const Color.fromRGBO(
                                                243, 60, 60, 1)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter primarily age in days'
                                              : '',
                                          border: InputBorder.none),
                                      controller: ageController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleVaccinationPlan['Age'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ageValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size,
                                ageValidationMessage,
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: size.width * 0.25,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Vaccination Name'),
                                ),
                                Container(
                                  width: size.width * 0.25,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: activityPlanIdError == false
                                            ? Colors.black26
                                            : const Color.fromRGBO(
                                                243, 60, 60, 1)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter vaccination name'
                                              : '',
                                          border: InputBorder.none),
                                      controller: vaccinationNameController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleVaccinationPlan[
                                            'Vaccination_Name'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        vaccinationNameValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, vaccinationNameValidationMessage),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: size.width * 0.25,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Mode of Administration'),
                                ),
                                Container(
                                  width: size.width * 0.25,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: activityPlanIdError == false
                                            ? Colors.black26
                                            : const Color.fromRGBO(
                                                243, 60, 60, 1)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter mode of administration'
                                              : '',
                                          border: InputBorder.none),
                                      controller: modeController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleVaccinationPlan['Mode'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        modeValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, modeValidationMessage),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: size.width * 0.25,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Site of Administration'),
                                ),
                                Container(
                                  width: size.width * 0.25,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: activityPlanIdError == false
                                            ? Colors.black26
                                            : const Color.fromRGBO(
                                                243, 60, 60, 1)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter Site of administration'
                                              : '',
                                          border: InputBorder.none),
                                      controller: siteController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleVaccinationPlan['Site'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        siteValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, siteValidationMessage),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: size.width * 0.25,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Dosage per Bird'),
                                ),
                                Container(
                                  width: size.width * 0.25,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: activityPlanIdError == false
                                            ? Colors.black26
                                            : const Color.fromRGBO(
                                                243, 60, 60, 1)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter dosage per bird'
                                              : '',
                                          border: InputBorder.none),
                                      controller: dosageController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleVaccinationPlan['Dosage'] =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        dosageValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, dosageValidationMessage),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: size.width * 0.25,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Dosage unit'),
                                ),
                                Container(
                                  width: size.width * 0.25,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: activityPlanIdError == false
                                            ? Colors.black26
                                            : const Color.fromRGBO(
                                                243, 60, 60, 1)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter Dosage unit'
                                              : '',
                                          border: InputBorder.none),
                                      controller: dosageUnitController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleVaccinationPlan['Dosage_Unit'] =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        dosageUnitValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, dosageUnitValidationMessage),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: size.width * 0.25,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text(
                                      'Vaccination Storage Temperature'),
                                ),
                                Container(
                                  width: size.width * 0.25,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: activityPlanIdError == false
                                            ? Colors.black26
                                            : const Color.fromRGBO(
                                                243, 60, 60, 1)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter vaccination storage temperature'
                                              : '',
                                          border: InputBorder.none),
                                      controller:
                                          vaccineStoreTemperatureController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleVaccinationPlan[
                                                'Vaccine_Store_Temperature'] =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        vaccineStoreTemperatureValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, vaccineStoreTemperatureValidationMessage),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: size.width * 0.25,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text('Description'),
                                ),
                                Container(
                                  width: size.width * 0.25,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: activityPlanIdError == false
                                            ? Colors.black26
                                            : const Color.fromRGBO(
                                                243, 60, 60, 1)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter description'
                                              : '',
                                          border: InputBorder.none),
                                      controller:
                                          vaccinationDescriptionController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleVaccinationPlan['Descripption'] =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        vaccinationDescriptionValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, vaccinationDescriptionValidationMessage),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: size.width * 0.25,
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: const Text(
                                      'Notification Prior to Vaccine'),
                                ),
                                Container(
                                  width: size.width * 0.25,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: activityPlanIdError == false
                                            ? Colors.black26
                                            : const Color.fromRGBO(
                                                243, 60, 60, 1)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter notification prior to vaccine'
                                              : '',
                                          border: InputBorder.none),
                                      controller: notificationPriorController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleVaccinationPlan[
                                            'Notification_Prior_Days'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        notificationPriorValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, notificationPriorValidationMessage),
                        Consumer<ActivityApis>(
                            builder: (context, value, child) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.activityPlanException.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ModularWidgets.exceptionDesign(
                                  MediaQuery.of(context).size,
                                  value.activityPlanException[index]);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: SizedBox(
                            width: size.width * 0.1,
                            height: 48,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(44, 96, 154, 1),
                                  ),
                                ),
                                onPressed: save,
                                child: Text(
                                  'Update Details',
                                  style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Color.fromRGBO(255, 254, 254, 1),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 42,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: size.width * 0.1,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
