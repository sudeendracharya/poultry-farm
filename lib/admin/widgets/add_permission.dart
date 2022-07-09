import 'package:flutter/material.dart';

class AddPermission extends StatefulWidget {
  const AddPermission({Key? key}) : super(key: key);
  static const routeName = '/AddPermission';

  @override
  _AddPermissionState createState() => _AddPermissionState();
}

class _AddPermissionState extends State<AddPermission> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var wareHouseId;

  Map<String, dynamic> permission = {
    'Permission_Id': null,
    'User_Name': null,
    'Module_Name': '',
    'Update': null,
    'Delete': null,
    'Read': null,
    'Create': null,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Activity plan'),
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
                    Text('Permission Id'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          permission['Permission_Id'] = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   width: 600,
              //   child: DropdownButton(
              //     value: wareHouseId,
              //     items: ['Android', 'Ios', 'Flutter']
              //         .map<DropdownMenuItem<String>>((e) {
              //       return DropdownMenuItem(
              //         child: Text(e),
              //         value: e,
              //       );
              //     }).toList(),
              //     hint: Text('Please Choose the Ware House Id'),
              //     onChanged: (value) {
              //       setState(() {
              //         wareHouseId = value as String?;
              //       });
              //     },
              //   ),
              // ),
              SizedBox(
                width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('User Name'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          permission['User_Name'] = value!;
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
                    const Text('Module Name'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          permission['Module_Name'] = value!;
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
                    const Text('Update'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          permission['Update'] = value!;
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
                    const Text('Delete'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          permission['Delete'] = value!;
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
                    const Text('Read'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          permission['Read'] = value!;
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
                    const Text('Create'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          permission['Create'] = value!;
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
