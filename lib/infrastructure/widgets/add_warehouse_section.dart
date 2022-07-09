import 'package:flutter/material.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:provider/provider.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';

class AddWareHouseSection extends StatefulWidget {
  AddWareHouseSection({Key? key}) : super(key: key);
  static const routeName = '/AddWarehouseSection';

  @override
  _AddWareHouseSectionState createState() => _AddWareHouseSectionState();
}

class _AddWareHouseSectionState extends State<AddWareHouseSection> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  List wareHouseDetails = [];
  var wareHouseId;
  var update = false;
  var wareHouseSectionId;

  Map<String, dynamic> wareHouseSectionSection = {
    'WareHouse_Id': '',
    'WareHouse_Section_Code': '',
    'WareHouse_Section_Number_Of_Lines': '',
  };

  Map<String, dynamic> initvalues = {
    'WareHouse_Id': '',
    'WareHouse_Section_Id': '',
    'WareHouse_Section_Code': '',
    'WareHouse_Section_Number_Of_Lines': '',
  };

  void initState() {
    super.initState();
    Provider.of<Apicalls>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      var plantId = await fetchPlant();
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWarehouseDetails(plantId, token)
          .then((value1) {});
    });
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      var data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      update = true;
      wareHouseSectionSection['WareHouse_Id'] = data['WareHouse_Id'].toString();
      wareHouseSectionId = data['WareHouse_Section_Id'].toString();

      initvalues = {
        'WareHouse_Id': data['WareHouse_Id'].toString(),
        'WareHouse_Section_Id': data['WareHouse_Section_Id'].toString(),
        'WareHouse_Section_Code': data['WareHouse_Section_Code'].toString(),
        'WareHouse_Section_Number_Of_Lines':
            data['WareHouse_Section_Number_Of_Lines'].toString()
      };
    }

    super.didChangeDependencies();
  }

  Future<void> save() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    // print(wareHouseDetails);

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .addWareHouseSectionDetails('', wareHouseSectionSection, token)
            .then((value) {
          if (value == 200 || value == 201) {
            showDialog(
                context: context,
                builder: (ctx) => SuccessDialog(
                    title: 'Success',
                    subTitle: 'SuccessFully Added Ware House Section Details'));
            _formKey.currentState!.reset();
          } else {
            showDialog(
                context: context,
                builder: (ctx) => FailureDialog(
                    title: 'Failed',
                    subTitle: 'Something Went Wrong Please Try Again'));
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateData() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    // print(wareHouseDetails);

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .editWareHouseSectionCodes(wareHouseSectionSection, token)
            .then((value) {
          if (value == 200 || value == 201) {
            showDialog(
                context: context,
                builder: (ctx) => SuccessDialog(
                    title: 'Success',
                    subTitle: 'SuccessFully Added Ware House Section Details'));
            _formKey.currentState!.reset();
          } else {
            showDialog(
                context: context,
                builder: (ctx) => FailureDialog(
                    title: 'Failed',
                    subTitle: 'Something Went Wrong Please Try Again'));
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    wareHouseDetails = Provider.of<InfrastructureApis>(
      context,
    ).warehouseDetails;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add WareHouse Section Details'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Container(
                width: 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Ware house Id'),
                    Container(
                      width: 385,
                      child: DropdownButton(
                        value: wareHouseId,
                        items:
                            wareHouseDetails.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem(
                            child: Text(e['WareHouse_Code']),
                            value: e['WareHouse_Code'],
                            onTap: () {
                              // firmId = e['Firm_Code'];
                              wareHouseSectionSection['WareHouse_Id'] =
                                  e['WareHouse_Id'];
                              //print(warehouseCategory);
                            },
                          );
                        }).toList(),
                        hint: const Text('Please Choose wareHouse Id'),
                        onChanged: (value) {
                          setState(() {
                            wareHouseId = value as String;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   width: 700,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       const Text('Ware house Section Id'),
              //       Padding(
              //         padding: getPadding(),
              //         child: Container(
              //           width: 400,
              //           child: TextFormField(
              //             onSaved: (value) {
              //               wareHouseSectionSection['WareHouse_Section_Id'] =
              //                   value!;
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                width: 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Ware house Section Code'),
                    Padding(
                      padding: getPadding(),
                      child: Container(
                        width: 400,
                        child: TextFormField(
                          initialValue: initvalues['WareHouse_Section_Code'],
                          onSaved: (value) {
                            wareHouseSectionSection['WareHouse_Section_Code'] =
                                value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Ware house Section Number Of Lines'),
                    Padding(
                      padding: getPadding(),
                      child: Container(
                        width: 400,
                        child: TextFormField(
                          initialValue:
                              initvalues['WareHouse_Section_Number_Of_Lines'],
                          onSaved: (value) {
                            wareHouseSectionSection[
                                'WareHouse_Section_Number_Of_Lines'] = value!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              update == false
                  ? Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: ElevatedButton(
                          onPressed: save, child: const Text('Save')),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: ElevatedButton(
                          onPressed: updateData, child: const Text('Update')),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
