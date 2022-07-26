import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/items/providers/items_apis.dart';
import 'package:provider/provider.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';

class AddItemDetails extends StatefulWidget {
  AddItemDetails({Key? key}) : super(key: key);
  static const routeName = '/AddItemDetails';
  @override
  _AddItemDetailsState createState() => _AddItemDetailsState();
}

enum selectTransfer { yes, no }

enum selectInventoryAdjustment { yes, no }

enum selectMortality { yes, no }

enum selectGrading { yes, no }

class _AddItemDetailsState extends State<AddItemDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  selectTransfer transferSelected = selectTransfer.no;

  selectInventoryAdjustment adjustmentSelected = selectInventoryAdjustment.no;

  selectMortality mortalitySelected = selectMortality.no;

  selectGrading gradingSelected = selectGrading.no;

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var itemId;
  var subCatId;
  Map<String, dynamic> itemDetails = {
    'Product_Id': null,
    'Product_Sub_Category_Id': null,
    'Product_Name': '',
    'Product_Unit_Of_Measure': '',
    'Stock_Keeping_Unit': '',
    'Description': '',
    'Product_Batch_Request_For_Transfer': '',
    'Product_Batch_Request_Inventory_Adjustment': '',
    'Product_Batch_Request_For_Mortality': '',
    'Product_Batch_Request_For_Grading': '',
  };

  List itemCategoryData = [];
  List itemSubCategoryData = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .getItemCategory(token)
          .then((value1) {});
    });
    // Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   Provider.of<ItemApis>(context, listen: false)
    //       .getItemSubCategory(token)
    //       .then((value1) {});
    // });
    super.initState();
  }

  void save() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<ItemApis>(context, listen: false)
          .addItemDetailsData(itemDetails, token)
          .then((value) {
        if (value == 200 || value == 201) {
          showDialog(
              context: context,
              builder: (ctx) => SuccessDialog(
                  title: 'Success',
                  subTitle: 'SuccessFully Added Item Details'));
        } else {
          showDialog(
              context: context,
              builder: (ctx) => FailureDialog(
                  title: 'Failed',
                  subTitle: 'Something Went Wrong Please Try Again'));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    itemCategoryData = Provider.of<ItemApis>(context).itemcategory;
    itemSubCategoryData = Provider.of<ItemApis>(context).itemSubCategory;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Choose Category Name'),
                    Container(
                      width: 400,
                      child: DropdownButton(
                        value: itemId,
                        items:
                            itemCategoryData.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            child: Text(e['Product_Category_Name']),
                            value: e['Product_Category_Name'],
                            onTap: () {
                              itemDetails['Product_Id'] =
                                  e['Product_Category_Id'];
                            },
                          );
                        }).toList(),
                        hint: Container(
                            width: 350,
                            child: const Text('Please Choose category Name')),
                        onChanged: (value) {
                          setState(() {
                            itemId = value as String?;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Choose Sub Category Name'),
                    Container(
                      width: 400,
                      child: DropdownButton(
                        value: subCatId,
                        items: itemSubCategoryData
                            .map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            child: Text(e['Product_Sub_Category_Name']),
                            value: e['Product_Sub_Category_Name'],
                            onTap: () {
                              itemDetails['Product_Sub_Category_Id'] =
                                  e['Product_Sub_Category_Id'];
                            },
                          );
                        }).toList(),
                        hint: Container(
                            width: 350,
                            child:
                                const Text('Please Choose Sub category Name')),
                        onChanged: (value) {
                          setState(() {
                            subCatId = value as String?;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Product Name:'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          itemDetails['Product_Name'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Unit Of Measure:'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          itemDetails['Product_Unit_Of_Measure'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   width: 600,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       const Text('Item Grade: '),
              //       Container(
              //         width: 400,
              //         child: TextFormField(
              //           onSaved: (value) {
              //             itemDetails['Item_Grade'] = value!;
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Stock Keeping Unit:'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          itemDetails['Stock_Keeping_Unit'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200,
                      child: const Text('Description:'),
                    ),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          itemDetails['Description'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200,
                      child: const Text('Required Batch Number For Transfer:'),
                    ),
                    Container(
                        width: 400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: selectTransfer.yes,
                                    groupValue: transferSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        itemDetails[
                                                'Product_Batch_Request_For_Transfer'] =
                                            true;
                                        transferSelected =
                                            value as selectTransfer;
                                      });
                                    }),
                                const Text('Yes')
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: selectTransfer.no,
                                    groupValue: transferSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        itemDetails[
                                                'Product_Batch_Request_For_Transfer'] =
                                            false;

                                        transferSelected =
                                            value as selectTransfer;
                                      });
                                    }),
                                const Text('No')
                              ],
                            )
                          ],
                        )
                        // TextFormField(
                        //   onSaved: (value) {
                        //     itemDetails['Product_Batch_Request_For_Transfer'] =
                        //         value!;
                        //   },
                        // ),
                        ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200,
                      child: const Text(
                          'Required Batch Number For Inventory Adjustment:'),
                    ),
                    Container(
                        width: 400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: selectInventoryAdjustment.yes,
                                    groupValue: adjustmentSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        itemDetails[
                                                'Product_Batch_Request_Inventory_Adjustment'] =
                                            true;
                                        adjustmentSelected =
                                            value as selectInventoryAdjustment;
                                      });
                                    }),
                                const Text('Yes')
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: selectInventoryAdjustment.no,
                                    groupValue: adjustmentSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        itemDetails[
                                                'Product_Batch_Request_Inventory_Adjustment'] =
                                            false;

                                        adjustmentSelected =
                                            value as selectInventoryAdjustment;
                                      });
                                    }),
                                const Text('No')
                              ],
                            )
                          ],
                        )
                        // TextFormField(
                        //   onSaved: (value) {
                        //     itemDetails[
                        //             'Product_Batch_Request_Inventory_Adjustment'] =
                        //         value!;
                        //   },
                        // ),
                        ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200,
                      child: const Text('Required Batch Number For Mortality:'),
                    ),
                    Container(
                        width: 400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: selectMortality.yes,
                                    groupValue: mortalitySelected,
                                    onChanged: (value) {
                                      setState(() {
                                        itemDetails[
                                                'Product_Batch_Request_For_Mortality'] =
                                            true;
                                        mortalitySelected =
                                            value as selectMortality;
                                      });
                                    }),
                                const Text('Yes')
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: selectMortality.no,
                                    groupValue: mortalitySelected,
                                    onChanged: (value) {
                                      setState(() {
                                        itemDetails[
                                                'Product_Batch_Request_For_Mortality'] =
                                            false;

                                        mortalitySelected =
                                            value as selectMortality;
                                      });
                                    }),
                                const Text('No')
                              ],
                            )
                          ],
                        )
                        // TextFormField(
                        //   onSaved: (value) {
                        //     itemDetails['Product_Batch_Request_For_Mortality'] =
                        //         value!;
                        //   },
                        // ),
                        ),
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 200,
                      child: const Text(
                          'Required Batch Number For Grading Grading:'),
                    ),
                    Container(
                        width: 400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: selectGrading.yes,
                                    groupValue: gradingSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        itemDetails[
                                                'Product_Batch_Request_For_Grading'] =
                                            true;
                                        gradingSelected =
                                            value as selectGrading;
                                      });
                                    }),
                                const Text('Yes')
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: selectGrading.no,
                                    groupValue: gradingSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        itemDetails[
                                                'Product_Batch_Request_For_Grading'] =
                                            false;

                                        gradingSelected =
                                            value as selectGrading;
                                      });
                                    }),
                                const Text('No')
                              ],
                            )
                          ],
                        )
                        // TextFormField(
                        //   onSaved: (value) {
                        //     itemDetails['Product_Batch_Request_For_Grading'] =
                        //         value!;
                        //   },
                        // ),
                        ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child:
                    ElevatedButton(onPressed: save, child: const Text('Save')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
