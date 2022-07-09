import 'package:flutter/material.dart';

class AddSalesRecord extends StatefulWidget {
  AddSalesRecord({Key? key}) : super(key: key);
  static const routeName = '/AddSalesRecord';

  @override
  _AddSalesRecordState createState() => _AddSalesRecordState();
}

class _AddSalesRecordState extends State<AddSalesRecord> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var itemId;
  var batchId;
  var wareHouseId;

  Map<String, dynamic> salesRecordId = {
    'Sales_Record_Id': null,
    'Customer_Id': null,
    'Ware_House_Id': '',
    'Batch_ID': '',
    'Item_Id': null,
    'Bill_Number': null,
    'Quantity': null,
    'CW_Quantity': null,
    'CW_Unit': '',
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sales Record'),
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
              //       const Text('Sales Record Id'),
              //       DropdownButton(
              //         value: itemId,
              //         items: ['Android', 'Ios', 'Flutter']
              //             .map<DropdownMenuItem<String>>((e) {
              //           return DropdownMenuItem(
              //             child: Text(e),
              //             value: e,
              //           );
              //         }).toList(),
              //         hint: Text('Please Enter Batch Plan Id'),
              //         onChanged: (value) {
              //           setState(() {
              //             itemId = value as String?;
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
                    const Text('Sales Record Id: '),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          salesRecordId['Sales_Record_Id'] = value!;
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
                    Text('Customer Id'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          salesRecordId['Customer_Id'] = int.parse(value!);
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
                    Text('Ware House Id'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          salesRecordId['Ware_House_Id'] = value!;
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
                    Text('Batch Id'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          salesRecordId['Batch_Id'] = value!;
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
                    Text('Item Id'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          salesRecordId['Item_Id'] = value!;
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
                    Text('Bill Number'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          salesRecordId['Bill_Number'] = value!;
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
                    Text('Quantity'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          salesRecordId['Quantity'] = value!;
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
                    Text('Shipped Date '),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          salesRecordId['Shipped_Date'] = value!;
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
                    Text('CW Quantity'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          salesRecordId['CW_Quantity'] = value!;
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
                    Text('CW Unit'),
                    Container(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          salesRecordId['CW_Unit'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child:
                    ElevatedButton(onPressed: () {}, child: const Text('Save')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
