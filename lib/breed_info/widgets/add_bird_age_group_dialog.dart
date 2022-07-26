import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/breed_info/providers/breed_info_apicalls.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../styles.dart';
import '../../widgets/modular_widgets.dart';

class AddBirdAgeGroup extends StatefulWidget {
  AddBirdAgeGroup({Key? key, required this.reFresh}) : super(key: key);
  static const routeName = '/AddBirdAgeGroup';

  final ValueChanged<int> reFresh;

  @override
  _AddBirdAgeGroupState createState() => _AddBirdAgeGroupState();
}

class _AddBirdAgeGroupState extends State<AddBirdAgeGroup> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _singleActivityFormKey = GlobalKey();
  var activityPlanIdError = false;

  Map<String, dynamic> birdsAgeGroup = {
    'Breed_Id': '',
    'Name': '',
    'Start_Week': '',
    'End_Week': '',
  };

  var breedVersionId;
  TextEditingController nameController = TextEditingController();
  TextEditingController startWeekController = TextEditingController();
  TextEditingController endWeekController = TextEditingController();
  bool groupNameValidation = true;
  bool breedNameValidation = true;
  bool startWeekValidation = true;
  bool endWeekValidation = true;
  String groupNameValidationMessage = '';
  String startValidationMessage = '';
  String endValidationMessage = '';
  String breedNameValidationMessage = '';

  bool validate() {
    if (nameController.text == '') {
      groupNameValidationMessage = 'Group name cannot be empty';
      groupNameValidation = false;
    } else {
      groupNameValidation = true;
    }
    if (breedVersionId == null) {
      breedNameValidationMessage = 'Breed name cannot be empty';
      breedNameValidation = false;
    } else {
      breedNameValidation = true;
    }
    if (startWeekController.text == '') {
      startValidationMessage = 'Start week cannot be empty';
      startWeekValidation = false;
    } else {
      startWeekValidation = true;
    }
    if (endWeekController.text == '') {
      endValidationMessage = 'End week cannot be empty';
      endWeekValidation = false;
    } else {
      endWeekValidation = true;
    }

    if (groupNameValidation == true &&
        breedNameValidation == true &&
        startWeekValidation == true &&
        endWeekValidation == true) {
      return true;
    } else {
      return false;
    }
  }

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
    clearBreedException(context);
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false).getBreed(token);
      }
    });
    super.initState();
  }

  bool _validate = true;

  void save() {
    _validate = validate();

    if (_validate != true) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();

    // print(birdsAgeGroup);

    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false)
            .addBirdAgeGroup(birdsAgeGroup, token)
            .then((value) {
          if (value == 201 || value == 200) {
            widget.reFresh(100);
            Get.back();

            successSnackbar('Successfully added Bird Age Group');
          } else {
            widget.reFresh(100);
            Get.back();
            failureSnackbar('Something Went Wrong');
          }
        });
      }
    });
  }

  List breed = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    breed = Provider.of<BreedInfoApis>(context).breedInfo;

    return Container(
      width: size.width * 0.3,
      height: size.height * 0.7,
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
                        'Add Breed',
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
                                        birdsAgeGroup['Breed_Id'] =
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
                          size, breedNameValidationMessage),
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
                            child: const Text('Group Name'),
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
                                        ? 'Enter Group Name'
                                        : '',
                                    border: InputBorder.none),
                                controller: nameController,
                                onSaved: (value) {
                                  birdsAgeGroup['Name'] = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  groupNameValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, groupNameValidationMessage),
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
                            child: const Text('Age From'),
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
                                        ? 'Enter Age From'
                                        : '',
                                    border: InputBorder.none),
                                controller: startWeekController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // showError('FirmCode');
                                    return '';
                                  }
                                },
                                onSaved: (value) {
                                  birdsAgeGroup['Start_Week'] = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  startWeekValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, startValidationMessage),
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
                            child: const Text('Age To'),
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
                                        ? 'Enter Age To'
                                        : '',
                                    border: InputBorder.none),
                                controller: endWeekController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // showError('FirmCode');
                                    return '';
                                  }
                                },
                                onSaved: (value) {
                                  birdsAgeGroup['End_Week'] = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  endWeekValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, endValidationMessage),
                  Consumer<BreedInfoApis>(builder: (context, value, child) {
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
                  ModularWidgets.globalAddDetailsDialog(size, save),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
