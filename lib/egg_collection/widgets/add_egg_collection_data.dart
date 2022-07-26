import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/egg_collection/providers/egg_collection_apis.dart';
import 'package:poultry_login_signup/grading/providers/grading_apis.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';

class AddEggCollectionData extends StatefulWidget {
  AddEggCollectionData({Key? key}) : super(key: key);
  static const routeName = '/AddEggCollectionData';

  @override
  _AddEggCollectionDataState createState() => _AddEggCollectionDataState();
}

enum status { pending, complete }

class _AddEggCollectionDataState extends State<AddEggCollectionData> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  status statusSelected = status.pending;

  List plantList = [];

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  List warehouseDetails = [];
  var wareHouseId;
  var myFormatData = DateFormat('dd-MM-yyyy');
  var sendFormatData = DateFormat('yyyy-MM-dd');
  TextEditingController _txtFormCtrl = TextEditingController();

  List eggGradeList = [];
  var eggGradeId;

  void initState() {
    Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      // Provider.of<ItemApis>(context, listen: false)
      //     .getItemDetails(token)
      //     .then((value1) {});
      var firmId = await getFirmData();
      if (firmId != '') {
        fechplantList(firmId, context);
      }

      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseDetails(firmId, token)
          .then((value1) {});
      Provider.of<GradingApis>(context, listen: false)
          .getEggGrading(token)
          .then((value1) {});

      // Provider.of<ItemApis>(context, listen: false)
      //     .getInventoryItems(token)
      //     .then((value1) {});
    });
  }

  Map<String, dynamic> eggCollectionData = {
    'Egg_Collection_Id': null,
    'Egg_Grade_Id': '',
    'Egg_Quantity': null,
    'Egg_Collection_Date': '',
    'Average_Egg_Weight': null,
    'Egg_Collection_Status': '',
    'Is_Cleared': '',
    'Ware_House_Id': '',
    'Unit': '',
  };

  void _eggCollectionDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2016),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        eggCollectionData['Egg_Collection_Date'] =
            sendFormatData.format(pickedDate);
        // print(eggCollectionData['Egg_Collection_Date']);
        _txtFormCtrl.text = myFormatData.format(pickedDate);
      });
    });
  }

  void save() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    // print(eggCollectionData);

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<EggCollectionApis>(context, listen: false)
          .addEggCollection(eggCollectionData, token)
          .then((value) {
        if (value == 200 || value == 201) {
          showDialog(
            context: context,
            builder: (ctx) => SuccessDialog(
                title: 'Success',
                subTitle: 'SuccessFully Added Egg Collection'),
          );
          _formKey.currentState!.reset();
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
  }

  @override
  Widget build(BuildContext context) {
    warehouseDetails = Provider.of<InfrastructureApis>(
      context,
    ).warehouseDetails;
    eggGradeList = Provider.of<GradingApis>(context).eggGradingList;
    plantList = Provider.of<InfrastructureApis>(
      context,
    ).plantDetails;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Egg Collection Details'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              // Container(
              //   width: 600,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Container(
              //         width: 200,
              //         child: const Text('Egg Collection Id'),
              //       ),
              //       Container(
              //         width: 400,
              //         child: TextFormField(
              //           validator: (value) {},
              //           onSaved: (value) {
              //             eggCollectionData['Egg_Collection_Id'] = value!;
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
                    Container(
                      width: 200,
                      child: const Text('Grade'),
                    ),
                    DropdownButton(
                      value: eggGradeId,
                      items: eggGradeList.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem(
                          value: e['Egg_Grade_Name'],
                          onTap: () {
                            eggCollectionData['Egg_Grade_Id'] =
                                int.parse(e['Egg_Grade_Id'].toString());
                            // print(eggCollectionData['Egg_Grade_Id']);
                          },
                          child: Text(e['Egg_Grade_Name']),
                        );
                      }).toList(),
                      hint: Container(
                          width: 350,
                          child: const Text('Please Choose ware house code')),
                      onChanged: (value) {
                        setState(() {
                          eggGradeId = value;
                        });
                      },
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
                    Text('Unit:'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          eggCollectionData['Unit'] = value!;
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
                    Text('Egg Quantity:'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          eggCollectionData['Egg_Quantity'] = value!;
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
                    Expanded(child: Text('Egg Collection Date:')),
                    Container(
                      width: 400,
                      child: TextFormField(
                        enabled: false,
                        controller: _txtFormCtrl,
                        // onSaved: (value) {
                        //   eggCollectionData['Egg_Collection_Date'] = value!;
                        // },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: _eggCollectionDate,
                        child: const Text('Pick Date'))
                  ],
                ),
              ),
              Container(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Average Egg Weight: '),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          eggCollectionData['Average_Egg_Weight'] = value!;
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
                    Text('Egg Collection Status:'),
                    Container(
                        width: 400,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    activeColor: Colors.black,
                                    value: status.pending,
                                    groupValue: statusSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        eggCollectionData[
                                                'Egg_Collection_Status'] =
                                            'Pending';
                                        // print(eggCollectionData[
                                        //     'Egg_Collection_Status']);
                                        statusSelected = value as status;
                                      });
                                    }),
                                const Text('Pending')
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    activeColor: Colors.black,
                                    value: status.complete,
                                    groupValue: statusSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        eggCollectionData[
                                                'Egg_Collection_Status'] =
                                            'Complete';

                                        statusSelected = value as status;
                                      });
                                    }),
                                const Text('Complete')
                              ],
                            )
                          ],
                        )),
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
                      child: const Text('Is Cleared:'),
                    ),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          eggCollectionData['Is_Cleared'] = value!;
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
                    const Text('Choose warehouse code'),
                    Container(
                      width: 400,
                      child: DropdownButton(
                        value: wareHouseId,
                        items:
                            warehouseDetails.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            value: e['WareHouse_Code'],
                            onTap: () {
                              eggCollectionData['Ware_House_Id'] =
                                  e['WareHouse_Id'];
                            },
                            child: Text(e['WareHouse_Code']),
                          );
                        }).toList(),
                        hint: Container(
                            width: 350,
                            child: const Text('Please Choose ware house Id')),
                        onChanged: (value) {
                          setState(() {
                            wareHouseId = value;
                          });
                        },
                      ),
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
