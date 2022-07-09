import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/items/providers/items_apis.dart';

import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../main.dart';
import '../../styles.dart';
import '../../widgets/administration_search_widget.dart';
import '../../widgets/modular_widgets.dart';

class ProductTypePage extends StatefulWidget {
  ProductTypePage({Key? key}) : super(key: key);
  static const routeName = '/ItemCategory';

  @override
  _ProductTypePageState createState() => _ProductTypePageState();
}

class _ProductTypePageState extends State<ProductTypePage> {
  List itemCategoryData = [];

  var _productType;

  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getItemCategory(token)
          .then((value1) {});
      // Provider.of<ItemApis>(context, listen: false)
      //     .getItemSubCategoryAllData(token)
      //     .then((value1) {});
    });
    super.initState();
  }

  var query = '';

  List list = [];

  void updateCheckBox(int data) {
    setState(() {});
  }

  void update(int data) {
    selectedProductType.clear();
    fetchCredientials().then((token) {
      if (token != '') {
        Provider.of<ItemApis>(context, listen: false)
            .getItemCategory(token)
            .then((value1) {});
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

  List ProductTypeList = [];
  List selectedActivityIds = [];
  var extratedPermissions;
  bool loading = true;

  int defaultRowsPerPage = 3;

  void delete() {
    if (selectedProductType.isEmpty) {
      alertSnackBar('Please select the checkbox to delete');
    } else {
      List temp = [];
      for (var data in selectedProductType) {
        temp.add(data['Product_Category_Id']);
      }
      fetchCredientials().then((token) {
        if (token != '') {
          Provider.of<ItemApis>(context, listen: false)
              .deleteItemCategoryData(temp, token)
              .then((value) {
            if (value == 204) {
              successSnackbar('Successfully deleted the data');
              update(100);
              selectedProductType.clear();
              temp.clear();
            } else {
              failureSnackbar('Unable to delete the data Something went wrong');
            }
          });
        }
      });
    }
  }

  void searchBook(String query) {
    final searchOutput = ProductTypeList.where((details) {
      final breedName = details['Breed_Name'];
      final breedVendor = details['Vendor'].toString().toLowerCase();
      final searchName = query.toLowerCase();

      return breedName.contains(searchName) || breedVendor.contains(searchName);
    }).toList();

    setState(() {
      this.query = query;
      list = searchOutput;
    });
  }

  final GlobalKey<FormState> _productTypeFormKey = GlobalKey();
  Future<void> submitProductType(Size size) async {
    _productTypeFormKey.currentState!.save();
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<ItemApis>(context, listen: false).addItemCategoryData(
            {'Product_Category_Name': productTypeController.text},
            token).then((value) {
          if (value == 200 || value == 201) {
            Get.back();
            // getItemCategory().then((value) {
            //   Get.dialog(productSubTypeDialog(size));
            // });

            successSnackbar('Successfully Added Product Type');
            update(100);
          }
        });
      }
    });
  }

  Future<void> editProductType(Size size, var id) async {
    _productTypeFormKey.currentState!.save();
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<ItemApis>(context, listen: false)
            .editItemCategoryData(
                id,
                {
                  "Product_Category_Id": id,
                  'Product_Category_Name': productTypeController.text
                },
                token)
            .then((value) {
          if (value == 200 || value == 202) {
            Get.back();
            selectedProductType.clear();
            // getItemCategory().then((value) {
            //   Get.dialog(productSubTypeDialog(size));
            // });

            successSnackbar('Successfully Updated Product Type');
            update(100);
          }
        });
      }
    });
  }

  TextEditingController productTypeController = TextEditingController();
  bool productTypeValidation = true;
  String productTypeValidationMessage = '';

  Dialog productTypeDialog(Size size) {
    return Dialog(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            width: size.width * 0.25,
            height: size.height * 0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Form(
                key: _productTypeFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: size.width * 0.2,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                'Product Type',
                                style: GoogleFonts.roboto(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
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
                                  decoration: const InputDecoration(
                                      hintText: 'Enter Product Type',
                                      border: InputBorder.none),
                                  controller: productTypeController,
                                  onSaved: (value) {
                                    _productType = value!;
                                  },
                                ),
                              ),
                            ),
                            productTypeValidation == false
                                ? SizedBox()
                                : const SizedBox(
                                    height: 25,
                                  ),
                            productTypeValidation == true
                                ? const SizedBox()
                                : ModularWidgets.validationDesign(
                                    size, productTypeValidationMessage),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    ProjectColors.themecolor,
                                  ),
                                ),
                                onPressed: () => {
                                      if (productTypeController.text.length >
                                          18)
                                        {
                                          productTypeValidation = false,
                                          productTypeValidationMessage =
                                              'Product Type Cannot be greater then 18 characters',
                                        }
                                      else if (productTypeController.text == '')
                                        {
                                          productTypeValidation = false,
                                          productTypeValidationMessage =
                                              'Product Type Cannot be Empty',
                                        }
                                      else
                                        {
                                          productTypeValidation = true,
                                        },
                                      if (productTypeValidation == true)
                                        {
                                          if (selectedProductType.isEmpty)
                                            {
                                              submitProductType(size),
                                            }
                                          else
                                            {
                                              editProductType(
                                                  size,
                                                  selectedProductType[0]
                                                      ['Product_Category_Id']),
                                            }
                                        }
                                      else
                                        {setState(() {})}
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
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    ProductTypeList = Provider.of<ItemApis>(context).itemcategory;
    List batchDetails = [];

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
            'Product Type',
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
                  hintText: 'Search'),
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
                    selectedProductType.clear();
                    showGlobalDrawer(
                        context: context,
                        builder: (ctx) => productTypeDialog(size),
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
                selectedProductType.length == 1
                    ? IconButton(
                        onPressed: () {
                          productTypeController.text =
                              selectedProductType[0]['Product_Category_Name'];
                          showGlobalDrawer(
                              context: context,
                              builder: (ctx) => productTypeDialog(size),
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
                    query == '' ? ProductTypeList : list, updateCheckBox),

                columns: const [
                  DataColumn(
                      label: Text('Product Type',
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
}

List selectedProductType = [];

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

          if (selectedProductType.isEmpty) {
            selectedProductType.add(data[index]);
          } else {
            if (value == true) {
              selectedProductType.add(data[index]);
            } else {
              selectedProductType.remove(data[index]);
            }
          }
          reFresh(100);
          // print('selected breeds $selectedBreeds');
        },
        selected: data[index]['Is_Selected'],
        cells: [
          DataCell(Text(data[index]['Product_Category_Name'].toString())),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
