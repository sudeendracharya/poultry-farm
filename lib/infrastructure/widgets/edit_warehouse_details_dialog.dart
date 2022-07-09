import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:provider/provider.dart';

import '../../styles.dart';
import '../../widgets/modular_widgets.dart';
import 'add_warehouse_category_dialog.dart';
import 'addwarehouse_sub_category_dialog.dart';

class EditWareHouseDetailsDialog extends StatefulWidget {
  EditWareHouseDetailsDialog(
      {Key? key,
      required this.reFresh,
      this.wareHouseId,
      this.index,
      this.categoryName,
      this.description,
      this.subCategoryName,
      this.wareHouseCode,
      this.wareHouseName,
      this.wareHouseCategoryId,
      this.wareHouseSubCategoryId,
      this.plantId})
      : super(key: key);
  var index;
  var wareHouseId;
  var categoryName;
  var subCategoryName;
  var wareHouseCode;
  var wareHouseName;
  var description;
  var wareHouseCategoryId;
  var wareHouseSubCategoryId;
  var plantId;
  final ValueChanged<int> reFresh;

  @override
  _EditWareHouseDetailsDialogState createState() =>
      _EditWareHouseDetailsDialogState();
}

class _EditWareHouseDetailsDialogState
    extends State<EditWareHouseDetailsDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var wareHouseId;
  Map<String, dynamic> wareHouseDetails = {
    'Firm_Id': '',
    'Plant_Id': '',
    'WareHouse_Category_Id': '',
    'WareHouse_Sub_Category_Id': '',
    'WareHouse_Name': '',
    'WareHouse_Code': '',
    'Description': '',
  };

  TextEditingController wareHouseNameController = TextEditingController();
  TextEditingController wareHouseCodeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool warehouseCategoryNameValidation = true;
  bool wareHouseSubCategoryNameValidation = true;
  bool warehouseNameValidation = true;
  bool warehouseCodeValidation = true;
  bool descriptionValidation = true;

  String warehouseCategoryNameValidationMessage = '';
  String wareHouseSubCategoryNameValidationMessage = '';
  String warehouseNameValidationMessage = '';
  String warehouseCodeValidationMessage = '';
  String descriptionValidationMessage = '';

  List warehouseCategory = [];

  List warehouseSubCategory = [];

  var warehouseCategoryId;

  var warehouseSubCategoryId;

  @override
  void initState() {
    super.initState();
    wareHouseDetails['WareHouse_Category_Id'] = widget.wareHouseCategoryId;
    wareHouseDetails['WareHouse_Sub_Category_Id'] =
        widget.wareHouseSubCategoryId;
    wareHouseDetails['Plant_Id'] = widget.plantId;
    wareHouseDetails['Description'] = widget.description ?? '';
    warehouseCategoryId = widget.categoryName;
    warehouseSubCategoryId = widget.subCategoryName;
    wareHouseNameController.text = widget.wareHouseName;
    wareHouseCodeController.text = widget.wareHouseCode;
    descriptionController.text = widget.description ?? '';
    // warehouseSubCategoryId = widget.subCategoryName;
    // warehouseCategoryId = widget.categoryName;
    // print(widget.wareHouseCategoryId);
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseCategory(token)
          .then((value1) {});
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getFirmDetails(token)
      //     .then((value1) {});
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseSubCategory(widget.wareHouseCategoryId ?? 1, token)
          .then((value1) {});
      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
    });
  }

  bool validate() {
    if (warehouseCategoryId == null) {
      warehouseCategoryNameValidation = false;
      warehouseCategoryNameValidationMessage = 'Please Select the category';
    } else {
      warehouseCategoryNameValidation = true;
    }

    if (warehouseSubCategoryId == null) {
      wareHouseSubCategoryNameValidation = false;
      wareHouseSubCategoryNameValidationMessage = 'Please Select the category';
    } else {
      wareHouseSubCategoryNameValidation = true;
    }

    if (wareHouseNameController.text.length > 30) {
      warehouseNameValidation = false;
      warehouseNameValidationMessage =
          'WareHouse Name Cannot be Greater then 30 characters';
    } else if (wareHouseNameController.text == '') {
      warehouseNameValidation = false;
      warehouseNameValidationMessage = 'WareHouse Name Cannot be empty';
    } else {
      warehouseNameValidation = true;
    }

    if (wareHouseCodeController.text == '') {
      warehouseCodeValidation = false;
      warehouseCodeValidationMessage = 'WareHouse Cannot Cannot be empty';
    } else {
      warehouseCodeValidation = true;
    }

    if (descriptionController.text == '') {
      descriptionValidation = false;
      descriptionValidationMessage = 'Description Cannot Cannot be empty';
    } else {
      descriptionValidation = true;
    }

    if (warehouseCategoryNameValidation == true &&
        wareHouseSubCategoryNameValidation == true &&
        warehouseNameValidation == true &&
        warehouseCodeValidation == true &&
        descriptionValidation == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateData() async {
    var isValid = validate();
    if (!isValid) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    print(wareHouseDetails);

    var plantId = await fetchPlant();
    wareHouseDetails['Plant_Id'] = plantId;

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .editWareHouseDetails(wareHouseDetails, widget.wareHouseId, token)
            .then((value) {
          if (value == 200 || value == 202) {
            widget.reFresh(100);
            Get.back();
            successSnackbar('Successfully updated the data');
          } else {
            failureSnackbar('Something went wrong please try again later');
          }
        });
      });
    } catch (e) {
      // print(e);
    }
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

  void fetchSubCategoryId(var id) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseSubCategory(id, token)
          .then((value1) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    warehouseCategory = Provider.of<InfrastructureApis>(
      context,
    ).warehouseCategory;
    warehouseSubCategory = Provider.of<InfrastructureApis>(
      context,
    ).warehouseSubCategory;
    return SafeArea(
      child: Container(
        width: 500,
        height: MediaQuery.of(context).size.height,
        child: Drawer(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('WareHouse Category Name'),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) =>
                                                AddWareHouseCategoryDialog(
                                                  categoryDescription: '',
                                                  categoryId: '',
                                                  categoryName: '',
                                                  refresh:
                                                      fechWareHouseCategory,
                                                ));
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                              Icons.add_circle_outline_rounded),
                                          Text('Add')
                                        ],
                                      ),
                                    ),
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
                                          value: e['WareHouse_Category_Name'],
                                          onTap: () {
                                            wareHouseDetails[
                                                    'WareHouse_Category_Id'] =
                                                e['WareHouse_Category_Id'];
                                            fetchSubCategoryId(
                                                e['WareHouse_Category_Id']);
                                            warehouseSubCategoryId = null;
                                          },
                                          child: Text(
                                              e['WareHouse_Category_Name']),
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
                      warehouseCategoryNameValidation == true
                          ? const SizedBox()
                          : ModularWidgets.validationDesign(
                              size, warehouseCategoryNameValidationMessage),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('WareHouse Sub Category Name'),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) =>
                                                AddWareHouseSubCategoryDialog(
                                                  reFresh: (int value) {},
                                                ));
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.add_circle_outline),
                                          Text('Add')
                                        ],
                                      ),
                                    )
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
                                      value: warehouseSubCategoryId,
                                      items: warehouseSubCategory
                                          .map<DropdownMenuItem<String>>((e) {
                                        return DropdownMenuItem(
                                          value:
                                              e['WareHouse_Sub_Category_Name'],
                                          onTap: () {
                                            wareHouseDetails[
                                                    'WareHouse_Sub_Category_Id'] =
                                                e['WareHouse_Sub_Category_Id'];
                                          },
                                          child: Text(
                                              e['WareHouse_Sub_Category_Name']),
                                        );
                                      }).toList(),
                                      hint: const Text(
                                          'Choose WareHouse Sub Category Name'),
                                      onChanged: (value) {
                                        setState(() {
                                          warehouseSubCategoryId =
                                              value as String;
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
                      wareHouseSubCategoryNameValidation == true
                          ? const SizedBox()
                          : ModularWidgets.validationDesign(
                              size, wareHouseSubCategoryNameValidationMessage),
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
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    controller: wareHouseCodeController,
                                    decoration: const InputDecoration(
                                        hintText: 'Ware House Code',
                                        border: InputBorder.none),
                                    onSaved: (value) {
                                      wareHouseDetails['WareHouse_Code'] =
                                          value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      warehouseCodeValidation == true
                          ? const SizedBox()
                          : ModularWidgets.validationDesign(
                              size, warehouseCodeValidationMessage),
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
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    controller: wareHouseNameController,
                                    decoration: const InputDecoration(
                                        hintText: 'WareHouse Name',
                                        border: InputBorder.none),
                                    onSaved: (value) {
                                      wareHouseDetails['WareHouse_Name'] =
                                          value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      warehouseNameValidation == true
                          ? const SizedBox()
                          : ModularWidgets.validationDesign(
                              size, warehouseNameValidationMessage),
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
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: TextFormField(
                                    controller: descriptionController,
                                    decoration: const InputDecoration(
                                        hintText: 'Description',
                                        border: InputBorder.none),
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
                      descriptionValidation == true
                          ? const SizedBox()
                          : ModularWidgets.validationDesign(
                              size, descriptionValidationMessage),
                      Consumer<InfrastructureApis>(
                          builder: (context, value, child) {
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 30.0),
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
                                    onPressed: updateData,
                                    child: Text(
                                      'Update Details',
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
        ),
      ),
    );
  }
}
