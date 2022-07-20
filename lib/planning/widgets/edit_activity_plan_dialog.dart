import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/planning/providers/activity_validation.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/activity_plan_apis.dart';

class EditActivityPlanDialog extends StatefulWidget {
  const EditActivityPlanDialog(
      {Key? key,
      required this.reFresh,
      required this.activityId,
      required this.recommendedBy,
      required this.activityList,
      required this.breedVersion})
      : super(key: key);

  final ValueChanged<int> reFresh;
  final String activityId;
  final String recommendedBy;
  final List activityList;
  final String breedVersion;

  @override
  State<EditActivityPlanDialog> createState() => _EditActivityPlanDialogState();
}

class _EditActivityPlanDialogState extends State<EditActivityPlanDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _singleActivityFormKey = GlobalKey();
  var activityPlanIdError = false;

  Map<String, dynamic> activityPlanData = {
    'Activity_Id': '',
    'Recommended_By': '',
    'Activity_Plan': [],
    'Breed_Version_Id': '',
  };

  Map<String, dynamic> singleActivityPlan = {
    'Age': '',
    'Activity_Name': '',
    'Notification_Prior_To_Activity': '',
  };

  var breedVersionId;
  bool fileSelected = false;
  String fileName = '';

  List breedVersion = [];

  List sendData = [];

  var _age;

  var _activityName;

  var _notification;

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
    breedVersionController.text = widget.breedVersion;
    activityCodeController.text = widget.activityId.toString();
    recommendedByController.text = widget.recommendedBy;
    breedVersionId = widget.breedVersion;
    if (widget.activityList.length == 1) {
      ageController.text = widget.activityList[0]['Age'];
      activityNameController.text = widget.activityList[0]['Activity_Name'];
      notificationPriorController.text =
          widget.activityList[0]['Notification_Prior_To_Activity'];
    }
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<ActivityApis>(context, listen: false)
            .getBreedDetails(token);
      }
    });

    super.initState();
  }

  TextEditingController activityCodeController = TextEditingController();
  TextEditingController recommendedByController = TextEditingController();
  TextEditingController breedVersionController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController activityNameController = TextEditingController();
  TextEditingController notificationPriorController = TextEditingController();

  bool activityCodeValidation = true;
  bool recommendedByValidation = true;
  bool breedVersionValidation = true;
  bool ageValidation = true;
  bool activityNameValidation = true;
  bool notificationPriorValidation = true;

  String activityCodeValidationMessage = '';
  String recommendedByValidationMessage = '';
  String breedVersionValidationMessage = '';
  String ageValidationMessage = '';
  String activityNameValidationMessage = '';
  String notificationPriorValidationMessage = '';

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

        List names = ['Age', 'Activity_Name', 'Notification_Prior_To_Activity'];

        for (var table in excel.tables.keys) {
          for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
            Map temp = {
              'Age': '',
              'Activity_Name': '',
              'Notification_Prior_To_Activity': ''
            };
            List tempList = [];
            // print(excel.tables[table]!.rows[i].length.toString());

            for (int j = 0; j < excel.tables[table]!.rows[i].length; j++) {
              // print(excel.tables[table]!.rows[i][j]!.value.toString());
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
              sendData[i]['Activity_Name'] == '' ||
              sendData[i]['Activity_Name'] == null ||
              sendData[i]['Notification_Prior_To_Activity'] == '' ||
              sendData[i]['Notification_Prior_To_Activity'] == null) {
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

  bool validate() {
    if (activityCodeController.text == '') {
      activityCodeValidationMessage = 'Activity Code cannot be empty';
      activityCodeValidation = false;
    } else if (activityCodeController.text.length > 6) {
      activityCodeValidationMessage = 'Activity Code cannot be greater then 6';
      activityCodeValidation = false;
    } else {
      activityCodeValidation = true;
    }

    if (recommendedByController.text == '') {
      recommendedByValidationMessage = 'Recommended by cannot be empty';
      recommendedByValidation = false;
    } else {
      recommendedByValidation = true;
    }

    if (breedVersionId == null) {
      breedVersionValidationMessage = 'Breed Version cannot be empty';
      breedVersionValidation = false;
    } else {
      breedVersionValidation = true;
    }

    if (sendData.isEmpty) {
      if (ageController.text.isNum != true) {
        ageValidationMessage = 'Ente a valid Age';
        ageValidation = false;
      } else if (ageController.text.length > 6) {
        ageValidationMessage = 'Age cannot be greater then 6 characters';
        ageValidation = false;
      } else if (ageController.text == '') {
        ageValidationMessage = 'Age cannot be empty';
        ageValidation = false;
      } else {
        ageValidation = true;
      }

      if (activityNameController.text.length > 16) {
        activityNameValidationMessage =
            'Activity name cannot be greater then 16 characters';
        activityNameValidation = false;
      } else if (activityNameController.text == '') {
        activityNameValidationMessage = 'Activity name cannot be empty';
        activityNameValidation = false;
      } else {
        activityNameValidation = true;
      }

      if (notificationPriorController.text.isNum != true) {
        notificationPriorValidationMessage =
            'Enter a valid Notification prior to days';
        notificationPriorValidation = false;
      } else if (notificationPriorController.text.length > 2) {
        notificationPriorValidationMessage =
            'Notification prior to days cannot be greater then 2 characters';
        notificationPriorValidation = false;
      } else if (notificationPriorController.text == '') {
        notificationPriorValidationMessage =
            'Notification prior to days cannot be empty';
        notificationPriorValidation = false;
      } else {
        notificationPriorValidation = true;
      }

      if (activityCodeValidation == true &&
          recommendedByValidation == true &&
          breedVersionValidation == true &&
          ageValidation == true &&
          activityNameValidation == true &&
          notificationPriorValidation == true) {
        return true;
      } else {
        return false;
      }
    } else {
      if (activityCodeValidation == true &&
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
    print('validatiopn $validateData');
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
      sendData.add(singleActivityPlan);
    }
    activityPlanData['Activity_Plan'] = sendData;

    // print(activityPlanData);

    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<ActivityApis>(context, listen: false)
            .updateActivityPlanData(activityPlanData, token, widget.activityId)
            .then((value) {
          if (value == 201 || value == 200) {
            widget.reFresh(100);
            Get.back();

            successSnackbar('Successfully updated Activity Plan');
          } else {
            ;
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
        if (data['Breed_Version_Id'] == widget.breedVersion) {
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
                        'Activity Planning',
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
                            child: const Text('Activity Plan ID'),
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
                                        ? 'Enter Activity Plan Id'
                                        : '',
                                    border: InputBorder.none),
                                controller: activityCodeController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // showError('FirmCode');
                                    return '';
                                  }
                                },
                                onSaved: (value) {
                                  activityPlanData['Activity_Id'] = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  activityCodeValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, activityCodeValidationMessage),
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
                                  activityPlanData['Recommended_By'] = value!;
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
                                      child:
                                          Text(e['Breed_Version'].toString()),
                                      value: e['Breed_Version'].toString(),
                                      onTap: () {
                                        activityPlanData['Breed_Version_Id'] =
                                            e['Breed_Version_Id'];
                                      },
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
                  const SizedBox(
                    height: 36,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Activity Plan Information',
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
                                        singleActivityPlan['Age'] = value!;
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
                                  child: const Text('Activity'),
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
                                              ? 'Enter activity'
                                              : '',
                                          border: InputBorder.none),
                                      controller: activityNameController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleActivityPlan['Activity_Name'] =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        activityNameValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, activityNameValidationMessage),
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
                                      'Notification days prior to activity'),
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
                                              ? 'Enter notification days prior to activity'
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
                                        singleActivityPlan[
                                                'Notification_Prior_To_Activity'] =
                                            value!;
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
