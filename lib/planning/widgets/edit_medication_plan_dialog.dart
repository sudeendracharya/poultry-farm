import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/activity_plan_apis.dart';

class EditMedicationPlanDialog extends StatefulWidget {
  EditMedicationPlanDialog(
      {Key? key,
      required this.reFresh,
      required this.recommendedBy,
      required this.medicationPlan,
      required this.breedVersionId,
      required this.description,
      required this.medicationId,
      required this.medicationCode})
      : super(key: key);

  final ValueChanged<int> reFresh;
  final String recommendedBy;
  final List medicationPlan;
  final String breedVersionId;
  final String description;
  final String medicationId;
  final String medicationCode;

  @override
  State<EditMedicationPlanDialog> createState() =>
      _EditMedicationPlanDialogState();
}

class _EditMedicationPlanDialogState extends State<EditMedicationPlanDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _singleActivityFormKey = GlobalKey();
  var activityPlanIdError = false;

  Map<String, dynamic> medicationPlanData = {
    'Medication_Code': '',
    'Recommended_By': '',
    'Medication_Plan': [],
    'Breed_Version_Id': '',
    'Description': '',
  };
  var vaccinationPlan = {
    'Age': '',
    'Medication_Name': null,
    'Mode': null,
    'Site': null,
    'Dosage': '',
    'Dosage_Unit': '',
    'Notification_Prior_Days': null,
    'Description': null,
  };

  Map<String, dynamic> singleMedicationPlan = {
    'Age': '',
    'Medication_Name': null,
    'Mode': null,
    'Site': null,
    'Dosage': '',
    'Dosage_Unit': '',
    'Notification_Prior_Days': null,
    'Description': null,
  };

  var breedVersionId;
  bool fileSelected = false;
  String fileName = '';

  List breedVersion = [];

  List sendData = [];

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
    print(widget.medicationPlan);
    medicationCodeController.text = widget.medicationCode;
    recommendedByController.text = widget.recommendedBy;
    breedVersionId = widget.breedVersionId;
    if (widget.medicationPlan.length == 1) {
      ageController.text = widget.medicationPlan[0]['Age'].toString();
      modeController.text = widget.medicationPlan[0]['Mode'];
      siteController.text = widget.medicationPlan[0]['Site'];
      dosageController.text = widget.medicationPlan[0]['Dosage'].toString();
      medicationDescriptionController.text =
          widget.medicationPlan[0]['Description'];
      dosageUnitController.text =
          widget.medicationPlan[0]['Dosage_Unit'].toString();
      mediactionNameController.text =
          widget.medicationPlan[0]['Medication_Name'];
      notificationPriorController.text =
          widget.medicationPlan[0]['Notification_Prior_Days'].toString();
    }
    medicationPlanData['Breed_Version_Id'] = breedVersionId;
    medicationPlanData['Description'] = widget.description;
    medicationPlanData['Recommended_By'] = widget.recommendedBy;
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<ActivityApis>(context, listen: false)
            .getBreedDetails(token);
      }
    });

    super.initState();
  }

  TextEditingController medicationCodeController = TextEditingController();
  TextEditingController recommendedByController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mediactionNameController = TextEditingController();
  TextEditingController modeController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController dosageUnitController = TextEditingController();
  TextEditingController notificationPriorController = TextEditingController();
  TextEditingController medicationDescriptionController =
      TextEditingController();
  bool medicationCodeValidation = true;
  bool recommendedByValidation = true;
  bool breedVersionValidation = true;
  bool ageValidation = true;
  bool medicationNameValidation = true;
  bool modeValidation = true;
  bool siteValidation = true;
  bool dosageValidation = true;
  bool dosageUnitValidation = true;
  bool notificationPriorValidation = true;
  bool medicationDescriptionValidation = true;

  String medicationCodeValidationMessage = '';
  String recommendedByValidationMessage = '';
  String breedVersionValidationMessage = '';
  String ageValidationMessage = '';
  String medicationNameValidationMessage = '';
  String modeValidationMessage = '';
  String siteValidationMessage = '';
  String dosageValidationMessage = '';
  String dosageUnitValidationMessage = '';
  String notificationPriorValidationMessage = '';
  String medicationDescriptionValidationMessage = '';
  bool validate() {
    if (medicationCodeController.text == '') {
      medicationCodeValidationMessage = 'Medication code cannot be empty';
      medicationCodeValidation = false;
    } else if (medicationCodeController.text.length > 9) {
      medicationCodeValidationMessage =
          'Medication code cannot contain more then 9 characters';
      medicationCodeValidation = false;
    } else {
      medicationCodeValidation = true;
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
        ageValidationMessage = 'Enter a valid Age';
        ageValidation = false;
      } else if (ageController.text.length > 6) {
        ageValidationMessage = 'Age Cannot contain more then 6 characters';
        ageValidation = false;
      } else if (ageController.text == '') {
        ageValidationMessage = 'Age cannot be empty';
        ageValidation = false;
      } else {
        ageValidation = true;
      }
      if (mediactionNameController.text == '') {
        medicationNameValidationMessage = 'Medication name cannot be empty';
        medicationNameValidation = false;
      } else if (mediactionNameController.text.length > 12) {
        medicationNameValidationMessage =
            'Medication name cannot contain more then 12 characters';
        medicationNameValidation = false;
      } else {
        medicationNameValidation = true;
      }
      if (modeController.text == '') {
        modeValidationMessage = 'Mode cannot be empty';
        modeValidation = false;
      } else {
        modeValidation = true;
      }
      if (siteController.text == '') {
        siteValidationMessage = 'Site cannot be empty';
        siteValidation = false;
      } else {
        siteValidation = true;
      }
      if (dosageController.text == '') {
        dosageValidationMessage = 'Dosage cannot be empty';
        dosageValidation = false;
      } else {
        dosageValidation = true;
      }
      if (dosageUnitController.text == '') {
        dosageUnitValidationMessage = 'Dosage unit cannot be empty';
        dosageUnitValidation = false;
      } else {
        dosageUnitValidation = true;
      }

      if (notificationPriorController.text.isNum != true) {
        notificationPriorValidationMessage =
            'Enter a valid Notification prior to days';
        notificationPriorValidation = false;
      } else if (notificationPriorController.text.length > 2) {
        notificationPriorValidationMessage =
            'Notification prior to days Cannot contain more then 2 characters';
        notificationPriorValidation = false;
      } else if (notificationPriorController.text == '') {
        notificationPriorValidationMessage =
            'Notification prior to days cannot be empty';
        notificationPriorValidation = false;
      } else {
        notificationPriorValidation = true;
      }

      if (medicationDescriptionController.text == '') {
        medicationDescriptionValidationMessage = 'Description cannot be empty';
        medicationDescriptionValidation = false;
      } else if (medicationDescriptionController.text.length > 30) {
        medicationDescriptionValidationMessage =
            'Description cannot contain more then 30 characters';
        medicationDescriptionValidation = false;
      } else {
        medicationDescriptionValidation = true;
      }
      if (medicationCodeValidation == true &&
          recommendedByValidation == true &&
          breedVersionValidation == true &&
          ageValidation == true &&
          medicationNameValidation == true &&
          modeValidation == true &&
          siteValidation == true &&
          dosageValidation == true &&
          dosageUnitValidation == true &&
          notificationPriorValidation == true) {
        return true;
      } else {
        return false;
      }
    } else {
      if (medicationCodeValidation == true &&
          recommendedByValidation == true &&
          breedVersionValidation == true) {
        return true;
      } else {
        return false;
      }
    }
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
          'Medication_Name',
          'Mode',
          'Site',
          'Dosage',
          'Dosage_Unit',
          'Notification_Prior_Days',
          'Description',
        ];

        for (var table in excel.tables.keys) {
          for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
            Map temp = {
              'Age': '',
              'Medication_Name': null,
              'Mode': null,
              'Site': null,
              'Dosage': '',
              'Dosage_Unit': '',
              'Notification_Prior_Days': null,
              'Description': null,
            };
            List tempList = [];
            // print(excel.tables[table]!.rows[i].length.toString());

            for (int j = 0; j < excel.tables[table]!.rows[i].length; j++) {
              print(excel.tables[table]!.rows[i][j]!.value.toString());
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
              sendData[i]['Medication_Name'] == '' ||
              sendData[i]['Medication_Name'] == null ||
              sendData[i]['Mode'] == '' ||
              sendData[i]['Mode'] == null ||
              sendData[i]['Site'] == '' ||
              sendData[i]['Site'] == null ||
              sendData[i]['Dosage'] == '' ||
              sendData[i]['Dosage'] == null ||
              sendData[i]['Dosage_Unit'] == '' ||
              sendData[i]['Dosage_Unit'] == null ||
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
      sendData.add(singleMedicationPlan);
    }
    medicationPlanData['Medication_Plan'] = sendData;

    // print(medicationPlanData);

    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<ActivityApis>(context, listen: false)
            .updateMedicationPlanData(
                medicationPlanData, token, widget.medicationId)
            .then((value) {
          if (value == 202 || value == 200) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully added Medication Plan');
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
        if (data['Breed_Version_Id'].toString() == widget.breedVersionId) {
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
                        'Medication Planning',
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
                            child: const Text('Medication Code'),
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
                                        ? 'Enter Medication Code'
                                        : '',
                                    border: InputBorder.none),
                                controller: medicationCodeController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // showError('FirmCode');
                                    return '';
                                  }
                                },
                                onSaved: (value) {
                                  medicationPlanData['Medication_Code'] =
                                      value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  medicationCodeValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, medicationCodeValidationMessage),
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
                                  medicationPlanData['Recommended_By'] = value!;
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
                                        medicationPlanData['Breed_Version_Id'] =
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
                                        ? 'Enter description'
                                        : '',
                                    border: InputBorder.none),
                                initialValue: widget.description,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // showError('FirmCode');
                                    return '';
                                  }
                                },
                                onSaved: (value) {
                                  medicationPlanData['Description'] = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Medication Plan Information',
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
                                        singleMedicationPlan['Age'] = value!;
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
                                size, ageValidationMessage),
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
                                  child: const Text('Medication Name'),
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
                                              ? 'Enter Medication name'
                                              : '',
                                          border: InputBorder.none),
                                      controller: mediactionNameController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleMedicationPlan[
                                            'Medication_Name'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        medicationNameValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, medicationNameValidationMessage),
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
                                        singleMedicationPlan['Mode'] = value!;
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
                                        singleMedicationPlan['Site'] = value!;
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
                                        singleMedicationPlan['Dosage'] = value!;
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
                                        singleMedicationPlan['Dosage_Unit'] =
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
                                          medicationDescriptionController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleMedicationPlan['Description'] =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        medicationDescriptionValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, medicationDescriptionValidationMessage),
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
                                        singleMedicationPlan[
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
                                  value.activityPlanException[index][0]);
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
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            width: size.width * 0.1,
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
    );
  }
}
