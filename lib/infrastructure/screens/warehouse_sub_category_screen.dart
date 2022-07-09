import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poultry_login_signup/colors.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:poultry_login_signup/widgets/failure_dialog.dart';

import 'package:poultry_login_signup/widgets/success_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/add_warehouse_category.dart';
import '../widgets/add_warehouse_subcategory.dart';

// import '/widgets/add_warehouse_subcategory.dart';

class WarehouseSubCategoryScreen extends StatefulWidget {
  const WarehouseSubCategoryScreen({Key? key}) : super(key: key);
  static const routeName = '/WarehouseSubCategory';

  @override
  _WarehouseSubCategoryScreenState createState() =>
      _WarehouseSubCategoryScreenState();
}

class _WarehouseSubCategoryScreenState
    extends State<WarehouseSubCategoryScreen> {
  List wareHouseCategoryDetails = [];
  List wareHouseSubCategoryDetails = [];
  @override
  void initState() {
    super.initState();
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .loadWarehouseCategoryAndSubCategory(token)
          .then((value1) {
        if (value1 == 200 || value1 == 201) {}
      });
    });
  }

  // @override
  // void initState() {

  //   super.initState();
  //   Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
  //     var token = Provider.of<Apicalls>(context, listen: false).token;
  //     Provider.of<InfrastructureApis>(context, listen: false)
  //         .getWarehouseSubCategory(token)
  //         .then((value1) {});
  //   });
  // }
  void call(int data) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .loadWarehouseCategoryAndSubCategory(token)
          .then((value1) {
        if (value1 == 200 || value1 == 201) {}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    wareHouseCategoryDetails = Provider.of<InfrastructureApis>(
      context,
    ).displayWarehouseSubCategory;
    // wareHouseSubCategoryDetails = Provider.of<InfrastructureApis>(
    //   context,
    // ).warehouseSubCategory;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ware House Category'),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<Apicalls>(context, listen: false)
                    .tryAutoLogin()
                    .then((value) {
                  var token =
                      Provider.of<Apicalls>(context, listen: false).token;
                  Provider.of<InfrastructureApis>(context, listen: false)
                      .getWarehouseSubCategory(1, token)
                      .then((value1) {
                    if (value1 == 200 || value1 == 201) {}
                  });
                });

                // Navigator.of(context).pushNamed(AddWarehouseCategory.routeName);
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                Get.toNamed(
                  AddWarehouseCategory.routeName,
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: ListView.builder(
            itemCount: wareHouseCategoryDetails.length,
            itemBuilder: (BuildContext context, int index) {
              return DisplayWareHouseCategory(
                key: UniqueKey(),
                categoryList: wareHouseCategoryDetails,
                index: index,
                reFresh: call,
              );
            },
          ),
        ),
      ),
    );
  }
}

class DisplayWareHouseCategory extends StatefulWidget {
  DisplayWareHouseCategory(
      {Key? key,
      required this.categoryList,
      required this.index,
      required this.reFresh})
      : super(key: key);

  final List categoryList;
  final int index;
  final ValueChanged<int> reFresh;

  @override
  _DisplayWareHouseCategoryState createState() =>
      _DisplayWareHouseCategoryState();
}

class _DisplayWareHouseCategoryState extends State<DisplayWareHouseCategory> {
  void call(int data) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .loadWarehouseCategoryAndSubCategory(token)
          .then((value1) {
        if (value1 == 200 || value1 == 201) {}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => EditWareHouseCategoryData(
                          id: widget.categoryList[widget.index]
                              ['WareHouse_Category_Id'],
                          name: widget.categoryList[widget.index]
                              ['WareHouse_Category_Name'],
                          key: UniqueKey(),
                          reFresh: call,
                        ));
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                Provider.of<Apicalls>(context, listen: false)
                    .tryAutoLogin()
                    .then((value) {
                  var token =
                      Provider.of<Apicalls>(context, listen: false).token;
                  Provider.of<InfrastructureApis>(context, listen: false)
                      .deleteWareHouseCategory(
                          widget.categoryList[widget.index]
                              ['WareHouse_Category_Id'],
                          token)
                      .then((value1) {
                    if (value1 == 204 || value1 == 202) {
                      Provider.of<InfrastructureApis>(context, listen: false)
                          .loadWarehouseCategoryAndSubCategory(token)
                          .then((value1) {
                        if (value1 == 200 || value1 == 201) {}
                      });
                    }
                  });
                });
              },
              icon: Icon(Icons.delete)),
        ],
      ),
      title: Text(
        widget.categoryList[widget.index]['WareHouse_Category_Name'],
      ),
      subtitle: Align(
        alignment: Alignment.topLeft,
        child: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (ctx) => LoadWareHouseSubCategory(
                      id: widget.categoryList[widget.index]
                          ['WareHouse_Category_Id'],
                      name: widget.categoryList[widget.index]
                          ['WareHouse_Category_Name'],
                      reFresh: call,
                    )).then((value) {
              widget.reFresh(100);
            });
          },
          child: Text(
              'Sub Category Count: ${widget.categoryList[widget.index]['warehouse_sub_category__count'].toString()}'),
        ),
      ),
    );
  }
}

