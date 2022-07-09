import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:provider/provider.dart';

import '../../styles.dart';

class EditWareHouseSectionDialog extends StatefulWidget {
  EditWareHouseSectionDialog(
      {Key? key, required this.sectionCodes, required this.reFresh})
      : super(key: key);

  final List sectionCodes;

  final ValueChanged<int> reFresh;

  @override
  _EditWareHouseSectionDialogState createState() =>
      _EditWareHouseSectionDialogState();
}

class _EditWareHouseSectionDialogState
    extends State<EditWareHouseSectionDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  List newSectionCodes = [];
  void update(Map<String, dynamic> newSection) {
    var replace = false;
    if (newSectionCodes.isEmpty) {
      newSectionCodes.add(newSection);
    } else {
      for (int i = 0; i < newSectionCodes.length; i++) {
        if (newSectionCodes[i]['index'] == newSection['index']) {
          newSectionCodes.removeAt(i);
          newSectionCodes.add(newSection);
          replace = true;
        }
      }
      if (replace == false) {
        newSectionCodes.add(newSection);
      }
    }

    // print(newSectionCodes);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sections',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                      color: Theme.of(context).backgroundColor,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.sectionCodes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return DisplaySectionCode(
                      data: update,
                      index: index,
                      sectionList: widget.sectionCodes,
                      // key: globalKey,
                      // formKey: _formKey,
                    );
                  },
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // widget.update == null
                      //     ?
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
                              onPressed: () {
                                // globalKey.currentState!.save();
                                Provider.of<Apicalls>(context, listen: false)
                                    .tryAutoLogin()
                                    .then((value) {
                                  var token = Provider.of<Apicalls>(context,
                                          listen: false)
                                      .token;
                                  Provider.of<InfrastructureApis>(context,
                                          listen: false)
                                      .editWareHouseSectionCodes(
                                          newSectionCodes, token)
                                      .then((value1) {
                                    if (value1 == 202 || value1 == 201) {
                                      Get.back();
                                      widget.reFresh(100);
                                      successSnackbar(
                                          'Successfully updated the sections');
                                    } else {
                                      failureSnackbar(
                                          'Something went wrong please try again');
                                    }
                                  });

                                  // Provider.of<InfrastructureApis>(context, listen: false)
                                  //     .getPlantDetails(token)
                                  //     .then((value1) {});
                                });
                                // print(newSectionCodes);
                              },
                              child: Text(
                                'Update Section',
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
                            borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }
}

// GlobalKey<_DisplaySectionCodeState> globalKey = GlobalKey();

class DisplaySectionCode extends StatefulWidget {
  const DisplaySectionCode({
    Key? key,
    required this.sectionList,
    required this.index,
    required this.data,
  }) : super(key: key);

  final List sectionList;
  final int index;
  final ValueChanged<Map<String, dynamic>> data;

  @override
  State<DisplaySectionCode> createState() => _DisplaySectionCodeState();
}

class _DisplaySectionCodeState extends State<DisplaySectionCode> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode sectionFocus = FocusNode();
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    sectionFocus.addListener(save);

    super.initState();
  }

  void save() {
    if (sectionFocus.hasFocus == false) {
      // print(controller.text);
      widget.data({
        'index': widget.index,
        'NewSection': controller.text,
        'Section_Id': widget.sectionList[widget.index]['WareHouse_Section_Id']
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Form(
        key: _formKey,
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 440,
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('Old Section Code'),
                    Text('New Section Code'),
                  ],
                ),
              ),
              Container(
                width: 440,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 55.0),
                      child: Container(
                          width: 440 / 3,
                          child: Text(widget.sectionList[widget.index]
                              ['Section_Code'])),
                    ),
                    const SizedBox(
                      width: 65,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 440 / 3,
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
                            focusNode: sectionFocus,
                            controller: controller,
                            decoration: const InputDecoration(
                                // hintText:
                                //     'Enter Ware House Section Code:',
                                border: InputBorder.none),
                            validator: (value) {},
                            onSaved: (value) {
                              // wareHouseSection['WareHouse_Id'] = value!;
                            },
                          ),
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
