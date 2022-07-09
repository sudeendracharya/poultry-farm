import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:provider/provider.dart';

import '../../styles.dart';
import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';

class AddWareHouseSectionDialog extends StatefulWidget {
  AddWareHouseSectionDialog({Key? key}) : super(key: key);

  @override
  _AddWareHouseSectionDialogState createState() =>
      _AddWareHouseSectionDialogState();
}

class _AddWareHouseSectionDialogState extends State<AddWareHouseSectionDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController sectionCodeController = TextEditingController();
  TextEditingController sectionNumberOfLinesController =
      TextEditingController();

  Map<String, dynamic> wareHouseSection = {
    'WareHouse_Id': '',
    'WareHouse_Section_Code': '',
    'WareHouse_Section_Number_Of_Lines': '',
  };

  var sectionCode;
  var sectionNumberOfLines;
  List temp = [];

  void genearteSectionNumberOfLines(var code, var numberOfLines) {
    if (numberOfLines == null || numberOfLines == 0 || code == null) {
      return;
    } else {
      for (int i = 0; i < numberOfLines; i++) {
        temp.add(code + 'L' + i);
      }
      // print(temp);
    }
  }

  //  void initState() {
  //   super.initState();
  //   Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
  //     var token = Provider.of<Apicalls>(context, listen: false).token;
  //     Provider.of<InfrastructureApis>(context, listen: false)
  //         .getWarehouseDetails(token)
  //         .then((value1) {});
  //   });
  // }
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
            .addWareHouseSectionDetails('', wareHouseSection, token)
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
                          child: const Text('WareHouse Id'),
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
                                  // hintText:
                                  //     'Enter Ware House Section Code:',
                                  border: InputBorder.none),
                              validator: (value) {},
                              onSaved: (value) {
                                wareHouseSection['WareHouse_Id'] = value!;
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
                          child: const Text('WareHouse Section Code'),
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
                                  hintText: 'Enter Ware House Section Code:',
                                  border: InputBorder.none),
                              onFieldSubmitted: (value) {
                                sectionCode = value;
                                genearteSectionNumberOfLines(
                                  value,
                                  sectionNumberOfLines,
                                );
                              },
                              onChanged: (value) {},
                              validator: (value) {},
                              onSaved: (value) {
                                wareHouseSection['WareHouse_Section_Code'] =
                                    value!;
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
                          child:
                              const Text('WareHouse Section Number Of Lines'),
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
                                  hintText:
                                      'Enter Ware House Section Number Of Lines:',
                                  border: InputBorder.none),
                              validator: (value) {},
                              onSaved: (value) {
                                wareHouseSection[
                                        'WareHouse_Section_Number_Of_Lines'] =
                                    value!;
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
                          child: const Text('Line Id'),
                        ),
                        Container(
                          width: 440,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: ListView.builder(
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                return GenerateLineIds();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                              onPressed: save,
                              child: Text(
                                'Add Details',
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
                      // : Padding(
                      //     padding:
                      //         const EdgeInsets.symmetric(vertical: 74.0),
                      //     child: SizedBox(
                      //       width: 200,
                      //       height: 48,
                      //       child: ElevatedButton(
                      //           style: ButtonStyle(
                      //             backgroundColor:
                      //                 MaterialStateProperty.all(
                      //               const Color.fromRGBO(44, 96, 154, 1),
                      //             ),
                      //           ),
                      //           onPressed: updateData,
                      //           child: Text(
                      //             'Update',
                      //             style: GoogleFonts.roboto(
                      //               textStyle: const TextStyle(
                      //                 fontWeight: FontWeight.w500,
                      //                 fontSize: 18,
                      //                 color: Color.fromRGBO(
                      //                     255, 254, 254, 1),
                      //               ),
                      //             ),
                      //           )),
                      //     ),
                      //   ),
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
      ),
    );
  }
}

class GenerateLineIds extends StatefulWidget {
  const GenerateLineIds({
    Key? key,
  }) : super(key: key);

  @override
  State<GenerateLineIds> createState() => _GenerateLineIdsState();
}

class _GenerateLineIdsState extends State<GenerateLineIds> {
  var selected = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: selected, onChanged: (value) {}),
      ],
    );
  }
}
