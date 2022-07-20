import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect/multiselect.dart';
import 'package:poultry_login_signup/colors.dart';
import 'package:poultry_login_signup/infrastructure/widgets/add_warehouse_category_dialog.dart';
import 'package:poultry_login_signup/infrastructure/widgets/addwarehouse_sub_category_dialog.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/modular_widgets.dart';
import '../../widgets/success_dialog.dart';

class AddWareHouseDetails extends StatefulWidget {
  AddWareHouseDetails(
      {Key? key, this.index, this.id, required this.update, this.wareHouseCode})
      : super(key: key);
  static const routeName = '/AddWarehouseDetails';
  var index;
  var id;
  var wareHouseCode;
  final ValueChanged<int> update;
  @override
  _AddWareHouseDetailsState createState() => _AddWareHouseDetailsState();
}

class _AddWareHouseDetailsState extends State<AddWareHouseDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _sectionKey = GlobalKey();
  final GlobalKey<FormState> _updateSingleLineKey = GlobalKey();
  final GlobalKey<FormState> _updateAllLineKey = GlobalKey();
  final TextEditingController sectionController = TextEditingController();
  ScrollController allLineController = ScrollController();
  ScrollController individualLineController = ScrollController();

  List firmList = [];
  var firmId;
  List plantList = [];
  var plantId;

  var index = 0;
  var count = 0;

  var _selected = false;

  int lineCount = 0;

  var lineId;

  List individualLineDataList = [];
  List finalSectionDetailList = [];
  List individualdataList = [];

  var _isSucess = false;

  List sectionDataList = [];

  var formError = false;

  var selectedCode;

  var _wareHouseId;

  var _wareHouseName;

  var _wareHouseCode;

  var _firmId;

  var _plantId;

  bool descriptionError = false;

  String wareHouseErrorMessage = '';

  String wareHouseErrorTitle = '';

  bool wareHouseNameError = false;

  bool wareHouseCodeError = false;

  bool subCategoryError = false;

  bool categoryError = false;

  var sectionCodeError = false;

  var boxCountError = false;

  var maxBoxCapacityError = false;

  var boxHeightError = false;

  var boxBreadthError = false;

  var boxLengthError = false;

  var singleBoxCountError = false;

  var singleMaxBoxCountError = false;

  var singleBoxLengthError = false;

  var singleBoxHeightError = false;

  var singleBoxBreadthError = false;

  var sectionLineCountError = false;

  bool fieldError = false;

  ScrollController horizontalController = ScrollController();

  TextEditingController warehouseCodeController = TextEditingController();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  List warehouseCategory = [];
  List warehouseSubCategory = [];
  var sectionId;

  var warehouseCategoryId;
  var warehouseSubCategoryId;
  var plantDetailsId;
  var plantName;
  var isLoading = true;
  var sectionCode;
  var wareHouseName = 'Shed';
  var wareHouseCode = 'S01';
  List wareHouseSectionDetailsList = [];

  Map<String, dynamic> wareHouseDetails = {
    'Firm_Id': '',
    'Plant_Id': '',
    'WareHouse_Category_Id': '',
    'WareHouse_Sub_Category_Id': '',
    'WareHouse_Name': '',
    'WareHouse_Code': '',
    'Description': '',
  };
  var update = false;
  var wareHouseId;

  Map<String, dynamic> initValues = {
    'WareHouse_Category_Id': '',
    'WareHouse_Sub_Category_Id': '',
    'WareHouse_Plant_Name': '',
    'WareHouse_Code': '',
  };

  Map<String, dynamic> updateAllLines = {
    'Line_Id': '',
    'Box_Count': '',
    'WareHouse_Section_Line_Maximum_Box_Capacity': '',
    'Height': '',
    'Length': '',
    'Breadth': '',
  };

  Map<String, dynamic> updateSingleLines = {
    'Line_Id': '',
    'Box_Count': '',
    'WareHouse_Section_Line_Maximum_Box_Capacity': '',
    'Height': '',
    'Length': '',
    'Breadth': '',
  };

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      var data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      update = true;
      wareHouseId = data['WareHouse_Id'].toString();
      wareHouseDetails['WareHouse_Category_Id'] =
          data['WareHouse_Category_Id'].toString();
      wareHouseDetails['WareHouse_Sub_Category_Id'] =
          data['WareHouse_Sub_Category_Id'].toString();
      wareHouseDetails['WareHouse_Plant_Name'] =
          data['WareHouse_Plant_Name'].toString();

      initValues = {
        'WareHouse_Category_Id': data['WareHouse_Category_Id'],
        'WareHouse_Sub_Category_Id': data['WareHouse_Sub_Category_Id'],
        'WareHouse_Plant_Name': data['WareHouse_Plant_Name'],
        'WareHouse_Code': data['WareHouse_Code'],
      };
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    warehouseCodeController.text = getRandom(3, 'W-');
    lineIds.clear();
    individualLineDataList.clear();
    _selected = false;
    sectionCode = widget.wareHouseCode == null
        ? null
        : getRandom(3, '${widget.wareHouseCode}S-');
    sectionController.text = widget.wareHouseCode == null
        ? ''
        : getRandom(3, '${widget.wareHouseCode}S-');

    getFirmData().then((value) {
      wareHouseDetails['Firm_Id'] = _firmId;
      fechplantList(_firmId);
    });
    if (widget.index != null) {
      index = widget.index;
      _wareHouseId = widget.id;
    } else {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .getWarehouseCategory(token)
            .then((value1) {});
        // Provider.of<InfrastructureApis>(context, listen: false)
        //     .getFirmDetails(token)
        //     .then((value1) {});
        // Provider.of<InfrastructureApis>(context, listen: false)
        //     .getPlantDetails(token)
        //     .then((value1) {});
      });
    }
  }

  void showError(String error) {
    switch (error) {
      case 'Category':
        setState(() {
          wareHouseErrorTitle = 'Category';
          wareHouseErrorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          categoryError = true;
        });
        break;
      case 'SubCategory':
        setState(() {
          wareHouseErrorTitle = 'Sub Category';
          wareHouseErrorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          subCategoryError = true;
        });
        break;
      case 'WareHouseCode':
        setState(() {
          wareHouseErrorTitle = 'WareHouseCode';
          wareHouseErrorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          wareHouseCodeError = true;
        });
        break;
      case 'WareHouseName':
        setState(() {
          wareHouseErrorTitle = 'WareHouseName';
          wareHouseErrorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          wareHouseNameError = true;
        });
        break;
      case 'Description':
        setState(() {
          wareHouseErrorTitle = 'Description';
          wareHouseErrorMessage = 'Field Cannot Be Empty';
          // validationError = true;
          descriptionError = true;
        });
        break;

      default:
    }
  }

  Future<void> getFirmData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('FirmAndPlantDetails')) {
      return;
    }
    final extratedUserData =
        json.decode(prefs.getString('FirmAndPlantDetails')!)
            as Map<String, dynamic>;

    _firmId = extratedUserData['FirmId'];
    // _plantId = extratedUserData['PlantId'];
  }

  void getPlantName() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('firmData')) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('firmData')!) as Map<String, dynamic>;
    plantName = extratedUserData['plantName'];
    setState(() {
      isLoading = false;
    });
  }

  void fetchSubCategoryId(var id) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseSubCategory(id, token)
          .then((value1) {});
    });
  }

  Future<void> save() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (warehouseCategoryId == null) {
      setState(() {
        categoryError = true;
      });
      return;
    } else if (warehouseSubCategoryId == null) {
      setState(() {
        subCategoryError = true;
      });
      return;
    }
    _formKey.currentState!.save();

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .addWareHouseDetails(wareHouseDetails, token)
            .then((value) {
          if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
            Get.showSnackbar(GetSnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: Theme.of(context).backgroundColor,
              message: 'Successfully Added WareHouse Details',
              title: 'Success',
            ));
            _formKey.currentState!.reset();
            widget.update(100);
            setState(() {
              _wareHouseId = value['WareHouse_Id'];
              _wareHouseName = value['WareHouse_Name'];
              _wareHouseCode = value['WareHouse_Code'];
              index = index + 1;
            });
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
      rethrow;
    }
  }

  Future<void> updateData() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .editWareHouseDetails(wareHouseDetails, wareHouseId, token)
            .then((value) {
          if (value == 200 || value == 201) {
            showDialog(
                context: context,
                builder: (ctx) => SuccessDialog(
                    title: 'Success',
                    subTitle: 'SuccessFully Added Ware House Details'));
            _formKey.currentState!.reset();
          } else {
            showDialog(
                context: context,
                builder: (ctx) => FailureDialog(
                    title: 'Failed',
                    subTitle: 'Something Went Wrong Please Try Again'));
          }
        });
      });
    } catch (e) {}
  }

  void fechWareHouseCategory(int data) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseCategory(token)
          .then((value1) {});
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
    });
  }

  void run(Map<String, dynamic> data) {
    setState(() {
      lineIds.clear();
      individualLineDataList.clear();
      _selected = false;
      sectionCode = data['Section_Code'];
      sectionController.text = data['Section_Code'];
      sectionId = data['Section_Count'];
      if (index == 1) {
        index = index + 1;
      }
    });
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

  List<String> lineIds = [];
  List<String> selected = [];

  void generateLineCount(int count) {
    if (lineIds.isEmpty) {
      for (int i = 0; i < count; i++) {
        lineIds.add('${sectionCode}L${i + 1}');
      }
      setState(() {});
    } else {
      lineIds.clear();
      for (int i = 0; i < count; i++) {
        lineIds.add('${sectionCode}L${i + 1}');
      }
      setState(() {});
    }
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

  Future<void> sendSectionDetails(List data) async {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .addWareHouseSectionDetails(_wareHouseId, data[0], token)
          .then((value1) {
        if (value1 == 200 || value1 == 201) {
          individualdataList.clear();
          //finalSectionDetailList.clear();
          if (widget.index != null) {
            Get.back();
            widget.update(100);
          } else {
            setState(() {
              index = index - 1;
              fetchSectionDetails(_wareHouseId);
            });
          }
        } else {
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            message: 'Something Went Wrong Please Try Again',
            title: 'Failed',
          ));
          individualdataList.clear();
        }
      });

      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
    });
  }

  Future<void> fetchSectionDetails(var id) async {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWareHouseSectionDetails(id, token)
          .then((value1) {
        if (value1 == 200 || value1 == 201) {}
      });

      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
    });
  }

  TextEditingController sectionCodeController = TextEditingController();
  TextEditingController lineCountController = TextEditingController();
  TextEditingController boxCountController = TextEditingController();
  TextEditingController maxBoxCapacityController = TextEditingController();
  TextEditingController boxHeightController = TextEditingController();
  TextEditingController boxBreadthController = TextEditingController();
  TextEditingController boxLengthController = TextEditingController();

  bool sectionCodeValidation = true;
  bool lineCountValidation = true;
  bool boxCountValidation = true;
  bool maxBoxCapacityValidation = true;
  bool boxHeightValidation = true;
  bool boxBreadthValidation = true;
  bool boxLengthValidation = true;

  String sectionCodeValidationMessage = '';
  String lineCountValidationMessage = '';
  String boxCountValidationMessage = '';
  String maxBoxCapacityValidationMessage = '';
  String boxHeightValidationMessage = '';
  String boxBreadthValidationMessage = '';
  String boxLengthValidationMessage = '';

  bool validateAll() {
    print('Validating');

    var boxHeight =
        RegExp(r'^\d{1,2}(\.\d{0,3})?$').hasMatch(boxHeightController.text);

// r'^\d{1,2}\.?\d{0,3}'
    var boxBreadth =
        RegExp(r'^\d{1,2}(\.\d{0,3})?$').hasMatch(boxBreadthController.text);
    var boxLength =
        RegExp(r'^\d{1,2}(\.\d{0,2})?$').hasMatch(boxLengthController.text);

    print(boxHeight);
    print(boxBreadth);
    print(boxLength);
    if (sectionController.text == '') {
      sectionCodeValidation = false;
      sectionCodeValidationMessage = 'Section Code Cannot be empty';
    } else {
      sectionCodeValidation = true;
    }
    if (lineCountController.text == '') {
      lineCountValidation = false;
      lineCountValidationMessage = 'Line Count Cannot be empty';
    } else {
      lineCountValidation = true;
    }
    if (boxCountController.text.length > 4) {
      boxCountValidation = false;
      boxCountValidationMessage =
          'Box Count Cannot be greater then 4 characters';
    } else if (boxCountController.text == '') {
      boxCountValidation = false;
      boxCountValidationMessage = 'Box Count Cannot be empty';
    } else {
      boxCountValidation = true;
    }
    if (maxBoxCapacityController.text.length > 2) {
      maxBoxCapacityValidation = false;
      maxBoxCapacityValidationMessage =
          'Maximum Box Capacity Cannot be greater then 2 characters';
    } else if (maxBoxCapacityController.text == '') {
      maxBoxCapacityValidation = false;
      maxBoxCapacityValidationMessage = 'Maximum Box Capacity Cannot be Empty';
    } else {
      maxBoxCapacityValidation = true;
    }
    if (boxHeight != true) {
      boxHeightValidation = false;
      boxHeightValidationMessage = 'Enter a valid box height';
    } else {
      boxHeightValidation = true;
    }
    if (boxBreadth != true) {
      boxBreadthValidation = false;
      boxBreadthValidationMessage = 'Enter a valid box Breadth';
    } else {
      boxBreadthValidation = true;
    }

    if (boxLength != true) {
      boxLengthValidation = false;
      boxLengthValidationMessage = 'Enter a valid box Length';
    } else {
      boxLengthValidation = true;
    }

    if (boxHeightValidation == true &&
        boxBreadthValidation == true &&
        boxLengthValidation == true &&
        sectionCodeValidation == true &&
        lineCountValidation == true &&
        boxCountValidation == true &&
        maxBoxCapacityValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    warehouseCategory = Provider.of<InfrastructureApis>(
      context,
    ).warehouseCategory;
    warehouseSubCategory = Provider.of<InfrastructureApis>(
      context,
    ).warehouseSubCategory;
    plantList = Provider.of<InfrastructureApis>(
      context,
    ).plantDetails;

    firmList = Provider.of<InfrastructureApis>(
      context,
    ).firmDetails;
    wareHouseSectionDetailsList = Provider.of<InfrastructureApis>(
      context,
    ).warehouseSection;

    return Container(
      width: 550,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        child: Theme(
          data: ThemeData(
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(primary: const Color.fromRGBO(44, 95, 154, 1)),
          ),
          child: Stepper(
              elevation: 0,
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: index == 1
                      ? const SizedBox()
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 40.0),
                              child: SizedBox(
                                width: 200,
                                height: 48,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        const Color.fromRGBO(44, 96, 154, 1),
                                      ),
                                    ),
                                    onPressed: details.onStepContinue,
                                    child: Text(
                                      'Add Lines',
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
              type: StepperType.horizontal,
              currentStep: index,
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
                    // savePlantData();
                  } else if (index == 2) {
                    if (individualLineDataList.isEmpty && _selected == false) {
                      // bool status = _updateAllLineKey.currentState!.validate();
                      // if (status != true) {
                      //   return;
                      // }
                      // if (fieldError == true) {
                      //   return;
                      // }

                      bool validate = validateAll();
                      if (validate != true) {
                        print('Not True');
                        setState(() {});
                        return;
                      }
                      _updateAllLineKey.currentState!.save();
                      for (int i = 0; i < lineIds.length; i++) {
                        // updateAllLines['Line_Id'] = temp[i],
                        individualdataList.add({
                          'Section_Code': sectionCode,
                          'WareHouse_Section_Line_Code': lineIds[i],
                          'WareHouse_Section_Line_Number_Of_Boxes':
                              updateAllLines['Box_Count'],
                          'WareHouse_Section_Line_Maximum_Box_Capacity':
                              updateAllLines[
                                  'WareHouse_Section_Line_Maximum_Box_Capacity'],
                          'WareHouse_Section_Line_Box_Length':
                              updateAllLines['Length'],
                          'WareHouse_Section_Line_Box_Breadth':
                              updateAllLines['Breadth'],
                          'WareHouse_Section_Line_Box_Height':
                              updateAllLines['Height'],
                        });
                      }

                      finalSectionDetailList.add({
                        'WareHouse_Id': _wareHouseId,
                        'Section_Name': sectionId,
                        'WareHouse_Section_Code': sectionController.text,
                        'WareHouse_Section_Number_Of_Lines':
                            individualdataList.length,
                        'WareHouse_Section_Line_Details': individualdataList,
                      });

                      sendSectionDetails(finalSectionDetailList).then((value) {
                        individualdataList.clear();
                        finalSectionDetailList.clear();
                      });
                    } else {
                      if (lineIds.isNotEmpty) {
                        Get.showSnackbar(GetSnackBar(
                          duration: const Duration(seconds: 2),
                          backgroundColor: Theme.of(context).backgroundColor,
                          message: 'Enter Data for All The Lines',
                          title: 'Alert',
                        ));
                      } else {
                        for (int i = 0;
                            i < individualLineDataList.length;
                            i++) {
                          individualdataList.add(individualLineDataList[i]);
                        }
                        finalSectionDetailList.add({
                          'WareHouse_Id': _wareHouseId,
                          'Section_Name': sectionId,
                          'WareHouse_Section_Code': sectionController.text,
                          'WareHouse_Section_Number_Of_Lines':
                              individualdataList.length,
                          'WareHouse_Section_Line_Details': individualdataList,
                        });

                        sendSectionDetails(finalSectionDetailList)
                            .then((value) {
                          individualdataList.clear();
                          finalSectionDetailList.clear();
                        });
                      }
                    }
                  }
                }
              },
              // onStepTapped: (int value) {
              //   setState(() {
              //     index = value;
              //   });
              // },
              steps: [
                Step(
                  isActive: true,
                  title: const Text(''),
                  content: wareHouseDetailsWidget(context),
                ),
                Step(
                  isActive: index >= 1 ? true : false,
                  title: const Text(''),
                  content: getSectionCount(context),
                ),
                Step(
                  isActive: index >= 2 ? true : false,
                  title: const Text(''),
                  content: addSectionLines(context),
                )
              ]),
        ),
      ),
    );
  }

  Padding showErrorWidget(String errorTitle, String errorMessage) {
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

  Padding showCustomErrorWidget(String errorTitle, String errorMessage) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 15, right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 374,
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
    );
  }

  Form wareHouseDetailsWidget(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'WareHouse Details',
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          color: Theme.of(context).backgroundColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 36)),
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
                      width: 440,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Plant Name'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
                            value: plantId,
                            items: plantList.map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                value: e['Plant_Name'],
                                onTap: () {
                                  wareHouseDetails['Plant_Id'] = e['Plant_Id'];
                                },
                                child: Text(e['Plant_Name']),
                              );
                            }).toList(),
                            hint: const Text('Choose Plant Name'),
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
              padding: const EdgeInsets.only(top: 24.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 440,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('WareHouse Category Name'),
                          // GestureDetector(
                          //   onTap: () {
                          //     showDialog(
                          //         context: context,
                          //         builder: (ctx) => AddWareHouseCategoryDialog(
                          //               refresh: fechWareHouseCategory,
                          //               categoryDescription: '',
                          //               categoryName: '',
                          //               categoryId: '',
                          //             ));
                          //   },
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: const [
                          //       Icon(Icons.add_circle_outline_rounded),
                          //       SizedBox(
                          //         width: 5,
                          //       ),
                          //       Text('Add')
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
                            value: warehouseCategoryId,
                            items: warehouseCategory
                                .map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                value: e['WareHouse_Category_Name'],
                                onTap: () {
                                  wareHouseDetails['WareHouse_Category_Id'] =
                                      e['WareHouse_Category_Id'];
                                  fetchSubCategoryId(
                                      e['WareHouse_Category_Id']);
                                  warehouseSubCategoryId = null;
                                },
                                child: Text(e['WareHouse_Category_Name']),
                              );
                            }).toList(),
                            hint: const Text('Choose WareHouse Category Name'),
                            onChanged: (value) {
                              setState(() {
                                warehouseCategoryId = value as String;
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

            categoryError == false
                ? const SizedBox()
                : showErrorWidget(
                    'Ware House Category', 'Field Cannot Be Empty'),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 440,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('WareHouse Sub Category Name'),
                          // GestureDetector(
                          //   onTap: () {
                          //     showDialog(
                          //         context: context,
                          //         builder: (ctx) =>
                          //             AddWareHouseSubCategoryDialog(
                          //               reFresh: (int value) {},
                          //             ));
                          //   },
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: const [
                          //       Icon(Icons.add_circle_outline),
                          //       SizedBox(
                          //         width: 5,
                          //       ),
                          //       Text('Add')
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
                            value: warehouseSubCategoryId,
                            items: warehouseSubCategory
                                .map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                value: e['WareHouse_Sub_Category_Name'],
                                onTap: () {
                                  wareHouseDetails[
                                          'WareHouse_Sub_Category_Id'] =
                                      e['WareHouse_Sub_Category_Id'];
                                },
                                child: Text(e['WareHouse_Sub_Category_Name']),
                              );
                            }).toList(),
                            hint: const Text(
                                'Choose WareHouse Sub Category Name'),
                            onChanged: (value) {
                              setState(() {
                                warehouseSubCategoryId = value as String;
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
            subCategoryError == false
                ? const SizedBox()
                : showErrorWidget(
                    'Ware House Sub Category', 'Field Cannot Be Empty'),
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
                      child: const Text('WareHouse Code:'),
                    ),
                    Container(
                      width: 440,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(
                            color: wareHouseCodeError == false
                                ? Colors.black26
                                : const Color.fromRGBO(243, 60, 60, 1)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: TextFormField(
                          controller: warehouseCodeController,
                          decoration: InputDecoration(
                              hintText: wareHouseCodeError == false
                                  ? 'Ware House Code'
                                  : '',
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                wareHouseCodeError = true;
                              });
                              fieldError = true;
                            }
                          },
                          onSaved: (value) {
                            wareHouseDetails['WareHouse_Code'] = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            wareHouseCodeError == false
                ? const SizedBox()
                : showErrorWidget('Ware House Code', 'Field Cannot Be Empty'),
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
                      child: const Text('WareHouse Name:'),
                    ),
                    Container(
                      width: 440,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(
                            color: wareHouseNameError == false
                                ? Colors.black26
                                : const Color.fromRGBO(243, 60, 60, 1)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: wareHouseNameError == false
                                  ? 'WareHouse Name'
                                  : '',
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                wareHouseNameError = true;
                              });
                              fieldError = true;
                            }
                          },
                          onSaved: (value) {
                            wareHouseDetails['WareHouse_Name'] = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            wareHouseNameError == false
                ? const SizedBox()
                : showErrorWidget('Ware House Name', 'Field Cannot Be Empty'),
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
                      child: const Text('Description:'),
                    ),
                    Container(
                      width: 440,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(
                            color: descriptionError == false
                                ? Colors.black26
                                : const Color.fromRGBO(243, 60, 60, 1)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: descriptionError == false
                                  ? 'Description'
                                  : '',
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                descriptionError = true;
                              });
                              fieldError = true;
                            }
                          },
                          onSaved: (value) {
                            wareHouseDetails['Description'] = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            descriptionError == false
                ? const SizedBox()
                : showErrorWidget('Description', 'Field Cannot Be Empty'),

            Consumer<InfrastructureApis>(builder: (context, value, child) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.wareHouseException.length,
                itemBuilder: (BuildContext context, int index) {
                  return ModularWidgets.exceptionDesign(
                      MediaQuery.of(context).size,
                      value.wareHouseException[index][0]);
                },
              );
            }),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       update == false
            //           ? Padding(
            //               padding: const EdgeInsets.symmetric(vertical: 30.0),
            //               child: SizedBox(
            //                 width: 200,
            //                 height: 48,
            //                 child: ElevatedButton(
            //                     style: ButtonStyle(
            //                       backgroundColor: MaterialStateProperty.all(
            //                         const Color.fromRGBO(44, 96, 154, 1),
            //                       ),
            //                     ),
            //                     onPressed: save,
            //                     child: Text(
            //                       'Add Details',
            //                       style: GoogleFonts.roboto(
            //                         textStyle: const TextStyle(
            //                           fontWeight: FontWeight.w500,
            //                           fontSize: 18,
            //                           color: Color.fromRGBO(255, 254, 254, 1),
            //                         ),
            //                       ),
            //                     )),
            //               ),
            //             )
            //           : Padding(
            //               padding: const EdgeInsets.symmetric(vertical: 74.0),
            //               child: SizedBox(
            //                 width: 200,
            //                 height: 48,
            //                 child: ElevatedButton(
            //                     style: ButtonStyle(
            //                       backgroundColor: MaterialStateProperty.all(
            //                         const Color.fromRGBO(44, 96, 154, 1),
            //                       ),
            //                     ),
            //                     onPressed: updateData,
            //                     child: Text(
            //                       'Update',
            //                       style: GoogleFonts.roboto(
            //                         textStyle: const TextStyle(
            //                           fontWeight: FontWeight.w500,
            //                           fontSize: 18,
            //                           color: Color.fromRGBO(255, 254, 254, 1),
            //                         ),
            //                       ),
            //                     )),
            //               ),
            //             ),
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

  Form getSectionCount(BuildContext context) {
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

    return Form(
        key: _sectionKey,
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
                      'WareHouse Id',
                      style: keyStyle(),
                    ),
                    Text(_wareHouseCode ?? ''),
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
                      'WareHouse Name',
                      style: keyStyle(),
                    ),
                    Text(_wareHouseName ?? ''),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Text(
                    'Sections',
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
                      child: const Text('Section Count:'),
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              hintText: 'Enter Section Count',
                              border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              if (value != '') {
                                count = int.parse(value);
                              } else {
                                count = 0;
                              }
                            });
                          },
                          onSaved: (value) {
                            wareHouseDetails['WareHouse_Name'] = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            count == 0
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Enter Section Details For Each Section',
                      style: keyStyle(),
                    ),
                  ),
            count == 0
                ? const SizedBox()
                : Container(
                    height: 350,
                    child: GetSectionList(
                      success: _isSucess,
                      count: count,
                      data: run,
                      wareHouseCode: _wareHouseCode,
                      wareHouseName: _wareHouseName,
                      submittedSectionData: wareHouseSectionDetailsList,
                    ),
                  ),
          ],
        ));
  }

  Form addSectionLines(BuildContext context) {
    var size = MediaQuery.of(context).size;
    TextStyle getStyle() {
      return GoogleFonts.roboto(
          textStyle:
              const TextStyle(fontWeight: FontWeight.w400, fontSize: 14));
    }

    return Form(
      key: _updateAllLineKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                Text(
                  'Section Lines',
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
                    child: const Text('Section Code:'),
                  ),
                  Container(
                    width: 440,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(
                          color: sectionCodeError == false
                              ? Colors.black26
                              : const Color.fromRGBO(243, 60, 60, 1)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: TextFormField(
                        controller: sectionController,
                        decoration: InputDecoration(
                            hintText:
                                sectionCodeError == false ? 'Section Code' : '',
                            border: InputBorder.none),
                        onChanged: (value) {
                          sectionCode = value;
                          if (lineCount != 0) {
                            lineIds.clear();
                            _selected = false;
                            generateLineCount(lineCount);
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              sectionCodeError = true;
                              fieldError = true;
                            });
                          }
                        },
                        onSaved: (value) {
                          wareHouseDetails['WareHouse_Name'] = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          sectionCodeError == false
              ? const SizedBox()
              : showErrorWidget('Section Code', 'Field Cannot Be Empty'),
          sectionCodeValidation == true
              ? const SizedBox()
              : ModularWidgets.validationDesign(
                  size, sectionCodeValidationMessage),
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
                    child: const Text('Line Count:'),
                  ),
                  Container(
                    width: 440,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(
                          color: sectionLineCountError == false
                              ? Colors.black26
                              : const Color.fromRGBO(243, 60, 60, 1)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: TextFormField(
                        controller: lineCountController,
                        maxLength: 2,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            hintText: sectionLineCountError == false
                                ? 'Total Number of Lines'
                                : '',
                            border: InputBorder.none),
                        onChanged: (value) {
                          if (value != '') {
                            int data = int.parse(value);
                            if (data.isOdd) {
                              Get.defaultDialog(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  title: 'Alert',
                                  titleStyle: TextStyle(
                                      color: ProjectColors.themecolor),
                                  middleText:
                                      'You have entered an odd number would you Like to continue with that',
                                  confirm: TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(
                                            color: ProjectColors.themecolor),
                                      )),
                                  cancel: TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: ProjectColors.themecolor),
                                      )));
                            }
                            lineCount = int.parse(value);
                            generateLineCount(int.parse(value));
                            individualLineDataList.clear();
                            selectedCode = null;
                          } else {
                            lineCount = 0;
                            lineIds.clear();
                            individualLineDataList.clear();
                            selectedCode = null;
                            setState(() {});
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              sectionLineCountError = true;
                              fieldError = true;
                            });
                          }
                        },
                        onSaved: (value) {
                          wareHouseDetails['WareHouse_Name'] = value!;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          sectionLineCountError == false
              ? const SizedBox()
              : showErrorWidget('Line Count', 'Field Cannot Be Empty'),
          lineCountValidation == true
              ? const SizedBox()
              : ModularWidgets.validationDesign(
                  size, lineCountValidationMessage),
          wareHouseSectionDetailsList.isEmpty
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 12),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 440,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text('Copy From:'),
                        ],
                      ),
                    ),
                  ),
                ),
          wareHouseSectionDetailsList.isEmpty
              ? const SizedBox()
              : Align(
                  alignment: Alignment.topLeft,
                  child: Container(
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
                          value: selectedCode,
                          items: wareHouseSectionDetailsList
                              .map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem(
                              value: e['WareHouse_Section_Code'],
                              onTap: () {
                                if (lineCount == 0) {
                                  Get.showSnackbar(GetSnackBar(
                                    duration: const Duration(seconds: 2),
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    message: 'Select the Line IDs first',
                                    title: 'Alert',
                                  ));
                                } else {
                                  generateLineCount(
                                      e['Section_Details'].length);
                                  List temp = [];
                                  for (int i = 0;
                                      i < e['Section_Details'].length;
                                      i++) {
                                    temp.add({
                                      'Section_Code': sectionController.text,
                                      'WareHouse_Section_Line_Code': lineIds[i],
                                      'WareHouse_Section_Line_Number_Of_Boxes': e[
                                                  'Section_Details'][i][
                                              'warehouse_section_line__WareHouse_Section_Line_Number_Of_Boxes']
                                          .toString(),
                                      'WareHouse_Section_Line_Maximum_Box_Capacity': e[
                                                  'Section_Details'][i][
                                              'warehouse_section_line__WareHouse_Section_Line_Maximum_Box_Capacity']
                                          .toString(),
                                      'WareHouse_Section_Line_Box_Length': e[
                                                  'Section_Details'][i][
                                              'warehouse_section_line__WareHouse_Section_Line_Box_Length']
                                          .toString(),
                                      'WareHouse_Section_Line_Box_Breadth': e[
                                                  'Section_Details'][i][
                                              'warehouse_section_line__WareHouse_Section_Line_Box_Breadth']
                                          .toString(),
                                      'WareHouse_Section_Line_Box_Height': e[
                                              'Section_Details'][i][
                                          'warehouse_section_line__WareHouse_Section_Line_Box_Height']
                                        ..toString(),
                                    });
                                  }
                                  setState(() {
                                    individualLineDataList = temp;
                                    _selected = true;
                                    lineIds.clear();
                                    selected.clear();
                                  });
                                }
                              },
                              child: Text(e['WareHouse_Section_Code']),
                            );
                          }).toList(),
                          hint: const Text('Select'),
                          onChanged: (value) {
                            setState(() {
                              selectedCode = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
          _selected == true
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        lineIds.isEmpty
                            ? const SizedBox()
                            : Container(
                                width: 440,
                                height: 30,
                                alignment: Alignment.center,
                                child: ListView.builder(
                                  controller: horizontalController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: lineIds.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Text(
                                      ' ${lineIds[index]},',
                                      style: getStyle(),
                                    );
                                  },
                                ),
                              ),
                        Container(
                          width: 440,
                          height: 450,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(190, 190, 190, 1)),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SingleChildScrollView(
                              controller: allLineController,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 374,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: const Text('Box Count:'),
                                  ),
                                  Container(
                                    width: 374,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: boxCountError == false
                                              ? Colors.black26
                                              : const Color.fromRGBO(
                                                  243, 60, 60, 1)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: TextFormField(
                                        maxLength: 4,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: boxCountController,
                                        decoration: InputDecoration(
                                            hintText: boxCountError == false
                                                ? 'Total Number of Boxes'
                                                : '',
                                            border: InputBorder.none),
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            setState(() {
                                              boxCountError = true;
                                              fieldError = true;
                                            });
                                          }
                                        },
                                        onSaved: (value) {
                                          updateAllLines['Box_Count'] = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                  boxCountError == false
                                      ? const SizedBox()
                                      : showCustomErrorWidget('Line Count',
                                          'Field Cannot Be Empty'),
                                  boxCountValidation == true
                                      ? const SizedBox()
                                      : Container(
                                          width: 374,
                                          child:
                                              ModularWidgets.validationDesign(
                                                  size,
                                                  boxCountValidationMessage),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Container(
                                      width: 374,
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: const Text('Max Box Capacity'),
                                    ),
                                  ),
                                  Container(
                                    width: 374,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: maxBoxCapacityError == false
                                              ? Colors.black26
                                              : const Color.fromRGBO(
                                                  243, 60, 60, 1)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: TextFormField(
                                        maxLength: 2,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: maxBoxCapacityController,
                                        decoration: InputDecoration(
                                            hintText:
                                                maxBoxCapacityError == false
                                                    ? 'Maximum Box Capacity'
                                                    : '',
                                            border: InputBorder.none),
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            setState(() {
                                              maxBoxCapacityError = true;
                                              fieldError = true;
                                            });
                                          }
                                        },
                                        onSaved: (value) {
                                          updateAllLines[
                                                  'WareHouse_Section_Line_Maximum_Box_Capacity'] =
                                              value!;
                                        },
                                      ),
                                    ),
                                  ),
                                  maxBoxCapacityError == false
                                      ? const SizedBox()
                                      : showCustomErrorWidget(
                                          'Max Box Capacity ',
                                          'Field Cannot Be Empty'),
                                  maxBoxCapacityValidation == true
                                      ? const SizedBox()
                                      : Container(
                                          width: 374,
                                          child: ModularWidgets.validationDesign(
                                              size,
                                              maxBoxCapacityValidationMessage),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Container(
                                      width: 374,
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: const Text('Box Height(inches)'),
                                    ),
                                  ),
                                  Container(
                                    width: 374,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: boxHeightError == false
                                              ? Colors.black26
                                              : const Color.fromRGBO(
                                                  243, 60, 60, 1)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d{1,2}\.?\d{0,3}'))
                                          // r'^\d{1,3}(\.\d)?$'
                                        ],
                                        controller: boxHeightController,
                                        decoration: InputDecoration(
                                            hintText: boxHeightError == false
                                                ? 'Eg:12.123'
                                                : '',
                                            border: InputBorder.none),
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            setState(() {
                                              boxHeightError = true;
                                              fieldError = true;
                                            });
                                          }
                                        },
                                        onSaved: (value) {
                                          updateAllLines['Height'] = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                  boxHeightError == false
                                      ? const SizedBox()
                                      : showCustomErrorWidget('Box Height ',
                                          'Field Cannot Be Empty'),
                                  boxHeightValidation == true
                                      ? const SizedBox()
                                      : Container(
                                          width: 374,
                                          child:
                                              ModularWidgets.validationDesign(
                                                  size,
                                                  boxHeightValidationMessage),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Container(
                                      width: 374,
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: const Text('Box Breadth(inches)'),
                                    ),
                                  ),
                                  Container(
                                    width: 374,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: boxBreadthError == false
                                              ? Colors.black26
                                              : const Color.fromRGBO(
                                                  243, 60, 60, 1)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d{1,2}\.?\d{0,3}'))
                                          // r'^\d{1,3}(\.\d)?$'
                                        ],
                                        controller: boxBreadthController,
                                        decoration: InputDecoration(
                                            hintText: boxBreadthError == false
                                                ? 'Eg:12.123'
                                                : '',
                                            border: InputBorder.none),
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            setState(() {
                                              boxBreadthError = true;
                                              fieldError = true;
                                            });
                                          }
                                        },
                                        onSaved: (value) {
                                          updateAllLines['Breadth'] = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                  boxBreadthError == false
                                      ? const SizedBox()
                                      : showCustomErrorWidget('Box Breadth ',
                                          'Field Cannot Be Empty'),
                                  boxBreadthValidation == true
                                      ? const SizedBox()
                                      : Container(
                                          width: 374,
                                          child:
                                              ModularWidgets.validationDesign(
                                                  size,
                                                  boxBreadthValidationMessage),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Container(
                                      width: 374,
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: const Text('Box Length(inches)'),
                                    ),
                                  ),
                                  Container(
                                    width: 374,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: boxLengthError == false
                                              ? Colors.black26
                                              : const Color.fromRGBO(
                                                  243, 60, 60, 1)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      child: TextFormField(
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        // maxLength: 5,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d{1,2}\.?\d{0,2}'))
                                          // r'^\d{1,3}(\.\d)?$'
                                        ],
                                        controller: boxLengthController,
                                        decoration: InputDecoration(
                                            hintText: boxLengthError == false
                                                ? 'Eg:12.12'
                                                : '',
                                            border: InputBorder.none),
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            setState(() {
                                              boxLengthError = true;
                                            });
                                            fieldError = true;
                                          }
                                        },
                                        onSaved: (value) {
                                          updateAllLines['Length'] = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                  boxLengthError == false
                                      ? const SizedBox()
                                      : showCustomErrorWidget('Box Length',
                                          'Field Cannot Be Empty'),
                                  boxLengthValidation == true
                                      ? const SizedBox()
                                      : Container(
                                          width: 374,
                                          child:
                                              ModularWidgets.validationDesign(
                                                  size,
                                                  boxLengthValidationMessage),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Enter Specifically for each Line'),
                    Checkbox(
                        value: _selected,
                        onChanged: (value) {
                          setState(() {
                            if (value == false) {
                              individualLineDataList.clear();
                              selectedCode = null;
                              generateLineCount(lineCount);
                            }
                            // for (var data in temp) {
                            //   popUpMenuList.add(PopupMenuItem(
                            //       child: CheckboxListTile(
                            //           title: Text(
                            //             data['Id'],
                            //           ),
                            //           value: data['Selected'],
                            //           onChanged: (value) {
                            //             setState(() {
                            //               data['Selected'] = value;
                            //             });
                            //           })));
                            // }
                            _selected = value!;
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Lines'),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add_circle_outline_outlined,
                          color: Theme.of(context).backgroundColor,
                        ))
                  ],
                ),
              ],
            ),
          ),
          _selected == false
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Line Ids'),
                            ],
                          ),
                        ),
                        Container(
                          width: 440,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            // border: Border.all(color: Colors.black26),
                          ),
                          child: DropDownMultiSelect(
                              options: lineIds,
                              selectedValues: selected,
                              onChanged: (List<String> x) {
                                setState(() {
                                  selected = x;
                                });
                              },
                              whenEmpty: 'Select'),
                        ),
                      ],
                    ),
                  ),
                ),
          individualLineDataList.isEmpty
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 500,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: individualLineDataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DisplaySingleLineData(
                            individualLineDataList: individualLineDataList,
                            index: index,
                            key: UniqueKey(),
                            delete: deleteSingleLineData,
                          );
                        },
                      ),
                    ),
                  ),
                ),
          _selected == false
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      controller: individualLineController,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // temp.isEmpty
                          //     ? const SizedBox()
                          //     : Container(
                          //         width: 440,
                          //         height: 30,
                          //         child: ListView.builder(
                          //           scrollDirection: Axis.horizontal,
                          //           itemCount: temp.length,
                          //           itemBuilder: (BuildContext context, int index) {
                          //             return Text(
                          //               ' ${temp[index]},',
                          //               style: getStyle(),
                          //             );
                          //           },
                          //         ),
                          //       ),
                          Form(
                            key: _updateSingleLineKey,
                            child: Container(
                              width: 440,
                              height: 470,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          190, 190, 190, 1)),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 374,
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: const Text('Box Count:'),
                                      ),
                                      Container(
                                        width: 374,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          border: Border.all(
                                              color:
                                                  singleBoxCountError == false
                                                      ? Colors.black26
                                                      : const Color.fromRGBO(
                                                          243, 60, 60, 1)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            controller: boxCountController,
                                            decoration: InputDecoration(
                                                hintText: singleBoxCountError ==
                                                        false
                                                    ? 'Total Number of Boxes'
                                                    : '',
                                                border: InputBorder.none),
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                setState(() {
                                                  singleBoxCountError = true;
                                                  fieldError = true;
                                                });
                                              }
                                            },
                                            onSaved: (value) {
                                              updateSingleLines['Box_Count'] =
                                                  value!;
                                            },
                                          ),
                                        ),
                                      ),
                                      singleBoxCountError == false
                                          ? const SizedBox()
                                          : showCustomErrorWidget('Box Count',
                                              'Field Cannot Be Empty'),
                                      boxCountValidation == true
                                          ? const SizedBox()
                                          : Container(
                                              width: 374,
                                              child: ModularWidgets
                                                  .validationDesign(size,
                                                      boxCountValidationMessage),
                                            ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Container(
                                          width: 374,
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child:
                                              const Text('Max Box Capacity:'),
                                        ),
                                      ),
                                      Container(
                                        width: 374,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          border: Border.all(
                                            color:
                                                singleMaxBoxCountError == false
                                                    ? Colors.black26
                                                    : const Color.fromRGBO(
                                                        243, 60, 60, 1),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            controller:
                                                maxBoxCapacityController,
                                            decoration: InputDecoration(
                                                hintText:
                                                    singleMaxBoxCountError ==
                                                            false
                                                        ? 'Maximum Box Capacity'
                                                        : '',
                                                border: InputBorder.none),
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                setState(() {
                                                  singleMaxBoxCountError = true;
                                                  fieldError = true;
                                                });
                                              }
                                            },
                                            onSaved: (value) {
                                              updateSingleLines[
                                                      'WareHouse_Section_Line_Maximum_Box_Capacity'] =
                                                  value!;
                                            },
                                          ),
                                        ),
                                      ),
                                      singleMaxBoxCountError == false
                                          ? const SizedBox()
                                          : showCustomErrorWidget(
                                              'Max Box Capacity',
                                              'Field Cannot Be Empty'),
                                      maxBoxCapacityValidation == true
                                          ? const SizedBox()
                                          : Container(
                                              width: 374,
                                              child: ModularWidgets
                                                  .validationDesign(size,
                                                      maxBoxCapacityValidationMessage),
                                            ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Container(
                                          width: 374,
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: const Text('Box Length'),
                                        ),
                                      ),
                                      Container(
                                        width: 374,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: singleBoxLengthError == false
                                                ? Colors.black26
                                                : const Color.fromRGBO(
                                                    243, 60, 60, 1),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d{1,2}\.?\d{0,2}'))
                                              // r'^\d{1,3}(\.\d)?$'
                                            ],
                                            controller: boxLengthController,
                                            decoration: InputDecoration(
                                                hintText:
                                                    singleBoxLengthError ==
                                                            false
                                                        ? 'Eg:12.12'
                                                        : '',
                                                border: InputBorder.none),
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                setState(() {
                                                  singleBoxLengthError = true;
                                                  fieldError = true;
                                                });
                                              }
                                            },
                                            onSaved: (value) {
                                              updateSingleLines['Length'] =
                                                  value!;
                                            },
                                          ),
                                        ),
                                      ),
                                      singleBoxLengthError == false
                                          ? const SizedBox()
                                          : showCustomErrorWidget('Box Length',
                                              'Field Cannot Be Empty'),
                                      boxLengthValidation == true
                                          ? const SizedBox()
                                          : Container(
                                              width: 374,
                                              child: ModularWidgets
                                                  .validationDesign(size,
                                                      boxLengthValidationMessage),
                                            ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Container(
                                          width: 374,
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: const Text('Box Height'),
                                        ),
                                      ),
                                      Container(
                                        width: 374,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: singleBoxHeightError == false
                                                ? Colors.black26
                                                : const Color.fromRGBO(
                                                    243, 60, 60, 1),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d{1,2}\.?\d{0,3}'))
                                              // r'^\d{1,3}(\.\d)?$'
                                            ],
                                            controller: boxHeightController,
                                            decoration: InputDecoration(
                                                hintText:
                                                    singleBoxHeightError ==
                                                            false
                                                        ? 'Eg:12.123'
                                                        : '',
                                                border: InputBorder.none),
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                setState(() {
                                                  singleBoxHeightError = true;
                                                  fieldError = true;
                                                });
                                              }
                                            },
                                            onSaved: (value) {
                                              updateSingleLines['Height'] =
                                                  value!;
                                            },
                                          ),
                                        ),
                                      ),
                                      singleBoxHeightError == false
                                          ? const SizedBox()
                                          : showCustomErrorWidget('Box Height',
                                              'Field Cannot Be Empty'),
                                      boxHeightValidation == true
                                          ? const SizedBox()
                                          : Container(
                                              width: 374,
                                              child: ModularWidgets
                                                  .validationDesign(size,
                                                      boxHeightValidationMessage),
                                            ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Container(
                                          width: 374,
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: const Text('Box Breadth'),
                                        ),
                                      ),
                                      Container(
                                        width: 374,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          border: Border.all(
                                            color:
                                                singleBoxBreadthError == false
                                                    ? Colors.black26
                                                    : const Color.fromRGBO(
                                                        243, 60, 60, 1),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d{1,2}\.?\d{0,3}'))
                                              // r'^\d{1,3}(\.\d)?$'
                                            ],
                                            controller: boxBreadthController,
                                            decoration: InputDecoration(
                                                hintText:
                                                    singleBoxBreadthError ==
                                                            false
                                                        ? 'Eg:12.123'
                                                        : '',
                                                border: InputBorder.none),
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                setState(() {
                                                  singleBoxBreadthError = true;
                                                  fieldError = true;
                                                });
                                              }
                                            },
                                            onSaved: (value) {
                                              updateSingleLines['Breadth'] =
                                                  value!;
                                            },
                                          ),
                                        ),
                                      ),
                                      singleBoxBreadthError == false
                                          ? const SizedBox()
                                          : showCustomErrorWidget('Box Breadth',
                                              'Field Cannot Be Empty'),
                                      boxBreadthValidation == true
                                          ? const SizedBox()
                                          : Container(
                                              width: 374,
                                              child: ModularWidgets
                                                  .validationDesign(size,
                                                      boxBreadthValidationMessage),
                                            ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                const Color.fromRGBO(
                                                    44, 96, 154, 1),
                                              ),
                                            ),
                                            onPressed: () {
                                              // bool status = _updateSingleLineKey
                                              //     .currentState!
                                              //     .validate();

                                              // if (status != true) {
                                              //   return;
                                              // }
                                              // if (fieldError == true) {
                                              //   return;
                                              // }

                                              bool validate = validateAll();

                                              if (validate != true) {
                                                setState(() {});
                                                return;
                                              }

                                              _updateSingleLineKey.currentState!
                                                  .save();

                                              if (individualLineDataList
                                                  .isEmpty) {
                                                for (int i = 0;
                                                    i < selected.length;
                                                    i++) {
                                                  // updateSingleLines['Line_Id'] =
                                                  //     selected[i];

                                                  individualLineDataList.add({
                                                    'Section_Code': sectionCode,
                                                    'WareHouse_Section_Line_Code':
                                                        selected[i],
                                                    'WareHouse_Section_Line_Number_Of_Boxes':
                                                        updateSingleLines[
                                                            'Box_Count'],
                                                    'WareHouse_Section_Line_Maximum_Box_Capacity':
                                                        updateSingleLines[
                                                            'WareHouse_Section_Line_Maximum_Box_Capacity'],
                                                    'WareHouse_Section_Line_Box_Length':
                                                        updateSingleLines[
                                                            'Length'],
                                                    'WareHouse_Section_Line_Box_Breadth':
                                                        updateSingleLines[
                                                            'Breadth'],
                                                    'WareHouse_Section_Line_Box_Height':
                                                        updateSingleLines[
                                                            'Height'],
                                                  });
                                                }

                                                for (int i = 0;
                                                    i < selected.length;
                                                    i++) {
                                                  for (int j = 0;
                                                      j < lineIds.length;
                                                      j++) {
                                                    if (lineIds[j] ==
                                                        selected[i]) {
                                                      lineIds.removeAt(j);
                                                    }
                                                  }
                                                }
                                                selected.clear();
                                              } else {
                                                if (selected.isEmpty) {
                                                  Get.showSnackbar(GetSnackBar(
                                                    duration: const Duration(
                                                        seconds: 2),
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .backgroundColor,
                                                    message:
                                                        'Select the Line IDs first',
                                                    title: 'Alert',
                                                  ));
                                                } else {
                                                  for (int i = 0;
                                                      i < selected.length;
                                                      i++) {
                                                    updateSingleLines[
                                                            'Line_Id'] =
                                                        selected[i];

                                                    individualLineDataList.add({
                                                      'Section_Code':
                                                          sectionCode,
                                                      'WareHouse_Section_Line_Code':
                                                          selected[i],
                                                      'WareHouse_Section_Line_Number_Of_Boxes':
                                                          updateSingleLines[
                                                              'Box_Count'],
                                                      'WareHouse_Section_Line_Maximum_Box_Capacity':
                                                          updateSingleLines[
                                                              'WareHouse_Section_Line_Maximum_Box_Capacity'],
                                                      'WareHouse_Section_Line_Box_Length':
                                                          updateSingleLines[
                                                              'Length'],
                                                      'WareHouse_Section_Line_Box_Breadth':
                                                          updateSingleLines[
                                                              'Breadth'],
                                                      'WareHouse_Section_Line_Box_Height':
                                                          updateSingleLines[
                                                              'Height'],
                                                    });
                                                  }
                                                  for (int i = 0;
                                                      i < selected.length;
                                                      i++) {
                                                    for (int j = 0;
                                                        j < lineIds.length;
                                                        j++) {
                                                      if (lineIds[j] ==
                                                          selected[i]) {
                                                        lineIds.removeAt(j);
                                                      }
                                                    }
                                                  }
                                                  selected.clear();
                                                }
                                              }
                                              setState(() {});
                                            },
                                            child: Text(
                                              'Add',
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          formError == false
              ? const SizedBox()
              : Container(
                  width: 440,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.red[700]!),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Line Count Cannot Be Empty'),
                          Text('Enter Line Count'),
                        ],
                      )),
                ),
        ],
      ),
    );
  }

  void deleteSingleLineData(Map<String, dynamic> value) {
    setState(() {
      individualLineDataList.removeAt(value['Index']);
      lineIds.add(value['Line_Id']);
    });
  }
}

