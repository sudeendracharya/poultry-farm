import 'package:flutter/material.dart';

class AddUserCredentials extends StatefulWidget {
  AddUserCredentials({Key? key}) : super(key: key);
  static const routeName = '/AddUserCredentials';

  @override
  _AddUserCredentialsState createState() => _AddUserCredentialsState();
}

class _AddUserCredentialsState extends State<AddUserCredentials> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var wareHouseId;

  var userCredentials = {
    'User_Name': '',
    'Password': '',
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User Credentials'),
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
                    const Text('User Name'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          userCredentials['User_Name'] = value!;
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
                    const Text('Password'),
                    SizedBox(
                      width: 400,
                      child: TextFormField(
                        onSaved: (value) {
                          userCredentials['Password'] = value!;
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
