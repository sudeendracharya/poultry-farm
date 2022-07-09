import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/batch_plan/providers/batch_plan_apis.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';

class AddBatchPlanMapping extends StatefulWidget {
  AddBatchPlanMapping({Key? key}) : super(key: key);
  static const routeName = '/AddBatchPlanMapping';
  @override
  _AddBatchPlanMappingState createState() => _AddBatchPlanMappingState();
}

class _AddBatchPlanMappingState extends State<AddBatchPlanMapping> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var itemId;
  var batchId;
  var wareHouseId;
  var _selectdate;
  var myFormatData = DateFormat('dd-MM-yyyy');
  var sendFormatData = DateFormat('yyyy-MM-dd');

  Map<String, dynamic> batchPlanMapping = {
    'Batch_Plan_Id': null,
    'Batch_Code': '',
    'Status': '',
    'Required_Quantity': null,
    'Required_Date_Of_Delivery': null,
    'Received_Quantity': null,
    'Received_Date': null,
    'Hatch_Date': null,
    'Bird_Age_Name': '',
  };
  TextEditingController _txtFormCtrl = TextEditingController();
  TextEditingController _receivedDateCtrl = TextEditingController();
  TextEditingController _hatchDateCtrl = TextEditingController();

  List batchPlanData = [];
  @override
  void initState() {
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<BatchApis>(context, listen: false)
          .getBatchPlan(token)
          .then((value1) {});
    });
    super.initState();
  }

  void _dateOfDelivery() {
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
        batchPlanMapping['Required_Date_Of_Delivery'] =
            sendFormatData.format(pickedDate);
        _txtFormCtrl.text = myFormatData.format(pickedDate);
      });
    });
  }

  void _receivedDate() {
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
        batchPlanMapping['Received_Date'] = sendFormatData.format(pickedDate);
        _receivedDateCtrl.text = myFormatData.format(pickedDate);
      });
    });
  }

  void _hatchDate() {
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
        batchPlanMapping['Hatch_Date'] = sendFormatData.format(pickedDate);
        _hatchDateCtrl.text = myFormatData.format(pickedDate);
      });
    });
  }

  void save() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<BatchApis>(context, listen: false)
          .addBatchPlanMapping(batchPlanMapping, token)
          .then((value) {
        if (value == 200 || value == 201) {
          showDialog(
            context: context,
            builder: (ctx) => SuccessDialog(
                title: 'Success',
                subTitle: 'SuccessFully Added Batch Plan Mapping'),
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
    batchPlanData = Provider.of<BatchApis>(context).batchPlan;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Batch Plan Mapping'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Batch Plan Id'),
                    DropdownButton(
                      value: itemId,
                      items: batchPlanData.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem(
                          child: Text(e['Batch_Code']),
                          value: e['Batch_Code'],
                          onTap: () {
                            // firmId = e['Firm_Code'];
                            batchPlanMapping['Batch_Plan_Id'] =
                                e['Batch_Plan_Id'].toString();
                          },
                        );
                      }).toList(),
                      hint: const Text('Please Select Batch Plan Id'),
                      onChanged: (value) {
                        setState(() {
                          itemId = value as String?;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Batch Code: '),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          batchPlanMapping['Batch_Code'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Status'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          batchPlanMapping['Status'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Required Quantity'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          batchPlanMapping['Required_Quantity'] =
                              int.parse(value!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Expanded(child: Text('Required Date Of Delivery')),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        enabled: false,
                        controller: _txtFormCtrl,
                        // initialValue: 'Please Select date',
                        // onSaved: (value) {
                        //   batchPlanMapping['Required_Date_Of_Delivery'] =
                        //       value!;
                        // },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: _dateOfDelivery,
                        child: const Text('Pick Date'))
                  ],
                ),
              ),
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Received Quantity'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          batchPlanMapping['Received_Quantity'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Expanded(child: Text('Received Date')),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        enabled: false,
                        controller: _receivedDateCtrl,
                        // onSaved: (value) {
                        //   batchPlanMapping['Received_Date'] = value!;
                        // },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: _receivedDate,
                        child: const Text('Pick Date'))
                  ],
                ),
              ),
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Expanded(child: Text('Hatch Date')),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        enabled: false,
                        controller: _hatchDateCtrl,
                        // onSaved: (value) {
                        //   batchPlanMapping['Hatch_Date'] = value!;
                        // },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: _hatchDate, child: const Text('Pick Date'))
                  ],
                ),
              ),
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Bird Age Name'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          batchPlanMapping['Bird_Age_Name'] = value!;
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
