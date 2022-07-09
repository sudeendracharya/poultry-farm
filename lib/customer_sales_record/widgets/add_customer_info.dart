import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/customer_sales_record/providers/cust_sales_api.dart';
import 'package:provider/provider.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';

class AddCustomerInfo extends StatefulWidget {
  AddCustomerInfo({Key? key}) : super(key: key);
  static const routeName = '/AddCustomerInfo';

  @override
  _AddCustomerInfoState createState() => _AddCustomerInfoState();
}

class _AddCustomerInfoState extends State<AddCustomerInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var itemId;
  var batchId;
  var wareHouseId;

  Map<String, dynamic> customerInfo = {
    'Customer_Contact_Number': null,
    'Customer_Name': null,
  };

  void save() {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    // print(customerInfo);

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<CustomerSalesApis>(context, listen: false)
          .addCustomerInfo(customerInfo, token)
          .then((value) {
        if (value == 200 || value == 201) {
          showDialog(
            context: context,
            builder: (ctx) => SuccessDialog(
                title: 'Success', subTitle: 'SuccessFully Added Customer Info'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer Details'),
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
              //       const Text('Customer Name'),
              //       DropdownButton(
              //         value: itemId,
              //         items: ['Android', 'Ios', 'Flutter']
              //             .map<DropdownMenuItem<String>>((e) {
              //           return DropdownMenuItem(
              //             child: Text(e),
              //             value: e,
              //           );
              //         }).toList(),
              //         hint: Text('Please Ware House Id'),
              //         onChanged: (value) {
              //           setState(() {
              //             itemId = value as String?;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   width: 600,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       const Text('Customer Name'),
              //       DropdownButton(
              //         value: batchId,
              //         items: ['Android', 'Ios', 'Flutter']
              //             .map<DropdownMenuItem<String>>((e) {
              //           return DropdownMenuItem(
              //             child: Text(e),
              //             value: e,
              //           );
              //         }).toList(),
              //         hint: Text('Please Choose the Breed Id'),
              //         onChanged: (value) {
              //           setState(() {
              //             batchId = value as String?;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   width: 600,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       const Text('Activity Id'),
              //       DropdownButton(
              //         value: wareHouseId,
              //         items: ['Android', 'Ios', 'Flutter']
              //             .map<DropdownMenuItem<String>>((e) {
              //           return DropdownMenuItem(
              //             child: Text(e),
              //             value: e,
              //           );
              //         }).toList(),
              //         hint: Text('Please Choose the Activity Id'),
              //         onChanged: (value) {
              //           setState(() {
              //             wareHouseId = value as String?;
              //           });
              //         },
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
                    const Text('Customer Name'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          customerInfo['Customer_Name'] = value!;
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
                    const Text('Customer Contact Number: '),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          customerInfo['Customer_Contact_Number'] = value!;
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
