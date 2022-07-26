import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/items/providers/items_apis.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../../widgets/modular_widgets.dart';

class ProductSubCategory extends StatefulWidget {
  ProductSubCategory({Key? key}) : super(key: key);
  static const routeName = '/ItemSubCategory';

  @override
  _ProductSubCategoryState createState() => _ProductSubCategoryState();
}

class _ProductSubCategoryState extends State<ProductSubCategory> {
  List itemSubCategoryData = [];
  var query = '';

  List list = [];

  String? selectedProductTypeData;
  List itemCategoryData = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getItemSubCategoryAllData(token)
          .then((value1) {});
      Provider.of<ItemApis>(context, listen: false)
          .getItemCategory(token)
          .then((value1) {});
    });
    super.initState();
  }

  int defaultRowsPerPage = 3;
  void searchBook(String query) {
    final searchOutput = itemSubCategoryData.where((details) {
      final breedVendor =
          details['Product_Sub_Category_Name'].toString().toLowerCase();
      final searchName = query.toLowerCase();

      return breedVendor.contains(searchName);
    }).toList();

    setState(() {
      this.query = query;
      list = searchOutput;
    });
  }

  void updateCheckBox(int data) {
    setState(() {});
  }

  void update(int data) {
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<ItemApis>(context, listen: false)
            .getItemSubCategoryAllData(token)
            .then((value1) {
          selectedProductSubType.clear();
        });
      }
    });
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

  void delete() {
    if (selectedProductSubType.isEmpty) {
      alertSnackBar('Please select the checkbox to delete');
    } else {
      List temp = [];
      for (var data in selectedProductSubType) {
        temp.add(data['Product_Sub_Category_Id']);
      }
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<ItemApis>(context, listen: false)
              .deleteItemSubCategory(temp, token)
              .then((value) {
            if (value == 204) {
              successSnackbar('Successfully deleted the data');
              update(100);
              selectedProductSubType.clear();
              temp.clear();
            } else {
              failureSnackbar('Unable to delete the data Something went wrong');
              selectedProductSubType.clear();
              update(100);
            }
          });
        }
      });
    }
  }

  final GlobalKey<FormState> _productSubTypeFormKey = GlobalKey();
  Map<String, dynamic> productSubType = {
    'Product_Category_Id': '',
    'Product_Sub_Category_Name': '',
  };
  Future<void> submitProductSubType(Size size) async {
    bool validate = _productSubTypeFormKey.currentState!.validate();
    if (validate != true) {
      return;
    }
    _productSubTypeFormKey.currentState!.save();
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<ItemApis>(context, listen: false)
            .addItemSubCategoryData(
                productSubType['Product_Category_Id'], productSubType, token)
            .then((value) {
          if (value == 200 || value == 201) {
            Get.back();
            update(100);
            successSnackbar('Successfully added product Sub Type');
          } else {
            failureSnackbar(
                'Something went wrong unable to add product sub type');
          }
        });
      }
    });
  }

  Future<void> editProductSubType(Size size) async {
    bool validate = _productSubTypeFormKey.currentState!.validate();
    if (validate != true) {
      return;
    }
    _productSubTypeFormKey.currentState!.save();
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<ItemApis>(context, listen: false)
            .editItemSubCategory(productSubType,
                productSubType['Product_Sub_Category_Id'], token)
            .then((value) {
          if (value == 200 || value == 202) {
            Get.back();
            update(100);
            selectedProductSubType.clear();
            successSnackbar('Successfully Updated product Sub Type');
          } else {
            Get.back();
            update(100);
            selectedProductSubType.clear();
            failureSnackbar(
                'Something went wrong unable to update product sub type');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    itemSubCategoryData =
        Provider.of<ItemApis>(context).itemSubCategoryAllDataList;
    List batchDetails = [];
    itemCategoryData = Provider.of<ItemApis>(context).itemcategory;

    return
        // loading == true
        //     ? const Center(
        //         child: Text('Loading'),
        //       )
        //     : extratedPermissions['View'] == false
        //         ? SizedBox(
        //             height: size.height * 0.5,
        //             child: const Center(
        //                 child: Text('You don\'t have access to view this page')),
        //           )
        //         :
        SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 34,
          ),
          Text(
            'Product Sub Type',
            style: ProjectStyles.contentHeaderStyle(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: 253,
              child: AdministrationSearchWidget(
                  search: (value) {},
                  reFresh: (value) {},
                  text: query,
                  onChanged: searchBook,
                  hintText: 'Product Sub Type'),
            ),
          ),
          Container(
            width: size.width * 0.25,
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // extratedPermissions['Create'] == true
                //     ?
                IconButton(
                  onPressed: () {
                    selectedProductSubType.clear();
                    showGlobalDrawer(
                        context: context,
                        builder: (ctx) => productSubTypeDialog(size),
                        direction: AxisDirection.right);
                  },
                  icon: const Icon(Icons.add),
                ),
                // : const SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                // extratedPermissions['Edit'] == true
                //     ?
                selectedProductSubType.length == 1
                    ? IconButton(
                        onPressed: () {
                          productSubTypeController.text =
                              selectedProductSubType[0]
                                  ['Product_Sub_Category_Name'];
                          productSubType['Product_Category_Id'] =
                              selectedProductSubType[0]['Product_Category_Id'];
                          productSubType['Product_Sub_Category_Id'] =
                              selectedProductSubType[0]
                                  ['Product_Sub_Category_Id'];
                          showGlobalDrawer(
                              context: context,
                              builder: (ctx) => productSubTypeDialog(size),
                              direction: AxisDirection.right);
                        },
                        icon: const Icon(Icons.edit),
                      )
                    : const SizedBox(),
                // : const SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                // extratedPermissions['Delete'] == true
                //     ?
                IconButton(
                  onPressed: delete,
                  icon: const Icon(Icons.delete),
                )
                // : const SizedBox(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              width: size.width * 0.25,
              child: PaginatedDataTable(
                arrowHeadColor: ProjectColors.themecolor,
                onSelectAll: (value) {},

                source: MySearchBreedData(
                    query == '' ? itemSubCategoryData : list, updateCheckBox),

                columns: const [
                  DataColumn(
                      label: Text('Product Sub Type',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  // DataColumn(
                  //     label: Text('Description',
                  //         style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                onRowsPerPageChanged: (index) {
                  setState(() {
                    defaultRowsPerPage = index!;
                  });
                },

                availableRowsPerPage: const <int>[
                  3,
                  5,
                  10,
                  20,
                  40,
                  60,
                  80,
                ],
                columnSpacing: 20,
                //  horizontalMargin: 10,
                rowsPerPage: defaultRowsPerPage,
                showCheckboxColumn: true,
                // addEmptyRows: false,
                checkboxHorizontalMargin: 30,
                // onSelectAll: (value) {},
                showFirstLastButtons: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController productSubTypeController = TextEditingController();
  bool productSubTypeValidation = true;
  String productSubTypeValidationMessage = '';

  bool productTypeValidation = true;
  String productTypeValidationMessage = '';

  StatefulBuilder productSubTypeDialog(Size size) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        if (productSubType['Product_Category_Id'] != '') {
          if (itemCategoryData.isNotEmpty) {
            for (var data in itemCategoryData) {
              if (data['Product_Category_Id'] ==
                  productSubType['Product_Category_Id']) {
                selectedProductTypeData = data['Product_Category_Name'];
              }
            }
          }
        }
        return Container(
          width: size.width * 0.3,
          height: size.height * 0.4,
          color: Colors.white,
          child: Drawer(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Form(
                key: _productSubTypeFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        width: size.width * 0.2,
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: const Text('Product Type'),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: size.width * 0.25,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black26),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                value: selectedProductTypeData,
                                                items: itemCategoryData.map<
                                                    DropdownMenuItem<
                                                        String>>((e) {
                                                  return DropdownMenuItem(
                                                    value: e[
                                                        'Product_Category_Name'],
                                                    onTap: () {
                                                      productSubType[
                                                              'Product_Category_Id'] =
                                                          e['Product_Category_Id'];
                                                    },
                                                    child: Text(e[
                                                        'Product_Category_Name']),
                                                  );
                                                }).toList(),
                                                hint: Container(
                                                    width: size.width * 0.15,
                                                    child:
                                                        const Text('Select')),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedProductTypeData =
                                                        value as String?;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            productTypeValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, productTypeValidationMessage),
                            const SizedBox(
                              height: 25,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: size.width * 0.2,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Product Sub Type'),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: size.width * 0.2,
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
                                    controller: productSubTypeController,
                                    decoration: const InputDecoration(
                                        hintText: 'Product Sub Type',
                                        border: InputBorder.none),
                                    onSaved: (value) {
                                      productSubType[
                                          'Product_Sub_Category_Name'] = value!;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            productSubTypeValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, productSubTypeValidationMessage),
                            const SizedBox(
                              height: 25,
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    ProjectColors.themecolor,
                                  ),
                                ),
                                onPressed: () {
                                  if (selectedProductTypeData == null) {
                                    productTypeValidation = false;
                                    productTypeValidationMessage =
                                        'Please Select Product Type';
                                  } else {
                                    productTypeValidation = true;
                                  }

                                  if (productSubTypeController.text.length >
                                      18) {
                                    productSubTypeValidation = false;
                                    productSubTypeValidationMessage =
                                        'Product Sub type Cannot be greater then 18 characters';
                                  } else if (productSubTypeController.text ==
                                      '') {
                                    productSubTypeValidation = false;
                                    productSubTypeValidationMessage =
                                        'Product Sub type Cannot be Empty';
                                  } else {
                                    productSubTypeValidation = true;
                                  }

                                  if (productTypeValidation == true &&
                                      productSubTypeValidation == true) {
                                    if (selectedProductSubType.isEmpty) {
                                      submitProductSubType(size);
                                    } else {
                                      editProductSubType(size);
                                    }
                                  } else {
                                    setState(() {});
                                  }
                                },
                                child: Text(
                                  'submit',
                                  style:
                                      GoogleFonts.roboto(color: Colors.white),
                                )),
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
      },
    );
  }
}

List selectedProductSubType = [];

class MySearchBreedData extends DataTableSource {
  final List<dynamic> data;

  final ValueChanged<int> reFresh;

  MySearchBreedData(this.data, this.reFresh);

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(
        onSelectChanged: (value) {
          data[index]['Is_Selected'] = value;

          if (selectedProductSubType.isEmpty) {
            selectedProductSubType.add(data[index]);
          } else {
            if (value == true) {
              selectedProductSubType.add(data[index]);
            } else {
              selectedProductSubType.remove(data[index]);
            }
          }
          reFresh(100);
          // print('selected breeds $selectedBreeds');
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(Text(data[index]['Product_Sub_Category_Name'].toString())),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
