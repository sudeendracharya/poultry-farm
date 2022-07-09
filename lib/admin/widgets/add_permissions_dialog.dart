import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/styles.dart';

class AddPermissionsDialog extends StatefulWidget {
  AddPermissionsDialog({Key? key}) : super(key: key);

  @override
  _AddPermissionsDialogState createState() => _AddPermissionsDialogState();
}

class _AddPermissionsDialogState extends State<AddPermissionsDialog> {
  Map<String, dynamic> permission = {
    'User_Name': null,
    'Module_Name': '',
    'Update': null,
    'Delete': null,
    'Read': null,
    'Create': null,
  };

  var readSelected = false;

  var deleteSelected = false;

  var addSelected = false;

  var updateSelected = false;

  void save() {}
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 600,
        height: MediaQuery.of(context).size.height / 1.9,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Permissions',
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 36)),
                  )
                ],
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
                        child: const Text('User Name'),
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
                                hintText: 'Enter User Name',
                                border: InputBorder.none),
                            validator: (value) {},
                            onSaved: (value) {
                              permission['User_Name'] = value!;
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
                        child: const Text('Module Name'),
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
                                hintText: 'Enter Module Name',
                                border: InputBorder.none),
                            validator: (value) {},
                            onSaved: (value) {
                              permission['Module_Name'] = value!;
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
                child: Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                            activeColor: Theme.of(context).backgroundColor,
                            value: addSelected,
                            onChanged: (value) {
                              setState(() {
                                addSelected = value!;
                              });
                            }),
                        const Text('Add')
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                            activeColor: Theme.of(context).backgroundColor,
                            value: updateSelected,
                            onChanged: (value) {
                              setState(() {
                                updateSelected = value!;
                              });
                            }),
                        const Text('Update')
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                            activeColor: Theme.of(context).backgroundColor,
                            value: deleteSelected,
                            onChanged: (value) {
                              setState(() {
                                deleteSelected = value!;
                              });
                            }),
                        const Text('Delete')
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                            activeColor: Theme.of(context).backgroundColor,
                            value: readSelected,
                            onChanged: (value) {
                              setState(() {
                                readSelected = value!;
                              });
                            }),
                        const Text('Read')
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: SizedBox(
                        width: 200,
                        height: 48,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color.fromRGBO(44, 96, 154, 1),
                              ),
                            ),
                            onPressed: save,
                            child: Text(
                              'Add Permissions',
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Color.fromRGBO(255, 254, 254, 1),
                                ),
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 42,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 200,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromRGBO(44, 96, 154, 1),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: ProjectStyles.cancelStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
