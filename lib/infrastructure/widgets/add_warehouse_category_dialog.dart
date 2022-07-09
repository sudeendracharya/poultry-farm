import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/colors.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';

import 'package:provider/provider.dart';

import '../../widgets/modular_widgets.dart';
import '../screens/warehouse_sub_category_screen.dart';

class AddWareHouseCategoryDialog extends StatefulWidget {
  AddWareHouseCategoryDialog(
      {Key? key,
      required this.refresh,
      required this.categoryName,
      required this.categoryDescription,
      required this.categoryId})
      : super(key: key);
  final String categoryName;
  final String categoryDescription;
  final String categoryId;
  final ValueChanged<int> refresh;

  @override
  _AddWareHouseCategoryDialogState createState() =>
      _AddWareHouseCategoryDialogState();
}

class _AddWareHouseCategoryDialogState
    extends State<AddWareHouseCategoryDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var wareHouseCategory = {
    'WareHouse_Category_Name': '',
    'Description': '',
  };

  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryDescriptionController = TextEditingController();

  bool categoryNameValidation = true;
  bool categoryDescriptionValidation = true;

  String categoryNameValidationMessage = '';
  String categoryDescriptionValidationMessage = '';

  bool validate() {
    if (categoryNameController.text.length > 18) {
      categoryNameValidationMessage =
          'Category Name Cannot Be Greater Then 18 Characters';
      categoryNameValidation = false;
    } else if (categoryNameController.text == '') {
      categoryNameValidationMessage = 'Category Name Cannot Be Empty';
      categoryNameValidation = false;
    } else {
      categoryNameValidation = true;
    }

    if (categoryDescriptionController.text.length > 30) {
      categoryDescriptionValidationMessage =
          'Description Cannot Be Greater Then 30 Characters';
      categoryDescriptionValidation = false;
    } else if (categoryDescriptionController.text == '') {
      categoryDescriptionValidationMessage = 'Description Cannot Be Empty';
      categoryDescriptionValidation = false;
    } else {
      categoryDescriptionValidation = true;
    }

    if (categoryNameValidation == true &&
        categoryDescriptionValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  void update(int data) {
    widget.refresh(100);
  }

  @override
  void initState() {
    super.initState();
    categoryNameController.text = widget.categoryName;
    categoryDescriptionController.text = widget.categoryDescription;
    Provider.of<InfrastructureApis>(context, listen: false)
        .infrastructureException
        .clear();
  }

  Future<void> save() async {
    var isValid = validate();
    if (!isValid) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    // print(wareHouseCategoryName);
    if (widget.categoryId == '') {
      try {
        Provider.of<Apicalls>(context, listen: false)
            .tryAutoLogin()
            .then((value) {
          var token = Provider.of<Apicalls>(context, listen: false).token;
          Provider.of<InfrastructureApis>(context, listen: false)
              .addWareHouseCategory(wareHouseCategory, token)
              .then((value) {
            // print(value);
            if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
              Get.back();
              update(10);

              successSnackbar('Successfully Added warehouse Category');
            } else {
              failureSnackbar(
                  'Something went wrong unable to add warehouse category');
            }
          });
        });
      } catch (e) {
        // print(e);
      }
    } else {
      try {
        Provider.of<Apicalls>(context, listen: false)
            .tryAutoLogin()
            .then((value) {
          print(wareHouseCategory);
          var token = Provider.of<Apicalls>(context, listen: false).token;
          Provider.of<InfrastructureApis>(context, listen: false)
              .editWareHouseCategory(
                  wareHouseCategory, widget.categoryId, token)
              .then((value) {
            // print(value);
            if (value == 200 || value == 202) {
              Get.back();
              update(100);
              successSnackbar('Successfully Updated warehouse Category');
            } else {
              failureSnackbar(
                  'Something went wrong unable to Update warehouse category');
            }
          });
        });
      } catch (e) {
        // print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        width: 550,
        height: 350,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                            child: const Text('WareHouse Category Name'),
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
                                decoration: const InputDecoration(
                                    hintText: 'Enter WareHouse category Name',
                                    border: InputBorder.none),
                                controller: categoryNameController,
                                onSaved: (value) {
                                  wareHouseCategory['WareHouse_Category_Name'] =
                                      value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  categoryNameValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, categoryNameValidationMessage),
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
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(color: Colors.black26),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    hintText: 'Enter Description',
                                    border: InputBorder.none),
                                controller: categoryDescriptionController,
                                onSaved: (value) {
                                  wareHouseCategory['Description'] = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  categoryDescriptionValidation == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, categoryDescriptionValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Consumer<InfrastructureApis>(
                        builder: (context, value, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.infrastructureExceptionData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Column(
                              children: [
                                Text(value.infrastructureExceptionData[index]
                                        ['Key'] ??
                                    ''),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(value.infrastructureExceptionData[index]
                                        ['Value'] ??
                                    '')
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: SizedBox(
                            width: 200,
                            height: 48,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    const Color.fromRGBO(44, 96, 154, 1),
                                  ),
                                ),
                                onPressed: save,
                                child: Text(
                                  widget.categoryId == ''
                                      ? 'Add Details'
                                      : 'Update Details',
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
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 200,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(44, 96, 154, 1),
                              ),
                            ),
                            child: Text('Cancel'),
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
