import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/breed_info/providers/breed_info_apicalls.dart';
import 'package:poultry_login_signup/widgets/modular_widgets.dart';
import 'package:provider/provider.dart';

import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../main.dart';
import '../../providers/apicalls.dart';
import '../../styles.dart';

class AddBreedDialog extends StatefulWidget {
  AddBreedDialog({Key? key, required this.reFresh}) : super(key: key);
  final ValueChanged<int> reFresh;
  @override
  State<AddBreedDialog> createState() => _AddBreedDialogState();
}

class _AddBreedDialogState extends State<AddBreedDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _singleActivityFormKey = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController vendorController = TextEditingController();
  var activityPlanIdError = false;

  Map<String, dynamic> breedVersionData = {
    'Breed_Name': '',
    'Vendor': '',
  };

  String _nameValidationSubject = '';
  String _vendorValidationSubject = '';
  bool _validation = true;
  bool breedNameValid = true;
  bool vendorValid = true;

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
    super.initState();
  }

  bool validation() {
    if (nameController.text == '') {
      _nameValidationSubject = 'Breed Name cannot be empty';
      breedNameValid = false;
    } else if (nameController.text.length > 18) {
      _nameValidationSubject =
          'Breed Name cannot be greater then 18 characters';
      breedNameValid = false;
    } else {
      breedNameValid = true;
    }
    if (vendorController.text == '') {
      _vendorValidationSubject = 'Vendor name cannot be empty';
      vendorValid = false;
    } else {
      vendorValid = true;
    }

    if (breedNameValid == true && vendorValid == true) {
      return true;
    } else {
      return false;
    }
  }

  void save() {
    // _formKey.currentState!.save();

    _validation = validation();

    if (_validation != true) {
      setState(() {});
      return;
    } else {
      setState(() {});
    }

    // print(breedVersionData);

    breedVersionData = {
      'Breed_Name': nameController.text,
      'Vendor': vendorController.text,
    };

    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<BreedInfoApis>(context, listen: false)
            .addBreed(breedVersionData, token)
            .then((value) {
          if (value == 201 || value == 200) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: _formKey,
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
                  ModularWidgets().genericFormField(
                    size: size,
                    borderColor: Colors.black26,
                    controller: nameController,
                    formHeader: 'Breed Name',
                    hintText: 'Enter Breed Name',
                    onSaved: breedVersionData['Breed_Name'],
                  ),
                  breedNameValid == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, _nameValidationSubject),
                  ModularWidgets().genericFormField(
                    size: size,
                    borderColor: Colors.black26,
                    controller: vendorController,
                    formHeader: 'Breed Vendor',
                    hintText: 'Enter breed vendor',
                    onSaved: breedVersionData['Vendor'],
                  ),
                  vendorValid == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, _vendorValidationSubject),
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
  // hinttext,onsaved value,controller,border color,formfield header

}
