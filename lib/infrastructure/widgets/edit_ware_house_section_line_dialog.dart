import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:provider/provider.dart';

import '../../styles.dart';

class EditSectionLineDialog extends StatefulWidget {
  EditSectionLineDialog(
      {Key? key, required this.lineData, required this.reFresh})
      : super(key: key);
  final List lineData;
  final ValueChanged<int> reFresh;

  @override
  _EditSectionLineDialogState createState() => _EditSectionLineDialogState();
}

class _EditSectionLineDialogState extends State<EditSectionLineDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, dynamic> updateSingleLines = {
    'Line_Id': '',
    'Box_Count': '',
    'Max_Box_Capacity': '',
    'Height': '',
    'Length': '',
    'Breadth': '',
  };
  List newSectionLineCodes = [];
  List finalSectionLineDetails = [];
  void update(Map<String, dynamic> newSection) {
    var replace = false;
    if (newSectionLineCodes.isEmpty) {
      newSectionLineCodes.add(newSection);
    } else {
      for (int i = 0; i < newSectionLineCodes.length; i++) {
        if (newSectionLineCodes[i]['index'] == newSection['index']) {
          newSectionLineCodes.removeAt(i);
          newSectionLineCodes.add(newSection);
          replace = true;
        }
      }
      if (replace == false) {
        newSectionLineCodes.add(newSection);
      }
    }

    // print(newSectionLineCodes);
  }

  Future<void> save() async {
    _formKey.currentState!.save();
    if (newSectionLineCodes.isEmpty) {
      for (int i = 0; i < widget.lineData.length; i++) {
        finalSectionLineDetails.add({
          'WareHouse_Section_Line_Id': widget.lineData[i]
              ['warehouse_section_line__WareHouse_Section_Line_Id'],
          'WareHouse_Section_Line_Code': widget.lineData[i]
              ['warehouse_section_line__WareHouse_Section_Line_Code'],
          'WareHouse_Section_Line_Number_Of_Boxes':
              updateSingleLines['Box_Count'],
          'WareHouse_Section_Line_Maximum_Box_Capacity':
              updateSingleLines['Max_Box_Capacity'],
          'WareHouse_Section_Line_Box_Length': updateSingleLines['Length'],
          'WareHouse_Section_Line_Box_Breadth': updateSingleLines['Breadth'],
          'WareHouse_Section_Line_Box_Height': updateSingleLines['Height'],
        });
      }
    } else {
      if (newSectionLineCodes.length == widget.lineData.length) {
        for (int i = 0; i < newSectionLineCodes.length; i++) {
          finalSectionLineDetails.add({
            'WareHouse_Section_Line_Id': newSectionLineCodes[i]['Line_Id'],
            'WareHouse_Section_Line_Code': newSectionLineCodes[i]
                ['newLineCode'],
            'WareHouse_Section_Line_Number_Of_Boxes':
                updateSingleLines['Box_Count'],
            'WareHouse_Section_Line_Maximum_Box_Capacity':
                updateSingleLines['Max_Box_Capacity'],
            'WareHouse_Section_Line_Box_Length': updateSingleLines['Length'],
            'WareHouse_Section_Line_Box_Breadth': updateSingleLines['Breadth'],
            'WareHouse_Section_Line_Box_Height': updateSingleLines['Height'],
          });
        }
      } else {
        for (int i = 0; i < widget.lineData.length; i++) {
          for (int j = 0; j < newSectionLineCodes.length; j++) {
            if (newSectionLineCodes[j]['Line_Id'] ==
                widget.lineData[i]
                    ['warehouse_section_line__WareHouse_Section_Line_Id']) {
              widget.lineData.removeAt(i);
            }
          }
        }
        for (int i = 0; i < widget.lineData.length; i++) {
          newSectionLineCodes.add({
            'newLineCode': widget.lineData[i]
                ['warehouse_section_line__WareHouse_Section_Line_Code'],
            'Line_Id': widget.lineData[i]
                ['warehouse_section_line__WareHouse_Section_Line_Id'],
          });
        }
        for (int i = 0; i < newSectionLineCodes.length; i++) {
          finalSectionLineDetails.add({
            'WareHouse_Section_Line_Id': newSectionLineCodes[i]['Line_Id'],
            'WareHouse_Section_Line_Code': newSectionLineCodes[i]
                ['newLineCode'],
            'WareHouse_Section_Line_Number_Of_Boxes':
                updateSingleLines['Box_Count'],
            'WareHouse_Section_Line_Maximum_Box_Capacity':
                updateSingleLines['Max_Box_Capacity'],
            'WareHouse_Section_Line_Box_Length': updateSingleLines['Length'],
            'WareHouse_Section_Line_Box_Breadth': updateSingleLines['Breadth'],
            'WareHouse_Section_Line_Box_Height': updateSingleLines['Height'],
          });
        }
      }
    }
    // print(finalSectionLineDetails);
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .editWareHouseSectionLineDetails(finalSectionLineDetails, token)
          .then((value1) {
        if (value1 == 202 || value1 == 201) {
          Get.back();
          widget.reFresh(100);
          successSnackbar('Successfully updated the section line details');
        } else {
          failureSnackbar('Something went wrong please try again later');
        }
      });

      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Section Lines',
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
                          child: const Text('Line Codes'),
                        ),
                        Container(
                          width: 440,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.lineData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: DisplayLineIds(
                                  lineIds: widget.lineData,
                                  data: update,
                                  index: index,
                                  key: UniqueKey(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      width: 440,
                      height: 300,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromRGBO(190, 190, 190, 1)),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 374,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text('Box Count:'),
                            ),
                            Container(
                              width: 374,
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
                                      hintText: 'Total Number of Boxes',
                                      border: InputBorder.none),
                                  onChanged: (value) {},
                                  validator: (value) {},
                                  onSaved: (value) {
                                    updateSingleLines['Box_Count'] = value!;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                width: 374,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text('Max Box Capacity:'),
                              ),
                            ),
                            Container(
                              width: 374,
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
                                      hintText: 'Maximum Box Capacity',
                                      border: InputBorder.none),
                                  onChanged: (value) {},
                                  validator: (value) {},
                                  onSaved: (value) {
                                    updateSingleLines['Max_Box_Capacity'] =
                                        value!;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                width: 374,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.0),
                                          child: Text('Box Length'),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black26),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  hintText: 'Length',
                                                  border: InputBorder.none),
                                              onChanged: (value) {},
                                              validator: (value) {},
                                              onSaved: (value) {
                                                updateSingleLines['Length'] =
                                                    value!;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Column(
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.0),
                                          child: Text('Box Height'),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black26),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  hintText: 'Height',
                                                  border: InputBorder.none),
                                              onChanged: (value) {},
                                              validator: (value) {},
                                              onSaved: (value) {
                                                updateSingleLines['Height'] =
                                                    value!;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Column(
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.0),
                                          child: Text('Box Breadth'),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black26),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  hintText: 'Breadth',
                                                  border: InputBorder.none),
                                              onChanged: (value) {},
                                              validator: (value) {},
                                              onSaved: (value) {
                                                updateSingleLines['Breadth'] =
                                                    value!;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                'Update Details',
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

class DisplayLineIds extends StatefulWidget {
  const DisplayLineIds({
    Key? key,
    required this.lineIds,
    required this.index,
    required this.data,
  }) : super(key: key);

  final List lineIds;
  final int index;
  final ValueChanged<Map<String, dynamic>> data;

  @override
  State<DisplayLineIds> createState() => _DisplayLineIdsState();
}

class _DisplayLineIdsState extends State<DisplayLineIds> {
  TextEditingController controller = TextEditingController();
  final FocusNode sectionFocus = FocusNode();

  @override
  void initState() {
    controller.text = widget.lineIds[widget.index]
        ['warehouse_section_line__WareHouse_Section_Line_Code'];
    sectionFocus.addListener(save);
    super.initState();
  }

  void save() {
    if (sectionFocus.hasFocus == false) {
      // print(controller.text);
      widget.data({
        'index': widget.index,
        'newLineCode': controller.text,
        'Line_Id': widget.lineIds[widget.index]
            ['warehouse_section_line__WareHouse_Section_Line_Id']
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 440,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: TextFormField(
          focusNode: sectionFocus,
          controller: controller,
          decoration: const InputDecoration(
              hintText: 'Enter Line Code', border: InputBorder.none),
          validator: (value) {},
          onSaved: (value) {
            // wareHouseSection[
            //         'WareHouse_Section_Number_Of_Lines'] =
            //     value!;
          },
        ),
      ),
    );
  }
}
