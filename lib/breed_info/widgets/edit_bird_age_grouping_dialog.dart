import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/breed_info_apicalls.dart';

class EditBirdAgeGroupingDialog extends StatefulWidget {
  EditBirdAgeGroupingDialog(
      {Key? key,
      required this.reFresh,
      required this.breedId,
      required this.name,
      required this.startWeek,
      required this.endWeek,
      required this.birdAgeid})
      : super(key: key);
  final ValueChanged<int> reFresh;
  final int breedId;
  final String name;
  final String startWeek;
  final String endWeek;
  final String birdAgeid;

  @override
  State<EditBirdAgeGroupingDialog> createState() =>
      _EditBirdAgeGroupingDialogState();
}

class _EditBirdAgeGroupingDialogState extends State<EditBirdAgeGroupingDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _singleActivityFormKey = GlobalKey();
  var activityPlanIdError = false;

  Map<String, dynamic> birdsAgeGroup = {
    'Breed_Id': '',
    'Name': '',
    'Start_Week': '',
    'End_Week': '',
  };

  var breedName;

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
    birdsAgeGroup['Breed_Id'] = widget.breedId;
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false).getBreed(token);
      }
    });
    super.initState();
  }

  void save() {
    bool validate = _formKey.currentState!.validate();

    if (validate != true) {
      return;
    }
    _formKey.currentState!.save();

    // print(birdsAgeGroup);

    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false)
            .updateBirdAgeGroup(birdsAgeGroup, widget.birdAgeid, token)
            .then((value) {
          if (value == 201 || value == 200 || value == 202) {
            widget.reFresh(100);
            Get.back();

            successSnackbar('Successfully updated Bird Age Group');
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
    if (breed.isNotEmpty && birdsAgeGroup['Breed_Id'] == widget.breedId) {
      for (var data in breed) {
        if (data['Breed_Id'] == widget.breedId) {
          breedName = data['Breed_Name'];
        }
      }
    }
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
                        'update Bird Age Grouping',
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
                                  value: breedName,
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
                                      breedName = value as String;
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
                                initialValue: widget.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // showError('FirmCode');
                                    return '';
                                  }
                                },
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
                                initialValue: widget.startWeek,
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
                                initialValue: widget.endWeek,
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
                  ModularWidgets.globalUpdateDetailsDialog(size, save),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
