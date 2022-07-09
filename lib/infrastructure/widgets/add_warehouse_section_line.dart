import 'package:flutter/material.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';
import 'package:provider/provider.dart';

import '../../widgets/failure_dialog.dart';
import '../../widgets/success_dialog.dart';

class AddWareHouseSectionLine extends StatefulWidget {
  AddWareHouseSectionLine({Key? key}) : super(key: key);
  static const routeName = '/AddWarehouseSectionLine';

  @override
  _AddWareHouseSectionLineState createState() =>
      _AddWareHouseSectionLineState();
}

enum showSeperateLineCodes { yes, no }

class _AddWareHouseSectionLineState extends State<AddWareHouseSectionLine> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController controller = TextEditingController();

  showSeperateLineCodes lineCodes = showSeperateLineCodes.no;
  var showSeperate = false;
  var sectionLine = 0;
  int index = 0;
  List wareHouseSection = [];
  var wareHouseSectionId;
  List sectionLineCodeList = [];
  var sectionLineCode;
  List sendData = [];

  static List<Map<String, dynamic>> temp = [];
  // UniqueKey<_EditEachSectionLineDataState> globalKey =
  //     UniqueKey<_EditEachSectionLineDataState>();

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  void initState() {
    super.initState();
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<InfrastructureApis>(context, listen: false)
          .getWareHouseSectionDetails(01, token)
          .then((value) {});
    });
  }

  Map<String, dynamic> warehouseSectionLine = {
    'WareHouse_Section_Id': '',
    'WareHouse_Section_Line_Code': '',
    'WareHouse_Section_Line_Number_Of_Boxes': '',
    'WareHouse_Section_Line_Box_Length': '',
    'WareHouse_Section_Line_Box_Breadth': '',
    'WareHouse_Section_Line_Box_Height': '',
  };

  var initValues = {
    'WareHouse_Section_Id': '',
    'WareHouse_Section_Line_Code': '',
    'WareHouse_Section_Line_Number_Of_Boxes': '',
    'WareHouse_Section_Line_Box_Length': '',
    'WareHouse_Section_Line_Box_Breadth': '',
    'WareHouse_Section_Line_Box_Height': '',
  };
  var update = false;
  var wareHouseSectionLineId;

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      var data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      update = true;
      wareHouseSectionLineId = data['WareHouse_Section_Line_Id'];
      warehouseSectionLine['WareHouse_Section_Id'] =
          data['WareHouse_Section_Id'].toString();
      warehouseSectionLine['WareHouse_Section_Line_Code'] =
          data['WareHouse_Section_Line_Code'].toString();

      initValues = {
        'WareHouse_Section_Id': data['WareHouse_Section_Id'].toString(),
        'WareHouse_Section_Line_Code':
            data['WareHouse_Section_Line_Code'].toString(),
        'WareHouse_Section_Line_Number_Of_Boxes':
            data['WareHouse_Section_Line_Number_Of_Boxes'].toString(),
        'WareHouse_Section_Line_Box_Length':
            data['WareHouse_Section_Line_Box_Length'].toString(),
        'WareHouse_Section_Line_Box_Breadth':
            data['WareHouse_Section_Line_Box_Breadth'].toString(),
        'WareHouse_Section_Line_Box_Height':
            data['WareHouse_Section_Line_Box_Height'].toString(),
      };
    }
    super.didChangeDependencies();
  }

  Future<void> save() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    // globalKey.currentState!.save();
    // print(temp);

    if (temp.isEmpty) {
      for (int i = 0; i < sectionLineCodeList.length; i++) {
        sendData.add({
          'WareHouse_Section_Id': warehouseSectionLine['WareHouse_Section_Id'],
          'WareHouse_Section_Line_Code': sectionLineCodeList[i],
          'WareHouse_Section_Line_Number_Of_Boxes':
              warehouseSectionLine['WareHouse_Section_Line_Number_Of_Boxes'],
          'WareHouse_Section_Line_Box_Length':
              warehouseSectionLine['WareHouse_Section_Line_Box_Length'],
          'WareHouse_Section_Line_Box_Breadth':
              warehouseSectionLine['WareHouse_Section_Line_Box_Breadth'],
          'WareHouse_Section_Line_Box_Height':
              warehouseSectionLine['WareHouse_Section_Line_Box_Height'],
        });
      }
    } else {
      List tempList = [];
      for (var data in temp) {
        tempList.add(data['WareHouse_Section_Line_Code']);
      }
      for (var data in tempList) {
        if (sectionLineCodeList.contains(data)) {
          sectionLineCodeList.remove(data);
        }
      }

      for (int i = 0; i < sectionLineCodeList.length; i++) {
        sendData.add({
          'WareHouse_Section_Id': warehouseSectionLine['WareHouse_Section_Id'],
          'WareHouse_Section_Line_Code': sectionLineCodeList[i],
          'WareHouse_Section_Line_Number_Of_Boxes':
              warehouseSectionLine['WareHouse_Section_Line_Number_Of_Boxes'],
          'WareHouse_Section_Line_Box_Length':
              warehouseSectionLine['WareHouse_Section_Line_Box_Length'],
          'WareHouse_Section_Line_Box_Breadth':
              warehouseSectionLine['WareHouse_Section_Line_Box_Breadth'],
          'WareHouse_Section_Line_Box_Height':
              warehouseSectionLine['WareHouse_Section_Line_Box_Height'],
        });
      }
      for (var data in temp) {
        sendData.add(data);
      }
    }

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .addWareHouseSectionLineDetails(sendData, token)
            .then((value) {
          if (value == 200 || value == 201) {
            showDialog(
                context: context,
                builder: (ctx) => SuccessDialog(
                    title: 'Success',
                    subTitle: 'SuccessFully Added Ware House Section Line'));
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

  Future<void> updateData() async {
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    // globalKey.currentState!.save();

    // if (temp.isEmpty) {
    //   for (int i = 0; i < sectionLineCodeList.length; i++) {
    //     sendData.add({
    //       'WareHouse_Section_Id': warehouseSectionLine['WareHouse_Section_Id'],
    //       'WareHouse_Section_Line_Code': sectionLineCodeList[i],
    //       'WareHouse_Section_Line_Number_Of_Boxes':
    //           warehouseSectionLine['WareHouse_Section_Line_Number_Of_Boxes'],
    //       'WareHouse_Section_Line_Box_Length':
    //           warehouseSectionLine['WareHouse_Section_Line_Box_Length'],
    //       'WareHouse_Section_Line_Box_Breadth':
    //           warehouseSectionLine['WareHouse_Section_Line_Box_Breadth'],
    //       'WareHouse_Section_Line_Box_Height':
    //           warehouseSectionLine['WareHouse_Section_Line_Box_Height'],
    //     });
    //   }
    // } else {
    //   List tempList = [];
    //   for (var data in temp) {
    //     tempList.add(data['WareHouse_Section_Line_Code']);
    //   }
    //   for (var data in tempList) {
    //     if (sectionLineCodeList.contains(data)) {
    //       sectionLineCodeList.remove(data);
    //     }
    //   }

    //   for (int i = 0; i < sectionLineCodeList.length; i++) {
    //     sendData.add({
    //       'WareHouse_Section_Id': warehouseSectionLine['WareHouse_Section_Id'],
    //       'WareHouse_Section_Line_Code': sectionLineCodeList[i],
    //       'WareHouse_Section_Line_Number_Of_Boxes':
    //           warehouseSectionLine['WareHouse_Section_Line_Number_Of_Boxes'],
    //       'WareHouse_Section_Line_Box_Length':
    //           warehouseSectionLine['WareHouse_Section_Line_Box_Length'],
    //       'WareHouse_Section_Line_Box_Breadth':
    //           warehouseSectionLine['WareHouse_Section_Line_Box_Breadth'],
    //       'WareHouse_Section_Line_Box_Height':
    //           warehouseSectionLine['WareHouse_Section_Line_Box_Height'],
    //     });
    //   }
    //   for (var data in temp) {
    //     sendData.add(data);
    //   }
    // }

    try {
      Provider.of<Apicalls>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Apicalls>(context, listen: false).token;
        Provider.of<InfrastructureApis>(context, listen: false)
            .updateWareHouseSectionLineDetails(
                warehouseSectionLine, wareHouseSectionLineId, token)
            .then((value) {
          if (value == 200 || value == 201) {
            showDialog(
                context: context,
                builder: (ctx) => SuccessDialog(
                    title: 'Success',
                    subTitle: 'SuccessFully Added Ware House Section Line'));
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

  void delete(int index) {
    setState(() {
      temp.removeAt(index);
    });
  }

  void store(Map<String, dynamic> details) {
    setState(() {
      showSeperate = false;
      temp.add(details);

      // print(temp);
    });
  }

  void editSectionLineCode(Map<String, dynamic> data) {
    setState(() {
      sectionLineCodeList.insert(data['index'], data['value']);
    });
  }

  void close(int arg) {
    setState(() {
      showSeperate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    wareHouseSection = Provider.of<InfrastructureApis>(
      context,
    ).warehouseSection;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add WareHouse Section Line'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 700,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Ware house Section Id'),
                      Container(
                        width: 385,
                        child: DropdownButton(
                          value: wareHouseSectionId,
                          items: wareHouseSection
                              .map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem(
                              child: Text(e['WareHouse_Section_Code']),
                              value: e['WareHouse_Section_Code'],
                              onTap: () {
                                sectionLineCodeList.clear();
                                temp.clear();

                                for (int i = 1;
                                    i <= e['WareHouse_Section_Number_Of_Lines'];
                                    i++) {
                                  sectionLineCodeList.add(
                                      '${e['WareHouse_Section_Code'] + 'L' + i.toString()}');
                                }

                                // print(sectionLineCodeList);

                                controller.text = sectionLineCodeList.join(',');
                                sectionLine =
                                    e['WareHouse_Section_Number_Of_Lines'];

                                // firmId = e['Firm_Code'];
                                warehouseSectionLine['WareHouse_Section_Id'] =
                                    e['WareHouse_Section_Id'];
                                //print(warehouseCategory);
                              },
                            );
                          }).toList(),
                          hint: const Text('Please Choose wareHouse Id'),
                          onChanged: (value) {
                            setState(() {
                              wareHouseSectionId = value as String;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 700,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Ware house Section Line Code'),
                      Padding(
                        padding: getPadding(),
                        child: Container(
                            width: 400,
                            child: update == true
                                ? TextButton(
                                    onPressed: () {},
                                    child: Text(initValues[
                                        'WareHouse_Section_Line_Code']!))
                                : Row(
                                    children: [
                                      for (int i = 0;
                                          i < sectionLineCodeList.length;
                                          i++)
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                showSeperate = true;
                                                sectionLineCode =
                                                    sectionLineCodeList[i]
                                                        .toString();
                                                index = i;
                                              });
                                            },
                                            child: Text(sectionLineCodeList[i]))
                                    ],
                                  )
                            // TextFormField(
                            //   controller: controller,
                            //   enabled: false,
                            //   onSaved: (value) {
                            //     warehouseSectionLine[
                            //         'WareHouse_Section_Line_Code'] = value;
                            //   },
                            // ),
                            ),
                      ),
                    ],
                  ),
                ),
                // showSeperate == true
                //     ? const SizedBox()
                //     :
                Container(
                  width: 700,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Ware house Section Line Number Of Boxes'),
                      Padding(
                        padding: getPadding(),
                        child: Container(
                          width: 400,
                          child: TextFormField(
                            initialValue: initValues[
                                'WareHouse_Section_Line_Number_Of_Boxes'],
                            onSaved: (value) {
                              warehouseSectionLine[
                                      'WareHouse_Section_Line_Number_Of_Boxes'] =
                                  value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // showSeperate == true
                //     ? const SizedBox()
                //     :
                Container(
                  width: 700,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Ware house Section Line Box Length'),
                      Padding(
                        padding: getPadding(),
                        child: Container(
                          width: 400,
                          child: TextFormField(
                            initialValue:
                                initValues['WareHouse_Section_Line_Box_Length'],
                            onSaved: (value) {
                              warehouseSectionLine[
                                  'WareHouse_Section_Line_Box_Length'] = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // showSeperate == true
                //     ? const SizedBox()
                //     :
                Container(
                  width: 700,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Ware house Section Line Box breadth'),
                      Padding(
                        padding: getPadding(),
                        child: Container(
                          width: 400,
                          child: TextFormField(
                            initialValue: initValues[
                                'WareHouse_Section_Line_Box_Breadth'],
                            onSaved: (value) {
                              warehouseSectionLine[
                                  'WareHouse_Section_Line_Box_Breadth'] = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // showSeperate == true
                //     ? const SizedBox()
                //     :
                Container(
                  width: 700,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Ware house Section Line Box Height'),
                      Padding(
                        padding: getPadding(),
                        child: Container(
                          width: 400,
                          child: TextFormField(
                            initialValue:
                                initValues['WareHouse_Section_Line_Box_Height'],
                            onSaved: (value) {
                              warehouseSectionLine[
                                  'WareHouse_Section_Line_Box_Height'] = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                showSeperate == false
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: temp.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DisplayWareHouseSectionLineData(
                            list: temp,
                            index: index,
                            value: delete,
                            key: UniqueKey(),
                          );
                        },
                      )
                    : SizedBox(),

                showSeperate == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: EditEachSectionLineData(
                          sectionLineCode: sectionLineCode,
                          key: UniqueKey(),
                          save: store,
                          index: index,
                          wareHouseSectionId:
                              warehouseSectionLine['WareHouse_Section_Id'],
                          close: close,
                        ),
                      )
                    // ListView.builder(
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: sectionLine,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return Container(),
                    //     },
                    //   )
                    : const SizedBox(),
                update == false
                    ? Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: ElevatedButton(
                          onPressed: save,
                          child: const Text('Save'),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: ElevatedButton(
                          onPressed: updateData,
                          child: const Text('update'),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditEachSectionLineData extends StatefulWidget {
  EditEachSectionLineData({
    Key? key,
    required this.sectionLineCode,
    required this.index,
    required this.save,
    required this.wareHouseSectionId,
    required this.close,
  }) : super(key: key);

  final String sectionLineCode;
  final int index;
  final int wareHouseSectionId;

  final ValueChanged<Map<String, dynamic>> save;
  final ValueChanged<int> close;

  @override
  _EditEachSectionLineDataState createState() =>
      _EditEachSectionLineDataState();
}

class _EditEachSectionLineDataState extends State<EditEachSectionLineData> {
  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  TextEditingController controller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();
  var saveStore = false;
  @override
  void initState() {
    warehouseSectionLine['WareHouse_Section_Id'] = widget.wareHouseSectionId;

    super.initState();
  }

  Map<String, dynamic> warehouseSectionLine = {
    'WareHouse_Section_Id': null,
    'WareHouse_Section_Line_Code': '',
    'WareHouse_Section_Line_Number_Of_Boxes': '',
    'WareHouse_Section_Line_Box_Length': '',
    'WareHouse_Section_Line_Box_Breadth': '',
    'WareHouse_Section_Line_Box_Height': '',
  };

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        height: 400,
        child: Card(
          elevation: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Ware house Section Line Code'),
                    Padding(
                      padding: getPadding(),
                      child: Container(
                        width: 400,
                        child: TextFormField(
                          initialValue: widget.sectionLineCode,
                          enabled: false,
                          // controller: controller,

                          onChanged: (value) {
                            // widget
                            //     .close(100);
                          },
                          //  controller: controller,
                          onSaved: (value) {
                            warehouseSectionLine[
                                'WareHouse_Section_Line_Code'] = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Ware house Section Line Number Of Boxes'),
                    Padding(
                      padding: getPadding(),
                      child: Container(
                        width: 400,
                        child: TextFormField(
                          // onChanged: (value) {
                          //   warehouseSectionLine[
                          //           'WareHouse_Section_Line_Number_Of_Boxes'] =
                          //       value;
                          // },
                          onSaved: (value) {
                            warehouseSectionLine[
                                    'WareHouse_Section_Line_Number_Of_Boxes'] =
                                value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Ware house Section Line Box Length'),
                    Padding(
                      padding: getPadding(),
                      child: Container(
                        width: 400,
                        child: TextFormField(
                          // onChanged: (value) {
                          //   warehouseSectionLine[
                          //       'WareHouse_Section_Line_Box_Length'] = value;
                          // },
                          onSaved: (value) {
                            warehouseSectionLine[
                                'WareHouse_Section_Line_Box_Length'] = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Ware house Section Line Box breadth'),
                    Padding(
                      padding: getPadding(),
                      child: Container(
                        width: 400,
                        child: TextFormField(
                          // onChanged: (value) {
                          //   warehouseSectionLine[
                          //       'WareHouse_Section_Line_Box_Breadth'] = value;
                          // },
                          onSaved: (value) {
                            warehouseSectionLine[
                                'WareHouse_Section_Line_Box_Breadth'] = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Ware house Section Line Box Height'),
                    Padding(
                      padding: getPadding(),
                      child: Container(
                        width: 400,
                        child: TextFormField(
                          // decoration: InputDecoration(
                          //     //suffixIcon: Icon(Icons.corr)
                          //     ),
                          // onChanged: (value) {
                          //   warehouseSectionLine[
                          //       'WareHouse_Section_Line_Box_Height'] = value;
                          // },
                          onSaved: (value) {
                            warehouseSectionLine[
                                'WareHouse_Section_Line_Box_Height'] = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // saveStore == false
              //     ? const SizedBox()
              //     : Container(
              //         padding: const EdgeInsets.only(top: 25),
              //         width: 700,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [Text(warehouseSectionLine.toString())],
              //         ),
              //       ),
              Container(
                padding: const EdgeInsets.only(top: 25),
                width: 700,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          formKey.currentState!.save();
                          // setState(() {
                          //   saveStore = true;
                          // });
                          // print(warehouseSectionLine);

                          widget.save(warehouseSectionLine);
                          formKey.currentState!.reset();
                        },
                        child: const Text('Save')),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          widget.close(100);
                          formKey.currentState!.reset();
                        },
                        child: const Text('Close'))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayWareHouseSectionLineData extends StatefulWidget {
  DisplayWareHouseSectionLineData(
      {Key? key, required this.list, required this.index, required this.value})
      : super(key: key);

  final List list;
  final int index;
  final ValueChanged<int> value;

  @override
  _DisplayWareHouseSectionLineDataState createState() =>
      _DisplayWareHouseSectionLineDataState();
}

class _DisplayWareHouseSectionLineDataState
    extends State<DisplayWareHouseSectionLineData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    widget.value(widget.index);
                  },
                  icon: const Icon(Icons.delete)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    'WareHouse SectionLine Code: ${widget.list[widget.index]['WareHouse_Section_Line_Code']}'),
                Text(
                    'WareHouse SectionLine Number Of Boxes : ${widget.list[widget.index]['WareHouse_Section_Line_Number_Of_Boxes']}'),
                Text(
                    'WareHouse SectionLine Box Length: ${widget.list[widget.index]['WareHouse_Section_Line_Box_Length']}'),
                Text(
                    'WareHouse SectionLine Box Breadth: ${widget.list[widget.index]['WareHouse_Section_Line_Box_Breadth']}'),
                Text(
                    'WareHouse SectionLine Box Height: ${widget.list[widget.index]['WareHouse_Section_Line_Box_Height']}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
