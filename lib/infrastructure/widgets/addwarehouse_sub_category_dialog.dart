import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:poultry_login_signup/colors.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:poultry_login_signup/styles.dart';
import 'package:provider/provider.dart';

import '../../widgets/modular_widgets.dart';

class AddWareHouseSubCategoryDialog extends StatefulWidget {
  AddWareHouseSubCategoryDialog(
      {Key? key,
      required this.reFresh,
      this.subcategoryName,
      this.description,
      this.wareHouseCategoryId,
      this.warehouseSubCategoryId})
      : super(key: key);
  var wareHouseCategoryId;
  var subcategoryName;
  var description;
  var warehouseSubCategoryId;
  final ValueChanged<int> reFresh;
  @override
  _AddWareHouseSubCategoryDialogState createState() =>
      _AddWareHouseSubCategoryDialogState();
}

class _AddWareHouseSubCategoryDialogState
    extends State<AddWareHouseSubCategoryDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, dynamic> wareHouseSubCategory = {
    'WareHouse_Category_Id': '',
    'WareHouse_Sub_Category_Name': '',
    'Description': '',
  };
  var wareHouseId;

  List warehouseCategory = [];

  var warehouseCategoryId;

  TextEditingController subCategoryNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool subCategoryNameValidate = true;
  bool descriptionValidate = true;
  bool categoryIdValidate = true;

  String subCategoryNameValidateMessage = '';
  String descriptionValidateMessage = '';
  String categoryIdValidateMessage = '';

  @override
  void initState() {
    super.initState();
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseCategory(token)
          .then((value1) {});
      subCategoryNameController.text = widget.subcategoryName ?? '';
      descriptionController.text = widget.description ?? '';
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
    });
  }

  bool validate() {
    if (subCategoryNameController.text.length > 18) {
      subCategoryNameValidateMessage =
          'Sub Category Name Cannot Be Greater then 18 Characters';
      subCategoryNameValidate = false;
    } else if (subCategoryNameController.text == '') {
      subCategoryNameValidateMessage = 'Sub Category Name Cannot Be Empty';
      subCategoryNameValidate = false;
    } else {
      subCategoryNameValidate = true;
    }
    if (descriptionController.text.length > 30) {
      subCategoryNameValidateMessage =
          'Description Cannot Be Greater then 30 Characters';
      subCategoryNameValidate = false;
    } else if (descriptionController.text == '') {
      descriptionValidateMessage = 'Description Cannot Be Empty';
      descriptionValidate = false;
    } else {
      descriptionValidate = true;
    }

    if (warehouseCategoryId == null) {
      categoryIdValidateMessage = 'Select Category Name';
      categoryIdValidate = false;
    } else {
      categoryIdValidate = true;
    }

    if (subCategoryNameValidate == true &&
        descriptionValidate == true &&
        categoryIdValidate == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> save() async {
    var isValid = validate();
    if (!isValid) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    // print(wareHouseSubCategory);
    if (widget.warehouseSubCategoryId == null) {
      try {
        Provider.of<Apicalls>(context, listen: false)
            .tryAutoLogin()
            .then((value) {
          var token = Provider.of<Apicalls>(context, listen: false).token;
          Provider.of<InfrastructureApis>(context, listen: false)
              .addWareHouseSubCategory(wareHouseSubCategory, token)
              .then((value) {
            if (value == 200 || value == 201) {
              widget.reFresh(100);
              Get.back();
              successSnackbar('Successfully Added WareHouse Sub Category');
            } else {
              widget.reFresh(100);
              failureSnackbar('Something Went Wrong Unable to Add data');
            }
          });
        });
      } catch (e) {
        print(e);
      }
    } else {
      try {
        Provider.of<Apicalls>(context, listen: false)
            .tryAutoLogin()
            .then((value) {
          var token = Provider.of<Apicalls>(context, listen: false).token;
          Provider.of<InfrastructureApis>(context, listen: false)
              .editWareHouseSubCategory(
            wareHouseSubCategory,
            widget.warehouseSubCategoryId,
            token,
          )
              .then((value) {
            if (value == 200 || value == 202) {
              widget.reFresh(100);
              Get.back();
              successSnackbar('Successfully Updated WareHouse Sub Category');
            } else {
              widget.reFresh(100);
              failureSnackbar('Something Went Wrong Unable to Update data');
            }
          });
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    warehouseCategory = Provider.of<InfrastructureApis>(
      context,
    ).warehouseCategory;
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
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
                            width: 440,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('WareHouse Category Name'),
                              ],
                            ),
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
                                      child: Text(e['WareHouse_Category_Name']),
                                      value: e['WareHouse_Category_Name'],
                                      onTap: () {
                                        wareHouseSubCategory[
                                                'WareHouse_Category_Id'] =
                                            e['WareHouse_Category_Id'];
                                      },
                                    );
                                  }).toList(),
                                  hint: const Text(
                                      'Choose WareHouse Category Name'),
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
                  categoryIdValidate == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, categoryIdValidateMessage),
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
                            child: const Text('Ware house Sub category Name'),
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
                                  horizontal: 12, vertical: 12),
                              child: TextFormField(
                                controller: subCategoryNameController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                onSaved: (value) {
                                  wareHouseSubCategory[
                                      'WareHouse_Sub_Category_Name'] = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  subCategoryNameValidate == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, subCategoryNameValidateMessage),
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
                            child: const Text('Description'),
                          ),
                          Container(
                            width: 440,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(color: Colors.black26),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: TextFormField(
                                controller: descriptionController,
                                expands: true,
                                minLines: null,
                                maxLines: null,
                                decoration: const InputDecoration(
                                    hintText: 'Description',
                                    border: InputBorder.none),
                                validator: (value) {},
                                onSaved: (value) {
                                  wareHouseSubCategory['Description'] = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  descriptionValidate == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, descriptionValidateMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Container(
                      width: 150,
                      height: 60,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                ProjectColors.themecolor)),
                        onPressed: save,
                        child: Text('Save', style: ProjectStyles.normalStyle()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
