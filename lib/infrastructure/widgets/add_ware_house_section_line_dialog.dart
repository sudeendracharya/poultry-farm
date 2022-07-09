import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect/multiselect.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:provider/provider.dart';

import 'add_warehouse_details.dart';

class AddWareHouseSectionLineDialog extends StatefulWidget {
  AddWareHouseSectionLineDialog(
      {Key? key,
      this.sectionCode,
      this.addedLineCount,
      this.sectionId,
      required this.reFresh})
      : super(key: key);
  var sectionCode;
  var addedLineCount;
  var sectionId;
  final ValueChanged<int> reFresh;

  @override
  _AddWareHouseSectionLineDialogState createState() =>
      _AddWareHouseSectionLineDialogState();
}

class _AddWareHouseSectionLineDialogState
    extends State<AddWareHouseSectionLineDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _sectionKey = GlobalKey();
  final GlobalKey<FormState> _updateSingleLineKey = GlobalKey();
  final GlobalKey<FormState> _updateAllLineKey = GlobalKey();
  final TextEditingController sectionController = TextEditingController();

  List firmList = [];
  var firmId;
  List plantList = [];
  var plantId;

  var index = 0;
  var count = 0;

  var _selected = false;

  int lineCount = 0;

  var lineId;

  List individualLineDataList = [];
  List finalSectionDetailList = [];
  List individualdataList = [];

  var _isSucess = false;

  List sectionDataList = [];

  var formError = false;

  var selectedCode;

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  List warehouseCategory = [];
  List warehouseSubCategory = [];
  var sectionId;

  var warehouseCategoryId;
  var warehouseSubCategoryId;
  var plantDetailsId;
  var plantName;
  var isLoading = true;
  var sectionCode;
  var wareHouseName = 'Shed';
  var wareHouseCode = 'S01';
  List wareHouseSectionDetailsList = [];
  void deleteSingleLineData(Map<String, dynamic> value) {
    setState(() {
      individualLineDataList.removeAt(value['Index']);
      lineIds.add(value['Line_Id']);
    });
  }

  TextStyle getStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14));
  }

  List<String> lineIds = [];
  List<String> selected = [];
  Map<String, dynamic> updateAllLines = {
    'Line_Id': '',
    'Box_Count': '',
    'WareHouse_Section_Line_Maximum_Box_Capacity': '',
    'Height': '',
    'Length': '',
    'Breadth': '',
  };

  Map<String, dynamic> updateSingleLines = {
    'Line_Id': '',
    'Box_Count': '',
    'WareHouse_Section_Line_Maximum_Box_Capacity': '',
    'Height': '',
    'Length': '',
    'Breadth': '',
  };

  void generateLineCount(int count) {
    if (lineIds.isEmpty) {
      if (widget.addedLineCount != null) {
        for (int i = 0; i < count; i++) {
          lineIds
              .add('${widget.sectionCode}NL${widget.addedLineCount + i + 1}');
        }
      } else {
        for (int i = 0; i < count; i++) {
          lineIds.add('${widget.sectionCode}NL${i + 1}');
        }
      }

      setState(() {});
      // print(lineIds);
    } else {
      lineIds.clear();
      if (widget.addedLineCount != null) {
        for (int i = 0; i < count; i++) {
          lineIds
              .add('${widget.sectionCode}NL${widget.addedLineCount + i + 1}');
        }
      } else {
        for (int i = 0; i < count; i++) {
          lineIds.add('${widget.sectionCode}NL${i + 1}');
        }
      }

      setState(() {});
      // print(lineIds);
    }
  }

  Future<void> sendSectionDetails(List data) async {
    // print(data);

    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .addWareHouseSectionLineDetails(data[0], token)
          .then((value1) {
        if (value1 == 200 || value1 == 201) {
          individualdataList.clear();
          //finalSectionDetailList.clear();
          Get.back();
          widget.reFresh(100);
          successSnackbar('Successfully added the section line ');
        } else {
          individualdataList.clear();
          failureSnackbar('Something went wrong unable to add section line');
        }
      });

      // Provider.of<InfrastructureApis>(context, listen: false)
      //     .getPlantDetails(token)
      //     .then((value1) {});
    });
  }

  Future<void> save() async {
    if (individualLineDataList.isEmpty && _selected == false) {
      _updateAllLineKey.currentState!.save();
      for (int i = 0; i < lineIds.length; i++) {
        // updateAllLines['Line_Id'] = temp[i],
        individualdataList.add({
          'WareHouse_Section_Id': widget.sectionId,
          'Section_Code': widget.sectionCode,
          'WareHouse_Section_Line_Code': lineIds[i],
          'WareHouse_Section_Line_Number_Of_Boxes': updateAllLines['Box_Count'],
          'WareHouse_Section_Line_Maximum_Box_Capacity':
              updateAllLines['WareHouse_Section_Line_Maximum_Box_Capacity'],
          'WareHouse_Section_Line_Box_Length': updateAllLines['Length'],
          'WareHouse_Section_Line_Box_Breadth': updateAllLines['Breadth'],
          'WareHouse_Section_Line_Box_Height': updateAllLines['Height'],
        });
      }

      finalSectionDetailList.add({
        'WareHouse_Id': '1',
        'Section_Name': sectionId,
        'WareHouse_Section_Code': widget.sectionCode,
        'WareHouse_Section_Number_Of_Lines': individualdataList.length,
        'WareHouse_Section_Line_Details': individualdataList,
      });

      sendSectionDetails(finalSectionDetailList).then((value) {
        individualdataList.clear();
        finalSectionDetailList.clear();
      });
    } else {
      if (lineIds.isNotEmpty) {
        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).backgroundColor,
          message: 'Enter Data for All The Lines',
          title: 'Alert',
        ));
      } else {
        for (int i = 0; i < individualLineDataList.length; i++) {
          individualdataList.add(individualLineDataList[i]);
        }
        finalSectionDetailList.add({
          'WareHouse_Id': '1',
          'Section_Name': sectionId,
          'WareHouse_Section_Code': widget.sectionCode,
          'WareHouse_Section_Number_Of_Lines': individualdataList.length,
          'WareHouse_Section_Line_Details': individualdataList,
        });

        sendSectionDetails(finalSectionDetailList).then((value) {
          individualdataList.clear();
          finalSectionDetailList.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: SingleChildScrollView(
            child: Form(
              key: _updateAllLineKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'Section Lines',
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  color: Theme.of(context).backgroundColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 36)),
                        )
                      ],
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
                            child: const Text('Line Count:'),
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                    hintText: 'Total Number of Lines',
                                    border: InputBorder.none),
                                onChanged: (value) {
                                  if (value != '') {
                                    // print(value);
                                    lineCount = int.parse(value);
                                    generateLineCount(int.parse(value));
                                  } else {
                                    lineCount = 0;
                                    lineIds.clear();
                                    setState(() {});
                                  }
                                },
                                validator: (value) {},
                                onSaved: (value) {
                                  // wareHouseDetails['WareHouse_Name'] = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  wareHouseSectionDetailsList.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 24.0, bottom: 12),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 440,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text('Copy From:'),
                                ],
                              ),
                            ),
                          ),
                        ),
                  wareHouseSectionDetailsList.isEmpty
                      ? const SizedBox()
                      : Align(
                          alignment: Alignment.topLeft,
                          child: Container(
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
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: selectedCode,
                                  items: wareHouseSectionDetailsList
                                      .map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      child: Text(e['WareHouse_Section_Code']),
                                      value: e['WareHouse_Section_Code'],
                                      onTap: () {
                                        if (lineCount == 0) {
                                          Get.showSnackbar(GetSnackBar(
                                            duration:
                                                const Duration(seconds: 2),
                                            backgroundColor: Theme.of(context)
                                                .backgroundColor,
                                            message:
                                                'Select the Line IDs first',
                                            title: 'Alert',
                                          ));
                                        } else {
                                          generateLineCount(
                                              e['Section_Details'].length);
                                          List temp = [];
                                          for (int i = 0;
                                              i < e['Section_Details'].length;
                                              i++) {
                                            temp.add({
                                              'Section_Id': widget.sectionId,
                                              'Section_Code':
                                                  widget.sectionCode,
                                              'WareHouse_Section_Line_Code':
                                                  lineIds[i],
                                              'WareHouse_Section_Line_Number_Of_Boxes': e[
                                                          'Section_Details'][i][
                                                      'warehouse_section_line__WareHouse_Section_Line_Number_Of_Boxes']
                                                  .toString(),
                                              'WareHouse_Section_Line_Maximum_Box_Capacity': e[
                                                          'Section_Details'][i][
                                                      'WareHouse_Section_Line_Maximum_Box_Capacity']
                                                  .toString(),
                                              'WareHouse_Section_Line_Box_Length': e[
                                                          'Section_Details'][i][
                                                      'warehouse_section_line__WareHouse_Section_Line_Box_Length']
                                                  .toString(),
                                              'WareHouse_Section_Line_Box_Breadth': e[
                                                          'Section_Details'][i][
                                                      'warehouse_section_line__WareHouse_Section_Line_Box_Breadth']
                                                  .toString(),
                                              'WareHouse_Section_Line_Box_Height': e[
                                                      'Section_Details'][i][
                                                  'warehouse_section_line__WareHouse_Section_Line_Box_Height']
                                                ..toString(),
                                            });
                                          }
                                          setState(() {
                                            individualLineDataList = temp;
                                            _selected = true;
                                            lineIds.clear();
                                            selected.clear();
                                          });
                                        }
                                      },
                                    );
                                  }).toList(),
                                  hint: const Text('Select'),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCode = value as String;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                  _selected == true
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                lineIds.isEmpty
                                    ? const SizedBox()
                                    : Container(
                                        width: 440,
                                        height: 30,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: lineIds.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Text(
                                              ' ${lineIds[index]},',
                                              style: getStyle(),
                                            );
                                          },
                                        ),
                                      ),
                                Container(
                                  width: 440,
                                  height: 450,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromRGBO(
                                              190, 190, 190, 1)),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 374,
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: const Text('Box Count:'),
                                        ),
                                        Container(
                                          width: 374,
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
                                                  hintText:
                                                      'Total Number of Boxes',
                                                  border: InputBorder.none),
                                              onChanged: (value) {},
                                              validator: (value) {},
                                              onSaved: (value) {
                                                updateAllLines['Box_Count'] =
                                                    value!;
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Container(
                                            width: 374,
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child:
                                                const Text('Max Box Capacity:'),
                                          ),
                                        ),
                                        Container(
                                          width: 374,
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
                                                  hintText:
                                                      'Maximum Box Capacity',
                                                  border: InputBorder.none),
                                              onChanged: (value) {},
                                              validator: (value) {},
                                              onSaved: (value) {
                                                updateAllLines[
                                                        'WareHouse_Section_Line_Maximum_Box_Capacity'] =
                                                    value!;
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Container(
                                            width: 374,
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: const Text('Box Height'),
                                          ),
                                        ),
                                        Container(
                                          width: 374,
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
                                                updateAllLines['Height'] =
                                                    value!;
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Container(
                                            width: 374,
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: const Text('Box Breadth'),
                                          ),
                                        ),
                                        Container(
                                          width: 374,
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
                                                updateAllLines['Breadth'] =
                                                    value!;
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Container(
                                            width: 374,
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: const Text('Box Length'),
                                          ),
                                        ),
                                        Container(
                                          width: 374,
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
                                                updateAllLines['Length'] =
                                                    value!;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Enter Specifically for each Line'),
                            Checkbox(
                                value: _selected,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == false) {
                                      individualLineDataList.clear();
                                    }
                                    // for (var data in temp) {
                                    //   popUpMenuList.add(PopupMenuItem(
                                    //       child: CheckboxListTile(
                                    //           title: Text(
                                    //             data['Id'],
                                    //           ),
                                    //           value: data['Selected'],
                                    //           onChanged: (value) {
                                    //             setState(() {
                                    //               data['Selected'] = value;
                                    //             });
                                    //           })));
                                    // }
                                    _selected = value!;
                                  });
                                })
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Lines'),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.add_circle_outline_outlined,
                                  color: Theme.of(context).backgroundColor,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  _selected == false
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 440,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text('Line Ids'),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 440,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    // border: Border.all(color: Colors.black26),
                                  ),
                                  child: DropDownMultiSelect(
                                      options: lineIds,
                                      selectedValues: selected,
                                      onChanged: (List<String> x) {
                                        setState(() {
                                          selected = x;
                                        });
                                      },
                                      whenEmpty: 'Select'),
                                ),
                              ],
                            ),
                          ),
                        ),
                  individualLineDataList.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 500,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: individualLineDataList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return DisplaySingleLineData(
                                    individualLineDataList:
                                        individualLineDataList,
                                    index: index,
                                    key: UniqueKey(),
                                    delete: deleteSingleLineData,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                  _selected == false
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // temp.isEmpty
                                //     ? const SizedBox()
                                //     : Container(
                                //         width: 440,
                                //         height: 30,
                                //         child: ListView.builder(
                                //           scrollDirection: Axis.horizontal,
                                //           itemCount: temp.length,
                                //           itemBuilder: (BuildContext context, int index) {
                                //             return Text(
                                //               ' ${temp[index]},',
                                //               style: getStyle(),
                                //             );
                                //           },
                                //         ),
                                //       ),
                                Form(
                                  key: _updateSingleLineKey,
                                  child: Container(
                                    width: 440,
                                    height: 470,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                190, 190, 190, 1)),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 374,
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: const Text('Box Count:'),
                                          ),
                                          Container(
                                            width: 374,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child: TextFormField(
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        'Total Number of Boxes',
                                                    border: InputBorder.none),
                                                onChanged: (value) {},
                                                validator: (value) {},
                                                onSaved: (value) {
                                                  updateSingleLines[
                                                      'Box_Count'] = value!;
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Container(
                                              width: 374,
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: const Text(
                                                  'Max Box Capacity:'),
                                            ),
                                          ),
                                          Container(
                                            width: 374,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child: TextFormField(
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        'Maximum Box Capacity',
                                                    border: InputBorder.none),
                                                onChanged: (value) {},
                                                validator: (value) {},
                                                onSaved: (value) {
                                                  updateSingleLines[
                                                          'WareHouse_Section_Line_Maximum_Box_Capacity'] =
                                                      value!;
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Container(
                                              width: 374,
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: const Text('Box Length'),
                                            ),
                                          ),
                                          Container(
                                            width: 374,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: 'Length',
                                                        border:
                                                            InputBorder.none),
                                                onChanged: (value) {},
                                                validator: (value) {},
                                                onSaved: (value) {
                                                  updateSingleLines['Length'] =
                                                      value!;
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Container(
                                              width: 374,
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: const Text('Box Height'),
                                            ),
                                          ),
                                          Container(
                                            width: 374,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: 'Height',
                                                        border:
                                                            InputBorder.none),
                                                onChanged: (value) {},
                                                validator: (value) {},
                                                onSaved: (value) {
                                                  updateSingleLines['Height'] =
                                                      value!;
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Container(
                                              width: 374,
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: const Text('Box Breadth'),
                                            ),
                                          ),
                                          Container(
                                            width: 374,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: 'Breadth',
                                                        border:
                                                            InputBorder.none),
                                                onChanged: (value) {},
                                                validator: (value) {},
                                                onSaved: (value) {
                                                  updateSingleLines['Breadth'] =
                                                      value!;
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    const Color.fromRGBO(
                                                        44, 96, 154, 1),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _updateSingleLineKey
                                                      .currentState!
                                                      .save();
                                                  // print(selected);

                                                  setState(() {
                                                    if (individualLineDataList
                                                        .isEmpty) {
                                                      for (int i = 0;
                                                          i < selected.length;
                                                          i++) {
                                                        // updateSingleLines['Line_Id'] =
                                                        //     selected[i];

                                                        individualLineDataList
                                                            .add({
                                                          'Section_Code':
                                                              sectionCode,
                                                          'WareHouse_Section_Line_Code':
                                                              selected[i],
                                                          'WareHouse_Section_Line_Number_Of_Boxes':
                                                              updateSingleLines[
                                                                  'Box_Count'],
                                                          'WareHouse_Section_Line_Maximum_Box_Capacity':
                                                              updateSingleLines[
                                                                  'WareHouse_Section_Line_Maximum_Box_Capacity'],
                                                          'WareHouse_Section_Line_Box_Length':
                                                              updateSingleLines[
                                                                  'Length'],
                                                          'WareHouse_Section_Line_Box_Breadth':
                                                              updateSingleLines[
                                                                  'Breadth'],
                                                          'WareHouse_Section_Line_Box_Height':
                                                              updateSingleLines[
                                                                  'Height'],
                                                        });

                                                        // print(
                                                        //     individualLineDataList);
                                                      }

                                                      for (int i = 0;
                                                          i < selected.length;
                                                          i++) {
                                                        for (int j = 0;
                                                            j < lineIds.length;
                                                            j++) {
                                                          if (lineIds[j] ==
                                                              selected[i]) {
                                                            lineIds.removeAt(j);
                                                          }
                                                        }
                                                      }
                                                      selected.clear();
                                                      // print(lineIds);
                                                      // print(selected);
                                                    } else {
                                                      if (selected.isEmpty) {
                                                        Get.showSnackbar(
                                                            GetSnackBar(
                                                          duration:
                                                              const Duration(
                                                                  seconds: 2),
                                                          backgroundColor: Theme
                                                                  .of(context)
                                                              .backgroundColor,
                                                          message:
                                                              'Select the Line IDs first',
                                                          title: 'Alert',
                                                        ));
                                                      } else {
                                                        for (int i = 0;
                                                            i < selected.length;
                                                            i++) {
                                                          updateSingleLines[
                                                                  'Line_Id'] =
                                                              selected[i];

                                                          individualLineDataList
                                                              .add({
                                                            'Section_Code':
                                                                sectionCode,
                                                            'WareHouse_Section_Line_Code':
                                                                selected[i],
                                                            'WareHouse_Section_Line_Number_Of_Boxes':
                                                                updateSingleLines[
                                                                    'Box_Count'],
                                                            'WareHouse_Section_Line_Maximum_Box_Capacity':
                                                                updateSingleLines[
                                                                    'WareHouse_Section_Line_Maximum_Box_Capacity'],
                                                            'WareHouse_Section_Line_Box_Length':
                                                                updateSingleLines[
                                                                    'Length'],
                                                            'WareHouse_Section_Line_Box_Breadth':
                                                                updateSingleLines[
                                                                    'Breadth'],
                                                            'WareHouse_Section_Line_Box_Height':
                                                                updateSingleLines[
                                                                    'Height'],
                                                          });
                                                        }
                                                        for (int i = 0;
                                                            i < selected.length;
                                                            i++) {
                                                          for (int j = 0;
                                                              j <
                                                                  lineIds
                                                                      .length;
                                                              j++) {
                                                            if (lineIds[j] ==
                                                                selected[i]) {
                                                              lineIds
                                                                  .removeAt(j);
                                                            }
                                                          }
                                                        }
                                                        selected.clear();
                                                        // print(lineIds);
                                                        // print(selected);
                                                      }
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  'Add',
                                                  style: GoogleFonts.roboto(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18,
                                                      color: Color.fromRGBO(
                                                          255, 254, 254, 1),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
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
                        const SizedBox(
                          width: 42,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
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
                            child: const Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // formError == false
                  //     ? const SizedBox()
                  //     : Container(
                  //         width: 440,
                  //         height: 36,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(8),
                  //           color: Colors.white,
                  //           border: Border.all(color: Colors.red[700]!),
                  //         ),
                  //         child: Padding(
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 12, vertical: 6),
                  //             child: Column(
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: const [
                  //                 Text('Line Count Cannot Be Empty'),
                  //                 Text('Enter Line Count'),
                  //               ],
                  //             )),
                  //       ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