class DisplaySingleLineData extends StatelessWidget {
  const DisplaySingleLineData({
    Key? key,
    required this.individualLineDataList,
    required this.index,
    required this.delete,
  }) : super(key: key);

  final List individualLineDataList;
  final int index;
  final ValueChanged<Map<String, dynamic>> delete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: Colors.black26),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Line Id'),
                  Text(individualLineDataList[index]
                          ['WareHouse_Section_Line_Code'] ??
                      ''),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Box Count'),
                  Text(individualLineDataList[index]
                      ['WareHouse_Section_Line_Number_Of_Boxes']),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Max Box Capacity'),
                  Text(individualLineDataList[index]
                          ['WareHouse_Section_Line_Maximum_Box_Capacity'] ??
                      ''),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Box Dimensions(L,B,H)'),
                  Text(
                      '${individualLineDataList[index]['WareHouse_Section_Line_Box_Length']}, ${individualLineDataList[index]['WareHouse_Section_Line_Box_Breadth']},${individualLineDataList[index]['WareHouse_Section_Line_Box_Height']}'),
                ],
              ),
              IconButton(
                onPressed: () {
                  delete({
                    'Line_Id': individualLineDataList[index]
                        ['WareHouse_Section_Line_Code'],
                    'Index': index
                  });
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GetSectionList extends StatelessWidget {
  const GetSectionList({
    Key? key,
    required this.count,
    required this.data,
    required this.wareHouseName,
    required this.wareHouseCode,
    required this.success,
    required this.submittedSectionData,
  }) : super(key: key);

  final int count;
  final ValueChanged<Map<String, dynamic>> data;
  final String wareHouseName;
  final String wareHouseCode;
  final List submittedSectionData;
  final bool success;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        var text =
            '${wareHouseName.characters.first + wareHouseCode}${index + 1}';
        return submittedSectionData.isEmpty ||
                submittedSectionData.length <= index
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Section${index + 1}'),
                    const SizedBox(
                      height: 8,
                    ),
                    IconButton(
                        onPressed: () {
                          data({
                            'Section_Code': text,
                            'Section_Count': 'Section${index + 1}'
                          });
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
              )
            : submittedSectionData[index]['Section_Name'] ==
                    'Section${index + 1}'
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Section${index + 1}'),
                              // IconButton(
                              //     onPressed: () {
                              //       data({
                              //         'Section_Code': text,
                              //         'Section_Count': 'Section${index + 1}'
                              //       });
                              //     },
                              //     icon: const Icon(Icons.add))
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Section Code:'),
                              Text(submittedSectionData[index]
                                  ['WareHouse_Section_Code']),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Total Number Of Lines:'),
                              Text(submittedSectionData[index]
                                      ['Section_Details']
                                  .length
                                  .toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Section${index + 1}'),
                        IconButton(
                            onPressed: () {
                              data({
                                'Section_Code': text,
                                'Section_Count': 'Section${index + 1}'
                              });
                            },
                            icon: const Icon(Icons.add))
                      ],
                    ),
                  );
      },
    );
  }
}

class DataWidget extends StatefulWidget {
  DataWidget({
    Key? key,
    required this.list,
  }) : super(key: key);
  final List<String> list;

  @override
  _DataWidgetState createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  List<String> selected = [];
  @override
  Widget build(BuildContext context) {
    return DropDownMultiSelect(
        options: widget.list,
        selectedValues: selected,
        onChanged: (List<String> x) {
          setState(() {
            selected = x;
          });
        },
        whenEmpty: 'Select');
  }
}
