import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/breed_info/providers/breed_info_apicalls.dart';
import 'package:poultry_login_signup/widgets/modular_widgets.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../planning/providers/activity_plan_apis.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Column, Row, Border, Alignment;
import 'dart:html' as html;
import 'dart:js' as js;

class AddBreedVersionDetailsDialog extends StatefulWidget {
  AddBreedVersionDetailsDialog({Key? key, required this.reFresh})
      : super(key: key);

  final ValueChanged<int> reFresh;

  @override
  State<AddBreedVersionDetailsDialog> createState() =>
      _AddBreedVersionDetailsDialogState();
}

class _AddBreedVersionDetailsDialogState
    extends State<AddBreedVersionDetailsDialog> {
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

  var breedVersionId;
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

  @override
  void initState() {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false).getBreed(token);
      }
    });

    super.initState();
  }

  void downloadExcelSheet() {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    Range range = sheet.getRangeByName('A1');
    range.setText('Mortality');
    range = sheet.getRangeByName('B1');
    range.setText('Body Weight');
    range = sheet.getRangeByName('C1');
    range.setText('Primarily Days');
    range = sheet.getRangeByName('D1');
    range.setText('Feed Consumption');
    range = sheet.getRangeByName('E1');
    range.setText('Egg Production Rate');

    List exportActivityList = [];
    // if (breedInfoDataList.isNotEmpty) {
    //   for (var data in breedInfoDataList) {
    //     exportActivityList.add([
    //       data['Mortality'],
    //       data['Body_Weight'],
    //       data['Primarily_Days'],
    //       data['Feed_Consumption'],
    //       data['Egg_Production_Rate'],
    //     ]);
    //   }
    // }

    // for (int i = 0; i < exportActivityList.length; i++) {
    //   sheet.importList(exportActivityList[i], i + 2, 1, false);
    // }
    final List<int> bytes = workbook.saveAsStream();

    // File file=File();

    // file.writeAsBytes(bytes);

    // _localFile.then((value) {
    //   final file = value;
    //   file.writeAsBytes(bytes);
    // });
    saveFile(bytes, 'breedVersionInfoSample.xlsx');

    // final blob = html.Blob([bytes], 'application/vnd.ms-excel');
    // final url = html.Url.createObjectUrlFromBlob(blob);
    // html.window.open(url, "_blank");
    // html.Url.revokeObjectUrl(url);
    workbook.dispose();
  }

  void saveFile(Object bytes, String fileName) {
    js.context.callMethod("saveAs", <Object>[
      html.Blob(<Object>[bytes]),
      fileName
    ]);
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

  bool validate() {
    if (breedVersionController.text == '') {
      breedVersionValidationSubject = 'Breed Version cannot be empty';
      breedVersionValidation = false;
    } else {
      breedVersionValidation = true;
    }

    if (breedVersionId == null) {
      breedNameValidationSubject = 'Please choose the breed name';
      breedNameValidation = false;
    } else {
      breedNameValidation = true;
    }

    if (sendData.isEmpty) {
      if (primarilyDaysController.text == '') {
        primarilyInDaysSubjectValidationSubject =
            'Primarily in days cannot be empty';
        primarilyInDaysValidation = false;
      } else {
        primarilyInDaysValidation = true;
      }
      if (bodyWeightController.text == '') {
        bodyWeightValidationSubject = 'Body weight cannot be empty';
        bodyWeightValidation = false;
      } else {
        bodyWeightValidation = true;
      }
      if (feedConsumptionController.text == '') {
        feedConsumptionValidationSubject = 'Feed Consumption cannot be empty';
        feedConsumptionValidation = false;
      } else {
        feedConsumptionValidation = true;
      }
      if (eggProductionController.text == '') {
        eggProductRateValidationSubject = 'Egg production cannot be empty';
        eggproductionValidation = false;
      } else {
        eggproductionValidation = true;
      }
      if (mortalityController.text == '') {
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

  bool _validate = true;
  void save() {
    _validate = validate();
    if (_validate != true) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();

    if (sendData.isEmpty) {
      bool validate = _singleActivityFormKey.currentState!.validate();
      if (validate != true) {
        setState(() {});
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
            .addBreedVersionDetails(breedInfoData, token)
            .then((value) {
          if (value == 201 || value == 200) {
            widget.reFresh(100);
            Get.back();

            successSnackbar('Successfully added breed version data');
          } else {
            widget.reFresh(100);
            Get.back();
            failureSnackbar('Something Went Wrong');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    breed = Provider.of<BreedInfoApis>(context).breedInfo;
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
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: downloadExcelSheet,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: downloadExcelSheet,
                                icon: Icon(
                                  Icons.download_for_offline_outlined,
                                  color: ProjectColors.themecolor,
                                )),
                            Text(
                              'Download Sample',
                              style: ProjectStyles.cancelStyle()
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      )
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
                                decoration: InputDecoration(
                                    hintText: activityPlanIdError == false
                                        ? 'Enter Breed Version'
                                        : '',
                                    border: InputBorder.none),
                                controller: breedVersionController,
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
                  // ModularWidgets().genericFormField(
                  //     size: size,
                  //     hintText: 'Enter Breed Version',
                  //     onSaved: breedInfoData['Breed_Version'],
                  //     controller: breedVersionController,
                  //     borderColor: Colors.black26,
                  //     formHeader: 'Breed Version'),
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
                                  value: breedVersionId,
                                  items:
                                      breed.map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      child: Text(e['Breed_Name'].toString()),
                                      value: e['Breed_Name'].toString(),
                                      onTap: () {
                                        breedInfoData['Breed_Id'] =
                                            e['Breed_Id'];
                                      },
                                    );
                                  }).toList(),
                                  hint:
                                      const Text('Choose Relevant breed name'),
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
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter primarily days'
                                              : '',
                                          border: InputBorder.none),
                                      controller: primarilyDaysController,
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
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter body weight'
                                              : '',
                                          border: InputBorder.none),
                                      controller: bodyWeightController,
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
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter Feed consumption'
                                              : '',
                                          border: InputBorder.none),
                                      controller: feedConsumptionController,
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
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter Egg Production Rate'
                                              : '',
                                          border: InputBorder.none),
                                      controller: eggProductionController,
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
                                      decoration: InputDecoration(
                                          hintText: activityPlanIdError == false
                                              ? 'Enter mortality'
                                              : '',
                                          border: InputBorder.none),
                                      controller: mortalityController,
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
                                  'Add Details',
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
