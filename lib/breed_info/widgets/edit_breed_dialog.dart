import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';
import '../../widgets/modular_widgets.dart';
import '../providers/breed_info_apicalls.dart';

class EditBreedDialog extends StatefulWidget {
  EditBreedDialog(
      {Key? key,
      required this.reFresh,
      required this.breedName,
      required this.vendor,
      required this.breedId})
      : super(key: key);

  final ValueChanged<int> reFresh;
  final String breedName;
  final String vendor;
  final String breedId;

  @override
  State<EditBreedDialog> createState() => _EditBreedDialogState();
}

class _EditBreedDialogState extends State<EditBreedDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _singleActivityFormKey = GlobalKey();
  var activityPlanIdError = false;

  Map<String, dynamic> breedVersionData = {
    'Breed_Name': '',
    'Vendor': '',
  };

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

  void save() {
    bool validate = _formKey.currentState!.validate();

    if (validate != true) {
      return;
    }
    _formKey.currentState!.save();

    // print(breedVersionData);

    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false)
            .updateBreed(breedVersionData, widget.breedId, token)
            .then((value) {
          if (value == 201 || value == 200 || value == 202) {
            widget.reFresh(100);
            Get.back();

            successSnackbar('Successfully added Breed');
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

    return Container(
      width: size.width * 0.3,
      height: size.height * 0.5,
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
                        'Update Breed',
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
                            child: const Text('Breed Name'),
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
                                        ? 'Enter Breed Name'
                                        : '',
                                    border: InputBorder.none),
                                initialValue: widget.breedName,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // showError('FirmCode');
                                    return '';
                                  }
                                },
                                onSaved: (value) {
                                  breedVersionData['Breed_Name'] = value!;
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
                            child: const Text('Vendor'),
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
                                        ? 'Enter Vendor'
                                        : '',
                                    border: InputBorder.none),
                                initialValue: widget.vendor,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // showError('FirmCode');
                                    return '';
                                  }
                                },
                                onSaved: (value) {
                                  breedVersionData['Vendor'] = value!;
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
