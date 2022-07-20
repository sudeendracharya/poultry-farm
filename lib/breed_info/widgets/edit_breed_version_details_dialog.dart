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
import '../providers/breed_info_apicalls.dart';

class EditBreedVersionDetailsDialog extends StatefulWidget {
  EditBreedVersionDetailsDialog(
      {Key? key,
      required this.reFresh,
      required this.breedId,
      required this.breedVersion,
      required this.referenceData,
      required this.breedVersionId})
      : super(key: key);
  final ValueChanged<int> reFresh;
  final int breedId;
  final String breedVersion;
  final List referenceData;
  final String breedVersionId;

  @override
  State<EditBreedVersionDetailsDialog> createState() =>
      _EditBreedVersionDetailsDialogState();
}

class _EditBreedVersionDetailsDialogState
    extends State<EditBreedVersionDetailsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _singleActivityFormKey = GlobalKey();
  var activityPlanIdError = false;

  Map<String, dynamic> breedInfoData = {
    'Breed_Id': '',
    'Breed_Version': '',
    'Reference_Data': [],
  };

  Map<String, dynamic> singleBreedInfo = {
    'Primarily_Days': '',
    'Body_Weight': '',
    'Feed_Consumption': '',
    'Egg_Production_Rate': '',
    'Mortality': ''
  };

  var breedId;
  bool fileSelected = false;
  String fileName = '';

  List breed = [];

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

  var _days;
  var _bodyWeight;
  var _consumption;
  var _productionRate;
  var _mortality;

  @override
  void initState() {
    breedInfoData['Breed_Id'] = widget.breedId;
    breedVersionController.text = widget.breedVersion;
    if (widget.referenceData.length == 1) {
      primarilyDaysController.text = widget.referenceData[0]['Primarily_Days'];
      bodyWeightController.text = widget.referenceData[0]['Body_Weight'];
      feedConsumptionController.text =
          widget.referenceData[0]['Feed_Consumption'];
      eggProductionController.text =
          widget.referenceData[0]['Egg_Production_Rate'];
      mortalityController.text = widget.referenceData[0]['Mortality'];
    }
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false).getBreed(token);
      }
    });

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
          'Primarily_Days',
          'Body_Weight',
          'Feed_Consumption',
          'Egg_Production_Rate',
          'Mortality',
        ];

        for (var table in excel.tables.keys) {
          for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
            Map temp = {
              'Primarily_Days': '',
              'Body_Weight': '',
              'Feed_Consumption': '',
              'Egg_Production_Rate': '',
              'Mortality': ''
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
          if (sendData[i]['Primarily_Days'] == '' ||
              sendData[i]['Primarily_Days'] == null ||
              sendData[i]['Body_Weight'] == '' ||
              sendData[i]['Body_Weight'] == null ||
              sendData[i]['Feed_Consumption'] == '' ||
              sendData[i]['Feed_Consumption'] == null ||
              sendData[i]['Egg_Production_Rate'] == '' ||
              sendData[i]['Egg_Production_Rate'] == null ||
              sendData[i]['Mortality'] == '' ||
              sendData[i]['Mortality'] == null) {
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
      sendData.add(singleBreedInfo);
    }
    breedInfoData['Reference_Data'] = sendData;

    // print(breedInfoData);

    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false)
            .updateBreedVersionDetails(
                breedInfoData, widget.breedVersionId, token)
            .then((value) {
          if (value == 201 || value == 200 || value == 202) {
            widget.reFresh(100);
            Get.back();

            successSnackbar('Successfully updated breed version data');
          } else {
            widget.reFresh(100);
            Get.back();
            failureSnackbar('Something Went Wrong');
          }
        });
      }
    });
  }

  String breedVersionValidationSubject = '';
  String breedNameValidationSubject = '';
  String primarilyInDaysSubjectValidationSubject = '';
  String bodyWeightValidationSubject = '';
  String feedConsumptionValidationSubject = '';
  String eggProductRateValidationSubject = '';
  String mortalityValidationSubject = '';
  bool breedVersionValidation = true;
  bool breedNameValidation = true;
  bool primarilyInDaysValidation = true;
  bool bodyWeightValidation = true;
  bool feedConsumptionValidation = true;
  bool eggproductionValidation = true;
  bool mortalityValidation = true;

  TextEditingController breedVersionController = TextEditingController();
  TextEditingController primarilyDaysController = TextEditingController();
  TextEditingController bodyWeightController = TextEditingController();
  TextEditingController feedConsumptionController = TextEditingController();
  TextEditingController eggProductionController = TextEditingController();
  TextEditingController mortalityController = TextEditingController();

  bool validate() {
    if (breedVersionController.text == '') {
      breedVersionValidationSubject = 'Breed Version cannot be empty';
      breedVersionValidation = false;
    } else if (breedVersionController.text.length > 18) {
      breedVersionValidationSubject =
          'Breed Version cannot be greater then 18 characters';
      breedVersionValidation = false;
    } else {
      breedVersionValidation = true;
    }

    if (breedId == null) {
      breedNameValidationSubject = 'Please choose the breed name';
      breedNameValidation = false;
    } else {
      breedNameValidation = true;
    }

    if (sendData.isEmpty) {
      if (primarilyDaysController.text.isNum != true) {
        primarilyInDaysSubjectValidationSubject =
            'Enter a valid primarily in days';
        primarilyInDaysValidation = false;
      } else if (primarilyDaysController.text == '') {
        primarilyInDaysSubjectValidationSubject =
            'Primarily in days cannot be empty';
        primarilyInDaysValidation = false;
      } else {
        primarilyInDaysValidation = true;
      }
      if (bodyWeightController.text.isNum != true) {
        bodyWeightValidationSubject = 'Enter a valid Body weight';
        bodyWeightValidation = false;
      } else if (bodyWeightController.text == '') {
        bodyWeightValidationSubject = 'Body weight cannot be empty';
        bodyWeightValidation = false;
      } else {
        bodyWeightValidation = true;
      }
      if (feedConsumptionController.text.isNum != true) {
        feedConsumptionValidationSubject =
            'Enter a valid feed consumption unit';
        feedConsumptionValidation = false;
      } else if (feedConsumptionController.text == '') {
        feedConsumptionValidationSubject = 'Feed Consumption cannot be empty';
        feedConsumptionValidation = false;
      } else {
        feedConsumptionValidation = true;
      }
      if (eggProductionController.text.isNum != true) {
        eggProductRateValidationSubject = 'Enter a valid Egg production';
        eggproductionValidation = false;
      } else if (eggProductionController.text == '') {
        eggProductRateValidationSubject = 'Egg production cannot be empty';
        eggproductionValidation = false;
      } else {
        eggproductionValidation = true;
      }
      if (mortalityController.text.isNum != true) {
        mortalityValidationSubject = 'Enter a valid mortality';
        mortalityValidation = false;
      } else if (mortalityController.text == '') {
        mortalityValidationSubject = 'Mortality cannot be empty';
        mortalityValidation = false;
      } else {
        mortalityValidation = true;
      }

      if (breedVersionValidation == true &&
          breedNameValidation == true &&
          primarilyInDaysValidation == true &&
          bodyWeightValidation == true &&
          feedConsumptionValidation == true &&
          eggproductionValidation == true &&
          mortalityValidation == true) {
        return true;
      } else {
        return false;
      }
    }

    if (breedVersionValidation == true && breedNameValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    breed = Provider.of<BreedInfoApis>(context).breedInfo;
    if (breed.isNotEmpty) {
      for (var data in breed) {
        if (data['Breed_Id'] == widget.breedId) {
          breedId = data['Breed_Name'];
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
                        'Breed Version Details',
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
                            child: const Text('Breed Version'),
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
                                controller: breedVersionController,
                                decoration: InputDecoration(
                                    hintText: activityPlanIdError == false
                                        ? 'Enter Breed Version'
                                        : '',
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // showError('FirmCode');
                                    return '';
                                  }
                                },
                                onSaved: (value) {
                                  breedInfoData['Breed_Version'] = value!;
                                },
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
                          size, breedVersionValidationSubject),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: size.width * 0.25,
                            child: const Text('Breed'),
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
                                  value: breedId,
                                  items:
                                      breed.map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      value: e['Breed_Name'].toString(),
                                      onTap: () {
                                        breedInfoData['Breed_Id'] =
                                            e['Breed_Id'];
                                      },
                                      child: Text(e['Breed_Name'].toString()),
                                    );
                                  }).toList(),
                                  hint:
                                      const Text('Choose Relevant breed name'),
                                  onChanged: (value) {
                                    setState(() {
                                      breedId = value as String;
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
                  breedNameValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, breedNameValidationSubject),
                  const SizedBox(
                    height: 36,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Breed Info',
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
                                  child: const Text('Primarily Days'),
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
                                      controller: primarilyDaysController,
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter primarily days'
                                              : '',
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleBreedInfo['Primarily_Days'] =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        primarilyInDaysValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, primarilyInDaysSubjectValidationSubject),
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
                                  child: const Text('Body Weight'),
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
                                      controller: bodyWeightController,
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter body weight'
                                              : '',
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleBreedInfo['Body_Weight'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        bodyWeightValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, bodyWeightValidationSubject),
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
                                  child: const Text('Feed Consumption'),
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
                                      controller: feedConsumptionController,
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter Feed consumption'
                                              : '',
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleBreedInfo['Feed_Consumption'] =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        feedConsumptionValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, feedConsumptionValidationSubject),
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
                                  child: const Text('Egg Production Rate'),
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
                                      controller: eggProductionController,
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter Egg Production Rate'
                                              : '',
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleBreedInfo['Egg_Production_Rate'] =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        eggproductionValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, eggProductRateValidationSubject),
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
                                  child: const Text('Mortality'),
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
                                      controller: mortalityController,
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter mortality'
                                              : '',
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return '';
                                        }
                                      },
                                      onSaved: (value) {
                                        singleBreedInfo['Mortality'] = value!;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        mortalityValidation == true
                            ? const SizedBox()
                            : ModularWidgets.validationDesign(
                                size, mortalityValidationSubject),
                        Consumer<BreedInfoApis>(
                            builder: (context, value, child) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.breedException.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ModularWidgets.exceptionDesign(
                                  MediaQuery.of(context).size,
                                  value.breedException[index][0]);
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