class EditWareHouseCategoryData extends StatefulWidget {
  EditWareHouseCategoryData(
      {Key? key, required this.id, required this.name, required this.reFresh})
      : super(key: key);

  final int id;
  final String name;
  final ValueChanged<int> reFresh;

  @override
  _EditWareHouseCategoryDataState createState() =>
      _EditWareHouseCategoryDataState();
}

class _EditWareHouseCategoryDataState extends State<EditWareHouseCategoryData> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var update = false;
  var id;

  var wareHouseCategoryName = {
    'WareHouse_Category_Name': '',
    'Description': '',
  };
  Future<void> save() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .editWareHouseCategory(wareHouseCategoryName, widget.id, token)
            .then((value) {
          if (value == 202 || value == 201) {
            widget.reFresh(100);
            //Get.snackbar('Success', 'Successfully edited data');
            Get.back();
            // _formKey.currentState!.reset();
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SuccessDialog(title: 'Success', subTitle: 'SuccessFully Added WareHouse Category')
            // );

          } else {
            showDialog(
              context: context,
              builder: (ctx) => FailureDialog(
                  title: 'Failed',
                  subTitle: 'Something Went Wrong Please Try Again'),
            );
          }
        });
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Form(
          key: _formKey,
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
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('WareHouse category Name'),
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
                                  border: InputBorder.none),
                              initialValue: widget.name,
                              validator: (value) {},
                              onSaved: (value) {
                                wareHouseCategoryName[
                                    'WareHouse_Category_Name'] = value!;
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
                          width: 440,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Description'),
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
                                  border: InputBorder.none),
                              validator: (value) {},
                              onSaved: (value) {
                                wareHouseCategoryName['Description'] = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ElevatedButton(
                      onPressed: save, child: const Text('update')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadWareHouseSubCategory extends StatefulWidget {
  LoadWareHouseSubCategory(
      {Key? key, required this.id, required this.name, required this.reFresh})
      : super(key: key);

  final int id;
  final String name;
  final ValueChanged<int> reFresh;

  @override
  _LoadWareHouseSubCategoryState createState() =>
      _LoadWareHouseSubCategoryState();
}

class _LoadWareHouseSubCategoryState extends State<LoadWareHouseSubCategory> {
  var loading = true;

  List subCategoryList = [];

  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseSubCategory(widget.id, token)
          .then((value1) {
        if (value1 == 200 || value1 == 201) {}
      });
    });

    super.initState();
  }

  void run(int data) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseSubCategory(widget.id, token)
          .then((value1) {
        if (value1 == 200 || value1 == 201) {
          widget.reFresh(100);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    subCategoryList =
        Provider.of<InfrastructureApis>(context).warehouseSubCategory;
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 1.5,
        // color: Colors.amber,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AddWareHouseSubCategoryData(
                                context: ctx,
                                id: widget.id.toString(),
                                name: widget.name,
                                reFresh: run,
                              ));
                    },
                    icon: Icon(Icons.add)),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.8,
              child: ListView.builder(
                itemCount: subCategoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return DisplayWareHouseSubCategoryData(
                    subCategoryList: subCategoryList,
                    index: index,
                    id: widget.id,
                    name: widget.name,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayWareHouseSubCategoryData extends StatefulWidget {
  const DisplayWareHouseSubCategoryData({
    Key? key,
    required this.subCategoryList,
    required this.index,
    required this.id,
    required this.name,
  }) : super(key: key);

  final List subCategoryList;
  final int index;
  final int id;
  final String name;

  @override
  State<DisplayWareHouseSubCategoryData> createState() =>
      _DisplayWareHouseSubCategoryDataState();
}

class _DisplayWareHouseSubCategoryDataState
    extends State<DisplayWareHouseSubCategoryData> {
  void run(int data) {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseSubCategory(widget.id, token)
          .then((value1) {
        if (value1 == 200 || value1 == 201) {}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          widget.subCategoryList[widget.index]['WareHouse_Sub_Category_Name']),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AddWareHouseSubCategoryData(
                          context: ctx,
                          id: widget.id.toString(),
                          name: widget.name,
                          description: widget.subCategoryList[widget.index]
                              ['Description'],
                          subCategoryId: widget.subCategoryList[widget.index]
                              ['WareHouse_Sub_Category_Id'],
                          subCategoryName: widget.subCategoryList[widget.index]
                              ['WareHouse_Sub_Category_Name'],
                          update: true,
                          key: UniqueKey(),
                          reFresh: run,
                        ));
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                Provider.of<Apicalls>(context, listen: false)
                    .tryAutoLogin()
                    .then((value) {
                  var token =
                      Provider.of<Apicalls>(context, listen: false).token;
                  Provider.of<InfrastructureApis>(context, listen: false)
                      .deleteWarehouseSubCategory(
                          widget.subCategoryList[widget.index]
                              ['WareHouse_Sub_Category_Id'],
                          token)
                      .then((value1) {
                    if (value1 == 204 || value1 == 201) {
                      Provider.of<InfrastructureApis>(context, listen: false)
                          .getWarehouseSubCategory(widget.id, token)
                          .then((value1) {
                        if (value1 == 200 || value1 == 201) {}
                      });
                    }
                  });
                });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
    );
  }
}

class AddWareHouseSubCategoryData extends StatefulWidget {
  AddWareHouseSubCategoryData({
    Key? key,
    required this.id,
    required this.name,
    required this.context,
    this.description,
    this.subCategoryId,
    this.subCategoryName,
    this.update,
    required this.reFresh,
  }) : super(key: key);
  final String id;
  final String name;
  final BuildContext context;
  final ValueChanged<int> reFresh;
  var subCategoryName;
  var subCategoryId;
  var description;
  var update;

  @override
  _AddWareHouseSubCategoryDataState createState() =>
      _AddWareHouseSubCategoryDataState();
}

class _AddWareHouseSubCategoryDataState
    extends State<AddWareHouseSubCategoryData> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, dynamic> wareHouseSubCategory = {
    'WareHouse_Category_Id': '',
    'WareHouse_Sub_Category_Name': '',
    'Description': '',
  };
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.name;
    wareHouseSubCategory['WareHouse_Category_Id'] = widget.id;
  }

  Future<void> save() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

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
            Get.showSnackbar(GetSnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: Theme.of(context).backgroundColor,
              message: 'Successfully Added WareHouse Sub Category',
              title: 'Success',
            ));
            // showDialog(
            //     context: context,
            //     builder: (ctx) => SuccessDialog(
            //         title: 'Success',
            //         subTitle:
            //             'SuccessFully Added Ware House Sub-Category Details'));

            // _formKey.currentState!.reset();
          } else {
            widget.reFresh(100);
            showDialog(
                context: context,
                builder: (ctx) => FailureDialog(
                    title: 'Failed',
                    subTitle: 'Something Went Wrong Please Try Again'));
          }
        });
      });
    } catch (e) {}
  }

  Future<void> update() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .editWareHouseSubCategory(
                wareHouseSubCategory, widget.subCategoryId, token)
            .then((value) {
          if (value == 202 || value == 201) {
            widget.reFresh(100);
            Get.back();
            // showDialog(
            //     context: context,
            //     builder: (ctx) => SuccessDialog(
            //         title: 'Success',
            //         subTitle:
            //             'SuccessFully Added Ware House Sub-Category Details'));

            // _formKey.currentState!.reset();
          } else {
            showDialog(
                context: context,
                builder: (ctx) => FailureDialog(
                    title: 'Failed',
                    subTitle: 'Something Went Wrong Please Try Again'));
          }
        });
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Form(
          key: _formKey,
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
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('WareHouse category Name'),
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
                                  border: InputBorder.none),
                              controller: controller,
                              validator: (value) {},
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
                                horizontal: 12, vertical: 6),
                            child: TextFormField(
                              initialValue: widget.update != null
                                  ? widget.subCategoryName
                                  : '',
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              validator: (value) {},
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
                              expands: true,
                              minLines: null,
                              maxLines: null,
                              initialValue: widget.update == null
                                  ? ''
                                  : widget.description,
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
                widget.update == null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ProjectColors.themecolor)),
                          onPressed: save,
                          child: const Text('Save'),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: ElevatedButton(
                          onPressed: update,
                          child: const Text('update'),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildWareHouseCategory extends StatefulWidget {
  BuildWareHouseCategory({
    Key? key,
    required this.warehouseList,
    required this.index,
  }) : super(key: key);

  final List warehouseList;

  final int index;

  @override
  _BuildWareHouseCategoryState createState() => _BuildWareHouseCategoryState();
}

class _BuildWareHouseCategoryState extends State<BuildWareHouseCategory> {
  bool isOpened = false;
  int i = 0;
  var name;
  List values = [];
  var id;

  // @override
  // void initState() {
  //   widget.wareHouseSubCategory.forEach((key, value) {
  //     values = value;
  //   });

  //   name = widget.wareHouseCategory['WareHouseCategoryName'];
  //   id = widget.wareHouseCategory['WareHouseCategoryId'];

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: ExpansionPanelList(
        key: widget.key,
        children: [
          ExpansionPanel(
              headerBuilder: (context, isOpened) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                              widget.warehouseList[widget.index]['Category'])),
                      IconButton(
                          onPressed: () {
                            // Navigator.of(context).pushNamed(
                            //     AddWarehouseCategory.routeName,
                            //     arguments: {
                            //       'id': widget.warehouseList[widget.index]
                            //           ['id'],
                            //       'Category': widget.warehouseList[widget.index]
                            //           ['Category']
                            //     });
                            Get.toNamed(AddWarehouseCategory.routeName,
                                arguments: {
                                  'id': widget.warehouseList[widget.index]
                                      ['id'],
                                  'Category': widget.warehouseList[widget.index]
                                      ['Category']
                                });
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            Provider.of<Apicalls>(context, listen: false)
                                .tryAutoLogin()
                                .then((value) {
                              var token =
                                  Provider.of<Apicalls>(context, listen: false)
                                      .token;
                              Provider.of<InfrastructureApis>(context,
                                      listen: false)
                                  .deleteWareHouseCategory(
                                      widget.warehouseList[widget.index]['id'],
                                      token)
                                  .then((value) {
                                if (value == 200 || value == 204) {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => SuccessDialog(
                                          title: 'Success',
                                          subTitle:
                                              'SuccessFully Added WareHouse Category'));
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => FailureDialog(
                                        title: 'Failed',
                                        subTitle:
                                            'Something Went Wrong Please Try Again'),
                                  );
                                }
                              });
                            });
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                );
              },
              isExpanded: isOpened,
              canTapOnHeader: true,
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var data in widget.warehouseList[widget.index]
                      ['Sub_Category'])
                    data == null
                        ? GetWareHouseSubCategory(
                            name: '',
                            key: UniqueKey(),
                          )
                        : GetWareHouseSubCategory(
                            name: data,
                            key: UniqueKey(),
                          ),
                  ListTile(
                    title: IconButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final userData = json.encode(
                            {
                              'id': widget.warehouseList[widget.index]['id'],
                              'name': widget.warehouseList[widget.index]
                                  ['Category'],
                            },
                          );
                          prefs.setString('CategoryName', userData);

                          Get.toNamed(
                            AddWareHouseSubCategory.routeName,
                          );
                        },
                        icon: const Icon(Icons.add)),
                  )
                ],
              ))
        ],
        expansionCallback: (i, isOpen) => setState(
          () {
            isOpened = !isOpen;
          },
        ),
      ),
    );
  }
}

class GetWareHouseSubCategory extends StatefulWidget {
  const GetWareHouseSubCategory({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  State<GetWareHouseSubCategory> createState() =>
      _GetWareHouseSubCategoryState();
}

class _GetWareHouseSubCategoryState extends State<GetWareHouseSubCategory> {
  List wareHouseSubCategoryDetails = [];
  @override
  void initState() {
    // Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
    //   var token = Provider.of<Apicalls>(context, listen: false).token;
    //   Provider.of<InfrastructureApis>(context, listen: false)
    //       .getWarehouseSubCategoryForDisplay(widget.id, token)
    //       .then((value1) {
    //     wareHouseSubCategoryDetails = value1;
    //     setState(() {});
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // wareHouseSubCategoryDetails = Provider.of<InfrastructureApis>(
    //   context,
    // ).warehouseSubCategory;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        ListTile(
          title: Text(widget.name),
          trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
        )
      ],
    );
  }
}
